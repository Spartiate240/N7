with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;    use Ada.Float_Text_IO;


-----------------------------------------------------------------------------------------------
-- que faire avec l'aléatoire?
-----------------------------------------------------------------------------------------------

with Alea;


procedure Jeu_Devin is
    --J: bool: variable de boucle
    --role :int : corresponds au role qu'on veut prendre ou si on veut arreter de jouer
   J : Boolean;
   role : Integer;

procedure Exercice_1 is
    --l'ordinateur choisi et on doit deviner
    --i : int :indice du nombre de tentatives
    --nj: int : nombre choisi par l'utilisateur
    --no: int : nombre choisi par l'ordinateur à faire deviner
    --T: bool : variable de loop
   i : Integer;
   nj : Integer;
   no: Integer;
   T : Boolean;

   package Mon_Alea is
   new Alea (1, 999);  -- générateur de nombre dans l'intervalle [1, 999]
   use Mon_Alea;


begin
   i:=0;
   T := True;


   -- cr�ation du nombre de l'ordinateur
   Get_Random_Number(no);
   Put_Line("J'ai choisi un nombre entre 1 et 999.");

    while T loop
      i := i+1;


      Put_Line("proposition : ");

      Get(nj);
      Put_Line(nj);

      if nj < no then

         Put_Line("Trop petit.");

      elsif nj > no then
         Put_Line("Trop grand.");
      else
         Put_Line("Trouve.");
         T := False;
      end if;
   end loop;
   Put_Line("Bravo, vous avez trouve ");
   Put_Line(no);
   Put_Line(" en ");
   Put_Line(i);
   Put_Line(" essais");

end Exercice_1;



begin
    J :=True;
    while J loop
      Put_Line("1-L'ordinateur choisit un nombre et vous le deviez");
      Put_Line("2- Vous choisissez un nombre et l'ordinateur le devine");
      Put_Line("0 -Quitter me programme");
      Put_Line("Votre choix:");
      Get(role);

      if role = 1 then
         Exercice_1;
      elsif role = 2 then
         Exercice_2;
      elsif role = 0 then
         Put_Line("Au revoir...");
         J := False;
      else
         Put_Line("Choix incorrect.");
      end if;
   end loop;
end Jeu_Devin;
