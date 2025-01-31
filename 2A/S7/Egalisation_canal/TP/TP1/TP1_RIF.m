% Script for computing the BER for BPSK/QPSK modulation in ISI Channels
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
hc = [0.227, 0.460, 0.688, 0.460, 0.227];
a=0.7;
%hc=[1 -a];
Lc=length(hc);%Channel length
ChannelDelay=0; %delay is equal to number of non causal taps


Es_N0_dB = [0:3:60]; % On va aussi loin car on voit la stagnation


% Preallocations
nErr_zfinf = zeros(1, length(Es_N0_dB));
nErr_zf_rif = zeros(1, length(Es_N0_dB));
nErr_mmse_rif = zeros(1, length(Es_N0_dB));
nErr_zfinfdirectimp = zeros(1, length(Es_N0_dB));
nErr_mmseinf = zeros(1, length(Es_N0_dB));

for ii = 1:length(Es_N0_dB)
    % QPSK symbol generation
    bits = rand(2, N) > 0.5;  % Generate random bits (2 rows for QPSK)
    s = 1/sqrt(2) * ((1 - 2*bits(1,:)) + 1j * (1 - 2*bits(2,:)));  % QPSK modulation
    sigs2 = var(s);  % Signal power

    % Channel convolution: equivalent symbol-based representation
    z = conv(hc, s);  

    % Additive white Gaussian noise (AWGN)
    sig2b = 10^(-Es_N0_dB(ii)/10);  % Noise power
    n = sqrt(sig2b/2) * randn(1, N + Lc - 1) + 1j * sqrt(sig2b/2) * randn(1, N + Lc - 1);  % QPSK noise

    % Received signal
    y = z + n;  % Add noise to the signal

    %% Zero-Forcing RIF
    Nw = 5;  % Length of the Toeplitz matrix
    H = toeplitz([hc(1), zeros(1, Nw-1)]', [hc, zeros(1, Nw-1)]);  % Construct the Toeplitz matrix
    Ry = conj(H) * H.';  % Autocorrelation matrix of the channel output
    P = H.' * inv(Ry) * conj(H);  % Matrix for Zero-Forcing equalizer design
    
    [valeur_max, indice] = max(diag(abs(P)));  % Maximum diagonal element for selection
    
    % Zero-Forcing equalizer design
    p = zeros(Nw + Lc - 1, 1);
    p(indice) = 1;
    gamma = conj(H) * p;
    w_zf = inv(Ry) * gamma;
    s_rif_zf = conv(w_zf, y);
    s_rif_zf = s_rif_zf(indice:end);
    
    bhat_zf_rif = zeros(2, length(bits));
    bhat_zf_rif(1, :) = real(s_rif_zf(1:N)) < 0;
    bhat_zf_rif(2, :) = imag(s_rif_zf(1:N)) < 0;
    nErr_zf_rif(ii) = sum(bits(1,:) ~= bhat_zf_rif(1,:)) + sum(bits(2,:) ~= bhat_zf_rif(2,:));

    %% MMSE RIF
    Ry = sigs2*conj(H) * H.' + sig2b*eye(Nw);  % Autocorrelation matrix of the channel output (with noise)
    P = sigs2 * H.' * inv(Ry/sigs2) * conj(H);  % Matrix for MMSE equalizer design
    
    [valeur_max, indice] = max(diag(abs(P)));  % Maximum diagonal element for selection
    
    % MMSE
    p = zeros(Nw + Lc - 1, 1);
    p(indice) = 1;
    gamma = sigs2 * conj(H) * p;
    w_mmse = inv(Ry) * gamma;
    s_rif_mmse = conv(w_mmse, y);
    s_rif_mmse = s_rif_mmse(indice:end);
    
    bhat_mmse_rif = zeros(2, length(bits));
    bhat_mmse_rif(1, :) = real(s_rif_mmse(1:N)) < 0;
    bhat_mmse_rif(2, :) = imag(s_rif_mmse(1:N)) < 0;
    nErr_mmse_rif(ii) = sum(bits(1,:) ~= bhat_mmse_rif(1,:)) + sum(bits(2,:) ~= bhat_mmse_rif(2,:));

    %% ZF (unconstrained)
    % Zero-Forcing equalization (causal)
    s_zf = filter(1, hc, y);  % Apply ZF filter
    bhat_zf = zeros(2, length(bits));
    bhat_zf(1, :) = real(s_zf(1:N)) < 0;
    bhat_zf(2, :) = imag(s_zf(1:N)) < 0;
    nErr_zfinfdirectimp(ii) = sum(bits(1,:) ~= bhat_zf(1,:)) + sum(bits(2,:) ~= bhat_zf(2,:));

    %% Non-causal case (for ZF)
    Nzf = 200;  % Non-causal length for ZF
    [r, p, k] = residuez(1, hc);  % Compute residues, poles, and gain
    w_zfinf = ComputeRI(Nzf, r, p, k);  % Compute the inverse filter (function needs to be defined)
    s_zf = conv(w_zfinf, y);  % Apply non-causal ZF filter
    bhat_zf = zeros(2, length(bits));
    bhat_zf(1, :) = real(s_zf(Nzf:N + Nzf - 1)) < 0;
    bhat_zf(2, :) = imag(s_zf(Nzf:N + Nzf - 1)) < 0;
    nErr_zfinf(ii) = sum(bits(1,:) ~= bhat_zf(1,:)) + sum(bits(2,:) ~= bhat_zf(2,:));

    %% MMSE equalization (causal)
    deltac = zeros(1, 2 * Lc - 1);
    deltac(Lc) = 1;
    Nmmse = 200;  % Causal length for MMSE
    [r, p, k] = residuez(fliplr(conj(hc)), (conv(hc, fliplr(conj(hc))) + (sig2b / sigs2) * deltac));
    w_mmseinf = ComputeRI(Nmmse, r, p, k);  % Compute MMSE filter
    s_mmse = conv(w_mmseinf, y);  % Apply MMSE filter
    bhat_mmse = zeros(2, length(bits));
    bhat_mmse(1, :) = real(s_mmse(Nzf:N + Nzf - 1)) < 0;
    bhat_mmse(2, :) = imag(s_mmse(Nzf:N + Nzf - 1)) < 0;
    nErr_mmseinf(ii) = sum(bits(1,:) ~= bhat_mmse(1,:)) + sum(bits(2,:) ~= bhat_mmse(2,:));
end

%% Calculate simulated BER for different equalizer types
simBer_zfinfdirectimp = nErr_zfinfdirectimp / N / log2(M);  % Simulated BER for direct ZF
simBer_zfinf = nErr_zfinf / N / log2(M);  % Simulated BER for non-causal ZF
simBer_mmseinf = nErr_mmseinf / N / log2(M);  % Simulated BER for MMSE
simBer_zf_rif = nErr_zf_rif / N / log2(M);  % Simulated BER for parallel ZF
simBer_mmse_rif = nErr_mmse_rif / N / log2(M);  % Simulated BER for parallel MMSE

%% Plotting the results
figure;
semilogy(Es_N0_dB, simBer_zfinf, 'bs-', 'LineWidth', 2);
hold on;
semilogy(Es_N0_dB, simBer_mmseinf, 'rs-', 'LineWidth', 2);
semilogy(Es_N0_dB, simBer_zf_rif, 'go-', 'LineWidth', 2);  % Parallel ZF curve
semilogy(Es_N0_dB, simBer_mmse_rif, 'yo-', 'LineWidth', 2);  % Parallel MMSE curve
axis([0 50 10^-6 0.5]);
grid on;
legend('sim-zf-inf/direct', 'sim-mmse-inf/direct', 'sim-zf-parallel', 'sim-mmse-parallel');
xlabel('E_s/N_0, dB');
ylabel('Bit Error Rate');
title('Bit error probability curve for QPSK in ISI with ZF equalizers');

% Impulse response of the non-causal ZF filter
figure;
stem(real(w_zfinf));
hold on;
stem(real(w_zfinf), 'r-');
ylabel('Amplitude');
xlabel('Time index');
title('Impulse response of the non-causal ZF filter');
