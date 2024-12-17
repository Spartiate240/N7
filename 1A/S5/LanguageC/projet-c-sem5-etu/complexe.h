#ifndef COMPLEX_H
#define COMPLEX_H
#include <math.h>


// Type utilisateur complexe_t
struct complexe_t {
    double P_reelle;
    double P_imag;
};
typedef struct complexe_t complexe_t;

// Fonctions reelle et imaginaire
/*
Nom: reelle
Paramètres:
    complexe            [in] complexe
    complexe.P_reelle   [out] partie reelle du complexe

Retourne: la partie réelle de complexe_t
*/

double reelle(complexe_t complexe);

/*
Nom: imaginaire
Paramètres:
    complexe                [in] complexe
    complexe.P_imag         [out] partie imaginaire du complexe

*/
double imaginaire(complexe_t complexe);




// Procédures set_reelle, set_imaginaire et init
/*
Nom: set_reel donne une valeur à la partie réelle
Paramètres:
        complexe        [in] complexe initial
                        [out] Complexe avec la partie réelle changée
        reel            [in] réel qu'il faut mettre dans la partie reelle
        */
void set_reelle(complexe_t* complexe, double reel);

/*
Nom: set_imaginaire donne une valeur à la partie imaginaire
Paramètres:
        complexe        [in] complexe initial 
                        [out] Complexe avec la partie imaginaire changée
        imaginaire      [in] réel qu'il faut mettre dans la partie imaginaire
*/
void set_imaginaire(complexe_t* complexe, double imaginaire);
/*
Nom: init
Paramètres:
        complexe        [out] complexe avec les valeurs réelles et imaginaire changées
        reel            [in] partie réelle à affecter au complexe
        imaginaire      [in] partie imaginaire à affecter au complexe

*/
void init(complexe_t* complexe, double reel, double imaginaire);


// Procédure copie
/*
 * copie
 * Copie les composantes du complexe donné en second argument dans celles du premier
 * argument

aramètres :
    resultat       [out] Complexe dans lequel copier les composantes
    autre          [in]  Complexe à copier
 *
 * Pré-conditions : resultat non null
 * Post-conditions : resultat et autre ont les mêmes composantes
 */
void copie(complexe_t* resultat, complexe_t autre);


// Algèbre des nombres complexes
/*
 * conjugue
 * Calcule le conjugué du nombre complexe op et le sotocke dans resultat.
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   op             [in]  Complexe dont on veut le conjugué
 *
 * Pré-conditions : resultat non-null
 * Post-conditions : reelle(*resultat) = reelle(op), complexe(*resultat) = - complexe(op)
 */
void conjugue(complexe_t* resultat, complexe_t op);


/*
 * ajouter
 * Réalise l'addition des deux nombres complexes gauche et droite et stocke le résultat
 * dans resultat.
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   gauche         [in]  Opérande gauche
 *   droite         [in]  Opérande droite
 *
 * Pré-conditions : resultat non-null
 * Post-conditions : *resultat = gauche + droite
 */
void ajouter(complexe_t* resultat, complexe_t gauche, complexe_t droite);


/*
 * soustraire
 * Réalise la soustraction des deux nombres complexes gauche et droite et stocke le résultat
 * dans resultat.
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   gauche         [in]  Opérande gauche
 *   droite    how      [in]  Opérande droite
 *
 * Pré-conditions : resultat non-null
 * Post-conditions : *resultat = gauche - droite
 */
void soustraire(complexe_t* resultat, complexe_t gauche, complexe_t droite);

/*
 * multiplier
 * Réalise le produit des deux nombres complexes gauche et droite et stocke le résultat
 * dans resultat.
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   gauche         [in]  Opérande gauche
 *   droite         [in]  Opérande droite
 *
 * Pré-conditions : resultat non-null
 * Post-conditions : *resultat = gauche * droite
 */
void multiplier(complexe_t* resultat, complexe_t gauche, complexe_t droite);


/*
 * echelle
 * Calcule la mise à l'échelle d'un nombre complexe avec le nombre réel donné (multiplication
 * de op par le facteur réel facteur).
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   op             [in]  Complexe à mettre à l'échelle
 *   facteur        [in]  Nombre réel à multiplier
 *
 * Pré-conditions : resultat non-null
 * Post-conditions : *resultat = op * facteur
 */
void echelle(complexe_t* resultat, complexe_t op, double facteur);


/*
 * puissance
 * Calcule la puissance entière du complexe donné et stocke le résultat dans resultat.
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   op             [in]  Complexe dont on veut la puissance
 *   exposant       [in]  Exposant de la puissance
 *
 * Pré-conditions : resultat non-null, exposant >= 0
 * Post-conditions : *resultat = op * op * ... * op
 *                                 { n fois }
 */
void puissance(complexe_t* resultat, complexe_t op, int exposant);


// Module et argument
/*
 * module_carre
 * Calcule le module au carré d'un complexe
 *Paramètres:
 *  op          [in] complexe donc ton veut le module au carré
 *  resultat    [out] module au carré
 */
double module_carre(complexe_t op);


/*
 * module
 * Calcule le module d'un complexe
 *Paramètres:
 *  op          [in] complexe donc ton veut le module
 *  resultat    [out] module
 */
double module(complexe_t op);


/*
 * argument
 *Calcule l'argument d'un complexe
 *Paramètres:
 *  op          [in] complexe donc ton veut l'argument
 *  resultat    [out] argument du complexe 
 */
double argument(complexe_t complexe);


#endif // COMPLEXE_H



