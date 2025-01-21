public class SficheImpl implements SFiche {
    public String nom;
    public String email;
    

    // Constructeur
    public SficheImpl(String nom, String email) {
        this.nom = nom;
        this.email = email;
    }

    public String getNom() {
        return this.nom;
    }

    public String getEmail() {
        return this.email;
    }


}
