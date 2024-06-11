with Ada.Text_IO;              use Ada.Text_IO;
with SDA_Exceptions;           use SDA_Exceptions;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
with TH;

procedure th_sujet is
    -- longeur max de la table = 11 d'après l'énoncé, à changer pour l'utilisateur
    L : constant Integer := 11;

    procedure hachage(Cle: Unbounded_String) return Integer is
    begin   
        return Length(Cle) mod L + 1;  --on veut comme hachage la longueur de la clé modulo 11 + 1
    end hachage;


                    -- La Valeur est ce qu'on mets dans la case de la table
    package TH_String_Int is
        new TH(T_Cle => Unbounded_String, T_Valeur => Integer, hachage => hachage, L => Integer);
    use TH_String_Int;

    procedure Afficher (Cle: in Unbounded_String ; Valeur : in Integer) is
    begin               
                        --
                        -- A VOIR SI CA RESTE
                        --
        Put(" Cle : " & '"' & To_String(Cle) & '"');
        New_Line;

        Put(" Hachage : " & '"' & hachage(Cle) & '"');
        New_Line;

        Put("Valeur : ");
        Put(Valeur,1);
        New_Line;


        
    end Afficher;
    
    procedure Affichage is new Pour_Chaque(Afficher);
    th : T_th;
begin
    Initialiser(th);
    Enregistrer(th, To_Unbounded_String("un"), 1);
    Enregistrer(th, To_Unbounded_String("deux"), 2);
    Enregistrer(th, To_Unbounded_String("trois"), 3);
    Enregistrer(th, To_Unbounded_String("quatre"), 4);
    Enregistrer(th, To_Unbounded_String("cinq"), 5);
    Enregistrer(th, To_Unbounded_String("quatre-vingt-dix-neuf"), 99);
    Enregistrer(th, To_Unbounded_String("vingt-et-un"), 21);
    --afficher chaque clé et le.s élément.s correspondant.s
    Affichage(th);
    Detruire(th);
end th_sujet;