% fonction classification_MV (pour l'exercice 2)

function Y_pred_MV = classification_MV(X,mu_1,Sigma_1,mu_2,Sigma_2)
    n = length(X);
    Y_pred_MV = zeros(n,1);


    Y_1 = modelisation_vraisemblance(X,mu_1,Sigma_1);
    Y_2 = modelisation_vraisemblance(X,mu_2,Sigma_2);

    Y_pred_MV(Y_1 > Y_2) = 1;          
    Y_pred_MV(Y_2 > Y_1) = 2;  
   
end
