%Nettoyer l'interface
clc;
clear all;
close all;

%Constantes
Fe = 24000;
Rb = 3000;
Tb = 1/Rb;
Nbits = 1000;
Te = 1/Fe;
V = 1;
alpha = 0.2 ;
L = 8;

EbN0dB = 0:8;
N = length(EbN0dB);


%% Chaine 1
TEB_estime1 = zeros(1,N);

for i=1:N

    % Généraion de bits
    bits = randi([0 1],1, Nbits);

    % Mapping 1
    Symboles1 = zeros(1,length(bits));
    Symboles1(bits==1) = V;
    Symboles1(bits==0) = -V;

    % Suréchantillonage
    Tsbin =Tb ;
    Nsbin = floor(Tsbin / Te);
    surech1 = zeros(1,Nsbin);
    surech1(1) = 1;
    Xk1 = kron(Symboles1,surech1);
    
    % Mise en forme:
    h1 = ones(1,Nsbin);
    Signal_Filtre1 = filter(h1,1,Xk1);
    
    % Canal avec bruit
    Px1 = mean(abs(Signal_Filtre1).^2);
    Sigma2N1 = (Px1*Nsbin)/(2*log2(2)*10^(EbN0dB(i)/10)) ;
    bruit1 = sqrt(Sigma2N1) * randn(1, length(Xk1));

    % Filtre de récéption
    hr1 = h1;
    Signal_z1 = filter(hr1,1,Signal_Filtre1 + bruit1);
    Signal_z1_SB = filter(hr1,1,Signal_Filtre1);

%     %Diagramme de l'oeuil chaine 1 avec bruit
%     diagramme_oeuil_1 = reshape(Signal_z1,Nsbin,floor(length(Signal_z1)/Nsbin)) ;
%     figure(10+i);
%     plot(diagramme_oeuil_1);
%     xlabel("Temps(s)");
%     ylabel("Amplitude");
%     title("Diagramme de l'oeil de la chaine 1 avec bruit");
%     grid on;
        


    % %Diagramme de l'oeuil chaine 1 sans bruit
    % diagramme_oeuil_1 = reshape(Signal_z1_SB,Nsbin,floor(length(Signal_z1)/Nsbin)) ;
    % figure(10+i);
    % plot(diagramme_oeuil_1);
    % xlabel("Temps(s)");
    % ylabel("Amplitude");
    % title("Diagramme de l'oeil de la chaine 1 sans bruit");
    % grid on;

    % echantillonage à t0=Ts
    z_ech1 = Signal_z1(Nsbin : Nsbin : end ) ;
    
    %Decision
    Seuil = 0;
    SymboleDecide1 = zeros(1,length(z_ech1));
    SymboleDecide1(z_ech1>Seuil) = V;
    SymboleDecide1(z_ech1<-Seuil) = -V;

    % TEB1
    bits_estimes1=zeros(1,Nbits);
    bits_estimes1(z_ech1>0) = 1;
    TEB_estime1(1,i) = sum(bits ~=bits_estimes1)/Nbits ;

end
% TEB théorique
TEB_Theorique1 = qfunc(sqrt(2*10.^(EbN0dB/10)));

figure(1);
semilogy(EbN0dB, TEB_estime1,'*b-');
hold on;
semilogy(EbN0dB, TEB_Theorique1,'sr-');
hold off;
legend({'TEB_{estime}','TEB_{Theorique}1'});
title("TEB estimé et théorique de la chaine 1");
xlabel("Eb/N0 (dB)");
ylabel("TEB");

%% Chaine 2
TEB_estime2 = zeros(1,N);

for i=1:N

    % Géneration de bits
    bits = randi([0 1],1, Nbits);

    % Mapping 2
    Symboles2 = zeros(1,length(bits));
    Symboles2(bits==1) = V;
    Symboles2(bits==0) = -V;

    % Suréchantillonage
    Tsbin =Tb ;
    Nsbin = floor(Tsbin / Te);
    surech2 = zeros(1,Nsbin);
    surech2(1) = 1;
    Xk2 = kron(Symboles2,surech2);
    
    %Mise en forme:
    h2 = ones(1,Nsbin);
    Signal_Filtre2 = filter(h2,1,Xk2);
    
    % Canal avec bruit
    Px2 = mean(abs(Signal_Filtre2).^2);
    Sigma2N2 = (Px2*Nsbin)/(2*log2(2)*10^(EbN0dB(i)/10)) ;
    bruit2 = sqrt(Sigma2N2) * randn(1, length(Xk2));

    % Filtre de récéption
    hr2 = ones(1,Nsbin/2);
    Signal_z2 = filter(hr2,1,Signal_Filtre2 + bruit2);
    Signal_z2_SB = filter(hr2,1,Signal_Filtre2);


    % % Diagramme de l'oeuil chaine 2 avec bruit
    % diagramme_oeuil_2 = reshape(Signal_z2,Nsbin,floor(length(Signal_z2)/Nsbin)) ;
    % figure(20 + i);
    % plot(diagramme_oeuil_2);
    % xlabel("Temps(s)");
    % ylabel("Amplitude");
    % title("Diagramme de l'oeil de la chaine 2 avec bruit");
    % grid on;


    % 
    % % Diagramme de l'oeuil chaine 2 sans bruit
    % diagramme_oeuil_2 = reshape(Signal_z2_SB,Nsbin,floor(length(Signal_z2)/Nsbin)) ;
    % figure(20 + i);
    % plot(diagramme_oeuil_2);
    % xlabel("Temps(s)");
    % ylabel("Amplitude");
    % title("Diagramme de l'oeil de la chaine 2 sans bruit");
    % grid on;

    % echantillonage à t0=Ts
    z_ech2 = Signal_z2(Nsbin : Nsbin : end ) ;
    
    %Decision
    Seuil = 0;
    SymboleDecide2 = zeros(1,length(z_ech2));
    SymboleDecide2(z_ech2>Seuil) = V;
    SymboleDecide2(z_ech2<-Seuil) = -V;

    % TEB2
    bits_estimes2=zeros(1,Nbits);
    bits_estimes2(z_ech2>0) = 1;
    TEB_estime2(1,i) = sum(bits ~=bits_estimes2)/Nbits ;

end

% TEB théorique 2
TEB_Theorique2 = qfunc(sqrt(10.^(EbN0dB/10)));

figure(2);
semilogy(EbN0dB, TEB_estime2,'*b-');
hold on;
semilogy(EbN0dB, TEB_Theorique2,'sr-');
hold off;
legend({'TEB_{estime}','TEB_{Theorique}2'});
title("TEB estimé et théorique de la chaine 2");
xlabel("Eb/N0 (dB)");
ylabel("TEB");

%% Chaine 3
TEB_estime3 = zeros(1,N);

for i = 1:N

    % Géneration de bits
    bits = randi([0 1],1, Nbits);

    % Mapping 3
    bits4aires = reshape(bits, 2,length(bits)/2);
    Symboles3 = zeros(1,length(bits4aires));
    Vecteur = bi2de(bits4aires.');

    Symboles3(Vecteur==0) = -3*V;
    Symboles3(Vecteur==1) = -V;
    Symboles3(Vecteur==2) = V;
    Symboles3(Vecteur==3) = 3*V;

    % Suréchantillonage
    Ts4air =2*Tb ;
    Ns4air = floor(Ts4air / Te);
    surech3 = zeros(1,Ns4air);
    surech3(1) = 1;
    Xk3 = kron(Symboles3,surech3);
    
    %Mise en forme:
    h3 = ones(1,Ns4air);
    Signal_Filtre3 = filter(h3,1,Xk3);

    % Canal avec bruit
    Px3 = mean(abs(Signal_Filtre3).^2);
    Sigma2N3 = (Px3*Ns4air)/(2*log2(4)*10^(EbN0dB(i)/10)) ;
    bruit3 = sqrt(Sigma2N3) * randn(1, length(Xk3));

    % Filtre de récéption
    hr3 = h3;
    Signal_z3 = filter(hr3,1,Signal_Filtre3 + bruit3);
    Signal_z3_SB = filter(hr3,1,Signal_Filtre3);

    % % Diagramme de l'oeuil chaine 3 avec bruit
    % diagramme_oeil_3 = reshape(Signal_z3,Ns4air,floor(length(Signal_z3)/Ns4air)) ;
    % figure(30+i);
    % plot(diagramme_oeil_3);
    % xlabel("Temps(s)");
    % ylabel("Amplitude");
    % title("Diagramme de l'oeil de la chaine 3 avec bruit");
    % grid on;

    % % Diagramme de l'oeuil chaine 3 sans bruit
    % diagramme_oeil_3 = reshape(Signal_z3_SB,Ns4air,floor(length(Signal_z3)/Ns4air)) ;
    % figure(30+i);
    % plot(diagramme_oeil_3);
    % xlabel("Temps(s)");
    % ylabel("Amplitude");
    % title("Diagramme de l'oeil de la chaine 3 sans bruit");
    % grid on;

    % echantillonage à t0=Ts4air
    z_ech3 = Signal_z3(Ns4air: Ns4air : end);

    %Decision
    SeuilBas = -2*Ns4air;
    SeuilHaut = 2*Ns4air;
    SeuilMilieu = 0;

    SymboleDecide3 = zeros(1,length(z_ech3));
    SymboleDecide3(z_ech3>SeuilHaut) = 3*V;
    SymboleDecide3((z_ech3>SeuilMilieu) & (z_ech3<=SeuilHaut)) = V;
    SymboleDecide3((z_ech3<=SeuilMilieu) & (z_ech3>=SeuilBas)) = -V;
    SymboleDecide3(z_ech3<=SeuilBas) = -3*V;

    % TEB3
    compteur=1;
    bits_estimes3=zeros(1,Nbits);
    taille = length(SymboleDecide3);
    for  j=1:taille
        valeur = SymboleDecide3(j);
        if valeur==-3*V
            bits_estimes3(1,compteur)=0;
            bits_estimes3(1,compteur+1)=0;
        elseif valeur==-V
            bits_estimes3(1,compteur)=1;
            bits_estimes3(1,compteur+1)=0;
        elseif valeur==V
            bits_estimes3(1,compteur)=0;
            bits_estimes3(1,compteur+1)=1;
        elseif valeur==3*V
            bits_estimes3(1,compteur)=1;
            bits_estimes3(1,compteur+1)=1;
        end
        compteur = compteur+2;
    end
    TEB_estime3(1,i) = sum(bits ~=bits_estimes3)/Nbits ;

end
% TEB théorique 3
TEB_Theorique3 = 3/4*(qfunc(sqrt((4/5)*10.^(EbN0dB/10))));

figure(3);
semilogy(EbN0dB, TEB_estime3,'*b-');
hold on;
semilogy(EbN0dB, TEB_Theorique3,'sr-');
hold off;
title("TEB estimé et théorique de la chaine 3");
legend({'TEB_{estime}','TEB_{Theorique}3'});
xlabel("Eb/N0 (dB)");
ylabel("TEB");


%% Superposition des TEB de la chaine 1 et 2
figure(4);
semilogy(EbN0dB, TEB_estime1,'*b-');
hold on;
semilogy(EbN0dB, TEB_estime2,'sr-');
hold off;
legend({'TEB_{estime_1}','TEB_{estime_2}'});
title("Représentation de l'évolution des TEB de la chaine 1 et 2");
xlabel("Eb/N0 (dB)");
ylabel("TEB");

%% Superposition des TEB de la chaine 1 et 3
figure(5);
semilogy(EbN0dB, TEB_estime1,'*b-');
hold on;
semilogy(EbN0dB, TEB_estime3,'sr-');
hold off;
legend({'TEB_{estime_1}','TEB_{estime_3}'});
title("Représentation de l'évolution des TEB de la chaine 1 et 3");
xlabel("Eb/N0 (dB)");
ylabel("TEB");
