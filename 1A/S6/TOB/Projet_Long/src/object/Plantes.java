package object;

import java.io.IOException;
import javax.imageio.ImageIO;

import main.Ecran;

public class Plantes extends JeuObject {
	
	Ecran ecran;

	public Plantes(Ecran ecran) {
		nom = "Chaussure";
		this.ecran = ecran;
		try {
			image = ImageIO.read(getClass().getResourceAsStream("/items/Chaussures.png"));
			fct.miseAEchelle(image, ecran.tailleFinale, ecran.tailleFinale);

		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
