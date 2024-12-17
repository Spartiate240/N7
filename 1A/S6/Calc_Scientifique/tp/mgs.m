%--------------------------------------------------------------------------
% ENSEEIHT - 1SN - Calcul scientifique
% TP1 - Orthogonalisation de Gram-Schmidt
% mgs.m
%--------------------------------------------------------------------------

function Q = mgs(A)

    % Recuperation du nombre de colonnes de A
    [~, m] = size(A);
    
    % Initialisation de la matrice Q avec la matrice A
    Q = A;
    
    for i = 1:m
        y = A(:,i);

        for j = 1:(i-1)
            courante = Q(:,j);
            Prod_S = courante' * y;
            y = y - courante*Prod_S ;
        end
        Q(:,i) = y/norm(y);
    end
end