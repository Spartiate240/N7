clear all; close all;

%%%%% SET ENV %%%%%

addpath('matlab_bgl');      %load graph libraries
addpath('matlab_tpgraphe'); %load tp ressources

load TPgraphe.mat;          %load data

%%%%%% DISPLAY INPUT DATA ON TERMINAL %%%%%
N = length(cities); %nb of cities
cities %names of cities
D      %distance matrix bw cities
pos    %x-y pos of the cities

%%%%%%EXO 1 (modeliser et afficher le graphe) %%%%%
A = (D < 500 & D>0); %adj matrix

viz_adj(D,A,pos,cities);

% As the longest rout is 7 steps, being higher than 7 is useless
A2 = graphPower(A,2); % Shows cities can return to origin in 2 or less steps
A3 = graphPower(A,3);
A7 = graphPower(A,7);
A10 = graphPower(A,10);
viz_adj(D,A2,pos,cities);
viz_adj(D,A3,pos,cities);
%viz_adj(D,A7,pos,cities);
viz_adj(D,A10,pos,cities);

% Montre les villes qui peuvent être atteintes en partant d'une autre, même si elles ne sont pas directement reliées
% dans le graphe A


%%%%%% EXO 2 %%%%%

%Q1 - existence d'un chemin de longueur 3
A_e3 = A3 - A2 > 0; % 1 si il existe un chemin de longueur 3 entre les villes, 0 sinon
%Q2 - nb de chemins de 3 sauts
nb_e3 = sum(sum(A_e3)); % Nombre de chemins de 3 sauts
%Q3 - nb de chemins <=3
nb_3 = sum(graphPower(A,3), 'all'); % Nombre de chemins de 3 sauts

% Affichage des résultats
%A_e3
nb_e3
nb_3

%%%%%%%% EXO 3 %%%%%

% indice i -> j : G(j,i) = 1


c=[18 13 9]; %la chaine 18 13 9 est t dans le graphe?
possedechaine(A,c)
c=[18 6 3]; %la chaine 18 6 3 est t dans le graphe?
possedechaine(A,c)
c=[26 5 17]; %la chaine 26 5 17 est t dans le graphe?
possedechaine(A,c)

%%%%%%%% EXO 4%%%%%
isEulerien(A);


%%%%%%%% EXO 5%%%%%
porteeEulerien(D)

