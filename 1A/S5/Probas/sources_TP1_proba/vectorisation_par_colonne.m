% Fonction vectorisation_par_colonne (exercice_1.m)

function [Vg,Vd] = vectorisation_par_colonne(I)
Id = I(:,2:end);
Ig =I(:,1:end-1);

Vd = Id(:);
Vg = Ig(:);

end