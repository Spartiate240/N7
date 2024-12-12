
with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;    use Ada.Float_Text_IO;




procedure Exo_1 is
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

end Exo_1;
