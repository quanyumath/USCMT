function X = prox_UTNN_singel(Y, rho, mode, theta)

dim = size(Y); dim3 = dim(1:3);
for v = 1:dim(4)
    Y_3v = Unfold(Y(:, :, :, v), dim3, mode);
    X_3v(:, :, v) = prox_mnn_phi(Y_3v, rho, theta);
end
for v = 1:dim(4)
    X(:, :, :, v) = Fold(X_3v(:, :, v), dim3, mode);
end

