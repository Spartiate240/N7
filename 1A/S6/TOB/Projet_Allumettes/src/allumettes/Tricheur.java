package allumettes;

/** Stratégie d'un tricheur géré par l'ordinateur.
 * @author	DUROLLET Pierre
 * @version	1.4
 */
public class Tricheur implements Strategie {

    @Override
    public int getPrise(Jeu jeu) {
    //Si triche: prends toutes sauf 2, il en prends ensuite une allumette
    //Donc triche si nb_Allumettes >  2
        System.out.println("[Je triche...]");
        while (jeu.getNombreAllumettes() > 2) {
            try {
                jeu.retirer(1);

            } catch (CoupInvalideException e) {
            }
        }
        System.out.println("[Allumettes restantes : "
        + jeu.getNombreAllumettes() + "]");
        return 1;
    }
}
