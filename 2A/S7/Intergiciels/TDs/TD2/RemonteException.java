public class RemonteException extends Exception {
    public static void main(String[] args) {
        String host = args[0];
        Daemon d = new Daemon(host);
        Naming.lookup("rmi://" + host + "/Daemon");
        d.exec(cmd); // Appel à distance
    }
}
