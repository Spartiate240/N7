/* ------------------------------------------------------- 
		Les packages Java qui doivent etre importes.
*/
import java.awt.*;
import java.awt.event.*;
import java.rmi.*;
import javax.swing.*;



/* ------------------------------------------------------- 
		Implementation de l'application
*/

public class Saisie extends JFrame {
	private static final long serialVersionUID = 1;
	TextField nom, email;
	Choice carnets;
	Label message;
	public Saisie() {
		setSize(300,200);
		setLayout(new GridLayout(6,2));
		add(new Label("  Nom : "));
		nom = new TextField(30);
		add(nom);
		add(new Label("  Email : "));
		email = new TextField(30);
		add(email);
		add(new Label("  Carnet : "));
		carnets = new Choice();
		carnets.addItem("Carnet1");
		carnets.addItem("Carnet2");
		add(carnets);
		add(new Label(""));
		add(new Label(""));
		Button Abutton = new Button("Ajouter");
		Abutton.addActionListener(new AButtonAction());
		add(Abutton);
		Button Cbutton = new Button("Consulter");
		Cbutton.addActionListener(new CButtonAction());
		add(Cbutton);
		message = new Label();
		add(message);
	}

	// La reaction au bouton Consulter
	class CButtonAction implements ActionListener {
		public void actionPerformed(ActionEvent ae) {
			String n, c;
			n = nom.getText();
			c = carnets.getSelectedItem();
			message.setText("Consulter("+n+","+c+")        ");
			try {
				Carnet carnet = (Carnet)Naming.lookup("//localhost:4000/"+c);
				RFiche rf = carnet.Consulter(n, true);
				email.setText((rf == null) ? "" : rf.getEmail());
			} catch (Exception ex) {
				message.setText("RMI call Consulter aborted");
				ex.printStackTrace();
			}
		}
	}
	// La reaction au bouton Ajouter
	class AButtonAction implements ActionListener {
		public void actionPerformed(ActionEvent ae) {
			String n, e, c;
			n = nom.getText();
			e = email.getText();
			c = carnets.getSelectedItem();
			message.setText("Ajouter("+n+","+e+","+c+")");
			try {
				SFiche sf = new SficheImpl(n, e);
				// Forward: faire if forward: nouv carnet: besoin d'une variable pour si changement carnet.
				Carnet carnet = (Carnet)Naming.lookup("//localhost:4000/"+c);
				carnet.Ajouter(sf);
				nom.setText("");
				email.setText("");
			} catch (Exception ex) {
				message.setText("RMI call Ajouter aborted");
				ex.printStackTrace();
			}
		}
	}
	
	public static void main(String args[]) {
		Saisie s = new Saisie();
		s.setSize(400,200);
  		s.setVisible(true);
	}
	
}


