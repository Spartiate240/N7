%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               TP1 de Traitement Num�rique du Signal
%                   SCIENCES DU NUMERIQUE 1A
%                       Fevrier 2024 
%                        Pr�nom Nom
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PARAMETRES GENERAUX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A=1;        %amplitude du cosinus
f1=1000;       %fr�quence du cosinus en Hz
T1=1/f1;       %p�riode du cosinus en secondes
f2 = 3000;
T2 = 1/f2;

N=100;        %nombre d'�chantillons souhait�s pour le cosinus
Fe=10000;       %fr�quence d'�chantillonnage en Hz
Te=1/Fe;       %p�riode d'�chantillonnage en secondes
SNR=10;      %SNR souhait� en dB pour le cosinus bruit�


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GENERATION DU COSINUS NUMERIQUE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%D�finition de l'�chelle temporelle
temps=0:Te:(N-1)*Te;
%G�n�ration de N �chantillons de cosinus � la fr�quence f1 et f2
x1=A*cos(2*pi*f1*temps);
x2=A*cos(2*pi*f2*temps);
x = x1 + x2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TRACE DU COSINUS NUMERIQUE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Sans se pr�occuper de l'�chelle temporelle
figure
plot(x)

%Trac� avec une �chelle temporelle en secondes
%des labels sur les axes et un titre (utilisation de xlabel, ylabel et
%title)
figure
plot(temps, x);
grid
xlabel('Temps (s)')
ylabel('signal')
title(['Trac� de la somme de cos de fr�quences ' num2str(f1) ' et' num2str(f2) 'Hz']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CALCUL DE LA TRANSFORMEE DE FOURIER NUMERIQUE (TFD) DU COSINUS NUMERIQUE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Sans zero padding 
X1=fft(x1);
X1 = fftshift(X1);
X2 = fft(x2);
X2 = fftshift(X2);
X = fft(x);
X = fftshift(X);

%Avec zero padding (ZP : param�tre de zero padding � d�finir)         
N2 = 2^8;
X1_ZP=fft(x1, N2);
X2_ZP = fft(x2, N2);
X_ZP= fft(x, N2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TRACE DU MODULE DE LA TFD DU COSINUS NUMERIQUE EN ECHELLE LOG
%SANS PUIS AVEC ZERO PADDING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Avec une �chelle fr�quentielle en Hz
%des labels sur les axes et des titres
%Trac�s en utilisant plusieurs zones de la figure (utilisation de subplot) 
figure('name',['Trac� du module de la TFD d''un cosinus num�rique de fr�quence ' num2str(f1) 'Hz'])

subplot(2,1,1)
f1 = 0:Fe/N:(Fe-Fe/N); 
semilogy(f1, abs(X));
grid
title('Sans zero padding')
xlabel('Fr�quence (Hz)')
ylabel('|TFD|')


subplot(2,1,2)
f2 = 0:Fe/N2:(Fe-Fe/N2); 
semilogy(f2, abs(X_ZP));
grid
title('Avec zero padding')
xlabel('Fr�quence (Hz)')
ylabel('|TFD|')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILTRE PASSE-BAS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = 2*f1/Fe;
ordre = 11;
h = 2./fc .* sinc(fc.*((-ordre+1)/2:(ordre-1)/2));


echelle_frequentielle=f*((-ordre+1)/2:(ordre-1)/2);
figure
semilogy(echelle_frequentielle, abs(y));
grid
title('Filtrage')
xlabel('Fr�quence (Hz)')
ylabel('|TFD|')


