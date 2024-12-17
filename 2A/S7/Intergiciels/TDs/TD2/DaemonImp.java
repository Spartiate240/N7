public class DaemonImp extends UnicastRemoteObject  implements Daemons {

    public Daemons() throws RemonteException {}

    public void exec(String cmd) {
        local exec(cmd);
    }
    public static void main(String[] args) {
        try {
            Daemons obj = new DaemonsImp();
            Naming.rebind("rmi://localhost:1099/Daemons", obj);
        } catch (Exception e) {
            System.out.println("DaemonsImp err: " + e.getMessage());
            e.printStackTrace();
        }
    }
}