%% ========================================================================
%  Residual of the collapse problem
%% ========================================================================
function R = sc_res_collapse(u, x, Dt, A, x_max)
    N1    = length(x);
    v     = u(1:N1);
    w     = u(N1+1:2*N1);
    alpha = exp(w);
    dv    = Dt * v;
    dw    = Dt * w;
    xv    = x - v;
    coef  = xv.^2 - 1;

    R1 = coef .* dv - (alpha .* x .* xv - 2) .* xv;
    R2 = coef .* dw - (alpha .* x        - 2 .* xv) .* xv;

    alpha_inf = A / x_max^2 - A * (A - 2) / (2 * x_max^4);
    v_inf     = -(A - 2) / x_max - (1 - A / 6) * (A - 2) / x_max^3;
    R1(1)     = v(1) - v_inf;
    R2(1)     = w(1) - log(alpha_inf);

    R = [R1(:); R2(:)];
end


