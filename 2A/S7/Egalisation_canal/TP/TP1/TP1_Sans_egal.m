% Script for computing the BER for BPSK/QPSK modulation in ISI Channels
% 
close all;
clear all;

%% Simulation parameters
% On d�crit ci-apr�s les param�tres g�n�raux de la simulation

noise = false; % true: add noise, false: no noise
% Si false: la différence avec/sans bruit dans les dsp à la fin n'existe pas

if noise ==false
    str_noise = "sans";
    Es_N0_dB = 0;
else 
    str_noise = "avec";
    Es_N0_dB = [0:5:25]; 
end

% Frame length
M = 4; %2:BPSK, 4: QPSK
N  = 1000000; % Number of transmitted bits or symbols
% Multipath channel parameters
%hc=[1 0.8*exp(1i*pi/3) 0.3*exp(1i*pi/6) ];%0.1*exp(1i*pi/12)];%ISI channel
%hc=[0.04, -0.05, 0.07, -0.21, -0.5, 0.72, 0.36, 0, 0.21, 0.03, 0.07];
%hc = [0.407, 0.815, 0.407];
%hc = [0.227, 0.460, 0.688, 0.460, 0.227];
a = 0.7;
hc = [1 -a];
Lc = length(hc); % Channel length
ChannelDelay = 0; % delay is equal to number of non causal taps

figure()

% Preallocations
nErr = zeros(1, length(Es_N0_dB));
sig_sur_bruit = zeros(1, length(Es_N0_dB));

for ii = 1:length(Es_N0_dB)
    % QPSK symbol generations
    bits = rand(2, N) > 0.5; % generating 0,1 with equal probability
    s = 1/sqrt(2)*((1-2*bits(1,:)) + 1j*(1-2*bits(2,:))); % QPSK modulation
    sigs2 = var(s);

    % Calcul de la DSP de l'émission (avant canal et bruit)
    % [dsp_emit, f_emit] = pwelch(s, [], [], [], 'twosided'); % Calcul de la DSP avant canal
    % nexttile
    % plot(f_emit, 10*log10(dsp_emit)); % Tracé de la DSP en dB
    % title('DSP de l émission');
    % xlabel('Fréquence (Hz)');
    % ylabel('DSP (dB/Hz)');

    % Channel convolution: equivalent symbol based representation
    z = conv(hc, s);  

    % Generating noise
    sig2b = 10^(-Es_N0_dB(ii)/10);
    n = sqrt(sig2b/2) * randn(1, N + Lc - 1) + 1j * sqrt(sig2b/2) * randn(1, N + Lc - 1); % white gaussian noise, QPSK case

    % Adding Noise
    if noise
        y = z + n; 
    else
        y = z; 
    end

    % Error computation (no equalization)
    % Directly compare transmitted bits and received signal
    bhat = zeros(2, length(bits));
    bhat(1,:) = real(y(1:N)) < 0;
    bhat(2,:) = imag(y(1:N)) < 0;

    nErr(1, ii) = size(find([bits(:) - bhat(:)]), 1);

    %% Affichage des constellations
    % Tracé des constellations
    if noise
        nexttile
        scatter(real(y(1:N)), imag(y(1:N)), 'filled');
        title(['Bruit avec Signal/Bruit = ', num2str(Es_N0_dB(ii)), 'dB']);
    else
        nexttile
        scatter(real(y(1:N)), imag(y(1:N)), 'filled');
        title('Constellation sans bruit');
    end

    %% Calcul et affichage de la DSP du signal reçu
    % Calcul de la DSP à l'aide de pwelch pour le signal reçu
    % [dsp_recv, f_recv] = pwelch(y, [], [], [], 'twosided'); % Calcul de la DSP
    % nexttile
    % plot(f_recv, 10*log10(dsp_recv)); % Tracé de la DSP en dB
    % if noise
    %     title(['Signal/Bruit = ', num2str(Es_N0_dB(ii)), 'dB']);
    % else
    %     title('DSP sans bruit');
    % end
    % xlabel('Fréquence (Hz)');
    % ylabel('DSP (dB/Hz)');
end
