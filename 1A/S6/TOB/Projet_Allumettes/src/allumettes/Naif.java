package allumettes;
import java.util.Random;
/** Stratégie naïve gérée par l'ordinateur.
 * @author	DUROLLET Pierre
 * @version	1.4
 */
public class Naif implements Strategie {


    @Override
    public int getPrise(Jeu jeu) {
        int nbMax = Math.min(Jeu.PRISE_MAX, jeu.getNombreAllumettes());
        return new Random().nextInt(nbMax) + 1; // Car aléa entre 0 et 2 de base,
                                            // donc +1 pour avoir entre 0 et PRISE_MAX.
    }
}
