function E = prox_l2psi(X, lambda, psi)

[~, ~, ~, V] = size(X);
nm = sqrt(sum(X.^2, 4));
nms = prox_psi(nm, lambda, psi);
sw = repmat(nms./nm, [1, 1, 1, V]);
sw(isnan(sw)) = 0;
E = sw .* X;

end