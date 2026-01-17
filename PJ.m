function [MAPE, RMSE, PV, EC] = PJ(X, X_true, Omega)

V = size(X_true, 4);
Pomega = zeros(size(X)); Pomega(Omega) = 1;


MAPE = []; RMSE = []; PV = []; EC = [];
for v = 1:V
    Xv = X(:, :, :, v); X_truev = X_true(:, :, :, v); pos = find(Pomega(:, :, :, v) == 0);
    mape = abs(X_truev(pos)-Xv(pos)) ./ abs(X_truev(pos));
    mape = mape(~isinf(mape)); mape = mape(~isnan(mape));
    MAPE = [MAPE, mean(mape)*100];
    RMSE = [RMSE, sqrt(mean((X_truev(pos) - Xv(pos)).^2))];
    PV = [PV, abs(1-var(Xv(:))/var(X_truev(:)))];
    EC = [EC, 1- sqrt(mean((X_truev(pos) - Xv(pos)).^2)) / (sqrt(mean(X_truev(pos)).^2)...
        + sqrt(mean(Xv(pos).^2)))];
end
