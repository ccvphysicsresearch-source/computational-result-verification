%% ========================================================================
%  Collapse-case solver  (A > 2)
%% ========================================================================
function [x, v, alpha] = sc_solve_collapse(A, x_prev, v_prev, alpha_prev)

    x_min = 0.001;   x_max = 20;
    t_min = log(x_min);  t_max = log(x_max);

    Ns      = [30, 60, 120];
    u       = [];
    t_prev  = []; v_prev_in = []; w_prev_in = [];

    for k = 1:numel(Ns)
        N = Ns(k);
        [D, xi] = sc_cheb(N);
        t       = t_min + (t_max - t_min) * (xi + 1) / 2;
        x       = exp(t);
        Dt      = D * 2 / (t_max - t_min);

        if isempty(u)
            if isempty(x_prev)
                m0_guess  = max(0.975, 0.5 * A);
                wblend    = x.^2 ./ (1 + x.^2);
                alpha_ff  = sqrt(m0_guess ./ (2 * x.^3));
                v_ff      = -sqrt(2 * m0_guess ./ x);
                alpha_inf = A ./ x.^2;
                v_inf     = -(A - 2) ./ x;
                log_alpha0 = (1 - wblend) .* log(alpha_ff) ...
                           +      wblend  .* log(alpha_inf);
                v0         = (1 - wblend) .* v_ff ...
                           +      wblend  .* v_inf;
                u = [v0(:); log_alpha0(:)];
            else
                v0    = interp1(x_prev, v_prev,     x, 'spline');
                a0    = interp1(x_prev, alpha_prev, x, 'spline');
                a0    = max(a0, 1e-8);
                u     = [v0(:); log(a0(:))];
            end
        else
            v_new = interp1(flipud(t_prev), flipud(v_prev_in), t, 'spline');
            w_new = interp1(flipud(t_prev), flipud(w_prev_in), t, 'spline');
            u     = [v_new(:); w_new(:)];
        end

        fprintf('  Chebyshev N = %3d ...\n', N);
        u = sc_newton_cs(@(u) sc_res_collapse(u, x, Dt, A, x_max), ...
                         u, 1e-10, 80);

        t_prev    = t;
        N1        = N + 1;
        v_prev_in = u(1:N1);
        w_prev_in = u(N1+1:2*N1);
    end

    N1    = Ns(end) + 1;
    v     = u(1:N1);
    w     = u(N1+1:2*N1);
    alpha = exp(w);

    x     = flipud(x);
    v     = flipud(v);
    alpha = flipud(alpha);
end


