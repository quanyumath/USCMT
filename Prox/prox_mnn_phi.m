function X = prox_mnn_phi(Y, rho, phi)

% The proximal operator of the matrix nuclear norm of a matrix
% min_X rho*||X||_*+0.5*||X-Y||_F^2
%
% Y     -    n1*n2 matrix
% X     -    n1*n2 matrix

[U, S, V] = svd(Y, 'econ');
S = diag(S);
S = prox_phi(S, rho, phi);
X = U * diag(S) * V';



