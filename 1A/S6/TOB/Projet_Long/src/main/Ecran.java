package main;

import Entites.Entite;
import java.util.*;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;

import javax.swing.JButton;
import javax.swing.JLayeredPane;
import javax.swing.JPanel;
import java.awt.event.ActionListener;
import java.awt.event.FocusEvent;
import java.awt.event.FocusListener;
import java.awt.event.ActionEvent;

import Entites.Entite;
import Entites.GestionEntite;
import Entites.Joueur;
import Entites.Poule;
import Entites.Renard;
import Entites.Vipere;
import object.GererObject;
import object.JeuObject;
import terrain.GestionTerrain;
import java.util.concurrent.CopyOnWriteArrayList;
import javax.swing.JLayeredPane;
import javax.swing.JLayeredPane;

public class Ecran extends JPanel implements Runnable {
	final int tailleElement = 16;
	final int echelle = 3;

	public final int tailleFinale = tailleElement * echelle;

	public final int colonneMax = 16;
	public final int ligneMax = 12;
	public final int ecranLongueur = colonneMax * tailleFinale;
	public final int ecranLargeur = ligneMax * tailleFinale;

	// param map monde
	public final int mondeColMax = 50;
	public final int mondeLignMax = 50;
	public final int mondeLongueur = tailleFinale * mondeColMax;
	public final int mondeLargeur = tailleFinale * mondeLignMax;

	ActionClavier action = new ActionClavier(this);
	Thread filDuJeu;

	public GestionTerrain terrain = new GestionTerrain(this);
	public VerifierCollision collisions = new VerifierCollision(this);
	public GererObject gerer = new GererObject(this);
	public GestionEntite gerer2 = new GestionEntite(this);

	public Son son = new Son();
	public Son musique = new Son();

	public Joueur joueur = new Joueur(this, action);

	public JeuObject obj[] = new JeuObject[10];
	public List<Entite> ent = new CopyOnWriteArrayList<>();

	public int nbrEntite = 0;

	public UI interfaceJoueur = new UI(this);

	int FPS = 60;

	public int etatActuel;
	public final int enJeu = 1;
	public final int pauseJeu = 2;
	public boolean terminer = false;
	public boolean commencer = false;
	public boolean strategieChassePoule = false;
	public boolean strategieChasseRenard = false;
	public boolean strategieChasseVipere = false;

	public int nombreRenards = 0;
	public int nombrePoules = 0;
	public int nombreViperes = 0;
	public int vipereTotal = 0;
	public int renradTotal = 0;
	public int poulesTotal = 0;

	private JButton buttonRenard;
	private JButton buttonPoule;
	private JButton buttonVipere;

	private JLayeredPane layeredPane;
	private JPanel gamePanel;

	public Ecran() {

		// Create the layered pane
		layeredPane = new JLayeredPane();
		layeredPane.setPreferredSize(new Dimension(ecranLongueur, ecranLargeur));
		this.setLayout(new BorderLayout());
		this.add(layeredPane, BorderLayout.CENTER);

		// Create and configure the game panel
		gamePanel = new JPanel() {
			@Override
			protected void paintComponent(Graphics g) {
				super.paintComponent(g);
				Ecran.this.drawGame(g);
			}
		};

		gamePanel.setBounds(0, 0, ecranLongueur, ecranLargeur);
		gamePanel.setBackground(Color.white);
		gamePanel.setDoubleBuffered(true);
		gamePanel.setFocusable(true);
		gamePanel.addKeyListener(action);

		// Create buttons
		buttonRenard = new JButton("Renard");
		buttonPoule = new JButton("Poule");
		buttonVipere = new JButton("Vipere");

		// Set bounds for buttons
		buttonRenard.setBounds(50, 50, 80, 30);
		buttonPoule.setBounds(50, 100, 80, 30);
		buttonVipere.setBounds(50, 150, 80, 30);

		// Add action listeners to the buttons
		// Add action listeners to buttons
		buttonRenard.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				if (etatActuel == enJeu && commencer) {
					Random random = new Random();
					int newX = random.nextInt(mondeColMax);
					int newY = random.nextInt(mondeLignMax);
					int typeTerrain = terrain.parcoursCarte[newX][newY];

					if (terrain.terrain[typeTerrain].interaction == false) {

						ent.add(new Renard(newX, newY, nbrEntite, "M", Ecran.this));

					}
					gamePanel.requestFocusInWindow();
				}
			}
		});

		buttonPoule.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				if (etatActuel == enJeu && commencer) {
					Random random = new Random();
					int newX = random.nextInt(mondeColMax);
					int newY = random.nextInt(mondeLignMax);
					int typeTerrain = terrain.parcoursCarte[newX][newY];

					if (terrain.terrain[typeTerrain].interaction == false) {
						ent.add(new Poule(newX, newY, nbrEntite, "M", Ecran.this));
					}
					gamePanel.requestFocusInWindow();
				}
			}
		});

		buttonVipere.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				if (etatActuel == enJeu && commencer) {
					Random random = new Random();
					int newX = random.nextInt(mondeColMax);
					int newY = random.nextInt(mondeLignMax);
					int typeTerrain = terrain.parcoursCarte[newX][newY];

					if (terrain.terrain[typeTerrain].interaction == false) {

						ent.add(new Vipere(newX, newY, nbrEntite, "M", Ecran.this));
					}
					gamePanel.requestFocusInWindow();
				}
			}
		});

		layeredPane.add(gamePanel, JLayeredPane.DEFAULT_LAYER);
		layeredPane.add(buttonRenard, JLayeredPane.PALETTE_LAYER);
		layeredPane.add(buttonPoule, JLayeredPane.PALETTE_LAYER);
		layeredPane.add(buttonVipere, JLayeredPane.PALETTE_LAYER);

	}

	public void initialiserJeu() {
		gerer.setObjects();
		gerer2.setObjects();
		//jouerMusique(0);
		etatActuel = enJeu;
		gamePanel.requestFocusInWindow();

	}

	public void lancerFil() {

		filDuJeu = new Thread(this);
		filDuJeu.start();
		gamePanel.requestFocusInWindow();
	}

	@Override
	public void run() {

		while (filDuJeu != null) {

			double intervalle = 1000000000 / FPS;
			double prochainIntervalle = System.nanoTime() + intervalle;

			// ent.add(new Poule(6, 6, this.nbrEntite, "F", this));

			miseAJour();

			repaint();

			try {
				double tempsRestant = (prochainIntervalle - System.nanoTime()) / 1000000;

				if (tempsRestant < 0) {
					tempsRestant = 0;
				}

				Thread.sleep((long) tempsRestant);

				prochainIntervalle += intervalle;

			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	public void miseAJour() {

		if (etatActuel == enJeu && commencer) {
			joueur.miseAJour();


			for (Entite e : ent) {
				if (e != null) {
					if (e instanceof Renard) {
						if (strategieChasseRenard == true){
							if (this.nombrePoules == 0) {
								e.Deplacer(e, 30);
							} else {
								e.chasseRenard(e);
							}
						}else {
							e.Deplacer(e, 30);
						}
					}
					if (e instanceof Poule) {
						if (strategieChassePoule == true){
							if (this.nombreViperes == 0) {
								e.Deplacer(e, 30);
							} else {
								e.chassePoule(e);
							}
						}else {
							e.Deplacer(e, 30);
						}
					}
					if (e instanceof Vipere) {
						if (strategieChasseVipere == true){
							if (this.nombreRenards == 0) {
								e.Deplacer(e, 30);
							} else {
								e.chasseVipere(e);
							}
						}else {
							e.Deplacer(e, 30);
						}
					}
				}
			}
			
			gerer2.verifierMorts();
		}
		if (etatActuel == pauseJeu) {

		}
	}

	int compteur = 0;

	@Override
	public void paintComponent(Graphics g) {
		super.paintComponent(g);
		gamePanel.repaint();
	}

	public void drawGame(Graphics graph) {

		Graphics2D graph2 = (Graphics2D) graph;

		terrain.afficher(graph2);

		for (int i = 0; i < obj.length; i++) {
			if (obj[i] != null) {
				obj[i].afficher(graph2, this);
			}
		}

		if (commencer) {
			for (Entite e : ent) {
				if (e != null) {
					e.afficher(graph2);
					// System.out.println(e.carteX + " " + e.carteY);
				}
			}
		}

		joueur.afficher(graph2);

		interfaceJoueur.afficher(graph2);

		graph2.dispose();

	}

	public void jouerMusique(int i) {
		musique.setFichier(i);
		musique.play();
		musique.loop();
	}

	public void stopperMusique(int i) {
		musique.stop();
	}

	public void jouerSE(int i) {
		son.setFichier(i);
		son.play();
	}
}