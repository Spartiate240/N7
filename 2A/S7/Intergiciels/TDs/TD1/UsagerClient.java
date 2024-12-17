public class UsagerClient extends Thread {
    final static String hosts[] = {"localhost", "localhost", "localhost"};
    final static int ports[] = {8081, 8082, 8083};
    final static int nb = 3;
    static String document[] = new String[nb];
    int index;


    public static void main(String args[]) {
        try {
            Thread t[] = new Thread[nb];
            for (int i = 0; i < nb; i++) {
                t[i] = new UsagerClient(hosts[i], ports[i], i);
                t[i].start();
            }
        for (int i = 0; i<nb; i++) {
            t[i].join();
            System.out.println("Thread " + i + " ok");
        }
        for (int i = O; i < nb; i++) {
            System.out.println("Document " + i + " : " + document[i]);
        }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public UsagerClient(String index) {
        this.index = index;
    }

    public void run() {
        try {
            Socket s = new Socket(hosts[index], ports[index]);
            inputStream is = s.getInputStream();
            outputStream os = s.getOutputStream();
            os.writeObject(index);
            document[index] = (String) is.readObject();
            os.close();
            is.close();
            s.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}