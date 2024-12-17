
% Script for computing the BER for BPSK/QPSK modulation in ISI Channels
% 
close all;
clear all;

%% Simulation parameters
% On d�crit ci-apr�s les param�tres g�n�raux de la simulation

noise = true; % true: add noise, false: no noise

%Frame length
M=4; %2:BPSK, 4: QPSK
N  = 1000000; % Number of transmitted bits or symbols
Es_N0_dB = [0:30]; % Eb/N0 values
%Multipath channel parameters
hc=[1 0.8*exp(1i*pi/3) 0.3*exp(1i*pi/6) ];%0.1*exp(1i*pi/12)];%ISI channel
%hc=[0.04, -0.05, 0.07, -0.21, -0.5, 0.72, 0.36, 0, 0.21, 0.03, 0.07];
%hc = [0.407, 0.815, 0.407];
%hc = [0.227, 0.460, 0.688, 0.460, 0.227];
%a=1.2;
%hc=[1 -a];
Lc=length(hc);%Channel length
ChannelDelay=0; %delay is equal to number of non causal taps

%Preallocations
nErr_zfinf=zeros(1,length(Es_N0_dB));
nErr_zf_=zeros(1,length(Es_N0_dB));
nErr_MMSE=zeros(1,length(Es_N0_dB));

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
      y = z + n; % additive white gaussian noise
   else
      y = z; % noiseless case
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
   %% 
   
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
   
    

   %% Toeplitz ZF equalization

   

end
simBer_zfinfdirectimp = nErr_zfinfdirectimp/N/log2(M); % simulated ber
simBer_zfinf = nErr_zfinf/N/log2(M); % simulated ber
      % Ces 2 courbes sont indentiques

simBer_mmse = nErr_mmse/N/log2(M); % simulated ber


%simBer_zfdirectimp_ = nErr_zfdirectimp_/N/log2(M); % simulated ber
%simBer_zf_ = nErr_zf_/N/log2(M); % simulated ber

% plot

figure
semilogy(Es_N0_dB,simBer_zfinfdirectimp(1,:),'bs-','Linewidth',2);
hold on
semilogy(Es_N0_dB,simBer_zfinf(1,:),'rs-','Linewidth',2);
hold on
semilogy(Es_N0_dB,simBer_mmse(1,:),'ys-','Linewidth',2);

axis([0 50 10^-6 0.5])
grid on
legend('sim-zf-inf/direct','sim-zf-inf/direct', 'sim-MMSE');
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



