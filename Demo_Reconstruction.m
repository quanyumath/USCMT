currentFolder = pwd; addpath(genpath(currentFolder));
% clear; close all;
% clc

% read data and produce mask
load PEMS04
D0 = 0; Day = 15; D = D0 + Day;
Data = data(288*D0+1:288*D, :, :); % 提取 D 天的数据

Dim = size(Data, 2);
Z = []; V = 3;
for v = 1:V
    N = Data(:, :, v);
    TN = [];
    for j = 1:Dim
        KL = reshape(N(:, j), [288, Day]);
        TN(:, :, j) = KL;
    end
    Z(:, :, :, v) = TN;
end

Z = permute(Z, [3, 2, 1, 4]); % size(Z)
Z(:, :, :, 2) = Z(:, :, :, 2) * 100;

NN = size(Z);
sr = 0.4; % 损失率
Omega = ms_scenario(NN, 'random', sr);
M = NaN(size(Z)); M(Omega) = Z(Omega);
Mm = zeros(size(Z)); Mm(Omega) = Z(Omega);

%% USCMT
max_v = max(Z, [], [1, 2, 3]);
opts = [];
opts.maxiter = 100; opts.tol = 1e-2;
opts.rho = [5e-3, 5e3, 5e-3, 1e-2];
opts.beta = [2, 1.15, 2, 1.5];
opts.lambda = 1e-2; opts.gamma = 10;
opts.phi = 'Log'; opts.psi = 'Lp';
opts.Z_ex = Z ./ max_v;
opts.D1 = gammaMatrix(1, NN(1), NN(1)); opts.D1(1, :) = [];
opts.D2 = circvet2mat(num2vetT(7, NN(2)));
opts.D3 = gammaMatrix(1, NN(3), NN(3)); opts.D3(1, :) = [];
tic
[X_U, E_USCMT, Z_USCMT] = USCMT(Mm./max_v, Omega, opts);
Time_USCMT = toc;
X_USCMT = abs(X_U.*max_v); X_USCMT(Omega) = Z(Omega);
[MAPE_USCMT, RMSE_USCMT, ~, ~] = PJ(X_USCMT, Z, Omega);






