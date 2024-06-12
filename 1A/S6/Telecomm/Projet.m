%Nettoyer l'interface
clc;
clear all;
close all;
%Constantes
Fe = 24000; % Fréquence echantillonnage
fp = 2000; % Fréquence porteuse
Rb = 3000; % Débit binaire
Tb = 1/Rb; % Période binaire
Nbits = 10; % Nombre de bits à prendre
Te = 1/Fe; % Période échantillonnage
V = 1; % Facteur symbole
M = 4; % Ordre modulation
alpha = 0.2 ;
L = 8;
EbN0dB = 0:6;
N = length(EbN0dB);
Ns = Fe/fp; % Facteur de suréchantillonnage


% Génération signal
signal = randi([0 1],1, Nbits);


% Mapping 
dk = zeros(1, length(signal)/2);
ak = signal(1:2:end);
bk = signal(2:2:end);


%%%???????????????????????????????????????????????????????
% signal = randi([0 M-1],Nbits, 1);
% dk = pskmod(signal, M, 0, 'gray');
%%%???????????????????????????????????????????????????????


for i=1:length(ak)
    if (ak(i) == 0 && bk(i) == 0)
        dk(i) = -3*V;
    elseif (ak(i) == 0 && bk(i) == 1)
        dk(i) = -V;
    elseif (ak(i) == 1 && bk(i) == 1)
        dk(i) = V;
    else
        dk(i) = 3*V;
    end
end


% Filtrage
h = rcosdesign(0.35, round((Nbits-1)/Ns), Ns);
x = filter();
 
% Constantes bruit
Px = mean(abs(x).^2); % Puissance du signal
M = 4; % Ordre de la modulation
rapport_sig_bruit = 0.5; % Rapport Signal/bruit souhaité

sigma = Px * Ns /(2 * log2(M)*rapport_sig_bruit);

% Génération bruit
bruit = sqrt(sigma)*randn(length(gray_code));

