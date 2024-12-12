% function correlation_contraste (pour exercice_1.m)

function [correlation,contraste] = correlation_contraste(X)
    
    
    Xbar = [sum(X(:,1))  sum(X(:,2))  sum(X(:,3))]/size(X,1) ;
    Xc = X - Xbar;
    
    Sigma = 1/size(X,1) * (Xc.'*Xc);
    
    ec_tyR = sqrt(Sigma(1,1));
    ec_tyV = sqrt(Sigma(2,2));
    ec_tyB = sqrt(Sigma(3,3));
    VarR = Sigma(1,1);
    VarV = Sigma(2,2);
    VarB = Sigma(3,3);
    covarRB = Sigma(1,3);
    covarRV = Sigma(1,2);
    covarVB = Sigma(3,2);

    % Correltaion:
    correlation1 = covarRV/(ec_tyR*ec_tyV);
    correlation2 = covarRB/(ec_tyR*ec_tyB);
    correlation3 = covarVB/(ec_tyB*ec_tyV);
 
    correlation = [correlation1  correlation2  correlation3];
    %Contraste:
    contrasteR = VarR/(VarR + VarV + VarB);
    contrasteV = VarV/(VarR + VarV + VarB);
    contrasteB = VarR/(VarR + VarV + VarB);

    contraste = [contrasteR contrasteV contrasteB];

end
