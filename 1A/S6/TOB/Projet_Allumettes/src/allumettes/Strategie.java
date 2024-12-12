package allumettes;

public interface Strategie {
    /** Nombre d'allumettes que prends le Joueur.
     * @param jeu jeu en cours
     * @return Le nombre d'allumeettes prises
     */
    int getPrise(Jeu jeu);
}

