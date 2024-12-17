close all;
clear all;
%%%%%%%%%%%%%%%%%%%
% Calcul de la BER MMSE raté
% Ajouter moyen de montrer tt les users


%% Simulation parameters
N_users = 2;
M = 64; %Modulation order
Nframe = 1000;
Nfft=1024;
Ncp=8;
Ns=Nframe*(Nfft+Ncp);
N= log2(M)*Nframe*Nfft; % Bit number
%Channel Parameters
Eb_N0_dB = [0:30]; % Eb/N0 values

% Créez des canaux distincts pour chaque utilisateur
hc_users = [{1 -0.9} ; {-1 0.9}];
Lc = length(hc_users{1}); % Longueur du canal la plus longue

% Pré-allouez les matrices d'erreur
nErr_zffde = zeros(1, N_users*length(Eb_N0_dB));
nErr_mmsefde = zeros(1, N_users*length(Eb_N0_dB));

% Boucle pour chaque utilisateur
for user = 1:N_users
    for ii = 1:length(Eb_N0_dB)
        % Génération du message
        bits = randi([0 1], N, 1);
        
        % Modulation
        s = qammod(bits, M, 'InputType', 'bit');
        sigs2 = var(s);
        
        % Ajout du CP
        smat = reshape(s, Nfft, []);
        smatcp = [smat(end-Ncp+1:end, :) ; smat];
        scp = reshape(smatcp, 1, (Nfft + Ncp) * Nframe);
        
        % Canal convolution : représentation symbolique équivalente
        z = filter(hc_users{user}, 1, scp);
        
        % Génération du bruit
        sig2b = 10^(-Eb_N0_dB(ii)/10);
        n = sqrt(sig2b/2) * randn(1, Ns) + 1j * sqrt(sig2b/2) * randn(1, Ns);
        
        % Ajout du bruit
        ycp = z + n;
        
        % Suppression du CP
        ymat = reshape(ycp, Nfft + Ncp, Nframe);
        ymat_ncp = ymat(Ncp + 1:end, :);
        Y = fft(ymat_ncp, Nfft, 1);
        
        % FDE
        H_fde = fft(hc_users{user}, Nfft);
        w_zf = 1 ./ H_fde;
        w_mmse = conj(H_fde) ./ (abs(H_fde).^2 + sigs2);
        
        Yzf = diag(w_zf) * Y;
        Ymmse = diag(w_mmse) * Y;
        yzf = ifft(Yzf, Nfft, 1);
        ymmse = ifft(Ymmse, Nfft, 1);
        
        % Détection
        bhat_zfeq = qamdemod(yzf(:), M, 'OutputType', 'bit');
        bhat_mmsefde = qamdemod(ymmse(:), M, 'OutputType', 'bit');
        
        nErr_zffde(1, ii + (user-1)*length(Eb_N0_dB)) = size(find([bits(:) - bhat_zfeq(:)]), 1);
        nErr_mmsefde(1, ii + (user-1)*length(Eb_N0_dB)) = size(find([bits(:) - bhat_mmsefde(:)]), 1);
    end
end

% Calcul de la BER simulée pour chaque utilisateur et type d'égalisation
simBer_zf = nErr_zffde / (N_users * Nframe * M);
simBer_mmse = nErr_mmsefde / (N_users * Nframe * M);  % A un TEB largement sup à 1, il faut vérifier le calcul

% Tracing
figure;
semilogy(Eb_N0_dB, simBer_zf(:, 1:end/2), 'bs-', 'Linewidth', 2);
hold on;
semilogy(Eb_N0_dB, simBer_mmse(:, 1:end/2), 'rd-', 'Linewidth', 2);
axis([0 40 10^-6 0.5]);
grid on;
legend('sim-zf-fde', 'sim-mmse-fde');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
title(['Bit error probability curve for 4-QAM SC-FDMA with ' num2str(N_users) ' users']);