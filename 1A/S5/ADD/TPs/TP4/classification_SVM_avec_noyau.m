% fonction classification_SVM_avec_noyau (pour l'exercice 2)

function Y_pred = classification_SVM_avec_noyau(X,sigma,X_VS,Y_VS,Alpha_VS,c)
    N = length(X);
    N_VS = length(X_VS);
    G = zeros(N,N_VS);
    Y_pred = zeros(N,1);
    
    
    %matrice de Gram
    for i = 1:N
        Xi = X(i);
        for j = 1:N_VS
            Xj = X_VS(j);
            G(i,j) = exp(-norm(Xi-Xj)^2/(2*sigma^2));
        end
    end

    a = zeros(N,1);
    for j = 1:N_VS
        a = a+ Alpha_VS(j)*Y_VS(j)*G(:,j);
    end
    Y_pred = sign(a - c);
end