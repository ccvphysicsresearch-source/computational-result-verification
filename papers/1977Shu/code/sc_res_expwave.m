%% ========================================================================
%  Residual of the expansion-wave problem
%% ========================================================================
function R = sc_res_expwave(u, x, Dt)
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

    R1(1) = v(1);
    R2(1) = w(1) - log(2);

    R = [R1(:); R2(:)];
end
