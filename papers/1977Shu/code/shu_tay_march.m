%% ========================================================================
%  Variable-step Taylor-series integration towards smaller x
%
%  [v_out, a_out, nsteps] = shu_tay_march(x, v, a, x_out, K, tol)
%
%  Integrates from (x, v, alpha = a) down to the points x_out (strictly
%  decreasing, all < x), landing exactly on every x_out.
%
%  Each step re-expands the solution about the current x with order K
%  (shu_tay_coeffs, scaled variable sigma = (x - x0)/x0) and takes the
%  largest step for which the two highest retained terms stay below
%      tol * (1 + |y|)
%  (standard a-posteriori truncation-error control for Taylor methods;
%  step size ~ radius of convergence * (tol/|c_K|)^(1/K) ).
%% ========================================================================
function [v_out, a_out, nsteps] = shu_tay_march(x, v, a, x_out, K, tol)

    if nargin < 5 || isempty(K),   K   = 30;    end
    if nargin < 6 || isempty(tol), tol = 1e-14; end

    n_out  = numel(x_out);
    v_out  = zeros(n_out, 1);
    a_out  = zeros(n_out, 1);
    nsteps = 0;
    io     = 1;
    sig_max = 0.9;                      % never step more than 0.9*x (x > 0)

    while io <= n_out
        rho = x;
        [vc, ac] = shu_tay_coeffs(x, v, a, rho, K);

        sig = sig_max;
        for kk = [K-1, K]
            cv = abs(vc(kk+1));
            ca = abs(ac(kk+1));
            if cv > 0, sig = min(sig, (tol * (1 + abs(v)) / cv)^(1/kk)); end
            if ca > 0, sig = min(sig, (tol * (1 + abs(a)) / ca)^(1/kk)); end
        end
        h = rho * sig;

        reach = false;
        if h >= x - x_out(io)
            h     = x - x_out(io);
            reach = true;
        end

        s = -h / rho;
        v = polyval(flipud(vc), s);
        a = polyval(flipud(ac), s);
        if reach
            x = x_out(io);
        else
            x = x - h;
        end
        nsteps = nsteps + 1;

        if reach
            v_out(io) = v;
            a_out(io) = a;
            io = io + 1;
        end
    end
end
