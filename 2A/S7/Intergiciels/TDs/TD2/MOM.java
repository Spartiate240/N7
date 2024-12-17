public interface MOM extends Remote {
    public void method(String temp, callback cb) throws RemoteException;
    public void publish(String temp, Message m) throws RemoteException;
}
