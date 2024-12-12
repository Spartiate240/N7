function L = laplacian(nu,dx1,dx2,N1,N2)
%
%  Cette fonction construit la matrice de l'opérateur Laplacien 2D anisotrope
%
%  Inputs
%  ------
%
%  nu : nu=[nu1;nu2], coefficients de diffusivité dans les dierctions x1 et x2. 
%
%  dx1 : pas d'espace dans la direction x1.
%
%  dx2 : pas d'espace dans la direction x2.
%
%  N1 : nombre de points de grille dans la direction x1.
%
%  N2 : nombre de points de grilles dans la direction x2.
%
%  Outputs:
%  -------
%
%  L      : Matrice de l'opérateur Laplacien (dimension N1N2 x N1N2)
%
% 

% Initialisation
    N = N1*N2;

    vi = nu(1)/dx1^2*ones(N,1);
    vij = -2*(nu(1)/dx1^2 +nu(2)/dx2^2)*ones(N,1);

%vecteur juste au dessus du vecteur du milieu
    vjp1 = nu(2)/dx2^2*ones(N,1);
    vjp1(1:N2:end) = 0;


%vecteur juste en dessous du vecteur du milieu
    vjm1 = nu(2)/dx2^2 *ones(N,1);
    vjm1(N2:N2:end) = 0;

    L = spdiags([vi,vjm1,vij,vjp1,vi],[-N2 -1 0 1 N2],N,N);

end    
