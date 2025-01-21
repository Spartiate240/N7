import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

public class RFicheImpl extends UnicastRemoteObject implements RFiche {
    public String nom;
    public String email;


    // Constructeur
    public RFicheImpl(String nom, String email) throws RemoteException {
        this.nom = nom;
        this.email = email;
    }

    public String getNom() throws RemoteException {
        return this.nom;
    }

    public String getEmail() throws RemoteException {
        return this.email;
    }
}
