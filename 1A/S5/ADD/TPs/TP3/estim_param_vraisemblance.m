% fonction estim_param_vraisemblance (pour l'exercice 1)

function [mu,Sigma] = estim_param_vraisemblance(X)
    
n = length(X);
mu = mean(X);
Xc = X - mu; % car mu = moyenne donc Xc = X centré
Sigma = Xc'*Xc * (1/n);
  
end