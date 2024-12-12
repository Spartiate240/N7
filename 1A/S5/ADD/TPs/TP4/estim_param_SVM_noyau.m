% fonction estim_param_SVM_noyau (pour l'exercice 2)

function [X_VS,Y_VS,Alpha_VS,c,code_retour] = estim_param_SVM_noyau(X,Y,sigma)

    
    %initialisation
    N = length(X);
    G = zeros(N);

    for i = 1:N
        Xi = X(i);
        for j = 1:N
            Xj = X(j);
            %matrice de Gram
            G(i,j) = exp(-norm(Xi-Xj)^2 / (2*sigma^2));
            
        end

    end

        %calcul de X_VS et Y_VS + obtention du code retour
    Yd = diag(Y);
    H = Yd*(G)*Yd;
    f = -ones(1,N);
    lb = zeros(N,1);
    [Alpha,~,code_retour,~] = quadprog(H,f,[],[],Y',0,lb,[]);
    
    X_VS =X(Alpha > 10^(-6)) ;
    Y_VS = Y(Alpha > 10^(-6));
    Alpha_VS = Alpha(Alpha > 10^(-6));

    c = Alpha_VS' * (Y .*G(:,1)') - Y(1);

end
