import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;
import java.util.HashMap;
import java.rmi.*;


public class CarnetImpl extends UnicastRemoteObject implements Carnet {
    public HashMap<String, String> fiches = new HashMap<String, String>();

    public CarnetImpl() throws RemoteException {
        this.fiches = new HashMap<String, String>();
    }


    public static void main(String[] args) {
        int port = 4000;
        try {
            Registry registry = LocateRegistry.createRegistry(port);
            CarnetImpl carnet = new CarnetImpl();
            Naming.rebind("//localhost:" + port + "/Carnet1", carnet);

        } catch (Exception e) {
            System.out.println("CarnetImpl err: " + e.getMessage());
            e.printStackTrace();
        }

    }

    public void Ajouter(SFiche sf) {
        // On ajoute le fichier:
        fiches.put(sf.getNom(), sf.getEmail());
    }

    public RFiche Consulter(String n, boolean forward) throws RemoteException {
        // On récupère le fichier:
        String nom = n;
        if (fiches.containsKey(n)) {
            String email = fiches.get(n);
            RFicheImpl sortie = new RFicheImpl(nom, email);
            forward = false;
            return sortie;
        }
        return null;
    }     
}
