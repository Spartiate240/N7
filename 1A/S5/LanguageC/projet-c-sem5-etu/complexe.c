#include "complexe.h"
#include <math.h>           // Pour certaines fonctions trigo notamment

// Implantations de reelle et imaginaire

double reelle(complexe_t complexe) {
    return complexe.P_reelle;
}

double imaginaire(complexe_t complexe) {
    return complexe.P_imag;
}


// Implantations de set_reelle et set_imaginaire
void set_reelle(complexe_t* complexe, double reel) {
    complexe->P_reelle = reel;
}


void set_imaginaire(complexe_t* complexe, double imaginaire) {
    complexe->P_imag = imaginaire;
}


void init(complexe_t* complexe, double reel, double imaginaire) {
    complexe->P_imag = imaginaire;
    complexe->P_reelle = reel;
}

// Implantation de copie
void copie(complexe_t* resultat, complexe_t autre) {
    resultat->P_imag = autre.P_imag;
    resultat->P_reelle = autre.P_reelle;
}

// Implantations des fonctions algébriques sur les complexes
void conjugue(complexe_t* resultat, complexe_t op){
    resultat->P_reelle = op.P_reelle;
    resultat->P_imag = - op.P_imag;
}


void ajouter(complexe_t* resultat, complexe_t gauche, complexe_t droite){
    resultat -> P_reelle = gauche.P_reelle + droite.P_reelle;
    resultat -> P_imag = gauche.P_imag + droite.P_imag;
}


void soustraire(complexe_t* resultat, complexe_t gauche, complexe_t droite){
    resultat -> P_reelle = gauche.P_reelle - droite.P_reelle;
    resultat -> P_imag = gauche.P_imag - droite.P_imag;
}


void multiplier(complexe_t* resultat, complexe_t gauche, complexe_t droite){
    resultat -> P_reelle = gauche.P_reelle*droite.P_reelle - gauche.P_imag*droite.P_imag;
    resultat -> P_imag = gauche.P_imag*droite.P_reelle + droite.P_imag*gauche.P_reelle;
}


void echelle(complexe_t* resultat, complexe_t op, double facteur){
    resultat -> P_reelle = op.P_reelle*facteur;
    resultat ->P_imag = op.P_imag*facteur;
}


void puissance(complexe_t* resultat, complexe_t op, int exposant){
    //initialiser le résultat, initialisé à 1 car si n = 0 resultat = 1
    resultat->P_reelle = 1;
    resultat->P_imag = 0;
    
    for (int i = 0; i <exposant; i++){
        //complexe temporaire pour stocker le résultat (cacul de op^i)
        complexe_t tempo = *resultat;

        resultat->P_reelle = tempo.P_reelle * op.P_reelle - tempo.P_imag * op.P_imag;
        resultat->P_imag = tempo.P_imag * op.P_reelle + op.P_imag * tempo.P_reelle;
        //on a bien à la fin de la première itération (donc pour exposant = 1) resultat = op.P_reelle,op.P_imag
    }
}


// Implantations du module et de l'argument
double module_carre(complexe_t op) {
    return  op.P_reelle*op.P_reelle + op.P_imag*op.P_imag;
}


double module(complexe_t op) {
    return  sqrt(op.P_reelle*op.P_reelle + op.P_imag*op.P_imag);
}


double argument(complexe_t complexe) {
    return atan2(complexe.P_imag, complexe.P_reelle);
}



