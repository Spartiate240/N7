with Ada.Text_IO;              use Ada.Text_IO;
with SDA_Exceptions;           use SDA_Exceptions;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
with LCA;

procedure lca_sujet is
    -- sda : liste de chaine assiociative à laquelle on veut rajouter des elements(ici 1 et 2 aux clés respectives "un" et "deux")

    package LCA_String_Int is
        new LCA (T_Cle => Unbounded_String, T_Valeur => Integer);
    use LCA_String_Int;

    procedure Afficher (Cle: in Unbounded_String ; Valeur : in Integer) is
    begin
        Put('"');
        Put(Cle);
        Put('"');
        Put(':');
        Put(Valeur,1);
        New_Line;
    end Afficher;
    
    procedure Affichage is new Pour_Chaque(Afficher);
    Sda : T_LCA;
begin
    Initialiser(Sda);
    Enregistrer (Sda,To_Unbounded_String("un"),1);
    Enregistrer (Sda,To_Unbounded_String("deux"),2);
    --afficher chaque clé et le.s élément.s correspondant.s
    Affichage(Sda);
    Detruire(Sda);
end lca_sujet;
