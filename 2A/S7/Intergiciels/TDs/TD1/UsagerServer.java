import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

public class UsagerServer extends Thread {
    Socket sreq;


    public static void main(String args[]) {
        try {
            ServerSocket s = new ServerSocket(sreq);
            while (true) {
                sreq = s.accept();
                Thread serverT = new Thread();
                serverT.start();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    void run() {
        trry {
        ObjectInputStream is = sreq.getInputStream();
        ObjectOutputStream os = sreq.getOutputStream();

        int frag = (int) is.readObject();
        os.writeObject(doculment[frag]);
        os.close();
        is.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
