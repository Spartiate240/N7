package allumettes;

/** Stratégie experte pour l'ordiateur
 * @author	DUROLLET Pierre
 * @version	1.4
 */
public class Expert implements Strategie {


    public int getPrise(Jeu jeu) {

        if ((jeu.getNombreAllumettes() - 1) % (Jeu.PRISE_MAX + 1) == 0) {
            return 1;
        } else {
            return (jeu.getNombreAllumettes() - 1) % (Jeu.PRISE_MAX + 1);
        }
    }
}
