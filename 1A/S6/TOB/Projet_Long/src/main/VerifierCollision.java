package main;

import Entites.Entite;

public class VerifierCollision {
	
	Ecran ecran;
	
	public VerifierCollision(Ecran ecran) {
		this.ecran = ecran;
	}
	
	public void AnalyserTerrain(Entite entite) {

		int gaucheX = entite.carteX + entite.aireCollision.x;
		int droiteX = entite.carteX + entite.aireCollision.x + entite.aireCollision.width;
		int hautY = entite.carteY + entite.aireCollision.y;
		int basY = entite.carteY + entite.aireCollision.y + entite.aireCollision.height;
	
		int colGauche = gaucheX / ecran.tailleFinale;
		int colDroite = droiteX / ecran.tailleFinale;
		int lignHaut = hautY / ecran.tailleFinale;
		int lignBas = basY / ecran.tailleFinale;
	
		int numTerrain1, numTerrain2;
	
		switch (entite.direction) {
			case "haut":
				lignHaut = (hautY + entite.vitesse) / ecran.tailleFinale;
				if (lignHaut < ecran.terrain.parcoursCarte[0].length && colGauche < ecran.terrain.parcoursCarte.length && colDroite < ecran.terrain.parcoursCarte.length && lignHaut >= 0 && colGauche >= 0 && colDroite >= 0) {
					numTerrain1 = ecran.terrain.parcoursCarte[colGauche][lignHaut];
					numTerrain2 = ecran.terrain.parcoursCarte[colDroite][lignHaut];
					if (ecran.terrain.terrain[numTerrain1].interaction || ecran.terrain.terrain[numTerrain2].interaction) {
						entite.direction = "bas";
					}
				}
				break;
			case "bas":
				lignBas = (basY - entite.vitesse) / ecran.tailleFinale;
				if (lignBas < ecran.terrain.parcoursCarte[0].length && colGauche < ecran.terrain.parcoursCarte.length && colDroite < ecran.terrain.parcoursCarte.length && lignBas >= 0 && colGauche >= 0 && colDroite >= 0) {
					numTerrain1 = ecran.terrain.parcoursCarte[colGauche][lignBas];
					numTerrain2 = ecran.terrain.parcoursCarte[colDroite][lignBas];
					if (ecran.terrain.terrain[numTerrain1].interaction || ecran.terrain.terrain[numTerrain2].interaction) {
						entite.direction = "haut";
					}
				}
				break;
			case "gauche":
				colGauche = (gaucheX - entite.vitesse) / ecran.tailleFinale;
				if (colGauche < ecran.terrain.parcoursCarte.length && lignHaut < ecran.terrain.parcoursCarte[0].length && lignBas < ecran.terrain.parcoursCarte[0].length && lignHaut >= 0 && colGauche >= 0 && lignBas >= 0) {
					numTerrain1 = ecran.terrain.parcoursCarte[colGauche][lignHaut];
					numTerrain2 = ecran.terrain.parcoursCarte[colGauche][lignBas];
					if (ecran.terrain.terrain[numTerrain1].interaction || ecran.terrain.terrain[numTerrain2].interaction) {
						entite.direction = "droite";
					}
				}
				break;
			case "droite":
				colDroite = (droiteX - entite.vitesse) / ecran.tailleFinale;
				if (colDroite < ecran.terrain.parcoursCarte.length && lignHaut < ecran.terrain.parcoursCarte[0].length && lignBas < ecran.terrain.parcoursCarte[0].length && lignHaut >= 0 && lignBas >= 0 && colDroite >= 0) {
					numTerrain1 = ecran.terrain.parcoursCarte[colDroite][lignHaut];
					numTerrain2 = ecran.terrain.parcoursCarte[colDroite][lignBas];
					if (ecran.terrain.terrain[numTerrain1].interaction || ecran.terrain.terrain[numTerrain2].interaction) {
						entite.direction = "gauche";
					}
				}
				break;
		}
	}
	

	public Entite analyserEntite(Entite entite) {		
		for (Entite e: ecran.ent) {
			if (e != entite) {
				entite.aireCollision.x = entite.aireCollision.x + entite.carteX;
				entite.aireCollision.y = entite.aireCollision.y + entite.carteY;
			
				e.aireCollision.x = e.aireCollision.x + e.carteX;
				e.aireCollision.y = e.aireCollision.y + e.carteY;
			
				switch (entite.direction) {
				case "haut":
					entite.aireCollision.y -= entite.vitesse;
					if (entite.aireCollision.intersects(e.aireCollision)) {
							entite.direction = "bas";
							return e;
					}
					break;
				case "bas":
					entite.aireCollision.y += entite.vitesse;
					if (entite.aireCollision.intersects(e.aireCollision)) {
							entite.direction = "haut";
							return e;
						
					}
					break;
				case "gauche":
					entite.aireCollision.x -= entite.vitesse;
					if (entite.aireCollision.intersects(e.aireCollision)) {
							entite.direction = "droite";
							return e;
						
					}
					break;
				case "droite":
					entite.aireCollision.x += entite.vitesse;
					if (entite.aireCollision.intersects(e.aireCollision)) {
							entite.direction = "gauche";
							return e;
						
					}
					break;
				}
				entite.aireCollision.x = entite.aireSolideDefautX;
				entite.aireCollision.y = entite.aireSolideDefautY;
			
				e.aireCollision.x = e.aireSolideDefautX;
				e.aireCollision.y = e.aireSolideDefautY;
			}
		}
		return null;
	}
	
	public int analyserObjet(Entite entite, boolean joueur) {
		
		int index = 999;
		
		for (int i=0; i < ecran.obj.length; i++) {
			if (ecran.obj[i] != null) {
			entite.aireCollision.x = entite.aireCollision.x + entite.carteX;
			entite.aireCollision.y = entite.aireCollision.y + entite.carteY;
			
			ecran.obj[i].aireSolide.x = ecran.obj[i].aireSolide.x + ecran.obj[i].x;
			ecran.obj[i].aireSolide.y = ecran.obj[i].aireSolide.y + ecran.obj[i].y;
			
			switch (entite.direction) {
			case "haut":
				entite.aireCollision.y -= entite.vitesse;
				if (entite.aireCollision.intersects(ecran.obj[i].aireSolide)) {
					if (ecran.obj[i].collision == true) {
						entite.collision = true;
					}
					if (joueur == true) {
						index = i;
					}
				}
				break;
			case "bas":
				entite.aireCollision.y += entite.vitesse;
				if (entite.aireCollision.intersects(ecran.obj[i].aireSolide)) {
					if (ecran.obj[i].collision == true) {
						entite.collision = true;
					}
					if (joueur == true) {
						index = i;
					}
				}
				break;
			case "gauche":
				entite.aireCollision.x -= entite.vitesse;
				if (entite.aireCollision.intersects(ecran.obj[i].aireSolide)) {
					if (ecran.obj[i].collision == true) {
						entite.collision = true;
					}
					if (joueur == true) {
						index = i;
					}
				}
				break;
			case "droite":
				entite.aireCollision.x += entite.vitesse;
				if (entite.aireCollision.intersects(ecran.obj[i].aireSolide)) {
					if (ecran.obj[i].collision == true) {
						entite.collision = true;
					}
					if (joueur == true) {
						index = i;
					}
				}
				break;
			}
			entite.aireCollision.x = entite.aireSolideDefautX;
			entite.aireCollision.y = entite.aireSolideDefautY;
			
			ecran.obj[i].aireSolide.x = ecran.obj[i].aireDefautX;
			ecran.obj[i].aireSolide.y = ecran.obj[i].aireDefautY;
		}
		}
		return index;
	}
}
