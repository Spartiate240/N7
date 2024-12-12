package allumettes;

import java.util.Scanner;

/** Stratégie où c'est un humain qui joue.
 * @author	DUROLLET Pierre
 * @version	1.4
 */
public class Humain implements Strategie {

    private static Scanner scanString = new Scanner(System.in);
    private String nom;

    // Construcuteurs

    public Humain() {
        this.nom = "aucun nom";
    }

    public Humain(String nom) {
        this.nom = nom;
    }



    @Override
    public int getPrise(Jeu jeu) {
        int s = 0;
        boolean entreevalide = false;

        do {
            System.out.print(this.nom + ", combien d'allumettes ? ");
            String entreeString = scanString.nextLine();
            if (entreeString.equals("triche")) {
                if (jeu.getNombreAllumettes() == 1) {
                    System.out.println("Tu as perdu.");
                } else {
                    try {
                        jeu.retirer(1);
                        System.out.println("[Une allumette en moins, plus que "
                                        + jeu.getNombreAllumettes() + ". Chut !]");

                    } catch (CoupInvalideException e) {
                    }
                }
            } else {
                try {
                    s = Integer.parseInt(entreeString);
                    entreevalide = true; // Afin de quitter la boucle

                } catch (NumberFormatException e) {
                    throw new NumberFormatException();
                }
            }
        } while (!entreevalide); // Permets de boucler jusqu'à un entier soit entré.

        return s;
    }
}
