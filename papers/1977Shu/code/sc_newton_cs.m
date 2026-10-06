%% ========================================================================
%  Complex-step Newton iteration with Tikhonov regularisation
%% ========================================================================
function u = sc_newton_cs(resfun, u0, tol, maxit)

    u  = u0(:);
    n  = numel(u);
    h  = 1e-30;

    R0  = resfun(u);
    R0n = norm(R0);  if R0n < 1e-30, R0n = 1; end

    for it = 1:maxit
        R  = resfun(u);
        nR = norm(R);

        if nR / R0n < tol
            fprintf('      converged (iter %d, ||R||/||R0|| = %.2e)\n', ...
                    it, nR / R0n);
            return;
        end

        J = zeros(n, n);
        for j = 1:n
            up     = u;  up(j) = up(j) + 1i * h;
            J(:,j) = imag(resfun(up)) / h;
        end

        rs = max(abs(J), [], 2);  rs(rs < 1e-30) = 1;
        Js = J ./ rs;
        Rs = R ./ rs;

        eps_reg = 1e-10;
        du = -[Js; sqrt(eps_reg) * eye(n)] \ [Rs; zeros(n, 1)];

        lam = 1;
        for k = 1:30
            if norm(resfun(u + lam * du)) < nR * (1 - 1e-4 * lam)
                break;
            end
            lam = lam / 2;
        end
        u = u + lam * du;

        if mod(it, 10) == 0
            fprintf('      iter %3d  ||R||/||R0|| = %.2e  lam = %.3f\n', ...
                    it, nR / R0n, lam);
        end
    end

    fprintf('      maxit reached, ||R||/||R0|| = %.2e\n', ...
            norm(resfun(u)) / R0n);
end


