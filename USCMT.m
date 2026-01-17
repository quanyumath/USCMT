function [X, E, Z] = USCMT(Mo, Omega, opts)

% input:
% Mo: 部分观察数据，未观察到的数据用 0 替代 [4 阶张量]
% Omega: 观察到的数据的位置的集合
% opts: 实验中的一些参数

%% Parameters and defaults
if isfield(opts,'maxiter')  maxiter = opts.maxiter;  else maxiter = 100;         end
if isfield(opts,'tol')      tol = opts.tol;          else tol = 1e-3;            end
if isfield(opts,'gamma')    gamma = opts.gamma;      else gamma = 1;             end
if isfield(opts,'rho')      rho = opts.rho;          else rho = [1 1 1 1];       end
if isfield(opts,'beta')     beta = opts.beta;        else beta = [1.1 1.1 1.1 1.1];  end
if isfield(opts,'lambda')   lambda = opts.lambda;    else lambda = 1;            end
if isfield(opts,'psi')      psi = opts.psi;          else psi = 'Lp';            end
if isfield(opts,'phi')      phi = opts.phi;          else phi = 'Log';           end
if isfield(opts,'fusion')   fusion = opts.fusion;    else fusion = 1;            end


[T, D, N, V] = size(Mo); Z_ex = opts.Z_ex;
%X = zeros(size(Mo)); X(Omega) = Mo(Omega);
X = Mo;
Y = X; Z = zeros(D, D, N, V); G = Z;
E = zeros(T, D, N, V); P = E; R = P; J = R; K = Y;
Q = zeros(D, D, N, V); I = teye(D, N);
err0 = 1/eps; 
%% FFT setting
D1 = opts.D1; D2 = opts.D2; D3 = opts.D3;
DD{1} = D1; DD{2} = D2; DD{3} = D3;
for u = 1:3
    [VF{u}, DF{u}] = eig(DD{u}'*DD{u});
end
TF = zeros(T, D, N);
for u = 1:3
    TF = TF + lambda * tmult(ones(T, D, N), DF{u}, u);
end


fprintf('Iteration:     ');
for t = 1:maxiter
    fprintf('\b\b\b\b\b%5i', t);

    %% update X
    for v = 1:V
        YZ(:, :, :, v) = tprod(Y(:, :, :, v), Z(:, :, :, v));
    end
    X = (rho(1) * (YZ + E) - P + rho(3) * Y + R + rho(4) * K + J) / (rho(1) + rho(3) + rho(4));
    X(Omega) = Mo(Omega);
    
    
    %% update Y
    XEP = rho(1) * (X - E) + P; XR = rho(3) * X - R;
    for v = 1:V
        Z3 = Z(:, :, :, v); Z3T = tran(Z3);
        Y(:, :, :, v) = tinv2(rho(1)*tprod(Z3, Z3T)+rho(3)*I,...
            tprod(XEP(:, :, :, v), Z3T)+XR(:, :, :, v), 'right');
    end


    %% update E
    for v = 1:V
        YZ(:, :, :, v) = tprod(Y(:, :, :, v), Z(:, :, :, v));
    end
    if fusion == 1
        E = prox_l2psi(X-YZ+P/rho(1), gamma/rho(1), psi);
    else
        E = prox_psi(X-YZ+P/rho(1), gamma/rho(1), psi);
    end


    %% update Z
    XEP = rho(1) * (X - E) + P; GQ = rho(2) * G + Q;
    for v = 1:V
        Y3 = Y(:, :, :, v); Y3T = tran(Y3);
        Z(:, :, :, v) = tinv2(rho(1)*tprod(Y3T, Y3)+rho(2)*I,...
            tprod(Y3T, XEP(:, :, :, v))+GQ(:, :, :, v), 'left');
        
    end
    

    %% update G
    if fusion == 1
        G = prox_UTNN(Z-Q/rho(2), 1e2/rho(2), 3, phi);
    else
        G = prox_UTNN_singel(Z-Q/rho(2), 1e2/rho(2), 3, phi);
    end
    
    %% update K
    for v = 1:V
        Kv = rho(4) * X(:,:,:,v) - J(:,:,:,v);
        for u = 1:3
            Kv = tmult(Kv, VF{u}', u);
        end
        Kv = Kv ./ (rho(4) + TF);
        for u = 1:3
            Kv = tmult(Kv, VF{u}, u);
        end
        K(:,:,:,v) = Kv;
    end


    %% update Lagrangian multipliers & penalty parameter
    for v = 1:V
        YZ(:, :, :, v) = tprod(Y(:, :, :, v), Z(:, :, :, v));
    end
    P = P + rho(1) * (X - YZ - E);
    Q = Q + rho(2) * (G - Z);
    R = R + rho(3) * (Y - X);
    J = J + rho(4) * (K - X);


    for i = 1:4
        rho(i) = beta(i)*rho(i);
    end



    err1 = norm(X(:)-YZ(:)-E(:)) / (norm(X(:)) + norm(YZ(:)) + norm(E(:)));
    err2 = norm(G(:)-Z(:)) / (norm(G(:)) + norm(Z(:)));
    err3 = norm(Y(:)-X(:)) / (norm(Y(:)) + norm(X(:)));
    err4 = norm(K(:)-X(:)) / (norm(K(:)) + norm(X(:)));
    err = max([err1, err2, err3]);
    if (err < tol || abs(err-err0) < 1e-5) && t >= 15
        break;
    end
    
    err0 = err;

%     [PJ(X, Z_ex, Omega), AUCsM({sum(abs(E), 4)}, opts.Labels_2D, {'USCMT'}), ...
%  max([err1, err2, err3]), 1]
%       [PJ(X, Z_ex, Omega), max([err1, err2, err3]), 1]


end


end