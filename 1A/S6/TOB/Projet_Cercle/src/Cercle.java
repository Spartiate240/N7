import java.awt.Color;

public class Cercle implements Mesurable2D {
    /**
     * Centre du cercle.
     */
    private Point centre;
    /**
     * Rayon du cercle.
     */
    private double rayon;
    /**
     * Couleur du cercle.
     */
    private Color couleur;
    /**
     * Pi mise en constante.
     */
    public static final double PI = Math.PI;

    // Constructeurs

    /**
     * Construire un cercle à partir d'un point de centre et un rayon.
     *
     * @param point1 centre du cercle
     * @param r      rayon du cercle
     */
    public Cercle(Point point1, double r) {
        assert point1 != null && r > 0;
        this.centre = new Point(point1.getX(), point1.getY());
        this.rayon = r;
        this.couleur = Color.blue; // Couleur par défaut
    }

    /**
     * Consuitre un cercle d'une couleur donnee et avec 2 points opposés.
     *
     * @param point1     point d'un opposé
     * @param point2     2 point à l'opposé du 1er
     * @param setcouleur couleur que prends le cercle
     */
    public Cercle(Point point1, Point point2, Color setcouleur) {
        assert point1 != null && point2 != null & setcouleur != null;
        this.rayon = point1.distance(point2) / 2;
        assert rayon > 0;
        this.couleur = setcouleur;

        double xA = point1.getX();
        double yA = point1.getY();
        double xB = point2.getX();
        double yB = point2.getY();
        // détermination du centre du cercle
        double xC = (xA + xB) / 2;
        double yC = (yA + yB) / 2;
        this.centre = new Point(xC, yC);
    }

    /**
     * Construire un cercle à partir de 2 points opposés.
     *
     * @param point1 point d'un opposé
     * @param point2 point à l'autre opposé du cercle
     */
    public Cercle(Point point1, Point point2) {
        this(point1, point2, Color.BLUE);
    }

    // Methodes:

    /**
     * Translate le cercle.
     *
     * @param dx distance à translater suivant le 1er paramètre
     * @param dy distance à translater suvant le 2e paramètre
     */
    public void translater(double dx, double dy) {
        this.centre.translater(dx, dy);
    }

    /**
     * Obtenir le centre du cercle.
     *
     * @return le centre du cercle
     */
    public Point getCentre() {
        return new Point(this.centre.getX(), this.centre.getY());
    }

    /**
     * Obtenir le rayon du cercle.
     *
     * @return le rayon du cercle
     */
    public double getRayon() {
        return this.rayon;
    }

    /**
     * Obtenir le diamètre du cercle.
     *
     * @return le diamètre du cercle
     */
    public double getDiametre() {
        return 2 * this.rayon;
    }

    /**
     * Déterminer si un point appartient au cercle.
     *
     * @param point2 Point dont l'appartenance au cercle est à déterminer
     * @return si le point est dans le cercle ou sur son bord
     */
    public boolean contient(Point point2) {
        assert point2 != null;
        return this.centre.distance(point2) <= this.rayon;
    }

    /**
     * Obtenir le périmètre du cercle.
     *
     * @return le périmètre du cercle
     */
    public double perimetre() {
        return 2 * PI * this.rayon;
    }

    /**
     * Obtenir l'aire du cercle.
     *
     * @return l'aire du cercle
     */
    public double aire() {
        return PI * Math.pow(this.rayon, 2);
    }

    /**
     * Obtenir la couleur du cercle.
     *
     * @return la couleur du cercle
     */
    public Color getCouleur() {
        return this.couleur;
    }

    /**
     * Changer la couleur du cercle.
     *
     * @param nouvellecouleur nouvelle couleur pour le cercle
     */
    public void setCouleur(Color nouvellecouleur) {
        assert nouvellecouleur != null;
        this.couleur = nouvellecouleur;
    }

    /**
     * Changer le rayon du cercle.
     *
     * @param nouveaurayon nouvelle valeur pour le rayon du cercle
     */
    public void setRayon(double nouveaurayon) {
        assert nouveaurayon > 0;
        this.rayon = nouveaurayon;
    }

    /**
     * Changer le diamètre du cercle.
     *
     * @param nouveaudiametre
     */
    public void setDiametre(double nouveaudiametre) {
        assert nouveaudiametre > 0;
        this.rayon = nouveaudiametre / 2;
    }

    /**
     * Créer un cercle à partir d'un point central et d'un point sur la
     * circonférnce du cercle.
     *
     * @param point2 Point au centre du cercle
     * @param point1 Point sur la circonférnce du cercle
     *
     * @return un nouveau cercle
     */
    public static Cercle creerCercle(Point point2, Point point1) {
        assert point2 != null && point1 != null;
        double r = point2.distance(point1);
        assert r != 0;
        Cercle affichageCercle = new Cercle(point2, r);
        return affichageCercle;
    }

    /**
     * Afficher un cercle dans le terminal sous forme Cr@(a, b).
     *
     * @return L'afichage voulu
    */
    public String toString() {
        double cercle = this.rayon;
        return "C" + Double.toString(cercle) + "@" + this.centre.toString();
    }

}
