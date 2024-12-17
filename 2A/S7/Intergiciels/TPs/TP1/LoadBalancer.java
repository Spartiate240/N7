import java.io.InputStream;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Random;

// Test: avoir 3 terminaux: lancer java LoadBalancer, java Comanche 8081, java Comanche 8082 dans chacun
// ça boucle à l'infini normal.
// Dans browser mettre url: localhost:8080/page.html



public class LoadBalancer extends Thread {

    static String hosts[] = {"localhost", "localhost"};
    static int ports[] = {8081,8082};
    static int nbHosts = 2;
    static Random rand = new Random();
    private Socket s;

// Methode main : démarre serveur socket (boucle infinie)
    // Qd requete: mise en place thread

    public LoadBalancer(Socket s) {
        this.s =s;
    }


    public static void main(String[] args) throws Exception {
        ServerSocket s = new ServerSocket(8080);
        while (true) {
            Socket sl=s.accept();
            new LoadBalancer(sl).start();
        }
    }

    //write

    public void run() {
        try {
            // Index au pif
            int index = rand.nextInt(nbHosts);
            // Création socket avec cet index + streams entrée sortie
            Socket o = new Socket(hosts[index], ports[index]);
            InputStream is = this.s.getInputStream();
            OutputStream os = this.s.getOutputStream();
            byte buffer[] = new byte[1024];
            int n = is.read(buffer);
            InputStream is2= o.getInputStream();
            OutputStream os2= o.getOutputStream();

            // On écrit et on ferme
            os2.write(buffer, 0, n);
            n = is2.read(buffer);
            os.write(buffer, 0, n);
            is.close();
            os.close();
            s.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}