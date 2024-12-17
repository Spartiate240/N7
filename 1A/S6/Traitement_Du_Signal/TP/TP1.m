%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               TP1 de Traitement Numérique du Signal
%                   SCIENCES DU NUMERIQUE 1A
%                       Fevrier 2024 
%                        Prénom Nom
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PARAMETRES GENERAUX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A= 1;        %amplitude du cosinus
f0=1100;       %fréquence du cosinus en Hz
T0=1/f0;       %période du cosinus en secondes
N=90;        %nombre d'échantillons souhaités pour le cosinus
Fe1=1000;       %fréquence d'échantillonnage en Hz
Te1=1/Fe1;       %période d'échantillonnage en secondes
SNR= 10;      %SNR souhaité en dB pour le cosinus bruité


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GENERATION DU COSINUS NUMERIQUE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Définition de l'échelle temporelle
temps1=0:Te1:(N-1)*Te1;
%Génération de N échantillons de cosinus à la fréquence f0
x=A*cos(2*pi*f0*temps1);



Fe2=3000;       %fréquence d'échantillonnage n°2 en Hz
Te2=1/Fe2;       %période d'échantillonnage n°2 en secondes
temps2=0:Te2:(N-1)*Te2;
x2=A*cos(2*pi*f0*temps2);

% Les fréconeces ne sont pas les memes car la fréquence d'échantillonnage
% est trop grande par rapport à celle du signal.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TRACE DU COSINUS NUMERIQUE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Sans se préoccuper de l'échelle temporelle

figure;
plot(x);

%Tracé avec une échelle temporelle en secondes
%des labels sur les axes et un titre (utilisation de xlabel, ylabel et
%title)

figure;
plot(temps2,x2);
grid;
xlabel('Temps (s)');
ylabel('signal');
title(['Tracé d''un cosinus numérique de fréquence ' num2str(f0) 'Hz']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CALCUL DE LA TRANSFORMEE DE FOURIER NUMERIQUE (TFD) DU COSINUS NUMERIQUE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%Question 2.1.1
%La transformée de Fourier entre 0 et Fe est justifiée car car au cours du
%temps dans les échantillons, la transformée de Fourier sera au cours des
%fréquences, pour les fréquences allant de "0" à Fe.


%Sans zero padding 
X=fft(x);
%Avec zero padding (ZP : paramètre de zero padding à définir)         
N2 = 2^8;

X_ZP=fft(x, N2);

%Question 2.1.3
% Le zero padding est mieux car on voit mieux ce qu'on devrait avoir avec
% un cosinus (en valeur absolue), et en augmentant N2, on voit que le
% résultat se rapproche de + en + de ce qu'on devrait avoir avec un
% cosinus.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TRACE DU MODULE DE LA TFD DU COSINUS NUMERIQUE EN ECHELLE LOG
%SANS PUIS AVEC ZERO PADDING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Avec une échelle fréquentielle en Hz
%des labels sur les axes et des titres
%Tracés en utilisant plusieurs zones de la figure (utilisation de subplot) 
figure('name',['Tracé du module de la TFD d''un cosinus numérique de fréquence ' num2str(f0) 'Hz'])

subplot(2,1,1)
f1 = 0:Fe1/N:(Fe1-Fe1/N); 
semilogy(f1, abs(X));
grid
title('Sans zero padding')
xlabel('Fréquence (Hz)')
ylabel('|TFD|')
subplot(2,1,2)
f2 = 0:Fe2/N2:(Fe2-Fe2/N2);
semilogy(f2, abs(X_ZP));
grid
title('Avec zero padding')
xlabel('Fréquence (Hz)')
ylabel('|TFD|')

%Avec une échelle fréquentielle en Hz
%des labels sur les axes et des titres
%Tracés superposés sur une même figure 
% (utilisation de hold, de couleurs différentes et de legend)
% !! UTILISER ICI fftshift POUR LE TRACE !!
figure
echelle_frequentielle=linspace(-Fe1/2, Fe1/2, length(X));
semilogy(echelle_frequentielle,fftshift(abs(X)),'b');    %Tracé en bleu : 'b'
hold on
echelle_frequentielle=linspace(-Fe2/2, Fe2/2, length(X_ZP));
semilogy(echelle_frequentielle,fftshift(abs(X_ZP)),'r'); %Tracé en rouge : 'r'
grid
legend('Sans zero padding','Avec zero padding')
xlabel('Fréquence (Hz)')
ylabel('|TFD|')
title(['Tracé du module de la TFD d''un cosinus numérique de fréquence ' num2str(f0) 'Hz'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CALCUL DE LA TFD DU COSINUS NUMERIQUE AVEC FENETRAGE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Application de la fenêtre de pondération de Hamming
x_fenetre_hamming=x.*hamming(length(x)).';
%Calcul de la TFD pondérée, avec zeros padding
X_ZP_hamming=fft("à completer");
%Application de la fenêtre de pondération de Blackman
x_fenetre_blackman="à completer";
%Calcul de la TFD pondérée, avec zeros padding
X_ZP_blackman=fft("à completer");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TRACE DU MODULE DE LA TFD DU COSINUS NUMERIQUE AVEC FENETRAGE EN ECHELLE LOG
%POUR DIFFERENTES FENETRES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%"à réaliser : tracés superposés sur la même figure de la TFD non fenêtrée, 
%de la TFD avec fenêtrage de Hamming, de la TFD avec fenêtrage de Blackman
%Le tout avec une échelle fréquentielle en Hz, un titre, des labels sur les axes, 
%une légende et en utilisant fftshift"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CALCUL DE LA DENSITE SPECTRALE DE PUISSANCE (DSP) DU COSINUS NUMERIQUE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Estimation par périodogramme
Sx_periodogramme="à completer";

%Estimation par périodogramme de Welch
Sx_Welch=pwelch(x, [],[],[],Fe,'twosided');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TRACE DE LA DENSITE SPECTRALE DE PUISSANCE (DSP) DU COSINUS NUMERIQUE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Tracés superposés sur une même figure en utilisant fftshift
%Avec une échelle fréquentielle en Hz
%des labels sur les axes, un titre, une légende
figure
echelle_frequentielle="à completer";
semilogy("à completer",'b')
hold on
echelle_frequentielle="a completer";
semilogy("à completer",'r')
legend('Periodogramme','Periodogramme de Welch')
xlabel('Fréquences (Hz)')
ylabel('DSP')
title('Tracés de la DSP d''un cosinus numérique de fréquence 1100 Hz');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CALCUL ET TRACE DE LA FONCTION D'AUTOCORRELATION DU COSINUS BRUITE AVEC LE
%BON SNR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       

%Calcul de la puissance du signal
P_signal=mean(abs(x).^2);
%Calcul de la puissance du bruit pour obtenir le SNR souhaité
P_bruit="à completer";

%Génération du bruit gaussien à la puissance Pb
bruit=sqrt(P_bruit)*randn(1,length(x));
%Ajout du bruit sur le signal
x_bruite=x+bruit;

%Calcul de la fonction d'autocorrélation du signal bruite
%attention pas le 1/N quand on utilise xcorr => à rajouter
Rx=(1/length(x_bruite))*xcorr(x_bruite); 

%Tracé du signal bruité avec une échelle temporelle en secondes
figure
plot("à completer")
grid
xlabel('Temps (s)')
ylabel('Signal')
title('Tracé du cosinus bruité');

%Tracé de la fonction d'autocorrélation du signal bruite avec une échelle 
%temporelle en secondes
figure
echelle_tau="à completer";
plot("à completer")
grid
xlabel('\tau (s)')
ylabel('R_x(\tau)')
title('Tracé de la fonction d''autocorrélation du cosinus bruité');

