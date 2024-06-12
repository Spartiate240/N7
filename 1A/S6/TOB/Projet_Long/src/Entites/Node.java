package Entites;

import java.util.Objects;

public class Node {
    int x;
    int y;
    int gScore;
    int fScore;
    Node cameFrom;

    public Node(int x, int y) {
        this.x = x;
        this.y = y;
        this.gScore = Integer.MAX_VALUE;
        this.fScore = Integer.MAX_VALUE;
        this.cameFrom = null;
    }

    public int getFScore() {
        return fScore;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        Node other = (Node) obj;
        return x == other.x && y == other.y;
    }

    @Override
    public int hashCode() {
        return Objects.hash(x, y);
    }
}
