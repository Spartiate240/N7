package allumettes;

/** Lance une partie des 13 allumettes en fonction des arguments fournis
 * sur la ligne de commande.
 * @author	Xavier Crégut
 * @version	$Revision: 1.5 $
 */

// Si besoin d'ajouter des Strategies, modifier le case à la fin de la classe
// joueur


public class Jouer {

	/** Nombre d'allumettes de base. */
	private static final int NB_ALLUMETTES = 13;

	/** Lancer une partie. En argument sont donnés les deux joueurs sous
	 * la forme nom@stratégie.
	 * @param args la description des deux joueurs
	 */
	public static void main(String[] args) throws OperationInterditeException {
		try {
			// Regarde s'il y a l'argument de confiance et l'enlève
			// si il est présent.
			boolean confiant = false;
			if (args.length > 0 && (args[0].equals("-c")
				|| args[0].equals("-confiant"))) {
				confiant = true;
				// Enlever l'argument confiant des arguments
				String[] newArgs = new String[args.length - 1];
				System.arraycopy(args, 1, newArgs, 0, args.length - 1);
				args = newArgs;
			}

			verifierNombreArguments(args);

			Jeu jeu = new JeuReel(NB_ALLUMETTES);

			//Création des joueurs
			Joueur j1 = argumentJoueur(args[0].toString());
			Joueur j2 = argumentJoueur(args[1].toString());

			//Initializer Arbitre, et arbitrer la partie
			Arbitre arbitreCcours = new Arbitre(j1, j2, confiant);
			arbitreCcours.arbitrer(jeu);



		} catch (ConfigurationException e) {
			System.out.println();
			System.out.println("Erreur : " + e.getMessage());
			afficherUsage();
			System.exit(1);
		}
	}



	/** Permets de vérifer s'il y a suffisamment d'arguments pour lancer la parite.
	 * @param args les arguments donnés dans le scanner
	 */
	private static void verifierNombreArguments(String[] args) {
		final int nbJoueurs = 2;
		if (args.length < nbJoueurs) {
			throw new ConfigurationException("Trop peu d'arguments : "
					+ args.length);
		}
		if (args.length > nbJoueurs + 1) {
			throw new ConfigurationException("Trop d'arguments : "
					+ args.length);
		}
	}

	/** Afficher des indications sur la manière d'exécuter cette classe. */
	public static void afficherUsage() {
		System.out.println("\n" + "Usage :"
				+ "\n\t" + "java allumettes.Jouer joueur1 joueur2"
				+ "\n\t\t" + "joueur est de la forme nom@stratégie"
				+ "\n\t\t" + "strategie = naif | rapide | expert | humain | tricheur"
				+ "\n"
				+ "\n\t" + "Exemple :"
				+ "\n\t" + "	java allumettes.Jouer Xavier@humain "
					   + "Ordinateur@naif"
				+ "\n"
				);
	}

	/** Séparer un string en 2 en fonction du 1er caractère "@"
	 * @param argument un argument d'entrée qu'on veut séparer
	 * @return un array de longueur 2 contenant les 2 strings sans le "@"
	 */
	public static Joueur argumentJoueur(String argument) throws ConfigurationException {
		String[] joueur = argument.split("@", 2);
		return creerJoueur(joueur);
	}



	/** Permets de créer les joueurs en fonction de leur Stratégie.
	 * @param scan Option entrée
	 * @return L'objet du joueur correspondant crée
	 */
	private static Joueur creerJoueur(String[] scan) {
		if (scan.length != 2) {
			throw new ConfigurationException("Joueur mal défini" + scan.toString());
		}
		String nom = scan[0];
		String strategieNom = scan[1];
		switch (strategieNom.toLowerCase()) {
			case "naif":
				return new Joueur(nom, new Naif());
			case "rapide":
				return new Joueur(nom, new Rapide());
			case "expert":
				return new Joueur(nom, new Expert());
			case "humain":
				return new Joueur(nom, new Humain(nom));
			case "tricheur":
				return new Joueur(nom, new Tricheur());
			default:
				throw new ConfigurationException("Strategie non valide : "
													+ strategieNom);
		}
	}
}
