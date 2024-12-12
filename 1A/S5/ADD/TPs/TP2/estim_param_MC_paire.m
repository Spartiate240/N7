% fonction estim_param_MC_paire (pour exercice_2.m)

function parametres = estim_param_MC_paire(d,x,y_inf,y_sup)
    n = length(x);
    
    y = [y_inf  y_sup];

    A = zeros(2*n,2*d);
    for i =1:d-1
        A(1:n,i) = vecteur_bernstein(x,d,i);
        A(n:end,i+(d-1)) = vecteur_bernstein(x,d,i);
    end

    %récuperer conditions de départ
    y_inf = repmat(y_inf(1),n);
    y_sup = repmat(y_sup(1),n);
    
    
    B = y - [y_inf y_sup] .* vecteur_bernstein(x,d,0);

    
    parametres = (A'*A)\(A'*B);
end
