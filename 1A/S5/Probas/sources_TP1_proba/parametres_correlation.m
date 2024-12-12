% Fonction parametres_correlation (exercice_1.m)

function [r,a,b] = parametres_correlation(Vd,Vg)
Ex = mean(Vg);
Ey = mean(Vd);

Vx = mean(Vg.^2) - Ex*Ex;
Vy = mean(Vd.^2) - Ey*Ey;


Cxy =mean(Vg.*Vd) - Ex*Ey;

a = Cxy/Vy;
b = Ex - a*Ey;
r = Cxy/(sqrt(Vx.*Vy));
end