train(direction) {
    while (1) {
        arriver_voie_unique;                    // 3 canaux:
        Entree(direction);                      // entrée_EO
        rouler_sur_voie_unique;                 // entrer_OE
        Sortir();                               // sortir
        direction <- inverser(direction);
    }
}


/** Variables d'acceptation
 * entrée(direction)                train_circule && sens_voie == sens_circulation_train
 * sortir                           -----------------------------------
 *                                  bool train_circule
 *                                  sens snes_voie
 */

entree(direction) {
    if (train_circule && sens_voie != direction) {
        wait(access);
    }
}

/**
 * 
 * func when(b bool, c chan bool) chan bool {
 *     if b {return c,}
 *          else {nil,}
 * 
 * 
 * 
 * func voie_unique(entree_EO chan bool, entree_OE chan bool, sortir chan bool),
 *     train_circule = false;
 *     sens_courant = sens_EO;
 *         for {
 *           select {
 *              case <- when(!train_circule, entree_OE)
 *                      sens_courant = sens_OE;
 *                      train_circule = true;    
 *              case <- when(!train_circule, entree_EO)
 *                      sens_courant = sens_EO;
 *                      train_circule = true;
 *             case <- sortir: 
 *                      train_circule = false;    
 *         }
 *      }
 *  }
 * 
 * 
 * func train(entree chan bool, sortir chan bool) {
 *    entree <- true;
 *    sortir <- true;
 *    
 * }
 * 
 * 
 * go_train(entree_OE, sortir)
 * 
 * /
 * 
 * 
 * 
 * /


 /** QUESTION 2: NB oo de trains qui vont ds le même sens
  * 
  * func voie_unique(entree_EO chan bool, entree_OE chan bool, sortir chan bool) {}
  *     train_circule = false;
  *     sens_courant = sens_EO;
  *     nb_trains := 0;
  *         for {
  *           select {
  *              case <- when( sens_courant ==sens_OE && nb_trains > 0 || nb_train ==0, entree_OE)  // 1ère partie : si dans le sens du train, 2e partie: si pas de train
  *                      sens_courant = sens_OE;
  *                      nb_trains++;
  *              case <- when( sens_courant ==sens_EO && nb_trains > 0 || nb_train ==0, entree_EO);
  *                      sens_courant = sens_EO;
  *                      nb_trains++;
  *              case <- sortir:
  *                      nb_trains--;
  *          }
  *        }
  * }
  * 
  *  QUESTION 3: ajouter condition && nb_train < N dans les case
  */