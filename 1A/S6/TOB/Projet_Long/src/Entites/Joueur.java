package Entites;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.io.IOException;

import javax.imageio.ImageIO;

import main.ActionClavier;
import main.Ecran;
import main.FonctionUtiles;

public class Joueur extends Entite {
	
	ActionClavier action;
	
	public final int ecranX;
	public final int ecranY;
	
	public int clePossedees = 0;
	
	public Joueur(Ecran ecran, ActionClavier action) {
		super(0,0,0,0,0,5,"rien","", ecran);
		this.action = action;
		
		this.ecranX = ecran.ecranLongueur/2 - ecran.tailleFinale/2;
		this.ecranY = ecran.ecranLargeur/2 - ecran.tailleFinale/2;
		
		aireCollision = new Rectangle(10, 25, 20, 25);
		
		aireSolideDefautX = aireCollision.x;
		aireSolideDefautY = aireCollision.y;
		this.initialiser();
		this.getImage();
	}
	
	public void initialiser() {
		
		carteX = ecran.tailleFinale * ecran.mondeColMax / 2;
		carteY = ecran.tailleFinale * ecran.mondeLignMax / 2;
		vitesse = 5;
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
			imageEchelle = ImageIO.read(getClass().getResourceAsStream("/renard/" + image + ".png"));
			imageEchelle = fct.miseAEchelle(imageEchelle, ecran.tailleFinale, ecran.tailleFinale);
		} catch (IOException e) {
			e.printStackTrace();
			// TODO: handle exception
		}
		return imageEchelle;
	}
	
	public void miseAJour() {
		
		if (action.haut || action.bas || action.gauche || action.droite) {
			if (action.haut == true) {
				direction = "haut";
			}
			if (action.bas == true) {
				direction = "bas";
			}
			if (action.gauche == true) {
				direction = "gauche";
			}
			if (action.droite == true) {
				direction = "droite";
			}
			
			collision = false;
			//ecran.collisions.AnalyserTerrain(this);
			
			int index = ecran.collisions.analyserObjet(this, true);
			interactionObject(index);
			// Entite e = ecran.collisions.analyserEntite(this);
			// interactionEntite(e);
			
			if (collision == false) {
				switch(direction) {
				case "haut":
					carteY -= vitesse;
					break;
				case "bas":
					carteY += vitesse;
					break;
				case "gauche":
					carteX -= vitesse;
					break;
				case "droite":
					carteX += vitesse;
					break;
				}
			}
		
			compteur++;
			if (compteur > 15) {
				if (marcher == 1) {
					marcher = 2;
				}
				else if (marcher == 2) {
					marcher = 1;
				}
				compteur = 0;
			}
		}

	}
	
	public void afficher(Graphics2D graph2) {
		//graph2.setColor(Color.black);
		//graph2.fillRect(x, y, ecran.tailleFinale, ecran.tailleFinale);
		
		BufferedImage image = null;
		
		switch(direction) {
		case "haut":
			if (marcher == 1) {
				image = arriere;
			}
			if (marcher == 2) {
				image = arriere1;
			}
			break;
		case "bas":
			if (marcher == 1) {
				image = avant;
			}
			if (marcher == 2) {
				image = avant1;
			}
			break;
		case "gauche":
			if (marcher == 1) {
				image = gauche;
			}
			if (marcher == 2) {
				image = gauche1;
			}
			break;
		case "droite":
			if (marcher == 1) {
				image = droite;
			}
			if (marcher == 2) {
				image = droite1;
			}
			break;
		}
		graph2.drawImage(image, ecranX, ecranY, null);
	}

}
