% function ACP (pour exercice_2.m)

function [C,bornes_C,coefficients_RVG2gris] = ACP(X)
    %SIGMA:
    Xbar = [sum(X(:,1))  sum(X(:,2))  sum(X(:,3))]/size(X,1) ;
    Xc = X - Xbar;
    Sigma = 1/size(X,1) * (Xc.'*Xc);

    %val propres tirées:
    [W,D] = eig(Sigma);
    [val_pr_tri,I] = sort(diag(D), 'descend');

    %permutation des colonnes de W:
    W = [W(:,I(1)) W(:,I(2)) W(:,I(2))];
    C = W.'*Xc*W;

    %bornes:
    mini = min(X);
    maxi = max(X);
    bornes_C = [mini maxi];


    %3e sortie:
    Im_gris = W(1,1)*R + W(2,1)*V + W(3,1)*B; 
    coefficients_RVG2gris = [W(1,1) W(2,1) W(3,1)];

end
