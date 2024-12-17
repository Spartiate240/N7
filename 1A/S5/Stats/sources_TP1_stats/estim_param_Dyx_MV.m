% Fonction estim_param_Dyx_MV (exercice_1.m)

function [a_Dyx,b_Dyx,residus_Dyx] = ...
           estim_param_Dyx_MV(x_donnees_bruitees,y_donnees_bruitees,tirages_psi)


    x_G = mean(x_donnees_bruitees);
    y_G = mean(y_donnees_bruitees);
    
    n =length(x_G);
    x = x_donnees_bruitees - x_G;
    x = repmat(x, 1,n);
    y = y_donnees_bruitees - y_G;
    y = repmat(y,1,n);
    psi = repmat(tirages_psi,1,n);

    res = y - tan(psi) * x;
    [~, ind] = min( sum((res)^2) );


    a_Dyx = tan(tirage_psi(ind));
    b_Dyx = y_donnees_bruitees(1) - a_Dyx*x_donnees_bruitees(1);


    residus_Dyx = y - tan(psi)*x;
    
end