package allumettes;

/** Pour les joueurs qui vont jouer la partie
 * @author	DUROLLET Pierre
 * @version	1.4
 */
public class Joueur {
    /** Nom du joueur. */
    private String nom;
    /** Stratégie adoptée par ce joueur. */
    private Strategie strategie;


    /** Constructeur du joueur.
     * @param nom Nom du joueur.
     * @param strat Stratégie adoptée par le joueur.
     */
    public Joueur(String nom, Strategie strat) {
        this.strategie = strat;
        this.nom = nom;
    }



    /** Obtenir le nom du joueur.
     * @return Le nom du joueur.
     */
    public String getNom() {
        return this.nom;
    }

    /** Permets de changer la stratégie du joueur.
     * @param s nouvelle stratégie à adopter.
     */
    public void setStrategie(Strategie s) {
        this.strategie = s;
    }

    /** Permets d'obtenir la stratégie du joueur.
     * @return La stratégie du joueur.
     */
    public Strategie getStrategie() {
        return this.strategie;
    }

    /** Permets d'avoir la prise du joueur.
     * @param jeu Jeu auquel le joueur prends des allumettes.
     * @return Le nombre d'allumettes que veut prendre le joueur.
     * @throws OperationInterditeException
     * @throws CoupInvalideException
     */
    public int getPrise(Jeu jeu) throws OperationInterditeException,
                                        CoupInvalideException {
        return this.strategie.getPrise(jeu);
    }
}
