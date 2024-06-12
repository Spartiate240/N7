package Entites;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.PriorityQueue;
import java.util.Random;

import org.w3c.dom.Node;

import main.Ecran;
import main.FonctionUtiles;
import terrain.GestionTerrain;
import terrain.Terrain;

public class GestionEntite {

	Ecran ecran;
	public Terrain[] terrain;

	public GestionEntite(Ecran ecran) {
		this.ecran = ecran;

	}

	public void setObjects() {

		Random random = new Random();
		for (int i = 2; i < ecran.mondeColMax; i = i + 3) {
			for (int j = 2; j < ecran.mondeLignMax; j = j + 3) {
				int typeTerrain = ecran.terrain.parcoursCarte[i][j];
				double renardType = random.nextInt(100) + 1;
				double pouleType = random.nextInt(100) + 1;
				double vipereType = random.nextInt(100) + 1;
				int sexe = random.nextInt(2);
				if (renardType <= 20 && ecran.nbrEntite < 400 && ecran.terrain.terrain[typeTerrain].interaction == false) {
					if (sexe == 0) {
						ecran.ent.add(new Renard(i, j, ecran.nbrEntite, "M", ecran));
					} else {
						ecran.ent.add(new Renard(i, j, ecran.nbrEntite, "F", ecran));
					}
				}
				if (pouleType <= 20 && ecran.nbrEntite < 400 && ecran.terrain.terrain[typeTerrain].interaction == false) {
					if (sexe == 0) {
						ecran.ent.add(new Poule(i, j, ecran.nbrEntite, "M", ecran));
					} else {
						ecran.ent.add(new Poule(i, j, ecran.nbrEntite, "F", ecran));
					}
				}
				if (vipereType <= 20 && ecran.nbrEntite < 400 && ecran.terrain.terrain[typeTerrain].interaction == false) {
					if (sexe == 0) {
						ecran.ent.add(new Vipere(i, j, ecran.nbrEntite, "M", ecran));
					} else {
						ecran.ent.add(new Vipere(i, j, ecran.nbrEntite, "F", ecran));
					}
				}
				
			}
		}
		// System.out.println(ecran.ent);

		// ecran.ent.add(new Poule(5,5,ecran.nbrEntite,"M",ecran));

		// Poule nouv1 = new Poule(0, 0, ecran.nbrEntite, "M",
		// ecran);ecran.ent.add(nouv1);
		// Renard nouv3 = new Renard(0, 0, ecran.nbrEntite, "M", ecran);

		// Renard nouv4 = new Renard(0, 0, ecran.nbrEntite, "M", ecran);

		// Vipere nouv5 = new Vipere(0, 0, ecran.nbrEntite, "M", ecran);

		// Vipere nouv6 = new Vipere(0, 0, ecran.nbrEntite, "M", ecran);

		// Poule nouv7 = new Poule(30, 30, ecran.nbrEntite, "M", ecran);

		// Poule nouv8 = new Poule(0, 0, ecran.nbrEntite, "M", ecran);

		// Renard nouv9 = new Renard(0, 0, ecran.nbrEntite, "M", ecran);

		// Renard nouv10 = new Renard(0, 0, ecran.nbrEntite, "M", ecran);

		// Vipere nouv11 = new Vipere(0, 0, ecran.nbrEntite, "M", ecran);

		// Vipere nouv12 = new Vipere(0, 0, ecran.nbrEntite, "M", ecran);

	}

	public void verifierMorts() {
		List<Entite> aRetirer = new ArrayList<>();
		for (Entite e: ecran.ent) {
			if (e != null && e.getPv() <= 0) {
				if (e instanceof Poule) {
					ecran.nombrePoules--;
				}
				if (e instanceof Renard) {
					ecran.nombreRenards--;
				}
				if (e instanceof Vipere) {
					ecran.nombreViperes--;
				}
				aRetirer.add(e);
			}
			e.setAge(1);
			e.setFood(-1);
			e.setFertilite(10);
		}
		ecran.ent.removeAll(aRetirer);
		ecran.nbrEntite -= aRetirer.size();
	}

	// public String trouverChemin(int[] proche, Entite e) {
    // 	int debutX = e.carteX / ecran.tailleFinale;
    // 	int debutY = e.carteY / ecran.tailleFinale;
    // 	int objectifX = proche[0] / ecran.tailleFinale;
    // 	int objectifY = proche[1] / ecran.tailleFinale;

    // 	int largeur = ecran.mondeColMax;
    // 	int hauteur = ecran.mondeLignMax;

    // 	boolean[][] closedSet = new boolean[largeur][hauteur];
    // 	//PriorityQueue<Node> openSet = new PriorityQueue<>(Comparator.comparingInt(Noeud::getFScore));
    // 	Noeud[][] allNodes = new Noeud[largeur][hauteur];

    // 	for (int x = 0; x < largeur; x++) {
    //     	for (int y = 0; y < hauteur; y++) {
    //         	allNodes[x][y] = new Noeud(x, y);
    //     	}
    // 	}

    // 	Noeud startNode = allNodes[debutX][debutY];
    // 	Noeud goalNode = allNodes[objectifX][objectifY];

    // 	startNode.gScore = 0;
    // 	startNode.fScore = heuristic(startNode, goalNode);
    // 	openSet.add(startNode);

    // 	while (!openSet.isEmpty()) {
    //     	Node current = openSet.poll();

    //     	if (current.equals(goalNode)) {
    //         	return reconstructPath(current);
    //     	}

    //     	closedSet[current.x][current.y] = true;

    //     	for (Node neighbor : getNeighbors(current, allNodes)) {
    //         	if (closedSet[neighbor.x][neighbor.y] || !isWalkable(neighbor)) {
    //             	continue;
    //         	}

    //         	int tentativeGScore = current.gScore + 1; // Assuming uniform cost for each move

    //         	if (tentativeGScore < neighbor.gScore) {
    //             	neighbor.cameFrom = current;
    //             	neighbor.gScore = tentativeGScore;
    //             	neighbor.fScore = neighbor.gScore + heuristic(neighbor, goalNode);

    //             	if (!openSet.contains(neighbor)) {
    //                 	openSet.add(neighbor);
    //             	}
    //         	}
    //     	}
    // 	}

    // 	return null; // Path not found
	// }

	// private int heuristic(Noeud startNode, Noeud goalNode) {
    // 	return Math.abs(startNode.x - goalNode.x) + Math.abs(startNode.y - goalNode.y);
	// }

	// private List<Node> getNeighbors(Node node, Node[][] allNodes) {
    // 	List<Node> neighbors = new ArrayList<>();
    // 	int x = node.x;
    // 	int y = node.y;

    // 	if (x > 0) neighbors.add(allNodes[x - 1][y]);
    // 	if (x < allNodes.length - 1) neighbors.add(allNodes[x + 1][y]);
    // 	if (y > 0) neighbors.add(allNodes[x][y - 1]);
    // 	if (y < allNodes[0].length - 1) neighbors.add(allNodes[x][y + 1]);

    // 	return neighbors;
	// }

	private boolean isWalkable(Node node) {
    	// Add your logic to determine if a node is walkable (e.g., check terrain, obstacles)
    	return true;
	}

}