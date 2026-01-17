%% Load Data
currentFolder = pwd; addpath(genpath(currentFolder));
clear; close all;
clc

load FT-AED
lane = 4;
Z = Tensor_lane{lane}(:,:,:,:);
V = size(Z, 4); Day = size(Z, 2);
NN = size(Z);
%Omega = ms_scenario(NN, 'random', eps);
Omega = 1:length(Z(:));
M = NaN(size(Z)); M(Omega) = Z(Omega);
Mm = zeros(size(Z)); Mm(Omega) = Z(Omega);
% 导出异常张量
Labels_2D = generate_anomaly_labels(...
    Unfold(permute(Anomaly_crash{lane}, [1, 3, 2]), NN(1:3), 1),...
    Unfold(permute(Anomaly_human{lane}, [1, 3, 2]), NN(1:3), 1));
Labels_3D = permute(Fold(Labels_2D, NN(1:3), 1), [1, 3, 2]);


%% USCMT
max_v = max(Z, [], [1 2 3]);
opts = [];
opts.maxiter = 100; opts.tol = 1e-2;
opts.rho = [1e-2, 5e3, 1e-2, 1e-2];
opts.beta = [1.5 1.2 1.5 1.01];
opts.lambda = 1e-3; opts.gamma = 1e-2; opts.Z_ex = Z./max_v;
opts.phi = 'Log'; opts.psi = 'Lp';
opts.D1 = gammaMatrix(1, NN(1), NN(1)); opts.D1(1,:) = [];
opts.D2 = circvet2mat(num2vetT(5, NN(2))); 
opts.D3 = gammaMatrix(1, NN(3), NN(3)); opts.D3(1,:) = [];         
tic
[X_USCMT, E_US, Z_USCMT] = USCMT(Mm./max_v, Omega, opts);
Time_USCMT = toc;
E_USCMT = abs(E_US .* max_v);

AUCsMulti({sum(E_USCMT, 4)}, Labels_2D, {'USCMT'})



































