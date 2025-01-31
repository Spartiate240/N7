% Script for computing the BER for BPSK/QPSK modulation in ISI Channels
% 
close all;
clear all;
%% Simulation parameters
%Frame length
M=4; %2:BPSK, 4: QPSK
N  = 100000; % Number of transmitted bits or symbols
%Multipath channel parameters
%hc=[1 0.8*exp(1i*pi/3) 0.3*exp(1i*pi/6) ];%0.1*exp(1i*pi/12)];%ISI channel
%hc=[0.04, -0.05, 0.07, -0.21, -0.5, 0.72, 0.36, 0, 0.21, 0.03, 0.07];
%hc = [0.407, 0.815, 0.407];
hc = [ 0.623;0.489+0.234i;0.398i;0.21];
a=0.7;
%hc=[1 -a];
Lc=length(hc);%Channel length
ChannelDelay=0; %delay is equal to number of non causal taps


Es_N0_dB = [0:3:60]; % On va aussi loin car on voit la stagnation

% Viterbi decoding parameters
const = qammod((0:M-1)', M); % QPSK constellation (Gray coded)
tblen = 16; % Traceback length for Viterbi
nsamp = 1; % Over-sampling rate
preamble = []; % Not used
postamble = []; % Not used

% Preallocations

nErr_ml = zeros(1, length(Es_N0_dB));

for ii = 1:length(Es_N0_dB)
    % QPSK symbol generation
    bits = rand(2, N) > 0.5; % generating 0,1 with equal probability
    s = 1/sqrt(2) * ((1 - 2*bits(1,:)) + 1j*(1 - 2*bits(2,:))); % QPSK modulation

    sigs2 = var(s);

    % Channel convolution: equivalent symbol based representation
    z = conv(hc, s);

    % Generating noise
    sig2b = 10^(-Es_N0_dB(ii)/10); % Noise power
    n = sqrt(sig2b/2) * randn(1, N + Lc - 1) + 1j * sqrt(sig2b/2) * randn(1, N + Lc - 1); % white Gaussian noise for QPSK

    % Adding noise to the signal
    y = z + n; % Received signal with noise

    %% Maximum Likelihood Equalizer (ML)
    s_ml = mlseeq(y, hc, const, tblen, 'rst', nsamp, [], []); % Egaliseur ML
    
    bhat_ml = zeros(2, length(bits));
    bhat_ml(1, :) = real(s_ml(1:N)) < 0;
    bhat_ml(2, :) = imag(s_ml(1:N)) < 0;
    nErr_ml(ii) = size(find(bits(1,:) ~= bhat_ml(1,:)), 2) + size(find(bits(2,:) ~= bhat_ml(2,:)), 2);
end

% Simulated Bit Error Rates (BER)
simBer_ml = nErr_ml / N / log2(M); % Simulated BER for ML equalizer

% Plotting results
figure;

semilogy(Es_N0_dB, simBer_ml, 'go-', 'LineWidth', 2);
axis([0 50 10^-6 0.5]);
grid on;
legend('ML');
xlabel('E_s/N_0, dB');
ylabel('Bit Error Rate');
title('Bit Error Rate for QPSK in ISI Channels with  ML Equalizer');


