package allumettes;

/** Permets de voir si une tentative d'enlever des allumettes est possible
 * @author	DUROLLET Pierre
 * @version	1.4
 */
public class JeuProcuration implements Jeu {
    /** Jeu dont il est le Proxy. */
    private Jeu jeu;

    /** Constructeur du jeu par procuration
     * @param jeu Jeu dont il est le proxy
     */
    public JeuProcuration(Jeu jeu) {
        this.jeu = jeu;
    }

    @Override
    public int getNombreAllumettes() {
        return jeu.getNombreAllumettes();
    }

    @Override
    public void retirer(int nbPrises) throws CoupInvalideException {
        // Exception si c'est pas l'arbitre qui appelle.
        throw new OperationInterditeException("Tentative de triche");
    }
}

