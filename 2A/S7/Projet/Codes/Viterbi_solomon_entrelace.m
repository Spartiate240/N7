close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Auteur: DUROLLET Pierre
% Année: 2024-2025 2A SN R1



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               Variables Globales:

M = 4; % Nombre de symboles de la constellation (QPSK)
Ns = 5; % Facteur de suréchantillonage
% Paramètres du filtre de mise en forme
alpha = 0.35; % coeficient de roll-off
span = 8; % Durée du filtre en symboles
Nb_bits = 188*100*8;
Rb = 3000; % Débit binaire
Fe = Rb; % Fréquence d'échantillonage
Te = 1/Fe;
Tb = 1/Rb; % Durée d'un bit
Rs = Rb/log2(M); % Débit symbole



%% Variables du bruit

% Eb/N0 de -4 à 4 dB
EbN0dB = -4:4;
EbN0 = 10.^(EbN0dB/10); % Eb/N0 en linéaire
% Nombre de valeurs de Eb/N0
n = length(EbN0);

% Filtres
h = rcosdesign(alpha, span, Ns, 'sqrt');
hr = fliplr(h); % Filtre de reception = version retournée du filtre de mise en forme
retard = length(h); % somme des TPG

% Initialisation TEBs
TEB = zeros(1,n);
TEB_RS_e = zeros(1,n);
TEB_RS_e = zeros(1,n);
courant = 1;
epsilon = 5*10^-1;
precision = ceil(1/epsilon^2);
Nerreur = 0;

%% Codage

% Paramètres (3, 1/2)
K = 3;
N = 2;
%polynomes générateurs
g1 = 5; % g1 = 5 = 101
g2 = 7; % g2 = 7 = 111

TEB_RS_p = TEB_RS_e;

% Génération des polys de treillis
treillis = poly2trellis(K, [g1 g2]);
commcnv_plotnextstates(treillis.outputs);


% Encodage Reed-solomons 188:204
dec = comm.RSDecoder(204,188,BitInput=true);
enc = comm.RSEncoder(204,188,'BitInput',true);



%% Boucle

while courant<n

    % Génération de bits, on la garde pour la suite, évitant les redondances
    bits = randi([0 1],1,Nb_bits);
    % Encodage des bits à émettre à l'aide du treillis
    codee_trans = step(enc, bits.').';
    delay = 11*17*12;
    retard_entrelaceur = zeros(1,delay);
    codee_trans2 = convintrlv([codee_trans retard_entrelaceur],12,17);
    codee = convenc(codee_trans2, treillis);
    
    % Mapping QPSK défini par DVB-S, il y a donc Nb_bits/2 symboles
    sym = (1-2*codee(2:2:end)) + 1i*(1-2*codee(1:2:end));
    % Suréchantillonage: peigne de diracs
    pdirac = [kron(sym, [1 zeros(1,Ns-1)]) zeros(1,retard)];
    % Passage dans le filtre de mise en forme surélevé et convolution
    x = filter(h,1,pdirac);

    %Q2: forme : de -Fe(1+alpha)/2 à Fe(1+alpha)/2
    % Donc: Fe >= 2*Rs (1+alpha)/2
    %           Fe >= Rs (1 + alpha)

    % Filtre adapté = maximise rapport Sig/bruit

    %%%%%%%%%%%%%%%%%%%%%%%%% Bruit %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Puissance bruit
    Px = mean(abs(x).^2);

    % Boucle pour les différentes valeurs de Eb/N0
    % Bruit
    sigma2 = Px*Ns/(2*log2(M)*EbN0(courant));
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
   


    %% Decodage:
    % Utilisation fonction Viterbi
    

    bits_e_h_transition = vitdec(sig_re, treillis, 5, 'trunc', 'hard');
    bits_e_h_transition_2 = convdeintrlv(bits_e_h_transition,12,17);
    bits_e_h_transition_3 = bits_e_h_transition_2(delay+1:end);
    bits_e_h = step(dec, bits_e_h_transition_3.').';
    
    %% Calcul TEB
    % On réduit le vecteur du nb de bits pour qu'il ait la même taille
    TEB_RS_e(courant) = sum(bits ~= bits_e_h)/length(bits);
    Nerreur_h = sum(bits ~= bits_e_h);
    if Nerreur_h>precision
        courant = courant+1;
    end

end


%Tracé du TEB
figure(1);
semilogy(EbN0dB,TEB_RS_e,'g');
hold on;
semilogy(EbN0dB,qfunc(sqrt(2*EbN0)),'b');

legend('TEB simulé','TEB sans codage');
grid;
xlabel('Eb/N0 (dB)');
ylabel('TEB');
title('TEB en fonction de Eb/N0 sans poinçonnage');

% La différence se fait entre la déf de décodage hard et soft