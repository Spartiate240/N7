package Entites;

import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.PriorityQueue;
import java.util.Random;

import javax.imageio.ImageIO;
import javax.swing.text.Position;

import main.Ecran;

public class Entite {

    public int carteX, carteY;
    public int vitesse;

    public BufferedImage avant, arriere, gauche, droite, avant1, arriere1, gauche1, droite1;
    public String direction;

    int marcher = 1;
    int compteur = 0;
    int attente = 0;
    int initCollision = 0;

    public Rectangle aireCollision;
    public int aireSolideDefautX, aireSolideDefautY;
    public boolean collision = false;

    public int dureeVie;
    private int pv;
    private int food;
    private int age;
    private int degats;
    private String nom;
    private int fertilite;
    private Boolean actionHaut, actionBas, actionGauche, actionDroite;
    private boolean estDeplace;
    private String sexe;
    private boolean alive = true;

    public Ecran ecran;

    public Entite(int pv, int degats, int food, int fertilite, int age, int vitesse, String nom, String sexe,
            Ecran ecran) {
        this.pv = pv;
        this.age = age;
        this.degats = degats;
        this.nom = nom;
        this.food = food;
        this.fertilite = fertilite;
        this.sexe = sexe;
        this.ecran = ecran;
        this.vitesse = vitesse;
    }

    public int getPv() {
        return pv;
    }

    public int getDegats() {
        return degats;
    }

    public String getNom() {
        return nom;
    }

    public String getSexe() {
        return sexe;
    }

    public int getFood() {
        return food;
    }

    public void setFood(int food) {
        if (this.food + food <= 10000) {
            this.food = this.food + food;
        }
        if (this.food <= 0) {
            setPv(0);
        }
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        String[] nvNom = this.nom.split(" ");
        if (this.age > 1){
            this.age = this.age - age;
        }
        
        double mort = Math.random();
        if (mort < ((double) 1 / this.age)) {   
                setPv(0);
        }
        
        if (this.age <= dureeVie - dureeVie / 4 && nvNom.length > 1) {
            this.nom = "jeune " + nvNom[1];
        }
        if (this.age <= dureeVie / 2 && nvNom.length > 1) {
            this.nom = nvNom[1];
        }
    }

    public int getFertilite() {
        return fertilite;
    }

    public void setFertilite(int fertilite) {
        if (this.fertilite + fertilite < 12000) {
            this.fertilite = this.fertilite + fertilite;
        }
    }

    public void setAlive(boolean alive) {
        this.alive = alive;
    }

    public void setPv(int pv) {
        this.pv = pv;
        if (this.pv <= 1) {
            this.alive = false;
        }
    }

    public void changePV(int pv) {
        this.pv -= pv;
        if (this.pv <= 0) {
            this.alive = false;
        }
    }

    public boolean isAlive() {
        return alive;
    }

    public Boolean estDeplace() {
        return estDeplace;
    }

    public void finDuTour() {
        estDeplace = false;
    }

    public void hasard() {
        actionBas = false;
        actionDroite = false;
        actionGauche = false;
        actionHaut = false;
        Random alea = new Random();
        int choix = alea.nextInt(4);
        switch (choix) {
            case 0:
                actionHaut = true;
                break;
            case 1:
                actionBas = true;
                break;
            case 2:
                actionGauche = true;
                break;
            case 3:
                actionDroite = true;
                break;
        }
    }

    int[] chercherPartenaire() {
        int[] pos = new int[2];
        int x = this.carteX;
        int y = this.carteY;
        int distance = 1000;
        for (Entite e : ecran.ent) {
            if (e.getClass() == this.getClass()) {
                int partenaireX = e.carteX;
                int partenaireY = e.carteY;
                int distanceVipere = ((x - partenaireX) ^ 2 + (y - partenaireY) ^ 2);
                if (distanceVipere < distance) {
                    distance = distanceVipere;
                    pos[0] = e.carteX;
                    pos[1] = e.carteY;
                }
            }
        }
        return pos;
    }

    public void moveToVipere() {
        int[] vipereProche = this.chercherPartenaire();
        if (vipereProche != null) {
            // this.direction = ecran.gerer2.trouverChemin(vipereProche, this);

        }

    }

    public void Deplacer(Entite entite, int delai) {

        attente++;
        if (attente > delai) {
            hasard();
            if (actionHaut == true) {
                direction = "haut";
            }
            if (actionBas == true) {
                direction = "bas";
            }
            if (actionGauche == true) {
                direction = "gauche";
            }
            if (actionDroite == true) {
                direction = "droite";
            }
            attente = 0;
        }

        bouger(entite, direction);

    }

    public void bouger(Entite entite, String direction) {
        collision = false;
        ecran.collisions.AnalyserTerrain(this);

        int index = ecran.collisions.analyserObjet(this, true);
        Entite e = ecran.collisions.analyserEntite(this);
        interactionObject(index);
        interactionEntite(e);

        if (collision == false) {
            switch (direction) {
                case "haut":
                    carteY -= entite.vitesse;
                    break;
                case "bas":
                    carteY += entite.vitesse;
                    break;
                case "gauche":
                    carteX -= entite.vitesse;
                    break;
                case "droite":
                    carteX += entite.vitesse;
                    break;
            }

        }

        if (compteur > 15) {
            if (marcher == 1) {
                marcher = 2;
            } else if (marcher == 2) {
                marcher = 1;
            }
            compteur = 0;

        }
        compteur++;

    }

    public void interactionObject(int index) {

    }

    public void interactionEntite(Entite e) {
        if (e != null) {
            if (this instanceof Poule) {
                interactionPoule(e);
            } else if (this instanceof Renard) {
                interactionRenard(e);
            } else if (this instanceof Vipere) {
                interactionVipere(e);
            }
        }
    }

    private void interactionPoule(Entite e) {
        Poule poule = (Poule) this;
        if (e instanceof Vipere) {
            Vipere vipere = (Vipere) e;
            interactionPouleVipere(vipere, poule);
        } else if (canReproduce(e)) {
            reproduce(e, Poule::new);
        }
    }

    private void interactionRenard(Entite e) {
        Renard renard = (Renard) this;
        if (e instanceof Poule) {
            Poule poule = (Poule) e;
            interactionPouleRenard(poule, renard);
        } else if (canReproduce(e) && e instanceof Renard) {
            reproduce(e, Renard::new);
        }

    }

    private void interactionVipere(Entite e) {
        Vipere vipere = (Vipere) this;
        if (e instanceof Renard) {
            Renard renard = (Renard) e;
            interactionRenardVipere(renard, vipere);
        } else if (canReproduce(e)) {
            reproduce(e, Vipere::new);
        }
    }

    private boolean canReproduce(Entite e) {
        return !e.getNom().equals(this.getNom())
                && e.getFertilite() >= 10000 && e.getPv() > 0 && this.getFertilite() >= 10000
                && !e.getSexe().equals(this.getSexe());
    }

    private void reproduce(Entite e, EntityFactory factory) {
        Random random = new Random();
        String sexe = random.nextInt(2) == 0 ? "M" : "F";

        Entite newAnimal = factory.create(this.carteX / ecran.tailleFinale + 2, this.carteY / ecran.tailleFinale + 2,
                ecran.nbrEntite, sexe, ecran);
        ecran.ent.add(newAnimal);
        e.setFertilite(-10000);
        this.setFertilite(-10000);
    }

    public void interactionPouleRenard(Poule poule, Renard renard) {
        poule.changePV(renard.getDegats());
        if (!poule.isAlive()) {
            renard.setFood(2000);
        }
    }

    public void interactionPouleVipere(Vipere vipere, Poule poule) {
        vipere.changePV(poule.getDegats());
        if (!vipere.isAlive()) {
            poule.setFood(2000);
        }
    }

    public void interactionRenardVipere(Renard renard, Vipere vipere) {
        renard.changePV(vipere.getDegats());
        if (!renard.isAlive()) {
            vipere.setFood(2000);
        }
    }

    interface EntityFactory {
        Entite create(int carteX, int carteY, int nbrEntite, String sexe, Ecran ecran);
    }

    public void afficher(Graphics2D graph2) {
        // graph2.setColor(Color.black);
        // graph2.fillRect(x, y, ecran.tailleFinale, ecran.tailleFinale);

        BufferedImage image = null;

        int actuelX = carteX - ecran.joueur.carteX + ecran.joueur.ecranX;
        int actuelY = carteY - ecran.joueur.carteY + ecran.joueur.ecranY;

        switch (direction) {
            case "haut":
                if (marcher == 1) {
                    image = arriere;
                }
                if (marcher == 2) {
                    image = arriere1;
                }
                break;
            case "bas":
                if (marcher == 1) {
                    image = avant;
                }
                if (marcher == 2) {
                    image = avant1;
                }
                break;
            case "gauche":
                if (marcher == 1) {
                    image = gauche;
                }
                if (marcher == 2) {
                    image = gauche1;
                }
                break;
            case "droite":
                if (marcher == 1) {
                    image = droite;
                }
                if (marcher == 2) {
                    image = droite1;
                }
                break;
        }
        // System.out.println(carteX);
        // System.out.println(carteY);

        int mondeX = this.carteX;
        int mondeY = this.carteY;
        if (mondeX + ecran.tailleFinale > ecran.joueur.carteX - ecran.joueur.ecranX
                && mondeX - ecran.tailleFinale < ecran.joueur.carteX + ecran.joueur.ecranX
                && mondeY + ecran.tailleFinale > ecran.joueur.carteY - ecran.joueur.ecranY
                && mondeY - ecran.tailleFinale < ecran.joueur.carteY + ecran.joueur.ecranY) {
            graph2.drawImage(image, actuelX, actuelY, null);
        }
    }

    private boolean isWalkable(Node node) {
        int entier = ecran.terrain.parcoursCarte[node.x][node.y];
        return ecran.terrain.terrain[entier].interaction;
    }

    public String trouverChemin(int[] proche, Entite e) {
        int debutX = e.carteX / ecran.tailleFinale;
        int debutY = e.carteY / ecran.tailleFinale;
        int objectifX = proche[0] / ecran.tailleFinale;
        int objectifY = proche[1] / ecran.tailleFinale;

        int largeur = ecran.mondeColMax;
        int hauteur = ecran.mondeLignMax;

        boolean[][] closedSet = new boolean[largeur][hauteur];
        PriorityQueue<Node> openSet = new PriorityQueue<>(Comparator.comparingInt(Node::getFScore));
        Node[][] allNodes = new Node[largeur][hauteur];

        for (int x = 0; x < largeur; x++) {
            for (int y = 0; y < hauteur; y++) {
                allNodes[x][y] = new Node(x, y);
            }
        }

        
        if (objectifX < ecran.mondeColMax && objectifY < ecran.mondeLignMax) {
            Node startNode = allNodes[debutX][debutY];
            Node goalNode = allNodes[objectifX][objectifY];

            startNode.gScore = 0;
            startNode.fScore = heuristic(startNode, goalNode);
            openSet.add(startNode);

        int compteur = 0;
        while (!openSet.isEmpty()) {
            Node current = openSet.poll();

            if (current.equals(goalNode)) {

                ArrayList<Integer> path = reconstructPath(current);
                if (path.size() > 3) {
                    String direction = trouverDirection(path);
                    return direction;
                } else {
                    return "random";
                }
            }

            closedSet[current.x][current.y] = true;

            for (Node neighbor : getNeighbors(current, allNodes)) {
                compteur++;
                if (closedSet[neighbor.x][neighbor.y] || isWalkable(neighbor)) {
                    continue;
                }

                int tentativeGScore = current.gScore + 1; // Assuming uniform cost for each move

                if (tentativeGScore < neighbor.gScore) {
                    neighbor.cameFrom = current;
                    neighbor.gScore = tentativeGScore;
                    neighbor.fScore = neighbor.gScore + heuristic(neighbor, goalNode);

                    if (!openSet.contains(neighbor)) {
                        openSet.add(neighbor);
                    }
                }
            }
        }
    }

        return null; // Path not found
    }

    private int heuristic(Node startNode, Node goalNode) {
        return Math.abs(startNode.x - goalNode.x) + Math.abs(startNode.y - goalNode.y);
    }

    private List<Node> getNeighbors(Node node, Node[][] allNodes) {
        List<Node> neighbors = new ArrayList<>();
        int x = node.x;
        int y = node.y;

        if (x > 0)
            neighbors.add(allNodes[x - 1][y]);
        if (x < allNodes.length - 1)
            neighbors.add(allNodes[x + 1][y]);
        if (y > 0)
            neighbors.add(allNodes[x][y - 1]);
        if (y < allNodes[0].length - 1)
            neighbors.add(allNodes[x][y + 1]);

        return neighbors;
    }

    private String trouverDirection(ArrayList<Integer> chemin) {
        int dx = chemin.get(chemin.size() - 4) - this.carteX / ecran.tailleFinale;
        int dy = chemin.get(chemin.size() - 3) - this.carteY / ecran.tailleFinale;
        int dxfinal = Math.abs(chemin.get(0) - this.carteX / ecran.tailleFinale);
        int dyfinal = Math.abs(chemin.get(1) - this.carteY / ecran.tailleFinale);

        if (dx == 1 && dxfinal > dyfinal) {
            direction = "droite";
        } else if (dx == -1 && dxfinal > dyfinal) {
            direction = "gauche";
        } else if (dy == 1 && dyfinal > dxfinal) {
            direction = "bas";
        } else if (dy == -1 && dyfinal > dxfinal) {
            direction = "haut";
        }
        return direction;
    }

    private ArrayList<Integer> reconstructPath(Node current) {
        ArrayList<Integer> sortie = new ArrayList<Integer>();
        while (current != null) {
            sortie.add(current.x);
            sortie.add(current.y);
            current = current.cameFrom;
        }
        return sortie;
    }

    public void chassePoule(Entite entite) {
        if (ecran.nombreViperes == 0) {
            Deplacer(entite, 30);
            return;
        }
        int[] vipereProche = this.chercherVipere();
        if (vipereProche[0] == 0 && vipereProche[1] == 0) {
            Deplacer(entite, 15);
            return;
        }
        String directiondonnee = trouverChemin(vipereProche, this);
        if (directiondonnee == null || directiondonnee.equals("random")) {
            Deplacer(entite, 15);
            return;
        } else {
            if (vipereProche != null) {
                attente++;
                if (attente > 15) {
                    direction = directiondonnee;
                    attente = 0;
                }

                bouger(entite, direction);
            }
        }

    }

    public void chasseVipere(Entite entite) {
        if (ecran.nombreRenards == 0) {
            Deplacer(entite, 15);
            return;
        }
        int[] renardProche = this.chercherRenard();
        if (renardProche[0] == 0 && renardProche[1] == 0) {
            Deplacer(entite, 30);
            return;
        }
        String directiondonnee = trouverChemin(renardProche, this);
        if (directiondonnee == null || directiondonnee.equals("random")) {
            Deplacer(entite, 30);
            return;
        } else {
            if (renardProche != null) {
                attente++;
                if (attente > 30) {
                    direction = directiondonnee;
                    attente = 0;
                }

                bouger(entite, direction);
            }
        }

    }

    public void chasseRenard(Entite entite) {
        if (ecran.nombrePoules == 0) {
            Deplacer(entite, 15);
            return;
        }
        int[] pouleProche = this.chercherPoule();
        if (pouleProche[0] == 0 && pouleProche[1] == 0) {
            Deplacer(entite, 15);
            return;
        }
        String directiondonnee = trouverChemin(pouleProche, this);
        if (directiondonnee == null || directiondonnee.equals("random")) {
            Deplacer(entite, 15);
            return;
        } else {
            if (pouleProche != null) {
                attente++;
                if (attente > 15) {
                    direction = directiondonnee;
                    attente = 0;
                }

                bouger(entite, direction);
            }
        }

    }

    int[] chercherPoule() {
        int[] pos = new int[2];
        int x = this.carteX;
        int y = this.carteY;
        int distance = 100000;
        for (Entite e : ecran.ent) {
            if (e instanceof Poule) {
                int partenaireX = e.carteX;
                int partenaireY = e.carteY;
                int distancePoule = (x - partenaireX) * (x - partenaireX) + (y - partenaireY) * (y - partenaireY);
                if (distancePoule < distance) {
                    distance = distancePoule;
                    pos[0] = e.carteX;
                    pos[1] = e.carteY;
                }
            }
        }
        return pos;
    }

    int[] chercherRenard() {
        int[] pos = new int[2];
        int x = this.carteX;
        int y = this.carteY;
        int distance = 100000;
        for (Entite e : ecran.ent) {
            if (e instanceof Renard) {
                int partenaireX = e.carteX;
                int partenaireY = e.carteY;
                int distanceRenard = (x - partenaireX) * (x - partenaireX) + (y - partenaireY) * (y - partenaireY);
                if (distanceRenard < distance) {
                    distance = distanceRenard;
                    pos[0] = e.carteX;
                    pos[1] = e.carteY;
                }
            }
        }
        return pos;
    }

    int[] chercherVipere() {
        int[] pos = new int[2];
        int x = this.carteX;
        int y = this.carteY;
        int distance = 100000;
        for (Entite e : ecran.ent) {
            if (e instanceof Vipere) {
                int partenaireX = e.carteX;
                int partenaireY = e.carteY;
                int distanceVipere = (x - partenaireX) * (x - partenaireX) + (y - partenaireY) * (y - partenaireY);
                if (distanceVipere < distance) {
                    distance = distanceVipere;
                    pos[0] = e.carteX;
                    pos[1] = e.carteY;
                }
            }
        }
        return pos;
    }

}
