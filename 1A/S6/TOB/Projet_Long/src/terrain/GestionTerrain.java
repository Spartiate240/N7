package terrain;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import javax.imageio.ImageIO;

import main.Ecran;
import main.FonctionUtiles;

public class GestionTerrain {

	Ecran ecran;
	public Terrain[] terrain;
	public int parcoursCarte[][];

	public GestionTerrain(Ecran ecran) {
		this.ecran = ecran;

		terrain = new Terrain[10];
		parcoursCarte = new int[ecran.mondeColMax][ecran.mondeLignMax];

		chargerCarte("/cartes/monde.txt");
		getImage();
		
	}

	public void getImage() {

		initialiser(0, "Herbe", false);
		initialiser(5, "EauPeuProfonde", true);
		initialiser(1, "Mur", true);
		initialiser(2, "Terre", false);
		initialiser(4, "Desert", false);
		initialiser(3, "Arbre", true);
	}

	public void initialiser(int index, String image, boolean collision) {
		FonctionUtiles fct = new FonctionUtiles();
		try {
			terrain[index] = new Terrain();
			terrain[index].image = ImageIO.read(getClass().getResourceAsStream("/terrains/" + image + ".png"));
			terrain[index].image = fct.miseAEchelle(terrain[index].image, ecran.tailleFinale, ecran.tailleFinale);
			terrain[index].interaction = collision;
		} catch (IOException e) {
			e.printStackTrace();
			// TODO: handle exception
		}
	}

	public void chargerCarte(String plan) {
		try {
			InputStream carte = getClass().getResourceAsStream(plan);
			BufferedReader parcours = new BufferedReader(new InputStreamReader(carte));

			int colonnes = 0;
			int lignes = 0;

			while (colonnes < ecran.mondeColMax && lignes < ecran.mondeLignMax) {
				String ligne = parcours.readLine();
				String terrains[] = ligne.split(" ");

				while (colonnes < ecran.mondeColMax) {
					int num = Integer.parseInt(terrains[colonnes]);

					parcoursCarte[colonnes][lignes] = num;
					colonnes++;
				}
				if (colonnes == ecran.mondeColMax) {
					colonnes = 0;
					lignes++;
				}
			}
			parcours.close();

		} catch (Exception e) {

		}
	}

	public void afficher(Graphics2D graph) {

		int colonne = 0, ligne = 0;

		while (colonne < ecran.mondeColMax && ligne < ecran.mondeLignMax) {

			int mondeX = colonne * ecran.tailleFinale;
			int mondeY = ligne * ecran.tailleFinale;

			int actuelX = mondeX - ecran.joueur.carteX + ecran.joueur.ecranX;
			int actuelY = mondeY - ecran.joueur.carteY + ecran.joueur.ecranY;

			if (mondeX + ecran.tailleFinale > ecran.joueur.carteX - ecran.joueur.ecranX
					&& mondeX - ecran.tailleFinale < ecran.joueur.carteX + ecran.joueur.ecranX
					&& mondeY + ecran.tailleFinale > ecran.joueur.carteY - ecran.joueur.ecranY
					&& mondeY - ecran.tailleFinale < ecran.joueur.carteY + ecran.joueur.ecranY) {

				// System.out.println(actuelX);
				// System.out.println(actuelY);

				graph.drawImage(terrain[parcoursCarte[colonne][ligne]].image, actuelX, actuelY, null);
			}
			colonne++;

			if (colonne == ecran.mondeColMax) {
				colonne = 0;
				ligne++;
			}
		}
	}

}
