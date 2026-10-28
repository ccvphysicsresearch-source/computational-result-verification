%% ========================================================================
%  Taylor coefficients of Shu's similarity ODEs about a regular point
%
%  [vc, ac] = shu_tay_coeffs(x0, v0, a0, rho, K)
%
%  ODEs (w = x - v, D = w^2 - 1):
%      x D dv/dx     = (alpha w x - 2) w
%      x D dalpha/dx = alpha (alpha x - 2 w) w
%  (identical to Shu's Eqs. (11)-(12); multiplying by x removes the 1/x).
%
%  The series is in the scaled variable  sigma = (x - x0)/rho,
%      v(x) = sum_k vc(k+1) sigma^k ,   alpha(x) = sum_k ac(k+1) sigma^k ,
%  so with rho ~ radius of convergence the coefficients stay O(1) (this
%  avoids overflow for x0 -> 0 and loss of precision at high order).
%
%  Because every right-hand side is a polynomial in (x, v, alpha), the
%  coefficients follow from exact Cauchy products - no differentiation, no
%  finite differences.  Order k of the ODE gives
%      (k+1) p_0 v_{k+1} = rho P_k - sum_{j=0}^{k-1} p_{k-j} (j+1) v_{j+1}
%  with p = x*D, P = (alpha w x - 2) w   (and likewise for alpha with Q).
%% ========================================================================
function [vc, ac] = shu_tay_coeffs(x0, v0, a0, rho, K)

    xc = zeros(K+1, 1);  xc(1) = x0;  xc(2) = rho;
    vc = zeros(K+1, 1);  vc(1) = v0;
    ac = zeros(K+1, 1);  ac(1) = a0;

    w = zeros(K+1, 1);  D = w;  p = w;  q = w;  r = w;
    P = w;  g = w;  m = w;  Q = w;

    for k = 0:K-1                      % k = order of the equation
        i = k + 1;                     % MATLAB index of order k
        rev = i:-1:1;                  % reversed index for Cauchy products

        w(i) = xc(i) - vc(i);
        D(i) = sum(w(1:i) .* w(rev));
        if k == 0, D(i) = D(i) - 1; end
        p(i) = sum(xc(1:i) .* D(rev));

        q(i) = sum(ac(1:i) .* w(rev));
        r(i) = sum(q(1:i)  .* xc(rev));
        if k == 0, r(i) = r(i) - 2; end
        P(i) = sum(r(1:i)  .* w(rev));

        g(i) = sum(ac(1:i) .* xc(rev)) - 2 * w(i);
        m(i) = sum(g(1:i)  .* w(rev));
        Q(i) = sum(ac(1:i) .* m(rev));

        % sum_{j=0}^{k-1} p_{k-j} (j+1) c_{j+1}
        j  = (0:k-1)';
        sv = sum(p(k - j + 1) .* (j + 1) .* vc(j + 2));
        sa = sum(p(k - j + 1) .* (j + 1) .* ac(j + 2));

        vc(k+2) = (rho * P(i) - sv) / ((k + 1) * p(1));
        ac(k+2) = (rho * Q(i) - sa) / ((k + 1) * p(1));
    end
end
