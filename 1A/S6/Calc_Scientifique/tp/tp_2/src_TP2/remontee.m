%--------------------------------------------------------------------------
% ENSEEIHT - 1SN - Calcul scientifique
% TP2 - Factorisation LU
% remontee.m
%---------------------------------------------------------------------------

function x = remontee(U,b)
%---------------------------------------------------------------------------
% Resoudre U x = b avec 
% U triangulaire superieure, b second membre.
%---------------------------------------------------------------------------
       
     %Initialisation
     [n, ~] = size(U);
     x=b;
     for j = n-1:1
         for i = n:j-1
             x(i) = x(i) - U(j,i)*x(j);
         end
     end
end
