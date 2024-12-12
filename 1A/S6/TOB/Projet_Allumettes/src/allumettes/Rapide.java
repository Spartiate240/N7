package allumettes;

/** Stratégie rapide gérée par l'ordinateur.
 * @author	DUROLLET Pierre
 * @version	1.4
 */

 public class Rapide implements Strategie {
    @Override
    public int getPrise(Jeu jeu) {
        int allumettesRestantes = jeu.getNombreAllumettes();
        // Si moins d'allumettes, en prends moins
        if (allumettesRestantes <= Jeu.PRISE_MAX) {
            return allumettesRestantes;
        } else {
            // Sinon prends le maximum
            return Math.min(allumettesRestantes, Jeu.PRISE_MAX);
        }
    }
}
