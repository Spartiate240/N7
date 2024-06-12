#include "tab.h"
#include <stdlib.h>
#include <string.h> // Pour memcpy et memmove

// Implantation de tab_t
struct tab_t {
    int *elements;
    size_t taille_utilisee;
    size_t taille_allouee;
};

// creer
tab_t creer(void) {
    tab_t tab = malloc(sizeof(struct tab_t));
    if (!tab) return NULL;
    tab->elements = malloc(TAILLE_INITIALE * sizeof(int));
    if (!tab->elements) {
        free(tab);
        return NULL;
    }
    tab->taille_utilisee = 0;
    tab->taille_allouee = TAILLE_INITIALE;
    return tab;
}

// detruire
void detruire(tab_t tab) {
    if (tab) {
        free(tab->elements);
        free(tab);
    }
}

// ajouter
void ajouter(tab_t tab, int valeur) {
    if (tab->taille_utilisee == tab->taille_allouee) {
        tab->taille_allouee *= 2;
        tab->elements = realloc(tab->elements, tab->taille_allouee * sizeof(int));
        if (!tab->elements) {
            // Gérer l'erreur de réallocation
            return;
        }
    }
    tab->elements[tab->taille_utilisee++] = valeur;
}

// supprimer
void supprimer(tab_t tab, size_t indice) {
    if (indice < tab->taille_utilisee) {
        memmove(tab->elements + indice, tab->elements + indice + 1, (tab->taille_utilisee - indice - 1) * sizeof(int));
        tab->taille_utilisee--;
    }
}

// element
int element(tab_t tab, size_t indice) {
    if (indice < tab->taille_utilisee) {
        return tab->elements[indice];
    }
    // Gérer l'erreur d'indice hors limites
    return -1; // Exemple de gestion d'erreur
}

// taille
size_t taille(tab_t tab) {
    return tab->taille_utilisee;
}

// espace
size_t espace(tab_t tab) {
    return tab->taille_allouee;
}

// serrer
void serrer(tab_t tab) {
    tab->elements = realloc(tab->elements, tab->taille_utilisee * sizeof(int));
    tab->taille_allouee = tab->taille_utilisee;
}