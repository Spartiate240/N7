package allumettes;

import org.junit.*;
import static org.junit.Assert.*;


/** Classe de test de la stratégie rapide.
 * @author DUROLLET Pierre
 * @version 1.4
 */
 
public class StratRapideTest {
    /** Creer la stratégie rapide. */
    private Rapide rapide = new Rapide();



    //* Tester qu'il prenne bien PRISE_MAX lorsqu'il y a plus d'allumettes. */
    @Test
    public void testRapidePrisemaxSupNbAll() {
        // Creer un jeu avec un nombre d'allumettes inferieur à PRISE_MAX
        Jeu jeu = new JeuReel(2); 
        int prise = rapide.getPrise(jeu);

        assertEquals("Ne prends pas le nombre d'allumettes s'il en reste moins de PRISE_MAX",2 ,prise,0);
    }

    //* Tester quand il reste moins d'allumettes que PRISE_MAX. */
    @Test
    public void testRapidePrisemaxInfNbAll() {
        Jeu jeu = new JeuReel(5); 
        int prise = rapide.getPrise(jeu);

        assertEquals("Ne prends pas PRISE_MAX",Jeu.PRISE_MAX, prise,0);
    }

    //* Tester si on utlise getPrise sans qu'il n'y ait de jeu (Jeu = null) */
    @Test(expected = NullPointerException.class)
    public void testJeuNull() {
        rapide.getPrise(null);
    }
}
