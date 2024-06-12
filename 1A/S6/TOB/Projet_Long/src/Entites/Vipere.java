package Entites;

import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.io.IOException;

import javax.imageio.ImageIO;

import main.Ecran;
import main.FonctionUtiles;

public class Vipere extends Entite {

	public Vipere(int x, int y, int numero, String sexe, Ecran ecran) {
		super(2000, 5000, 2000, 10000, 3500, 10, "bebe Vipere" + sexe + numero, sexe, ecran);
		dureeVie = 15;

		carteX = x;
		carteY = y;

		aireCollision = new Rectangle(20, 20, 28, 28);

		aireSolideDefautX = aireCollision.x;
		aireSolideDefautY = aireCollision.y;

		ecran.nbrEntite++;
		this.initialiser();
		this.getImage();

		this.carteX = x * ecran.tailleFinale;
		this.carteY = y * ecran.tailleFinale;

		ecran.nombreViperes++;
		ecran.vipereTotal++;

	}

	public void initialiser() {

		vitesse = 3;
		direction = "bas";
	}

	public void getImage() {

		avant = initialiser("Avant");

		arriere = initialiser("Arriere");

		gauche = initialiser("Gauche");

		droite = initialiser("Droite");

		avant1 = initialiser("Avant1");

		arriere1 = initialiser("Arriere1");

		gauche1 = initialiser("Gauche1");

		droite1 = initialiser("Droite1");
	}

	public BufferedImage initialiser(String image) {
		FonctionUtiles fct = new FonctionUtiles();
		BufferedImage imageEchelle = null;
		try {
			imageEchelle = ImageIO.read(getClass().getResourceAsStream("/vipere/" + image + ".png"));
			imageEchelle = fct.miseAEchelle(imageEchelle, ecran.tailleFinale, ecran.tailleFinale);
		} catch (IOException e) {
			e.printStackTrace();
			// TODO: handle exception
		}
		return imageEchelle;
	}

}
