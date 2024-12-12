package allumettes;
/** Créer l'arbitre qui va arbitrer la partie
 * @author	DUROLLET Pierre
 * @version	1.4
 */
public class Arbitre {
    /** 1er joueur de la partie. */
    private Joueur j1;
    /** 2e joueur de la partie. */
    private Joueur j2;
    /** Si l'arbitre est confiant ou non. */
    private boolean confiant;


    /** Constructeur de l'arbitre.
     * @param j1 1er joueur de la partie
     * @param j2 2e joueur de la partie
     * @param confiance Si l'arbitre est confiant ou non
     */
    public Arbitre(Joueur j1, Joueur j2, boolean confiance) {
        this.j1 = j1;
        this.j2 = j2;
        this.confiant = confiance;
    }

    /** Constructeur d l'arbitre, initializé confiant.
     * @param j1 1er joueur de la partie
     * @param j2 2e joueur de la partie
     */
    public Arbitre(Joueur j1, Joueur j2) {
        this.j1 = j1;
        this.j2 = j2;
        this.confiant = true;
    }



    /** Arbitrer une partie.
     * @param jeu La partie à arbitrer.
     * @throws OperationInterditeException
     */
    public void arbitrer(Jeu jeu) throws OperationInterditeException {
        Joueur jCour = j1;
        Joueur jNonCour = j2;
        boolean triche = false; //En cas de triche
        boolean skip = false;
        Jeu jeuCour;

        // Boucle principale du jeu, chaque boucle = 1 tour de joueur
        while (jeu.getNombreAllumettes() > 0 && !triche) {
            boolean valide = false;
            int nbAllumettes = 0;

            //Boucle tant que coup invalide
            while (!valide && !triche) {
                if (!skip) {
                    System.out.println("Allumettes restantes : "
                                    + jeu.getNombreAllumettes());
                }
                skip = false;
                try {
                    // Utilise l'argument (ou non) "confiant".
                    if (confiant) {
                        jeuCour = jeu;
                    } else {
                        jeuCour = new JeuProcuration(jeu);
                    }

                    nbAllumettes = jCour.getPrise(jeuCour);
                    if (nbAllumettes > 1) {
                        System.out.println(jCour.getNom() + " prend "
                                        + nbAllumettes + " allumettes.");
                    } else if (nbAllumettes <= 1) {
                        System.out.println(jCour.getNom() + " prend "
                                        + nbAllumettes + " allumette.");
                        }
                    jeu.retirer(nbAllumettes);

                    valide = true; // Valide est vrai si coup valide

                } catch (CoupInvalideException e) {
                    valide = false; // Afin de reboucler tant que !valide.
                    System.out.println(e.getProbleme());

                } catch (OperationInterditeException e) {
                    System.out.println("Abandon de la partie car "
                    + jCour.getNom() + " triche !");
                    triche = true;

                } catch (NumberFormatException e) {
                    System.out.println("Vous devez donner un entier.");
                    valide = false;
                    skip = true; //Parce qu'on veut pas sauter de linges
                                 //si le joueur n'a pas entré un entier.
                }
                if (!skip) {
                System.out.println();
                }
            }


            //Echange du tour du joueur
            Joueur temporaire = jCour;
            jCour = jNonCour;
            jNonCour = temporaire;
        }

        if (!triche) { // Car il y a eu échange des joueurs
            System.out.println(jNonCour.getNom() + " perd !");
            System.out.println(jCour.getNom() + " gagne !");
        }
    }
}
