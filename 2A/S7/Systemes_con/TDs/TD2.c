/*   LECTEURS    ET     REDACTEURS    */
/*  dans un truc où 2 personnes font pas en même temps (si 2 écrivent en même temps, ou 1 écrit et 1 lit)
    Par contre plusieurs lecteurs peuvent lire en même temps
*/


/* Lecteurs prioritaires aux rédacteurs  (rédacteurs prioritaires c'est juste symétrique)*/




/*
Interfaces                      Conditions d'acceptation                                                            prédicats d'acceptation
*/

/*
Demander ecriture               pas d'écriture                                                                      !ecriture_en_cours
Terminer Lecture                ---------------
Demander Ecriture               pas de lecture ET pas d'ecriture ET pas de lecture en attente (EL par exemple)      !ecriture_en_cours ET nb_lecteurs = 0 
                                                                                                                    ET nb_lec_attente = 0
Terminer Ecriture               ---------------
*/


/*
Variables d'état
*/

/*
ecriture_en_cours : boolean = faux;
nb_lecteurs : int = 0;
nb_lec_attente : int = 0;
*/



demander_lecture() {
    if (ecriture_en_cours) {
        nb_lec_attente++;
        Acces_lecture.attendre();
        nb_lec_attente--;
    } 
        /* ecriture en cours */
    nb_lecteurs++;
    si (nb_lecteurs > 0 ) {
        Acces_lecture.signaler();
    }
}


Terminer_lecture() {
    /* nb_lecteur > 0 && nb_lec_attente ==0 */
    nb_lecteurs--;
    if (nb_lecteurs ==0 && nb_lec_attente == 0) {
        Acces_lecture.signaler();
    }
}

demander_ecriture() {
    /* accès dexclusion mutuelle*/
    if !(nb_lecteurs == 0 && nb_lec_attente == 0 && !ecriture_en_cours) {
        Acces_ecriture.attendre();
    }
    /* nb_lecteurs ==0 && nb_lec_attente == 0 && !ecriture_en_cours*/
    ecriture_en_cours = vrai;
    /* libération de l'exclusion mutuelle */
}


terminer_ecriture() {
    /* ecriture_en_cours & nb_lecteurs ==0*/
    ecriture_en_cours = faux;
    if (nb_lec_attente > 0) {
        Acces_lecture.signaler();
    } else {
        /*!ecriture_en_cours && nb_lec_attente ==0 */
        Acces_ecriture.signaler();
    }
}



