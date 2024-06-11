with Ada.Text_IO;            use Ada.Text_IO;
with SDA_Exceptions;         use SDA_Exceptions;
with Ada.Unchecked_Deallocation;

package body LCA is

	procedure Free is
		new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_LCA);



	procedure Initialiser(Sda: out T_LCA) is
	begin
		Sda := null;
	end Initialiser;




	procedure Detruire (Sda : in out T_LCA) is
	begin
		if (Sda /= null) then
			Detruire(Sda.suivant);
			Free (Sda);
		end if;
	end Detruire;




	procedure Afficher_Debug_LCA (Sda : in T_LCA) is
	begin
		if Sda = null
			then null;
		else
			Afficher_Cle(Sda.all.Cle);
			Afficher_Donnee(Sda.all.Valeur);
			Afficher_Debug_LCA(Sda.all.suivant);
		end if;
	end Afficher_Debug_LCA;




	function Est_Vide (Sda : T_LCA) return Boolean is
	begin
		 return Sda = null;
		--on ne peut pas utiliser la Taille car définie après et la Taille est définie à partir de 
		--Est_Vide, ceci est donc une égalité que va vérifier Ada.
	end Est_vide;




	function Taille (Sda : in T_LCA) return Integer is
		i : integer;
	begin
		i := 0;
			if Est_Vide(Sda)
				then return i;
			else
				i := Taille(Sda.all.suivant)+1;  
				--comme cela retourne i, il y a une récursivité de la taille
			end if;
		return i;
	end Taille;




	procedure Enregistrer (Sda : in out T_LCA ; Cle : in T_Cle ; Valeur : in T_Valeur) is
	begin
	--on va parcourir les clés via une récurssion pour trouver celle qui corresponds, et si on en trouve pas, on la crée: 

		if Est_Vide(Sda)
			then Sda:= new T_Cellule;
			Sda.all.Cle := Cle;
			Sda.all.Valeur := Valeur;
			Sda.all.Suivant := null;
		elsif Sda.all.cle = Cle   
			then Sda.all.Valeur := Valeur;
		else
			Enregistrer(Sda.all.suivant,Cle, Valeur); 
		end if;
   
	end Enregistrer;




	function Cle_Presente (Sda : in T_LCA ; Cle : in T_Cle) return Boolean is
	begin
		if Est_Vide(Sda)    
		-- logique, si la structure de donnée est vide, elle n'a pas de clé
			then return False;
		elsif Sda.all.Cle = Cle
			then return True;
		else
			return Cle_Presente(Sda.all.suivant,Cle); 
			-- comme avant, récursion pour parcourir les clé
		end if;
	end Cle_Presente;




	function La_Valeur (Sda : in T_LCA ; Cle : in T_Cle) return T_Valeur is
	begin
	    if Est_Vide(Sda)
			then raise Cle_Absente_Exception;
		elsif Sda.all.Cle = Cle
			then return Sda.all.Valeur;
		else	
			return La_Valeur(Sda.all.suivant,Cle);
		end if;

	end La_Valeur;


	procedure Supprimer (Sda : in out T_LCA ; Cle : in T_Cle) is
	pointeur : T_LCA;
	begin
		if not Cle_Presente(Sda,Cle)
			then raise Cle_Absente_Exception;
		else
			if Sda.all.Cle = Cle
				then pointeur := Sda;
				
				if Sda.all.suivant = null
					then Sda := null;
				else
					Sda := Sda.all.suivant;
				end if;
				Free(pointeur);
			else
				Supprimer(Sda.all.suivant,Cle);
			end if;
		end if;


	end Supprimer;


	procedure Pour_Chaque (Sda : in T_LCA) is
	begin
		--on veut appliquer une procedure (Traiter) à chaque couple (Cle, Valeur) d'une SDA
		if Est_Vide(Sda)
			then null;
			-- si vide on a rien à traiter
			else
				Traiter(Sda.all.Cle,Sda.all.Valeur);
				Pour_chaque(Sda.all.suivant);
		end if;

	end Pour_Chaque;

	function Get_Cle (Item : in T_LCA) return T_Cle is
	begin
		return Item.Cle;
	end Get_Cle;

	function Get_Valeur (Item : in T_LCA) return T_Valeur is
	begin
		return Item.Valeur;
	end Get_Valeur;

	function Get_Suivant (Item : in T_LCA) return T_LCA is
	begin
		return Item.Suivant;
	end Get_Suivant;





end LCA;
