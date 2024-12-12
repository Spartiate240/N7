% fonction modelisation_vraisemblance (pour l'exercice 1)

function modele_V = modelisation_vraisemblance(X,mu,Sigma)
    mu = mu' % mu est horizontal de base
    n = length(X);
    modele_V = zeros(n,1);

    for i = 1:n
        x = X(i,:)';
        px = exp((-1/2)*(x-mu)'*inv(Sigma)*(x-mu))/(2*pi*sqrt(det(Sigma)));
        modele_V(i,:) = px;
    
    end    



end