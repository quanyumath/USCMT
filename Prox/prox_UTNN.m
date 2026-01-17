function X = prox_UTNN(Y, rho, mode, phi)

dim3 = size(Y, 1:3); V = size(Y, 4);
for v = 1:V
    Y_3v(:, :, v) = Unfold(Y(:, :, :, v), dim3, mode);
end
X_3v = prox_tnn_phi(Y_3v, rho, phi);
for v = 1:V
    X(:, :, :, v) = Fold(X_3v(:, :, v), dim3, mode);
end

