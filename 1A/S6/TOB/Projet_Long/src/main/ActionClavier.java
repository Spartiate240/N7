package main;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.util.Random;

import Entites.Poule;
import Entites.Renard;
import Entites.Vipere;

public class ActionClavier implements KeyListener {

	Ecran ecran;
	public boolean haut, bas, gauche, droite;

	public ActionClavier(Ecran ecran) {
		this.ecran = ecran;
	}

	@Override
	public void keyTyped(KeyEvent e) {
	}

	@Override
	public void keyPressed(KeyEvent e) {
		int touche = e.getKeyCode();

		if (touche == KeyEvent.VK_RIGHT) {
			droite = true;
		}

		if (touche == KeyEvent.VK_LEFT) {
			gauche = true;
		}

		if (touche == KeyEvent.VK_UP) {
			haut = true;
		}

		if (touche == KeyEvent.VK_DOWN) {
			bas = true;
		}

		if (touche == KeyEvent.VK_ESCAPE) {
			if (ecran.etatActuel == ecran.enJeu) {
				ecran.etatActuel = ecran.pauseJeu;
			} else if (ecran.etatActuel == ecran.pauseJeu) {
				ecran.etatActuel = ecran.enJeu;
			}
		}

		if (touche == KeyEvent.VK_E) {
			ecran.interfaceJoueur.finDuJeu = true;
		}

		if (touche == KeyEvent.VK_K) {
			ecran.commencer = true;
			ecran.strategieChassePoule = !ecran.strategieChassePoule;

			//System.out.println("Lancement du jeu");
		}
		if (touche == KeyEvent.VK_L) {
			ecran.commencer = true;
			ecran.strategieChasseRenard = !ecran.strategieChasseRenard;
			//System.out.println("Lancement du jeu");
		}
		if (touche == KeyEvent.VK_M) {
			ecran.commencer = true;
			ecran.strategieChasseVipere = !ecran.strategieChasseVipere;
			//System.out.println("Lancement du jeu");
		}
		if (touche == KeyEvent.VK_A) {
			ecran.commencer = true;
			//System.out.println("Lancement du jeu");
		}

		if (touche == KeyEvent.VK_P) {
			Random random = new Random();
			int newX = random.nextInt(ecran.mondeColMax);
			int newY = random.nextInt(ecran.mondeLignMax);
			int typeTerrain = ecran.terrain.parcoursCarte[newX][newY];	

			if (ecran.terrain.terrain[typeTerrain].interaction == false) {
				ecran.ent.add(new Poule(newX, newY, ecran.nbrEntite, "M", ecran));
			}
		}

		if (touche == KeyEvent.VK_R) {
			Random random = new Random();
			int newX = random.nextInt(ecran.mondeColMax);
			int newY = random.nextInt(ecran.mondeLignMax);
			int typeTerrain = ecran.terrain.parcoursCarte[newX][newY];

			if (ecran.terrain.terrain[typeTerrain].interaction == false) {

				ecran.ent.add(new Renard(newX, newY, ecran.nbrEntite, "M", ecran));
			}
		}

		if (touche == KeyEvent.VK_V) {
			Random random = new Random();
			int newX = random.nextInt(ecran.mondeColMax);
			int newY = random.nextInt(ecran.mondeLignMax);
			int typeTerrain = ecran.terrain.parcoursCarte[newX][newY];

			if (ecran.terrain.terrain[typeTerrain].interaction == false) {

				ecran.ent.add(new Vipere(newX, newY, ecran.nbrEntite, "M", ecran));
			}
		}

		if (touche == KeyEvent.VK_C) {
			ecran.interfaceJoueur.commandes = true;
		}

	}

	@Override
	public void keyReleased(KeyEvent e) {

		int touche = e.getKeyCode();

		if (touche == KeyEvent.VK_RIGHT) {
			droite = false;
		}

		if (touche == KeyEvent.VK_LEFT) {
			gauche = false;
		}

		if (touche == KeyEvent.VK_UP) {
			haut = false;
		}

		if (touche == KeyEvent.VK_DOWN) {
			bas = false;
		}

		if (touche == KeyEvent.VK_C) {
			ecran.interfaceJoueur.commandes = false;
		}
	}

}
