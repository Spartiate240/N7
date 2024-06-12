package main;

import javax.swing.JFrame;

public class Main {
	public static void main(String[] args) {
		
		JFrame affichage = new JFrame();
		affichage.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		affichage.setResizable(false);
		affichage.setTitle("Ecosyst7m");
		
		Ecran ecran = new Ecran();
		affichage.add(ecran);
		
		affichage.pack();
		
		affichage.setLocationRelativeTo(null);
		affichage.setVisible(true);
		
		ecran.initialiserJeu();
		ecran.lancerFil();
	}
}