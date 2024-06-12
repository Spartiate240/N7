package object;

import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.image.BufferedImage;

import main.Ecran;
import main.FonctionUtiles;

public class JeuObject {
	
	public BufferedImage image;
	public String nom;
	public boolean collision = false;
	public int x, y;
	public Rectangle aireSolide = new Rectangle(0, 0, 48, 48);
	public int aireDefautX = 0;
	public int aireDefautY = 0;
	FonctionUtiles fct = new FonctionUtiles();
	
	public void afficher(Graphics2D graph, Ecran ecran) {
		int actuelX = x - ecran.joueur.carteX + ecran.joueur.ecranX;
		int actuelY = y - ecran.joueur.carteY + ecran.joueur.ecranY;
		
		if (x + ecran.tailleFinale > ecran.joueur.carteX - ecran.joueur.ecranX 
				&& x - ecran.tailleFinale < ecran.joueur.carteX + ecran.joueur.ecranX
				&& y + ecran.tailleFinale > ecran.joueur.carteY - ecran.joueur.ecranY 
				&& y - ecran.tailleFinale < ecran.joueur.carteY + ecran.joueur.ecranY) {

			
					// System.out.println(actuelX);
					// System.out.println(actuelY);

			graph.drawImage(image, actuelX, actuelY, ecran.tailleFinale, ecran.tailleFinale, null);
		}
	}
}
