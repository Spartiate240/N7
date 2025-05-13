/* Auteur : DUROLLET Pierre
   Date : 2025
   Description : Projet minishell de 1A (TPs 1 à 5)
*/

#include <stdio.h>
#include <stdlib.h>
#include "readcmd.h"
#include <stdbool.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <unistd.h>
#include <signal.h>

// Avancement:
// TP 1 OK Question 1: OK
// Question 2; OK
// TP 2: OK
// TP 3: Etape 12 NON OK
// TP 4: A FAIRE

int fils_termine= 0; 

// Etape 6
void traitement_fils(int sig) {
    // Initialiser pour utiliser le waitpid
    int status;
    pid_t pid;

    // ici aussi: Ignore les messges d'erreur, ça compile et tourne
    while ((pid = waitpid(-1, &status, WNOHANG | WUNTRACED | WCONTINUED)) > 0) {
        if (WIFEXITED(status)) {
            fprintf(stderr, "[PID %d] Processus terminé normalement (exit %d)\n", pid, WEXITSTATUS(status));
        }
        else if (WIFSIGNALED(status)) {
            fprintf(stderr, "[PID %d] Processus terminé par signal (%d)\n", pid, WTERMSIG(status));
        }
        else if (WIFSTOPPED(status)) {
            fprintf(stderr, "[PID %d] Processus suspendu par signal SIGSTOP\n", pid, WSTOPSIG(status));
        }
        else if (WIFCONTINUED(status)) {
            fprintf(stderr, "[PID %d] Processus repris SIGCONT\n", pid);
        }

        // Remise à zéro pour reprendre des commandes
        if (pid == fils_termine) {
            fils_termine = 0;
        }
        // Juste pour reimprimer le "> " après
        fprintf(stderr, "> ");
        fflush(stderr);
    }
}


void traitement_cz_11_1(int sig) {
    if (sig == SIGINT) {
        printf("\n Ctrl+C (SIGINT)\n> ");
        fflush(stdout);
    } else if (sig == SIGTSTP) {
        printf("\n Ctrl+Z (SIGSTP)\n> ");
        fflush(stdout);
    }
}

// Etape 11.2
int set_signal(int sig, void (*traitement)(int)) {
    struct sigaction sa;
    sa.sa_handler = traitement;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = SA_RESTART;

    return sigaction(sig, &sa, NULL);
}




int main(void) {
    // Ignore les messges d'erreur, ça compile et tourne

    // Traitement fils
    struct sigaction sa;
    sa.sa_handler = traitement_fils;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = SA_RESTART;


    /*
    // Traitement ctrl + C et ctrl + Z
    struct sigaction sa_cz;
    sa_cz.sa_handler = traitement_cz_11_1;
    sigemptyset(&sa_cz.sa_mask);
    sa_cz.sa_flags = SA_RESTART;
    
    sigaction(SIGINT, &sa_cz, NULL);
    sigaction(SIGTSTP, &sa_cz, NULL);
    */

    // Appel pour etape 11.2 partie 2
   //signal(SIGINT, SIG_IGN);
   //signal(SIGTSTP, SIG_IGN);

    // Etape 11.3 : Masquage de SIGINT et SIGTSTP
    sigset_t masque;
    sigemptyset(&masque);
    sigaddset(&masque, SIGINT);
    sigaddset(&masque, SIGTSTP);

    if (sigprocmask(SIG_BLOCK, &masque, NULL) < 0) {
        perror("sigprocmask");
        exit(EXIT_FAILURE);
    }

    bool fini= false;

    if (sigaction(SIGCHLD, &sa, NULL) < 0) {
        perror("sigaction");
        exit(EXIT_FAILURE);
    }

    // Etape 12 non fonctionnelle
    //signal(SIGINT, SIG_IGN);
    //signal(SIGTSTP, SIG_IGN);
    
    
    while (!fini) {
        printf("> ");
        struct cmdline *commande= readcmd();

        if (commande == NULL) {
            // commande == NULL -> erreur readcmd()
            perror("erreur lecture commande \n");
            exit(EXIT_FAILURE);
    
        } else {

            if (commande->err) {
                // commande->err != NULL -> commande->seq == NULL
                printf("erreur saisie de la commande : %s\n", commande->err);
        
            } else {
                int indexseq= 0;
                char **cmd;

                while ((cmd= commande->seq[indexseq])) {
                    if (cmd[0]) {
                        if (strcmp(cmd[0], "exit") == 0) {
                            fini= true;
                            printf("Au revoir ...\n");
                        }
                        else {
                            printf("commande : ");
                            int indexcmd= 0;
                            while (cmd[indexcmd]) {
                                printf("%s ", cmd[indexcmd]);
                                indexcmd++;
                            }

                            printf("\n");
                            // Etape 3.1: Creation du fils
                            pid_t pid = fork();

                            if (pid < 0) {
                                perror("Erreur fork");
                                exit(EXIT_FAILURE);

                            } else if (pid == 0) {
                                // Etape 12: détachement processus fils
                                /*
                                setpgrp();
                                setpgid(0, 0);
                                
                                if (commande->backgrounded == NULL) {
                                    tcsetpgrp(STDIN_FILENO, getpid());
                                }
                                signal(SIGINT, SIG_DFL);
                                signal(SIGTSTP, SIG_DFL);
                                */
                                
                                // Etape 3.2: Execution commande
                                execvp(cmd[0], cmd);
                                exit(EXIT_FAILURE);

                            } else {
                                int status;
                                // Etape 3.3: Pere attends fils
                                // sleep(1); // Teste si l'attente se fait bien

                                // Etape 4: Fond de tache
                                if (commande->backgrounded== NULL) { // On attend le fils
                                    // Etape 12
                                    /*
                                    setpgid(pid, pid);
                                    tcsetpgrp(STDIN_FILENO, pid);
                                    */
                                    int status;
                                    //waitpid(pid, &status, 0); // Etape 5
                                    
                                    // Etape 7 : remplacer par pause()
                                    fils_termine = pid;
                                     while (fils_termine != 0)
                                     {
                                        // on attend la fin du processus et on ne recupere la main que si le processus est termine
                                        pause();
                                                                       
                                     }
                                     //tcsetpgrp(STDIN_FILENO, getpgrp()); 
                                } else {
                                    printf("Commande exécutée en arrière-plan (PID %d)\n", pid);                            
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