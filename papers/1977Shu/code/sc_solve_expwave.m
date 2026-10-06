%% ========================================================================
%  Expansion-wave solver (A -> 2+)
%% ========================================================================
function [x, v, alpha] = sc_solve_expwave()

    x_min = 0.001;   x_max = 1;
    t_min = log(x_min);  t_max = 0;

    Ns      = [30, 60, 120];
    u       = [];
    t_prev  = []; v_prev = []; w_prev = [];

    for k = 1:numel(Ns)
        N = Ns(k);
        [D, xi] = sc_cheb(N);
        t       = t_min + (t_max - t_min) * (xi + 1) / 2;
        x       = exp(t);
        Dt      = D * 2 / (t_max - t_min);

        if isempty(u)
            m0_guess = 0.975;
            alpha_ff = sqrt(m0_guess ./ (2 * x.^3));
            v_ff     = -sqrt(2 * m0_guess ./ x);
            alpha_st = 2 ./ x.^2;
            wb       = x / x_max;
            alpha0   = (1 - wb) .* alpha_ff + wb .* alpha_st;
            v0       = (1 - wb) .* v_ff;
            u        = [v0(:); log(alpha0(:))];
        else
            v_new = interp1(flipud(t_prev), flipud(v_prev), t, 'spline');
            w_new = interp1(flipud(t_prev), flipud(w_prev), t, 'spline');
            u     = [v_new(:); w_new(:)];
        end

        fprintf('  Chebyshev N = %3d ...\n', N);
        u = sc_newton_cs(@(u) sc_res_expwave(u, x, Dt), u, 1e-10, 80);

        t_prev = t;
        N1     = N + 1;
        v_prev = u(1:N1);
        w_prev = u(N1+1:2*N1);
    end

    N1    = Ns(end) + 1;
    v     = u(1:N1);
    w     = u(N1+1:2*N1);
    alpha = exp(w);

    x     = flipud(x);
    v     = flipud(v);
    alpha = flipud(alpha);
end




