#include <stdio.h>
#include <stdlib.h>
#include "readcmd.h"
#include <stdbool.h>
#include <string.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <fcntl.h>

int copier(int argc, char* argv[]) {
    if (argc != 3) {
        printf("\nMauvais nombre d'arguments !");
        exit(-1);
    }

    # define BUFSIZE 1024
    char tampon [BUFSIZE];
    int red;
    int wrote;

    int src = open(argv[1], O_RDONLY);
    if (src == -1) {
        printf("\nLe fichier à copier est invalide.");
        exit(-1);
    }

    int end = open(argv[2], O_WRONLY|O_CREAT|O_TRUNC, 0666);
    if (end == -1) {
        printf("\nL'emplacement final est invalide.");
        exit(-1);
    }

    while ((red = read(src,tampon,BUFSIZE)) > 0) {
        wrote = write(end, tampon, red);
        if (wrote == -1) {
            printf("\nErreur lors de l'écriture...");
            exit(-1);
        }
    }

    close(src);
    close(end);
    return EXIT_SUCCESS;
}