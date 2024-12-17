%--------------------------------------------------------------------------
% ENSEEIHT - 1SN - Calcul scientifique
% TP1 - Orthogonalisation de Gram-Schmidt
% cgs.m
%--------------------------------------------------------------------------

function Q = cgs(A)

    % Recuperation du nombre de colonnes de A
    [n, m] = size(A);
    
    % Initialisation de la matrice Q avec la matrice A
    Q = A;
    
    Q(:,1) = Q(:,1)/norm(Q(:,1));

    for k = 2:m
        y = A(:,k);
        tmp = zeros(n,1);
        for i = 1:(k-1)
            cour = Q(:,i);
            tmp = tmp + cour*(y'*cour);
        end
        Q(:,k) = A(:,k) - tmp;
        Q(:,k) = Q(:,k)/norm(Q(:,k));
    end
end