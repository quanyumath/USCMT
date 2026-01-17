function x = prox_half(y, lambda)
% PROX_HALF  Proximal mapping for f(x)=|x|^{1/2}
%   x = prox_half(y, lambda)
%
% Solve: x = argmin_u 1/(2*lambda)*(u-y).^2 + |u|^(1/2)

    s = sign(y);
    Y = abs(y);
    x = zeros(size(y));

    % threshold below which prox=0
    thr = (3*lambda/4)^(2/3);
    mask = (Y > thr);
    
    % only compute on mask
    Ym = Y(mask);
    % compute t = sqrt(u)
    % define phi = arccos( (lambda/4)*(3/Y)^(3/2) )
    phi = acos( (lambda/4) .* (3 ./ Ym).^(3/2) );
    t = 2 * sqrt(Ym/3) .* cos(phi/3);
    x(mask) = s(mask) .* (t.^2);
end
