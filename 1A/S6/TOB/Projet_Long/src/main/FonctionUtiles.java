package main;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;

public class FonctionUtiles {
    

    public BufferedImage miseAEchelle(BufferedImage originelle, int longueur, int hauteur) {
        BufferedImage imageEchelle = new BufferedImage(longueur, hauteur, originelle.getType());
        Graphics2D graph = imageEchelle.createGraphics();
        graph.drawImage(originelle, 0, 0, longueur, hauteur, null);
        graph.dispose();

        return imageEchelle;
    }
}
