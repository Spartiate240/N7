with LCA;


-- Définition de structures de données associatives sous forme d'une liste
-- chaînée associative (TH).
generic
	type T_Cle is private;
	type T_Valeur is private;
    I_max : Integer;
	with function hachage(Cle : T_Cle) return Integer;


package TH is

    package LCA_th is
        new LCA (T_cle => T_Cle, T_Valeur => T_Valeur);
    use LCA_th;

	type T_TH is limited private;

	-- Initialiser une table de hachage(TH). la TH est vide.
	procedure Initialiser(th: out T_TH) with
		Post => Est_Vide (th);


	-- Détruire une TH.  Elle ne devra plus être utilisée.
	procedure Detruire (th : in out T_TH);


	-- Est-ce qu'une TH est vide ?
	function Est_Vide (th : T_TH) return Boolean;


	-- Obtenir le nombre d'éléments d'une TH. 
	function Taille (th : in T_TH) return Integer with
		Post => Taille'Result >= 0
			and (Taille'Result = 0) = Est_Vide (th);


	-- Enregistrer une valeur associée à une Clé dans une TH.
	-- Si la clé est déjà présente dans la TH, sa valeur est changée.
	procedure Enregistrer (th : in out T_TH ; Cle : in T_Cle ; Valeur : in T_Valeur) with
		Post => Cle_Presente (th, Cle) and (La_Valeur (th, Cle) = Valeur)                -- valeur insérée
				and (not (Cle_Presente (th, Cle)'Old) or Taille (th) = Taille (th)'Old)
				and (Cle_Presente (th, Cle)'Old or Taille (th) = Taille (th)'Old + 1);

	-- Supprimer la valeur associée à une Clé dans une TH.
	-- Exception : Cle_Absente_Exception si Clé n'est pas utilisée dans la TH
	procedure Supprimer (th : in out T_TH ; Cle : in T_Cle) with
		Post =>  Taille (th) = Taille (th)'Old - 1 -- un élément de moins
			and not Cle_Presente (th, Cle);         -- la clé a été supprimée


	-- Savoir si une Clé est présente dans une TH.
	function Cle_Presente (th : in T_TH ; Cle : in T_Cle) return Boolean;


	-- Obtenir la valeur associée à une Cle dans la TH.
	-- Exception : Cle_Absente_Exception si Clé n'est pas utilisée dans la TH
	function La_Valeur (th : in T_TH ; Cle : in T_Cle) return T_Valeur;


	-- Appliquer un traitement (Traiter) pour chaque couple d'une TH.
	generic
		with procedure Traiter (Cle : in T_Cle; Valeur: in T_Valeur);
	procedure Pour_Chaque (th : in T_TH);


	-- Afficher la TH en révélant sa structure interne.
	generic
		with procedure Afficher_Cle (Cle : in T_Cle);
		with procedure Afficher_Donnee (Valeur : in T_Valeur);
	procedure Afficher_Debug (th : in T_TH);



private

	type T_TH is array(1..I_max) of T_LCA;


	type T_LCA is access T_Cellule;
	
	type T_Cellule	is 
		record
			Cle : T_Cle;
			Valeur : T_Valeur;
			Suivant : T_LCA;
	end record;

end TH;       