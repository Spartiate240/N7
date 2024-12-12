% Fonction histogramme_normalise (exercice_2.m)

function [vecteurs_frequences,vecteur_Imin_a_Imax] = histogramme_normalise(I)
J = I(:);
Imin = min(J);
Imax = max(J);
vect_decoupe= [Imin:1:Imax+1]
[h] = histcounts(I, vect_decoupe);
vecteur_Imin_a_Imax = [Imin:1:Imax];
vecteurs_frequences = h/sum(h);
end