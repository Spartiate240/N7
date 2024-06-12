#define _GNU_SOURCE
#include "liste_noeud.h"
#include <stdlib.h>
#include <math.h>



liste_noeud_t* creer_liste() {

    liste_noeud_t* nouvelle_liste = malloc(sizeof(liste_noeud_t));

    nouvelle_liste->tete = NULL; // Initialisation de la liste comme vide
    return nouvelle_liste;
}


void detruire_liste(liste_noeud_t** liste_ptr) {
    noeud_t* cell_sui;

    if ((*liste_ptr)->tete != NULL) {
        noeud_t* cell_tete = (*liste_ptr)->tete;

        cell_sui = cell_tete->suivant;
        cell_tete->suivant = NULL;

        free(cell_tete);
        (*liste_ptr)->tete = cell_sui;

        // par récurence
        detruire_liste(liste_ptr);
    } else {
       free(*liste_ptr);
        *liste_ptr = NULL;

    }
    return;
}



bool est_vide_liste(liste_noeud_t* liste_noeuds) {
    return liste_noeuds->tete == NULL;
}




bool contient_noeud_liste(const liste_noeud_t* liste, int id_noeud) {

    noeud_t* prec = liste->tete;
    
    // Sinon on parcours la liste pour le chercher
    while (prec->suivant != NULL) {
        if (prec->noeud == id_noeud) {
            return true;
        }
        prec = prec->suivant;
    }
    if (prec->noeud == id_noeud) {
        return true;
    }
    return false;
}




 bool contient_arrete_liste(const liste_noeud_t* liste, int source, int destination) {

    noeud_t* act = liste->tete;

    while ((act->noeud != destination) && (act->suivant != NULL)) {
        act = act->suivant;
    }
    if ((act->noeud == destination) && (act->prec == source)) {
        return true;
    }
    return false;
}




double distance_noeud_liste(liste_noeud_t* liste_noeud, int noeud) {

    noeud_t* act = liste_noeud->tete;
    while (act->suivant != NULL) {
        if (act->noeud == noeud) {
            return act->distance;
        }
        act = act->suivant;
    }
    if (act->noeud == noeud) {
        return act->distance;
    }
    return INFINITY;
}




int precedent_noeud_liste(liste_noeud_t* liste_noeud, int noeud) {
    noeud_t* suivante = liste_noeud->tete;

    while (suivante->suivant != NULL) {
        // Si les indices du noeud actuel et cherché sont égaux
        if (suivante->noeud == noeud) { 
            return suivante->prec;
        }
        suivante = suivante->suivant;
    }
    if (suivante->noeud == noeud) {
        return suivante->prec;
    }
    return NO_ID;
}




int min_noeud_liste(liste_noeud_t* liste_noeud) {
    double min = INFINITY;
    noeud_t* id_min;
    noeud_t* act = liste_noeud->tete;

    if (est_vide_liste(liste_noeud)) {
        return NO_ID;
    }
    while (act->suivant != NULL) {
        if (min > act->distance) { 
            min = act->distance;
            id_min = act->noeud;
        }
        
        act = act->suivant;
    }

    if (min > act->distance) {
        min = act->distance;
        id_min = act->noeud;
    }
    return id_min;
}



void inserer_noeud_liste(liste_noeud_t* liste_noeud, int noeud, int precedent, double distance) {
        // Créer un nouveau noeud
    noeud_t* nouveau_noeud = malloc(sizeof(noeud_t));
    if (nouveau_noeud == NULL) {
        // Gestion de l'erreur d'allocation de mémoire
        return;
    }
        // Etablir les paramètres de ce noeud
    nouveau_noeud->noeud = noeud;
    nouveau_noeud->distance = distance;
    nouveau_noeud->prec = precedent;
    noeud_t* act = liste_noeud->tete;
    if (est_vide_liste(liste_noeud)) {
        liste_noeud->tete = nouveau_noeud;
        nouveau_noeud->suivant = NULL;
        return;
    }
    while (act->suivant != NULL) {
        act = act->suivant;
        
    }
    act->suivant = nouveau_noeud;
    nouveau_noeud->suivant = NULL;
    return;
}




void changer_noeud_liste(liste_noeud_t* liste_noeud, int noeud, int precedent, double distance) {
    noeud_t* act = liste_noeud->tete;
    if (contient_noeud_liste(liste_noeud,noeud) && !est_vide_liste(liste_noeud)) {
        while (act->noeud != noeud) {
            act = act->suivant;
        } 
        act->prec = precedent;
        act->distance = distance;
    }
    inserer_noeud_liste(liste_noeud,noeud,precedent,distance);
    return;
}

void supprimer_noeud_liste(liste_noeud_t* liste_noeud, int noeud) {
    noeud_t* act = liste_noeud->tete;
    noeud_t* precedent = NULL;
    // On a egalement besoin du noeud précédent pour supprimer.
    while (act->suivant != NULL && act->noeud != noeud) {
        precedent = act;
        act = act->suivant; // On a donc dans act le noeud actuel qu'il faut supprimer
                         // et dans prec son précédent.
    }

    // Si il n'a pas de précédent, alors c'est que le noeud est la tête de liste
    // il faut donc mettre à jour le pointeur de cette tête, de plus, il n'y a pas
    // de MAJ du précédent à faire.
    if (precedent == NULL) {
        liste_noeud->tete = act->suivant; // Effectivement, la nouvelle tête est le precedent
                                       // de act, qu'on veut supprimer.
    } else {
        // Si le noeud cherché n'est pas le 1er:
        precedent->suivant = act->suivant; // Décalage des précédents pour conserver le lien de 
                                     // passage d'une cellule à la suivante
    }
    //Libère la mémoire du noeud supprimé
    free(act);
    return;
}
