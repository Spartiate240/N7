#ifndef TAB_H
#define TAB_H
#include <stddef.h> // Pour size_t

// Type abstrait tab_t
typedef struct tab_t *tab_t;

// Constane pour la taille initiale d'un tableau :
#define TAILLE_INITIALE 4

// creer
tab_t creer(void);

// detruire
void detruire(tab_t tab);

// ajouter
void ajouter(tab_t tab, int valeur);

// supprimer
void supprimer(tab_t tab, size_t indice);

// element
int element(tab_t tab, size_t indice);

// taille
size_t taille(tab_t tab);

// espace
size_t espace(tab_t tab);

// serrer
void serrer(tab_t tab);

#endif

