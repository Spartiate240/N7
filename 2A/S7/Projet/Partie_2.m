clear all;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Auteur: DUROLLET Pierre
% Année: 2024-2025 2A SN R1

% Pour VSCode, lancer matlab en même temps

% Schema chaine porteuse:
% bits -> Mapping QPSK -> Filtre (SRRCF) -> Modulateur -> Canal -> 
% Demodulateur -> Filtre adapté -> Décision

% Schema chaine passe-bas equivalente:
% bits -> Mapping QPSK -> Filtre (SRRCF) -> Canal -> Filtre Adapté 
% -> Décision


% Ts = Ns*Te; or comme 2 bits par symbole au min : Ts >= 2*Tb
% Donc Ns >= 2*Tb/Te



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               Variables Globales:

M = 4; % Nombre de symboles de la constellation (QPSK)
Ns = 5; % Facteur de suréchantillonage
% Paramètres du filtre de mise en forme
alpha = 0.35; % coeficient de roll-off
span = 8; % Durée du filtre en symboles


Nb_bits = 50000;

Rb = 3000; % Débit binaire
Fe = Rb; % Fréquence d'échantillonage
Te = 1/Fe;
Tb = 1/Rb; % Durée d'un bit
Rs = Rb/log2(M); % Débit symbole
% Définition des filters
h = rcosdesign(alpha, span, Ns, 'sqrt');
hr = fliplr(h); % Filtre de reception = version retournée du filtre de mise en forme

retard = length(h); % somme des TPG

% Génération de bits, on la garde pour la suite, évitant les redondances
bits = randi([0 1],1,Nb_bits);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               Partie 2:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Mapping QPSK défini par DVB-S, il y a donc Nb_bits/2 symboles
sym = (1-2*bits(2:2:end)) + 1i*(1-2*bits(1:2:end));

% Suréchantillonage: peigne de diracs
pdirac = [kron(sym, [1 zeros(1,Ns-1)]) zeros(1,retard)];

% Passage dans le filtre de mise en forme surélevé et convolution

x = filter(h,1,pdirac);

%Q2: forme : de -Fe(1+alpha)/2 à Fe(1+alpha)/2
% Donc: Fe >= 2*Rs (1+alpha)/2
%           Fe >= Rs (1 + alpha)

% Filtre adapté = maximise rapport Sig/bruit

%%%%%%%%%%%%%%%%%%%%%%%%% Bruit %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Variables du bruit
% Eb/N0 de -4 à 4 dB
EbN0dB = -4:0.5:4;
EbN0 = 10.^(EbN0dB/10); % Eb/N0 en linéaire
% Nombre de valeurs de Eb/N0
n = length(EbN0);

% Puissance bruit
Px = mean(abs(x).^2);

% Initialisation du vecteur de TEB
TEB = zeros(1,n);
% Boucle pour les différentes valeurs de Eb/N0
for i = 1:n
    % Bruit
    sigma2 = Px*Ns/(2*log2(M)*EbN0(i));
    bruit = sqrt(sigma2)*(randn(1,length(x)) + 1i*randn(1,length(x)));
    % Ajout du bruit au signal
    y = x + bruit;
    
    % Demodulation
    y_demod = filter(hr,1,y);

    % Supression du retard et echantillonnage tout les Ns
    y_r_echan = y_demod(retard:Ns:length(y_demod)-1);

    % Démapping
    re = real(y_r_echan)<0;
    im = imag(y_r_echan)<0;

    % Signal réception
    sig_re = zeros(1,2*length(re));
    sig_re(1:2:end) = im;
    sig_re(2:2:end) = re;

    % Calcul TEB
    % On réduit le vecteur du nb de bits pour qu'il ait la même taille
    bits_TEB = bits(1: length(sig_re));
    TEB(i) = sum(bits_TEB ~= sig_re)/length(bits_TEB);

end


%Tracé du TEB
figure(1);
semilogy(EbN0dB,TEB,'r');
hold on;
semilogy(EbN0dB,qfunc(sqrt(2*EbN0)),'b');
legend('TEB simulé')
grid;
xlabel('Eb/N0 (dB)');
ylabel('TEB');
title('TEB en fonction de Eb/N0');


