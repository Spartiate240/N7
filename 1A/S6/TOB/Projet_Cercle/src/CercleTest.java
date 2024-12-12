import java.awt.Color;
import org.junit.*;
import static org.junit.Assert.*;
public class CercleTest {

	// précision pour les comparaisons réelle
	public final static double EPSILON = 0.001;

	// Les points du sujet
	private Point  D, E, cen12_13;

	// Les cercles du sujet
	private Cercle C12, C13, C14;

	@Before public void setUp() {
		// Construire les points
		D = new Point(-8, 1);
		E = new Point(-8, 4);

		// Construire les cercles
		C12 = new Cercle(D, E);
        // Centre de C12 et C13:
        cen12_13 = new Point(-8, 2.5);

        C13 = new Cercle(D,E, Color.YELLOW);


		C14 = Cercle.creerCercle(D,E);
    }
	/** Vérifier si deux Pointpoints ont mêmes coordonnées.
	  * @param p1 le premier point
	  * @param p2 le deuxième point
	  */
      static void memesCoordonnees(String message, Point p1, Point p2) {
		assertEquals(message + " (x)", p1.getX(), p2.getX(), EPSILON);
		assertEquals(message + " (y)", p1.getY(), p2.getY(), EPSILON);
	}


	@Test public void testerE12() {
		memesCoordonnees("E12 : Centre de C12 incorrect", cen12_13, C12.getCentre());
		assertEquals("E12 : Rayon incorrect",
				1.5, C12.getRayon(), EPSILON);
		assertEquals("E12 : couleur du cercle incorrect", Color.blue, C12.getCouleur());
	}



	@Test public void testerE13() {
		memesCoordonnees("E13 : Centre de C13 incorrect", cen12_13, C13.getCentre());
		assertEquals("E13 : Rayon incorrect",
				1.5, C13.getRayon(), EPSILON);
		assertEquals("E13 : couleur du cercle incorrect", Color.YELLOW, C13.getCouleur());
	}



	@Test public void testerE14() {
		memesCoordonnees("E14 : Centre de C1 incorrect", D, C14.getCentre());   //Par définition de creerCercle, D est le centre
		assertEquals("E14 : Rayon incorrect",
				3, C14.getRayon(), EPSILON);
		assertEquals("E14 : couleur du cercle incorrect", Color.blue, C14.getCouleur());
	}

}