function y = prox_phi(x, lambda, phi)

nv = 0.1; % Cap
p = 1/2; % LP
alpha = 1; % MCP
theta = 1e-1; % Log  1e-1

if strcmp(phi, 'L1')
    y = prox_Lp(x, lambda, 1);
elseif strcmp(phi, 'Lp')
    y = prox_Lp(x, lambda, p);
elseif strcmp(phi, 'MCP')
    y = prox_MCP(x, lambda, alpha);
elseif strcmp(phi, 'Log')
    y = prox_Log(x, lambda, theta);
elseif strcmp(phi, 'CapL1')
    y = prox_CapLp(x, lambda, 1, nv);
elseif strcmp(phi, 'CapLp')
    y = prox_CapLp(x, lambda, p, nv);
elseif strcmp(phi, 'CapMCP')
    y = prox_CapMCP(x, lambda, alpha, nv);
elseif strcmp(phi, 'CapLog')
    y = prox_CapLog(x, lambda, theta, nv);
end

end
