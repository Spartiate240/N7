package allumettes;

/** Créer la partie réelle qui suis le nombre d'allumettes
 *  permettant de savoir quand la partie est finie.
 * @author	DUROLLET Pierre
 * @version	1.4
 */

 public class JeuReel implements Jeu {
    /** Nombre d'allumettes de base du jeu. */
    private int nbAllumettes;

    /** Construit un jeu réel.
     * @param nombreAllumettes nombre d'allumettes de début de partie
     */
    JeuReel(int nombreAllumettes) {
        this.nbAllumettes = nombreAllumettes;
    }


    @Override
    public int getNombreAllumettes() {
        return this.nbAllumettes;
    }

    @Override
    public void retirer(int nombreAllumettes) throws CoupInvalideException {
        verifPrise(nombreAllumettes);
        this.nbAllumettes -= nombreAllumettes;
    }

    /** Permets de vérifier si la prise voulue est autorisée.
     * @param prise Nombre d'allumettes que veut prendre le joueur.
     * @return Si la prise est autorisée ou non
     */
    public void verifPrise(int prise) throws CoupInvalideException {
        int max = Math.min(Jeu.PRISE_MAX, getNombreAllumettes());
        if (prise > max || prise < 1) {
            String infsup = prise > max ? " (> " + max + ")" : " (< 1)";
            throw new CoupInvalideException(prise, "Impossible ! Nombre invalide : "
                        + prise + infsup);
        }
    }
}
