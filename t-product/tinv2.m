function invXY = tinv2(X, Y, form)

% X and Y are two third tensors
% invXY = tinv2(X, Y, 'left')  % Solves the equation X * invXY = Y
% invXY = tinv2(X, Y, 'right') % Solves the equation invXY * X = Y
%
% version 1.0 - 07/19/2025
%
% Written by Quan Yu (quanyu@tju.edu.cn)
%
%
% References:
%  Unified Spatio-Temporal and Coupled
%  Multi-Source Tensor Framework for Simultaneous
%  Traffic Data Reconstruction and Event Detection
%


n3 = size(X, 3);
X = fft(X, [], 3); Y = fft(Y, [], 3);

% first frontal slice
switch lower(form)
    case 'left'
        invXY(:, :, 1) = X(:, :, 1) \ Y(:, :, 1);
    case 'right'
        invXY(:, :, 1) = Y(:, :, 1) / X(:, :, 1);
end


% i=2,...,halfn3
halfn3 = round(n3/2);
for i = 2:halfn3
    switch lower(form)
        case 'left'
            invXY(:, :, i) = X(:, :, i) \ Y(:, :, i);
        case 'right'
            invXY(:, :, i) = Y(:, :, i) / X(:, :, i);
    end
    invXY(:, :, n3+2-i) = conj(invXY(:, :, i));
end
% if n3 is even
if mod(n3, 2) == 0
    i = halfn3 + 1;
    switch lower(form)
        case 'left'
            invXY(:, :, i) = X(:, :, i) \ Y(:, :, i);
        case 'right'
            invXY(:, :, i) = Y(:, :, i) / X(:, :, i);
    end
end
invXY = ifft(invXY, [], 3);
