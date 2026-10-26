
%% ========================================================================
%  Shu's similarity ODEs with a cancellation-free RHS
%% ========================================================================

function dydx = shu_odes(x, y)
%   dv/dx     = [alpha(x-v) - 2/x] (x-v) / [(x-v)^2 - 1]
%   dalpha/dx = alpha [alpha - 2(x-v)/x] (x-v) / [(x-v)^2 - 1]
%
% Numerically dangerous differences are rewritten as sums of small
% quantities:
%
%   alpha(x-v) - 2/x   =  (alpha - 2)*x + 2*(x - 1)*(1 + 1/x) - alpha*v
%   alpha - 2(x-v)/x   =  (alpha - 2) + 2*v/x
%   (x-v)^2 - 1        =  (x-v-1)*(x-v+1)

    alpha = y(1);
    v     = y(2);
    w     = x - v;

    num_v = (alpha - 2)*x + 2*(x - 1)*(1 + 1/x) - alpha*v;
    num_a = (alpha - 2) + 2*v/x;
    denom = (w - 1) * (w + 1);

    % x = 1, v = 0 is a removable singularity; nudge off if we land on it
    if abs(denom) < 1e-14
        denom = sign(denom + 1e-30) * 1e-14;
        if denom == 0, denom = 1e-14; end
    end

    dv     = num_v * w / denom;
    dalpha = alpha * num_a * w / denom;

    dydx = [dalpha; dv];
end
