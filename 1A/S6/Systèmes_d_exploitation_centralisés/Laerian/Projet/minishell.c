#include "readcmd.h"
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int pid_fg;
int nbcmd = 0;
void treat_all(int numsign) {
  int status;
  int pid;

  while ((pid = waitpid(-1, &status, WNOHANG)) > 0) {
    nbcmd--;
    if (WIFEXITED(status)) {
      printf("\n(Process n°%d terminated)\n", pid);
      pid_fg = 0;
    } else if (WIFSIGNALED(status)) {
    } else if (WIFSTOPPED(status)) {
    } else if (WIFCONTINUED(status)) {
    } else {
      if (pid == pid_fg) {
        pid_fg = 0;
      }
      printf("%d treated.\n", pid_fg);
    }
  }
}
void treat_c(int numsign) {
  if (pid_fg == 0) {
    printf("\n(No process to kill...).\n");
  } else {
    printf("\n(Process n°%d manually terminated)\n", pid_fg);
    kill(pid_fg, SIGKILL);
    pid_fg = 0;
  }
}
void treat_z(int numsign) {
  printf("\n(Process n°%d manually paused)\n", pid_fg);
  kill(pid_fg, SIGSTOP);
  pid_fg = 0;
}

int main(void) {

  struct sigaction action;
  action.sa_handler = treat_all;
  sigemptyset(&action.sa_mask);
  action.sa_flags = SA_RESTART;
  sigaction(SIGCHLD, &action, NULL);

  struct sigaction actionc;
  actionc.sa_handler = treat_c;
  sigemptyset(&actionc.sa_mask);
  actionc.sa_flags = SA_RESTART;
  sigaction(SIGINT, &actionc, NULL);

  struct sigaction actionz;
  actionz.sa_handler = treat_z;
  sigemptyset(&actionz.sa_mask);
  actionz.sa_flags = SA_RESTART;
  sigaction(SIGTSTP, &actionz, NULL);

  bool fini = false;

  while (!fini) {
    printf("> ");
    struct cmdline *commande = readcmd();

    if (commande == NULL) {
      // commande == NULL -> erreur readcmd()
      perror("ERROR : wrong input.\n");
      exit(EXIT_FAILURE);
    } else {

      if (commande->err) {
        // commande->err != NULL -> commande->seq == NULL
        printf("ERROR : invalid command : %s\n", commande->err);
      } else {

        int indexseq = 0;
        // Creating tubes
        int tubeIN[2];
        int tubeOUT[2];
        // Creating buffer
        char buffer[1024];

        char **cmd;
        pipe(tubeOUT);
        while ((cmd = commande->seq[indexseq])) {
          tubeIN[0] = tubeOUT[0];
          tubeIN[1] = tubeOUT[1];

          pipe(tubeOUT);

          close(tubeIN[1]);
          if (cmd[0]) {
            if (strcmp(cmd[0], "exit") == 0) {
              fini = true;
              printf("Shutting down ...\n");
            } else {
              printf("Command : ");
              int indexcmd = 0;
              while (cmd[indexcmd]) {
                printf("%s ", cmd[indexcmd]);
                indexcmd++;
              }
              printf("\n");
              int ret = fork();
              if (ret == -1) {
              } else if (ret == 0) {
                setpgrp();
                if ((indexseq == 0) && (commande->seq[indexseq + 1] == NULL)) {
                  if (commande->in != NULL) {
                    int file = open(commande->in, O_RDONLY);
                    dup2(file, 0);
                    close(file);
                  }
                  if (commande->out != NULL) {
                    int file =
                        open(commande->out, O_WRONLY | O_CREAT | O_TRUNC, 0666);
                    dup2(file, 1);
                    close(file);
                  }
                } else if (indexseq == 0) {

                  if (commande->in != NULL) {
                    int file = open(commande->in, O_RDONLY);
                    dup2(file, 0);
                    close(file);
                  }
                  dup2(tubeOUT[1], 1);

                } else if (commande->seq[indexseq + 1] == NULL) {
                  if (commande->out != NULL) {
                    int file =
                        open(commande->out, O_WRONLY | O_CREAT | O_TRUNC, 0666);
                    dup2(file, 1);
                    close(file);
                  }
                  dup2(tubeIN[0], 0);
                } else {
                  dup2(tubeOUT[1], 1);
                  dup2(tubeIN[0], 0);
                }

                close(tubeIN[0]);
                close(tubeIN[1]);
                close(tubeOUT[0]);
                close(tubeOUT[1]);

                execvp(cmd[0], cmd);

                exit(EXIT_FAILURE);
              } else {
                sigaction(SIGINT, &actionc, NULL);
                sigaction(SIGTSTP, &actionz, NULL);
                sigaction(SIGCHLD, &action, NULL);
                if (commande->backgrounded != NULL) {
                  nbcmd++;
                  printf("[%d] %d\n", nbcmd, ret);
                } else {
                  nbcmd++;
                  pid_fg = ret;
                  while (pid_fg != 0) {
                    pause();
                  }
                }
              }
            }

            indexseq++;
          }
        }
      }
    }
  }
  return EXIT_SUCCESS;
}