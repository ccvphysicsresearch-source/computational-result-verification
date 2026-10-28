%% ========================================================================
%  Taylor series of the expansion-wave solution about the critical point
%
%  [vc, ac] = shu_tay_crit(K, rho)
%
%  The expansion wave leaves the static state at x = 1, where
%  v = 0, alpha = 2 and the ODEs are 0/0.  The series is in the scaled
%  variable sigma = (x - 1)/rho  (same convention as shu_tay_coeffs).
%
%  Local analysis at x = 1 (v = sum v_k s^k, alpha = sum a_k s^k, s = x-1):
%    order 1 :  v_1 (a_1 + 2) = 0  and  a_1 = -2 v_1^2 + 4 v_1 - 4
%               -> static branch (v_1,a_1) = (0,-4)  or  v_1 = 1, a_1 = -2
%               (a double root).  The expansion wave is v_1 = 1, a_1 = -2.
%    order 2 :  a_2 = 2 is forced, v_2 is NOT determined here.
%    order 3 :  solvability condition  v_2 (v_2 + 1/2) = 0.
%               v_2 = 0 or -1/2; the expansion wave (the A -> 2+ limit,
%               and Shu's Table 2) is v_2 = -1/2.
%    order k >= 4 : the 2x2 linear system for (a_k, v_{k-1}) is regular.
%  Hence  v = s - s^2/2 + ...,  alpha = 2 - 2 s + 2 s^2 - ...
%
%  The unknowns of each order are found by exploiting that the order-k
%  equations are linear in them (probe with unit vectors).
%% ========================================================================
function [vc, ac] = shu_tay_crit(K, rho)

    if K < 5, error('shu_tay_crit: K must be >= 5'); end
    Kt = K + 1;                          % v_K needs the order-(K+1) equation

    xc = zeros(Kt+1, 1);  xc(1) = 1;  xc(2) = rho;
    vc = zeros(Kt+1, 1);
    ac = zeros(Kt+1, 1);

    % values fixed by the local analysis above (scaled by rho^k)
    ac(1) = 2;
    vc(2) = rho;          ac(2) = -2 * rho;
    vc(3) = -0.5 * rho^2; ac(3) =  2 * rho^2;

    % ---- order 3: only a_3 is unknown (v_2 already fixed) ----
    ac(4) = 0;  e0 = order_eq(xc, vc, ac, 3, rho);  e0 = e0(1);
    ac(4) = 1;  e1 = order_eq(xc, vc, ac, 3, rho);  e1 = e1(1);
    ac(4) = -e0 / (e1 - e0);

    % ---- orders k >= 4: unknowns a_k and v_{k-1} ----
    for k = 4:Kt
        vc(k) = 0;  ac(k+1) = 0;
        E00 = order_eq(xc, vc, ac, k, rho);
        ac(k+1) = 1;
        Ea  = order_eq(xc, vc, ac, k, rho);
        ac(k+1) = 0;  vc(k) = 1;
        Ev  = order_eq(xc, vc, ac, k, rho);
        M   = [Ea - E00, Ev - E00];
        sol = -M \ E00;
        ac(k+1) = sol(1);
        vc(k)   = sol(2);
    end

    vc = vc(1:K+1);
    ac = ac(1:K+1);
end


%% ------------------------------------------------------------------------
%  Order-k coefficient of  (x D v' - rho P)  and  (x D alpha' - rho Q)
%  (needs coefficients up to index k of v and alpha)
%% ------------------------------------------------------------------------
function E = order_eq(xc, vc, ac, k, rho)

    n = k + 1;
    w = zeros(n,1);  D = w;  p = w;  q = w;  r = w;
    P = w;  g = w;  m = w;  Q = w;

    for i = 1:n
        rev = i:-1:1;
        w(i) = xc(i) - vc(i);
        D(i) = sum(w(1:i) .* w(rev));
        if i == 1, D(i) = D(i) - 1; end
        p(i) = sum(xc(1:i) .* D(rev));
        q(i) = sum(ac(1:i) .* w(rev));
        r(i) = sum(q(1:i)  .* xc(rev));
        if i == 1, r(i) = r(i) - 2; end
        P(i) = sum(r(1:i)  .* w(rev));
        g(i) = sum(ac(1:i) .* xc(rev)) - 2 * w(i);
        m(i) = sum(g(1:i)  .* w(rev));
        Q(i) = sum(ac(1:i) .* m(rev));
    end

    j  = (0:k-1)';                       % sum over v_{j+1}, p_{k-j}
    E1 = sum(p(k - j + 1) .* (j + 1) .* vc(j + 2)) - rho * P(n);
    E2 = sum(p(k - j + 1) .* (j + 1) .* ac(j + 2)) - rho * Q(n);
    E  = [E1; E2];
end
