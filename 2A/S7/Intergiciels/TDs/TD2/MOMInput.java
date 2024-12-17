public class MOMInput extends UnicastRemoteObject implements MOM {
    hashTable<String, String> table = new hashTable<String, String>();

    public MOMInput() throws RemonteException {
        tab.get("topic1", new Vectort<callback>());
    }
    
    public void subscribe(String topic, callback c) throws RemoteException {
        tab.get(topic).add(c);
    }

    public publish(String topic, String message) throws RemoteException {
        for (callback c : tab.get(topic)) {
            c.notify(message);
        }
    }
    public static void main(String[] args) {
        Naming.rebind("rmi://localhost/MOM", new MOMInput());
    }
    
}
