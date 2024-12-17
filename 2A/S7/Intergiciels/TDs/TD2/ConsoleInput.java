public class ConsoleInput extends UnicastRemoteObject implements Console {
    public void println(String s) throws RemonteException {
        System.out.print(s);
    }
}
