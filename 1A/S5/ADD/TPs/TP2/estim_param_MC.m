% fonction estim_param_MC (pour exercice_1.m)

function parametres = estim_param_MC(d,x,y)

    n = length(x);

    A = zeros(n,d);
    for i =1:d
        A(:,i) = vecteur_bernstein(x,d,i);
    end
    B = y - y(1) * vecteur_bernstein(x,d,0);
    parametres = (A'*A)\(A'*B);

end
