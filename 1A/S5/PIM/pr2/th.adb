with Ada.Text_IO;            use Ada.Text_IO;
with SDA_Exceptions;         use SDA_Exceptions;
with Ada.Integer_Text_IO;    use Ada.Integer_Text_IO;
with Ada.Unchecked_Deallocation;
with LCA;

package body TH is

	procedure Initialiser(th: out T_TH) is
	begin
        for i in th'Range loop   -- 'Range car on a pas encore la Taille
		    Initialiser(th(i));
        end loop;
	end Initialiser;




	procedure Detruire (th : in out T_TH) is
	begin
        for i in th'Range loop 
		    if Est_Vide(th(i))
			    then null;
			else
				Detruire(th(i));
		    end if;
        end loop;
	end Detruire;




	procedure Afficher_Debug (th : in T_TH) is
		procedure Afficher_Debug is new Afficher_Debug_LCA(Afficher_Cle, Afficher_Donnee);
	begin
        for i in th'Range loop 
		    if Est_Vide(th(i))
			    then null;
		    else
			    Put(i);
                Put("-->");
                --même affichage que les couples de SDA
            	Afficher_Cle(LCA_th.Get_Cle(th(i)));
            	Afficher_Donnee(LCA_th.Get_Valeur(th(i)));
            	Afficher_Debug(LCA_th.Get_Suivant(th(i)));
			end if;
        Put("--E");
        Skip_Line;
        end loop;
	end Afficher_Debug;




	function Est_Vide (th : T_TH) return Boolean is
	begin
        for i in th'Range loop
            if not Est_Vide(th(i))
                then return False;
            end if;
        end loop;
        return True;
    end Est_vide;




	function Taille (th : in T_TH) return Integer is
		i : integer;
	begin
        i:=0;
		for j in th'Range loop
			i := i + Taille(th(j));
        end loop;
		return i;

	end Taille;




	procedure Enregistrer (th : in out T_TH ; Cle : in T_Cle ; Valeur : in T_Valeur) is
	--i est l'indice où on va insérer les éléments (Cle et Valeur)
    i: Integer; 
    
    begin
        i := hachage(Cle);
        Enregistrer(th(i) ,Cle ,Valeur);
	end Enregistrer;




	function Cle_Presente (th : in T_TH ; Cle : in T_Cle) return Boolean is
	begin
        return Cle_Presente(th(hachage(Cle)), Cle);
	end Cle_Presente;




	function La_Valeur (th : in T_TH ; Cle : in T_Cle) return T_Valeur is
	begin
        return La_Valeur(th(Hachage(Cle)), Cle);
	end La_Valeur;


	procedure Supprimer (th : in out T_TH ; Cle : in T_Cle) is
	begin
        LCA_th.Supprimer(th(Hachage(Cle)),Cle);
	end Supprimer;


	procedure Pour_Chaque (th : in T_TH) is

    procedure Lca_Pour_Chaque is new LCA_th.Pour_Chaque(Traiter => Traiter);
	
	begin
        for i in th'Range loop
            if Est_Vide(th(i))
                then null;
            else
                LCA_Pour_Chaque(th(i));

            end if;
        end loop;
	end Pour_Chaque; 




end TH;
