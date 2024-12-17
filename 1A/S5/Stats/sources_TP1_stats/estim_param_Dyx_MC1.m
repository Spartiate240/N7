% Fonction estim_param_Dyx_MC1 (exercice_2.m)

function [a_Dyx,b_Dyx,coeff_R2] = ...
                   estim_param_Dyx_MC1(x_donnees_bruitees,y_donnees_bruitees)
    
    n = length(x_donnees_bruitees);
    tirages_psi = tirages_aleatoires_uniformes(n);
    [a,b,res] = estim_param_Dyx_MV(x_doneess_bruitees, y_donnees_bruitees,tirages_psi);
    
    A = ones(n,2);
    A(:,1) = x_donnees_bruitees;
    B = y_donnees_bruitees;
    
end