
% Script for computing the BER for BPSK/QPSK modulation in ISI Channels
% 
close all;
clear all;

%% Simulation parameters
% On d�crit ci-apr�s les param�tres g�n�raux de la simulation

noise = true; % true: add noise, false: no noise
% Si false: la différence avec/sans bruit dans les dsp à la fin n'existe pas

if noise ==false
    str_noise = "sans";
    Es_N0_dB = 0; % Eb/N0 values

else 
    str_noise = "avec";
    %Es_N0_dB = [0:5:25]; % Eb/N0 values, meilleur pour voir l'effet sur les constellations
    Es_N0_dB = [0:25]; % meilleur pour voir l'effet sur le TEB

end

%Frame length
M=4; %2:BPSK, 4: QPSK
N  = 100000; % Number of transmitted bits or symbols
%Multipath channel parameters
%hc=[1 0.8*exp(1i*pi/3) 0.3*exp(1i*pi/6) ];%0.1*exp(1i*pi/12)];%ISI channel
%hc=[0.04, -0.05, 0.07, -0.21, -0.5, 0.72, 0.36, 0, 0.21, 0.03, 0.07];
%hc = [0.407, 0.815, 0.407];
%hc = [0.227, 0.460, 0.688, 0.460, 0.227];
a=0.7;
hc=[1 -a];
Lc=length(hc);%Channel length
ChannelDelay=0; %delay is equal to number of non causal taps

%figure()

%Preallocations
nErr_zfinf=zeros(1,length(Es_N0_dB));
nErr_zf_=zeros(1,length(Es_N0_dB));
nErr_MMSE=zeros(1,length(Es_N0_dB));
sig_sur_bruit_mmse = zeros(1,length(Es_N0_dB));

for ii = 1:length(Es_N0_dB)
   % BPSK symbol generations
%    bits = rand(1,N)>0.5; % generating 0,1 with equal probability
%    s = 1-2*bits; % BPSK modulation following: {0 -> +1; 1 -> -1} 
   
   % QPSK symbol generations
   bits = rand(2,N)>0.5; % generating 0,1 with equal probability
   s = 1/sqrt(2)*((1-2*bits(1,:))+1j*(1-2*bits(2,:))); % QPSK modulation following the BPSK rule for each quadatrure component: {0 -> +1; 1 -> -1} 
   sigs2=var(s);
   
   % Channel convolution: equivalent symbol based representation
   z = conv(hc,s);  
   
   %Generating noise
   sig2b=10^(-Es_N0_dB(ii)/10);
   %n = sqrt(sig2b)*randn(1,N+Lc-1); % white gaussian noise, BPSK Case
    n = sqrt(sig2b/2)*randn(1,N+Lc-1)+1j*sqrt(sig2b/2)*randn(1,N+Lc-1); % white gaussian noise, QPSK case
   
   % Adding Noise
   if noise
      y = z + n; 
   else
      y = z;
   end



   %% zero forcing equalization
   % We now study ZF equalization

   %Unconstrained ZF equalization, only if stable inverse filtering


   
   %%
   % 
   %  The unconstrained ZF equalizer, when existing is given by 
   % 
   % $w_{,\infty,zf}=\frac{1}{h(z)}$
   % 
   
   s_zf=filter(1,hc,y);%if stable causal filter is existing
   bhat_zf = zeros(2,length(bits));
   bhat_zf(1,:)= real(s_zf(1:N)) < 0;
   bhat_zf(2,:)= imag(s_zf(1:N)) < 0;
   nErr_zfinfdirectimp(1,ii) = size(find([bits(:)- bhat_zf(:)]),1);
   %Otherwise, to handle the non causal case
   Nzf=200;
   [r, p, k]=residuez(1, hc);
   [w_zfinf]=ComputeRI( Nzf, r, p, k );
   s_zf=conv(w_zfinf,y);
   bhat_zf = zeros(2,length(bits));
   bhat_zf(1,:)= real(s_zf(Nzf:N+Nzf-1)) < 0;
   bhat_zf(2,:)= imag(s_zf(Nzf:N+Nzf-1)) < 0;
   
   nErr_zfinf(1,ii) = size(find([bits(:)- bhat_zf(:)]),1);
   

   %% MMSE
   % We now study MMSE equalization
   deltac = zeros(1,2*Lc-1);
   deltac(Lc)=1;
   Nmmse=200;
   [r, p, k]=residuez(fliplr(conj(hc)), conv(hc,fliplr(conj(hc)))+ sig2b/sigs2*deltac);
   [w_mmse]=ComputeRI( Nmmse, r, p, k );
   s_mmse=conv(w_mmse,y);
   bhat_mmse = zeros(2,length(bits));
   bhat_mmse(1,:)= real(s_mmse(Nmmse:N+Nmmse-1)) < 0;
   bhat_mmse(2,:)= imag(s_mmse(Nmmse:N+Nmmse-1)) < 0;
   
   nErr_mmse(1,ii) = size(find([bits(:)- bhat_mmse(:)]),1);
   

    



   % Calcul du SNR après égalisation MMSE
   signal_power_mmse = mean(abs(s_mmse(Nmmse:N+Nmmse-1)).^2);  % Puissance du signal égalisé
   fin = min(N+Nmmse-1,length(y));
   noise_power_mmse = mean(abs(y(Nmmse:fin) - s_mmse(Nmmse:fin)).^2);  % Puissance du bruit égalisé
   sig_sur_bruit_mmse(ii) = signal_power_mmse / noise_power_mmse;

    %% Pour les tracés: en mettre un seul non commenté à la fois.


    %%%% Tracé des constellations:
    % Ligne 42 à commenter si ici commenté
    % if noise
    %     nexttile
    %     %scatter(real(s_mmse), imag(s_mmse),'filled');
    %     %title(['MMSE avec Signal/bruit = ', num2str(Es_N0_dB(ii)), 'dB'])
    % 
    %     scatter(real(s_zf), imag(s_zf),'filled');
    %     title(['ZF avec Signal/bruit = ', num2str(Es_N0_dB(ii)), 'dB'])
    % else
    %     nexttile
    %     scatter(real(s_mmse), imag(s_mmse),'filled');
    %     title('MMSE sans bruit')
    %     nexttile
    %     scatter(real(s_zf), imag(s_zf),'filled');
    %     title('ZF sans bruit')
    % end
   %% RIF:  
   % We now study RIF equalization
   
   % paramètres
   Nw=16;
   d = 5;
   H = toeplitz([hc(1) zeros(1,Nw-1)]',[hc, zeros(1,Nw-1)]);


   % Optimal
   Ry = (conj(H)*H.');
   p = zeros(Nw+Lc-1,1);
   P= (H.'*inv((Ry))*conj(H));
   [alpha,dopt]=max(diag(abs(P)));
   %p(d+1)=1;
   p(dopt)=1;
   Gamma = conj(H)*p;
   w_zf_fir = (inv(Ry)*Gamma).';
   sig_e_opt = sigs2 -conj(w_zf_fir)*Gamma;
   bias = 1-sig_e_opt/sigs2;
   shat = conv(w_zf_fir,y);
   shat = shat(dopt:end);

   bHat = zeros(2,length(bits));
   bHat(1,:)=real(shat(1:N))<0;
   bHat(2,:)=imag(shat(1:N))<0;

   nErr_Hatinfdirectimp(1,ii) = size(find([bits(:)- bHat(:)]),1);
   nErr_Hat(1,ii) = size(find([bits(:)- bHat(:)]),1);


   % non Optimal
   Ry = sigs2 * (conj(H)*H.')+sig2b*eye(Nw);
   p = zeros(Nw+Lc-1,1);

   P= 1/sigs2 * (H.'*inv((Ry/sigs2))*conj(H));
   [alpha,dopt]=max(diag(abs(P)));
   %p(d+1)=1;
   p(dopt)=1;
   Gamma = conj(H)*p;
   w_zf_fir = (inv(Ry)*Gamma).';

   sig_e_opt = sigs2 -conj(w_zf_fir)*Gamma;
   bias(ii) = 1-sig_e_opt/sigs2;
   shat = conv(w_zf_fir,y);
   shat = shat(dopt:end);

   bHat = zeros(2,length(bits));
   bHat(1,:)=real(shat(1:N))<0;
   bHat(2,:)=imag(shat(1:N))<0;

   nErr_Hat1infdirectimp(1,ii) = size(find([bits(:)- bHat(:)]),1);
   nErr_Hat1(1,ii) = size(find([bits(:)- bHat(:)]),1);

    bias_mmse(ii) = 1 - signal_power_mmse / sigs2;

end
simBer_zfinfdirectimp = nErr_zfinfdirectimp/N/log2(M); % simulated ber
simBer_zfinf = nErr_zfinf/N/log2(M); % simulated ber
      % Ces 2 courbes sont indentiques

simBer_mmse = nErr_mmse/N/log2(M); % simulated ber
simBer_Hat1infdirectimp = nErr_Hat1infdirectimp/N/log2(M);
simBer_Hat1 = nErr_Hat1/N/log2(M);

%simBer_zfdirectimp_ = nErr_zfdirectimp_/N/log2(M); % simulated ber
%simBer_zf_ = nErr_zf_/N/log2(M); % simulated ber

%% plot



% Affichage du SNR post égalisation
figure;
plot(Es_N0_dB, sig_sur_bruit_mmse);
xlabel('Eb/N0 [dB]');
ylabel('SNR post-égalisation MMSE');
grid on;
title('SNR post-égalisation MMSE');

%TEB
figure
semilogy(Es_N0_dB,simBer_zfinfdirectimp(1,:),'bs-','Linewidth',2);
hold on
semilogy(Es_N0_dB,simBer_zfinf(1,:),'rs-','Linewidth',2);
hold on
semilogy(Es_N0_dB,simBer_mmse(1,:),'ys-','Linewidth',2);

axis([0 30 10^-6 0.5])
grid on
legend('sim-zf-dir/imp','sim-zf-inf', 'sim-MMSE');
xlabel('E_s/N_0, dB');
ylabel('Bit Error Rate');
title('Bit error probability curve for QPSK in ISI with ZF equalizers')

figure
title('Impulse response')
stem(real(w_zfinf))
hold on
stem(real(w_zfinf),'r-')
ylabel('Amplitude');
xlabel('time index')



