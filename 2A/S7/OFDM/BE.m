clear all;
close all;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Chaine transmission OFDM                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Variables globales:
N = 16; % Nb porteuses TOTAL
Nb_bits = 16000; % nb de bits voulus %% Mieux si multiple de N
Ts = 1; %Période d'échantillonnage
Fe=1/Ts;
D_sy = N*Ts; % Durée symbole


% Génération bits:
bits_e = randi([0,1],1,Nb_bits);


% Mapping BPSK
sig_map = bits_e*2-1;

% IFFT:
mat_sig = reshape(sig_map,N, length(sig_map)/N);

% Utilisation que de n porteuses, donc mise à 0 de N-n porteuses
mat_sig_1 = mat_sig;
mat_sig_1(2:end,:) = 0;

mat_sig_2 = mat_sig;
mat_sig_2(3:end,:) = 0;

mat_sig_8 = mat_sig;
mat_sig_8(1:4,:) = 0; % 4 du bord gauche
mat_sig_8(13:end,:) = 0; % 4 du bord droit

porteuses_1 = ifft(mat_sig_1);
porteuses_2 = ifft(mat_sig_2);
porteuses_8 = ifft(mat_sig_8);


% Reshape pour mettre sur 1 ligne
sig_ifft_1 = reshape(porteuses_1,1,Nb_bits);
sig_ifft_2 = reshape(porteuses_2,1,Nb_bits);
sig_ifft_8 = reshape(porteuses_8,1,Nb_bits);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DSP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dsp_1 = pwelch(sig_ifft_1,[],[],[],Fe,'centered');
dsp_2 = pwelch(sig_ifft_2,[],[],[],Fe,'centered');
dsp_8 = pwelch(sig_ifft_8,[],[],[],Fe,'centered');


subplot(3,1,1);
semilogy(dsp_1); %%% Le centrer entre 1 et N-1
title('DSP 1 porteuse');


subplot(3,1,2);
semilogy(dsp_2);
title('DSP 2 porteuses');


subplot(3,1,3);
semilogy(dsp_8);
title('DSP 8 porteuses');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Réception sans canal                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Génération avec toutes les porteuses
mat_sig_16 = mat_sig;
porteuses_16 = ifft(mat_sig_16);


% Inversion de la génération avec toutes les porteuses
mat_sig_recu = fft(porteuses_16);
sig_recu = reshape(mat_sig_recu,1,Nb_bits);

% Décision
sym_recu = sign(real(sig_recu));


% Démapping
bits_recu = (sym_recu+1)/2;


% TES:
calc_tes = abs(sig_map - sym_recu);
sym_diff = sum(calc_tes);
TES = sym_diff/Nb_bits; % Car codage (1,1)
TES


% TEB:
calc = abs(bits_e - bits_recu); % comme bit: soit 0; soit 1, donc abs
                                   % de la différence: 1, donc chaque 
                                   % élément est: 1 si différent, 0 si
                                   % égaux

bits_diff = sum(calc);
TEB = bits_diff/Nb_bits;
TEB % non nul mais come e-18 et différence entre entiers et int, c'est du à
    %la précision de la machine


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      Transmission avec canal                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Y(z)/X(Z) = 0.407 + 0.815e(-Ts) + 0.404e(-2Ts)
Sx = reshape(porteuses_16,1,Nb_bits);

% Variables:
N = 10; % nombre d'échantillons
h = [0.407 0.815 0.407]; % coefficients
x = [1 zeros(1, Nb_bits-1)]; % Impulsion d'amplitude 1
Fs = 5000; % Fréquence max de la réponse fréquentielle
Ts = 1/Fs;
% Réponse impulsionnelle:
y = conv(x,h); %Convolution


y_imp = y(1:N); % Limite du nombre de points car avec 16000 on voit rien
figure;
stem(0: length(y_imp)-1,y_imp); % On voit que c'est échantilloné tout 
                                % les Ts au vu de la valeur de chacun 
                                % des 3 premier points.
title('Réponse impulsionnelle')


% Réponse en fréquence
N = 16;
H = fft(h,N);

figure;
subplot(2,1,1);
plot(abs(H));
title('Module de la réponse fréquetielle')

subplot(2,1,2);
plot(angle(H));
title('Phase de la réponse impulsionnelle')


% Question 3: passage dans le Canal 
SignalSortieCanal = filter(h,1,Sx);

% DSP sortie Canal
dsp_ap = pwelch(SignalSortieCanal, [], [], [], 1, 'twosided');  

figure;
subplot(2,1,2);
semilogy(dsp_ap);
title('DSP du signal en sortie du canal')


dsp_av = pwelch(Sx, [], [], [], 1, 'twosided');
subplot(2,1,1);
semilogy(dsp_av);
title('DSP du signal avant le canal');

% Constellations sur porteuses 6 et 15: on prends le 6e tout les 16 et le
% 15e tout les 16 pts 

N = 16;
% Vecteur des porteuses
port_6 = zeros(N, Nb_bits/N);
port_15 = zeros(N,Nb_bits/N);

port_6(6, :) = mat_sig(6, :);
port_15(15,:) = mat_sig(15,:);

% Calcul du signal OFDM par application du filtre IFFT(N)
sig_port_6 = ifft(port_6);
sig_port_15 = ifft(port_15);

% Calcul du signal x recu avec la porteuse 6
x6 = reshape((sig_port_6), 1, Nb_bits);
x15 = reshape((sig_port_15), 1, Nb_bits);

% Passage du signal dans le canal
x6_canal = filter(h, 1, x6);
x15_canal = filter(h, 1, x15);

% Redimensionnement du vecteur signal pour utiliser fft
x6_demod = reshape(x6_canal, N, Nb_bits/N);
x15_demod = reshape(x15_canal, N, Nb_bits/N);

% Demodulation du signal OFDM par application du filtre fft
x6_demodule_porteuses = fft(x6_demod);
x15_demodule_porteuses = fft(x15_demod);

% Reconstruction des signaux porteuses démodulé
x6_demodule = x6_demodule_porteuses(6, :);
x15_demodule = x15_demodule_porteuses(15, :);

figure;
scatter(real(x6_demodule), imag(x6_demodule),'filled');
hold on;
scatter(real(x15_demodule), imag(x15_demodule),'filled');
hold off;
title('porteuses 6 et 15 après Canal')
legend('6e porteuse', '15e porteuse')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               3.1.6

% Préparation et utilisation de FFT
x16_demod = reshape(SignalSortieCanal, N, Nb_bits/N);
x16_fft = fft(x16_demod);

% Redimensionnement 
syg_recu_P3 = reshape(x16_fft, 1, Nb_bits);

% Passage de complexe en réel, meme décision qu'avant:
sym_recu_P3 = sign(real(syg_recu_P3));

% Demapping:
bit_recu_P3 = (sym_recu_P3+1)/2;

% TEB:
calc = abs(bits_e - bit_recu_P3); % comme bit: soit 0; soit 1, donc abs
                                   % de la différence: 1, donc chaque 
                                   % élément est: 1 si différent, 0 si
                                   % égaux

TEB_3_1_6 = sum(calc)/Nb_bits;
TEB_3_1_6


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          TRAME DE GARDE                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Création Trame de garde
L = 2; % Taille de la trame (L zéros ajoutés)
sig_port_trame = zeros(N + L, (Nb_bits/N));

% Ajout porteuses en laissaint les L 1ères lignes à 0
sig_port_trame(L+1:end,:) = porteuses_16;


% Passage dans le canal
signalOFDM_trame = reshape(sig_port_trame,1,Nb_bits + (Nb_bits/N)*L);
SignalSortieCanal_trame = filter(h,1,signalOFDM_trame);

% Passage en porteuses
port_Sig_canal_trame = reshape(SignalSortieCanal_trame, N + L, Nb_bits/N);

% Enlever Trame de garde
sig_porteuse_ss_trame = port_Sig_canal_trame(L+1:end,:);

% Démodulation
sig_demod_ss_trame = fft(sig_porteuse_ss_trame);


% Isolement des porteuses
porteuse_6_trame = sig_demod_ss_trame(6:16:end);
porteuse_15_trame = sig_demod_ss_trame(15:16:end);


figure;
scatter(real(porteuse_6_trame), imag(porteuse_6_trame),'filled');
hold on;
scatter(real(porteuse_15_trame), imag(porteuse_15_trame),'filled');
hold off;
title('porteuses 6 et 15 avec trame')
legend('6e porteuse', '15e porteuse')



% Remise en ligne
sig_fft_ss_trame_1D = reshape(sig_demod_ss_trame,1, Nb_bits);

%Passage de complexe en réel, meme décision qu'avant:
sym_recu_P3_ss_trame = sign(real(sig_fft_ss_trame_1D));

%Demapping:
bit_recu_P3_trame = (sym_recu_P3_ss_trame+1)/2;

%TEB:
calc_trame = abs(bits_e - bit_recu_P3_trame); % 1 si différents, 0 si égaux
TEB_trame = sum(calc_trame)/Nb_bits;
TEB_trame

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Implantation avec préfixe cyclique %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N_cyc = 2; %nb cycles

% Création mat vide où on ajoutera les préfixes
mat_sig_port_cyc =  zeros(N + N_cyc, Nb_bits/N);

% Remplissage comme de base
mat_sig_port_cyc(3:end,:) = porteuses_16;

% Ajout préfixe
mat_sig_port_cyc(1:2,:) = porteuses_16(N-N_cyc+1:end,:);

% Passage en 1D
sig_16_cyc = reshape(mat_sig_port_cyc, 1, Nb_bits + Nb_bits/N *N_cyc);

% Passage canal
sig_canal_cyc = filter(h,1,sig_16_cyc);

% Retour en matrice pour isoler porteuses
port_canal_cyc = reshape(sig_canal_cyc,N+ N_cyc, Nb_bits/N);

% Retirer les cycles
port_canal_ss_cyc = zeros(size(porteuses_16));
port_canal_ss_cyc = port_canal_cyc(N_cyc+1:end,:);

% Démodulation sortie avec fft
sig_fft_ss_cyc = fft(port_canal_ss_cyc);

porteuse_6_cyc = sig_fft_ss_cyc(6,:);
porteuse_15_cyc = sig_fft_ss_cyc(15,:);

figure;
scatter(real(porteuse_6_cyc), imag(porteuse_6_cyc),'filled');
hold on;
scatter(real(porteuse_15_cyc), imag(porteuse_15_cyc),'filled');
hold off;
title('porteuses 6 et 15 avec préfixe cyclique')
legend('6e porteuse', '15e porteuse')


% Remise en ligne
sig_fft_ss_cyc_1D = reshape(sig_fft_ss_cyc,1, Nb_bits);

%Passage de complexe en réel, meme décision qu'avant:
sym_recu_P3_cyc = sign(real(sig_fft_ss_cyc_1D));

%Demapping:
bit_recu_P3_cyc = (sym_recu_P3_cyc+1)/2;

%TEB:
calc_cyc = abs(bits_e - bit_recu_P3_cyc); % 1 si différents, 0 si égaux
TEB_cyc = sum(calc_cyc)/Nb_bits;
TEB_cyc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               3.4 Préfixe et Egalisation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                   ZFE


% On prends le signal après fft dans cyclique
%sig_fft_ss_cyc 
sig_fft_ZFE = zeros(size(sig_fft_ss_cyc));

% Calcul avec H. 
for lig = 1:N
    sig_fft_ZFE(lig,:) = (sig_fft_ss_cyc(lig,:)/abs(H(lig))) * exp(-1j*angle(H(lig)));
end




porteuse_6_ZFE = sig_fft_ZFE(6,:);
porteuse_15_ZFE = sig_fft_ZFE(15,:);

figure;
scatter(real(porteuse_6_ZFE), imag(porteuse_6_ZFE),'filled');
hold on;
scatter(real(porteuse_15_ZFE), imag(porteuse_15_ZFE),'filled');
hold off;
title('porteuses 6 et 15 avec Zero Forcing Equalizer')
legend('6e porteuse', '15e porteuse')
axis([-1 1 -1 1])

%%%%% TEB %%%%%
% Remise en ligne
sig_fft_ZFE = reshape(sig_fft_ZFE,1, Nb_bits);

%Passage de complexe en réel, meme décision qu'avant:
sym_recu_ZFE = sign(real(sig_fft_ZFE));

%Demapping:
bit_recu_ZFE = (sym_recu_ZFE+1)/2;

%TEB:
calc_cyc = abs(bits_e - bit_recu_ZFE); % 1 si différents, 0 si égaux
TEB_ZFE = sum(calc_cyc)/Nb_bits;
TEB_ZFE


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Maximum Likelihood

sig_fft_ML = zeros(size(sig_fft_ss_cyc));

% Calcul avec H(i) = C(i)
for lig = 1:N
    sig_fft_ML(lig,:) = (sig_fft_ss_cyc(lig,:)*abs(H(lig)))*exp(-1j*angle(H(lig)));
end

porteuse_6_ML = sig_fft_ML(6,:);
porteuse_15_ML = sig_fft_ML(15,:);

figure;
scatter(real(porteuse_6_ML), imag(porteuse_6_ML),'filled');
hold on;
scatter(real(porteuse_15_ML), imag(porteuse_15_ML),'filled');
hold off;
title('porteuses 6 et 15 avec Maximum Likelihood')
legend('6e porteuse', '15e porteuse')


%%%%% TEB %%%%%
% Remise en ligne
sig_fft_ML = reshape(sig_fft_ML,1, Nb_bits);

%Passage de complexe en réel, meme décision qu'avant:
sym_recu_ML = sign(real(sig_fft_ML));

%Demapping:
bit_recu_ML = (sym_recu_ML+1)/2;

%TEB:
calc_cyc = abs(bits_e - bit_recu_ML); % 1 si différents, 0 si égaux
TEB_ML = sum(calc_cyc)/Nb_bits;
TEB_ML




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           PARTIE 4                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


N_cyc_4 = 3*N_cyc; %nb cycles

% Création mat vide où on ajoutera les préfixes
mat_sig_port_cyc_4 =  zeros(N + N_cyc_4, Nb_bits/N);

% Remplissage comme de base
mat_sig_port_cyc_4(N_cyc_4 +1:end,:) = porteuses_16;

% Ajout préfixe
mat_sig_port_cyc_4(1:N_cyc_4,:) = porteuses_16(N-N_cyc_4+1:end,:);

% Passage en 1D
sig_16_cyc_4 = reshape(mat_sig_port_cyc_4, 1, Nb_bits + Nb_bits/N *N_cyc_4);

% Passage canal
sig_canal_cyc_4 = filter(h,1,sig_16_cyc_4);

% Retour en matrice pour isoler porteuses
port_canal_cyc_4 = reshape(sig_canal_cyc_4,N+ N_cyc_4, Nb_bits/N);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               Cas 1


% Retirer les lignes
port_canal_ss_cyc_cas_1 = zeros(size(porteuses_16));
port_canal_ss_cyc_cas_1 = port_canal_cyc_4(1:end-N_cyc_4,:);

% Démodulation sortie avec fft
sig_fft_ss_cyc_cas_1 = fft(port_canal_ss_cyc_cas_1);

porteuse_6_cyc_cas_1 = sig_fft_ss_cyc_cas_1(6,:);
porteuse_15_cyc_cas_1 = sig_fft_ss_cyc_cas_1(15,:);

figure;
scatter(real(porteuse_6_cyc_cas_1), imag(porteuse_6_cyc_cas_1),'filled');
hold on;
scatter(real(porteuse_15_cyc_cas_1), imag(porteuse_15_cyc_cas_1),'filled');
hold off;
title('porteuses 6 et 15 du cas 1')
legend('6e porteuse', '15e porteuse')


% Remise en ligne
sig_fft_ss_cyc_cas_1 = reshape(sig_fft_ss_cyc_cas_1,1, Nb_bits);

%Passage de complexe en réel, meme décision qu'avant:
sym_recu_P3_cyc_cas_1 = sign(real(sig_fft_ss_cyc_cas_1));

%Demapping:
bit_recu_P3_cyc_cas_1 = (sym_recu_P3_cyc_cas_1+1)/2;

%TEB:
calc_cyc = abs(bits_e - bit_recu_P3_cyc_cas_1); % 1 si différents, 0 si égaux
TEB_cyc_cas_1 = sum(calc_cyc)/Nb_bits;
TEB_cyc_cas_1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               Cas 2


% Retirer les lignes
port_canal_ss_cyc_cas_2 = zeros(size(porteuses_16));
port_canal_ss_cyc_cas_2 = port_canal_cyc_4(N_cyc_4/2: end-N_cyc_4/2-1,:);

% Démodulation sortie avec fft
sig_fft_ss_cyc_cas_2 = fft(port_canal_ss_cyc_cas_2);

porteuse_6_cyc_cas_2 = sig_fft_ss_cyc_cas_2(6,:);
porteuse_15_cyc_cas_2 = sig_fft_ss_cyc_cas_2(15,:);

figure;
scatter(real(porteuse_6_cyc_cas_2), imag(porteuse_6_cyc_cas_2),'filled');
hold on;
scatter(real(porteuse_15_cyc_cas_2), imag(porteuse_15_cyc_cas_2),'filled');
hold off;
title('porteuses 6 et 15 du cas 2')
legend('6e porteuse', '15e porteuse')


% Remise en ligne
sig_fft_ss_cyc_cas_2 = reshape(sig_fft_ss_cyc_cas_2,1, Nb_bits);

%Passage de complexe en réel, meme décision qu'avant:
sym_recu_cyc_cas_2 = sign(real(sig_fft_ss_cyc_cas_2));

%Demapping:
bit_recu_cyc_cas_2 = (sym_recu_cyc_cas_2+1)/2;

%TEB:
calc_cyc = abs(bits_e - bit_recu_cyc_cas_2); % 1 si différents, 0 si égaux
TEB_cyc_cas_2 = sum(calc_cyc)/Nb_bits;
TEB_cyc_cas_2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               Cas 3
% Décalage cas 3
decal_cas_3 = 3;
N_cyc_cas_3 = N_cyc_4 + decal_cas_3;

% Retirer les lignes
port_canal_ss_cyc_cas_3 = zeros(size(porteuses_16));

% On retransmets les lignes qui bougent pas
port_canal_ss_cyc_cas_3(decal_cas_3:end,:) = port_canal_cyc_4(N_cyc_cas_3:end,:);

% Décalage des autres lignes et recopie des dernières aux 1ères
port_canal_ss_cyc_cas_3(1:decal_cas_3,:) = [port_canal_cyc_4(1:decal_cas_3,end) port_canal_cyc_4(1:decal_cas_3,1:end-1)];


% Démodulation sortie avec fft
sig_fft_ss_cyc_cas_3 = fft(port_canal_ss_cyc_cas_3);

porteuse_6_cyc_cas_3 = sig_fft_ss_cyc_cas_3(6,:);
porteuse_15_cyc_cas_3 = sig_fft_ss_cyc_cas_3(15,:);

figure;
scatter(real(porteuse_6_cyc_cas_3), imag(porteuse_6_cyc_cas_3),'filled');
hold on;
scatter(real(porteuse_15_cyc_cas_3), imag(porteuse_15_cyc_cas_3),'filled');
hold off;
title('porteuses 6 et 15 du cas 3')
legend('6e porteuse', '15e porteuse')


% Remise en ligne
sig_fft_ss_cyc_cas_3 = reshape(sig_fft_ss_cyc_cas_3,1, Nb_bits);

%Passage de complexe en réel, meme décision qu'avant:
sym_recu_cyc_cas_3 = sign(real(sig_fft_ss_cyc_cas_3));

%Demapping:
bit_recu_cyc_cas_3 = (sym_recu_cyc_cas_3+1)/2;

%TEB:
calc_cyc = abs(bits_e - bit_recu_cyc_cas_3); % 1 si différents, 0 si égaux
TEB_cyc_cas_3 = sum(calc_cyc)/Nb_bits;
TEB_cyc_cas_3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%       PARTIE 5        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Mapping QPSK:
sym_e = [1 - 2*bits_e(1:2:end) + 1i*(1-2*bits_e(2:2:end))];
N_cyc = 2; %nb cycles
Nb_sym = length(sym_e);
Nb_sym_cyc = N_cyc* Nb_bits/(2*N);

sig_OFDM = reshape(sym_e,N, Nb_sym/N);
porteuses_OFDM = ifft(sig_OFDM);

% Création mat vide où on ajoutera les préfixes
sig_port_OFDM =  zeros(N + N_cyc, Nb_sym/N);

% Remplissage comme de base
sig_port_OFDM(N_cyc+1:end,:) = porteuses_OFDM;

% Ajout préfixe
sig_port_OFDM(1:N_cyc,:) = porteuses_OFDM(N-N_cyc+1:end,:);

% Passage en 1D
sig_16_OFDM = reshape(sig_port_OFDM, 1, Nb_sym + Nb_sym/N *N_cyc);


% Ajout bruit
EbN0dB = 0:6; %Plage de valeurs de Eb/N0 en dB
n = length(EbN0dB);
Px = mean(abs(sig_16_OFDM).^2);
TEB_5 = zeros(1,n);
M = 4; % Order de la QPSK

for i = 0:6
    sigma = Px/(2*log2(M)*10^(i/10));
    
    % Génération bruit
    bruit = [sqrt(sigma)*(randn(1,Nb_sym+Nb_sym_cyc) + sqrt(sigma)*1i*randn(1,Nb_sym+Nb_sym_cyc))];

    % Passage dans le canal
    z = bruit + sig_16_OFDM;

    % Retour en matrice pour isoler porteuses
    port_canal_br = reshape(z,N + N_cyc, (Nb_sym+Nb_sym_cyc)/(N+N_cyc));

    % Retirer les cycles
    port_bruit = zeros(size(porteuses_OFDM));
    port_bruit = port_canal_br(N_cyc+1:end,:);

    % Démodulation sortie avec fft
    sig_fft_ss_cyc = fft(port_bruit);

    % Repassage en ligne
    sig_ligne = reshape(sig_fft_ss_cyc,1,Nb_sym);

    % Seuil et démapping
    re = sign(real(sig_ligne))<0;
    im = sign(imag(sig_ligne))<0;

    % Signal en réception
    sig_rec = zeros(1,Nb_bits);
    sig_rec(1:2:end) = re;
    sig_rec(2:2:end) = im;
    
    % TEB
    TEB_5(i+1) = sum(abs(sig_rec - bits_e))/Nb_bits;
end

figure;
semilogy(EbN0dB, TEB_5);
hold on
semilogy(EbN0dB, qfunc(sqrt(2*10.^([0:6]/10))));
grid;
title('Tracé du TEB en fonction du Eb/N0');
xlabel('Eb/N0');
ylabel('TEB');
legend('Pratique', 'Théorique');
