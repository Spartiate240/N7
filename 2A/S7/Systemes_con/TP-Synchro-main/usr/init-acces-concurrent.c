/**
 * @file usr/init.c
 * @brief L'init du monde utilisateur
 * 
 * Attention, ici les include sont dans usr/include !!!
 */
#include <manux/types.h>
#include <stdio.h>
#include <manux/errno.h>
#include <unistd.h>   // creerNouvelleTache
#include <manux/string.h>


/**
 * @brief Taille du buffer utilisé en lecture
 */ 
#define TAILLE_BUFFER 16

/**
 * @brief Nombres de lecteurs et écrivains
 */ 
#define NB_LECTEURS  5
#define NB_ECRIVAINS 5

int fd[2];  // Le tube

void lecteur()
{
   int r, c=0;
   char b[TAILLE_BUFFER];
   
   printf("[%d] Je suis un lecteur !\n", identifiantTache());
   
   do {
      r = lire(fd[0], b, TAILLE_BUFFER - 1);
      printf("[%d] lecture %d\n", identifiantTache(), r);
      if (r > 0) {
         b[r] = 0;
         printf(b);
         c += r;
      } else if (r < 0){
	printf("[%d] Erreur lecture\n", identifiantTache());
      }
   } while (r > 0);

   printf("\n[%d] Fini ... En tout, j'ai lu %d !\n", identifiantTache(), c);
}

void ecrivain()
{
   int r, c  = 0;
   
   // Activer verrou

   char * b = "Bonjour les jeunes ! ";

   printf("[%d] Je suis un ecrivain !\n", identifiantTache());

   do {
     printf("[%d] Je vais ecrire %d\n", identifiantTache(), strlen(b));
      r = ecrire(fd[1], b, strlen(b));
      printf("[%d] Voila j'ai ecrit %d\n", identifiantTache(), r);
      if (r >= 0) {
         c += r;
      } else {
         printf("[%d] Erreur ecriture\n", identifiantTache());
      }
   } while (r > 0);

   printf("[%d] En tout, j'ai ecrit %d !\n", identifiantTache(), c);

   // Desactiver verrou

}

void init()
{
  int r, l, e;

   printf("Bonjour le mode utilisateur !\n");

   r = tube(fd);




   if ( r != ESUCCES) {
      printf("r = %d : casse la pipe !?\n", r);
   } else {
      for (e = 0; e < NB_ECRIVAINS; e++) {
         r = creerNouvelleTache(ecrivain, FALSE);
      }
      for (l = 0; l < NB_LECTEURS; l++) {
         r = creerNouvelleTache(lecteur, FALSE);
      }
   }

   printf("Voila voila !\n");
   while(1){};
}
