% SHU1977_RK45_FINAL
% Reproduce Shu (1977) ApJ 214, 488 with adaptive RK45 (ode45, fallback ode15s).
% Output format matches shu1977_results_spectral.txt.
%
% Reference: Shu, F. H. 1977, ApJ, 214, 488
% -------------------------------------------------------------------------

    results_file = 'shu1977_results_rk45.txt';
    fid = fopen(results_file, 'w');

    fprintf(fid, '===============================================================\n');
    fprintf(fid, 'Reproduction of Shu (1977) ApJ 214, 488\n');
    fprintf(fid, 'Adaptive RK45 (ode45, fallback ode15s), cancellation-free RHS\n');
    fprintf(fid, '===============================================================\n\n');

    %% ---------------- Settings ----------------
    x_start = 10;
    x_end   = 1e-3;
    opts    = odeset('RelTol', 1e-11, 'AbsTol', 1e-13, ...
                     'MaxStep', 0.005, 'Stats', 'off');

    %% ---------------- TABLE 1 : m0(A) ----------------
    fprintf(fid, 'TABLE 1: Relation between A and m0\n');
    fprintf(fid, '--------------------------------------------------------\n');
    fprintf(fid, '%6s %16s %16s %14s\n', ...
            'A', 'm0 (RK45)', 'm0 (paper)', 'rel.error');

    A_list   = [2.2 2.4 2.6 2.8 3.0 3.2 3.4 3.6 3.8 4.0];
    paper_m0 = [1.45 1.88 2.31 2.74 3.18 3.63 4.10 4.58 5.08 5.58];
    m0_rk45  = zeros(size(A_list));

    for k = 1:numel(A_list)
        A = A_list(k);
        fprintf('=== Collapse case A = %.2f ===\n', A);

        [m0, ~, ~, ~, ok] = rk45_integrate(A, x_start, x_end, opts);
        if ~ok
            error('Table 1: A=%.2f did not reach x_end.', A);
        end

        m0_rk45(k) = m0;
        relerr     = abs(m0 - paper_m0(k)) / paper_m0(k);
        fprintf(fid, '%6.2f %16.5f %16.5f %14.3e\n', ...
                A, m0, paper_m0(k), relerr);
    end
    fprintf(fid, '\n');

    %% ---------------- TABLE 2 : expansion-wave solution ----------------
    fprintf(fid, 'TABLE 2: Expansion-wave collapse solution (A -> 2+)\n');
    fprintf(fid, '---------------------------------------------------------------\n');

    fprintf('=== Expansion-wave case ===\n');
    A_eps  = [2.001 2.002 2.003];
    x_fine = logspace(log10(x_end), log10(1), 3000);
    x_fine = unique([x_fine, 1]);

    alpha_e = zeros(3, numel(x_fine));
    v_e     = zeros(3, numel(x_fine));
    for j = 1:3
        [~, xs, alphas, vs, ok] = rk45_integrate(A_eps(j), x_start, x_end, opts);
        if ~ok
            error('Table 2: A=%.3f did not reach x_end.', A_eps(j));
        end
        alpha_e(j,:) = interp1(xs, alphas, x_fine, 'pchip');
        v_e(j,:)     = interp1(xs, vs,     x_fine, 'pchip');
    end
    alpha_ew_fine = 3*alpha_e(1,:) - 3*alpha_e(2,:) + alpha_e(3,:);
    v_ew_fine     = 3*v_e(1,:)     - 3*v_e(2,:)     + v_e(3,:);

    % Enforce analytic hydrostatic values for x >= 1
    idx = x_fine >= 1;
    alpha_ew_fine(idx) = 2 ./ x_fine(idx).^2;
    v_ew_fine(idx)     = 0;

    x_tab     = [0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 ...
                 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00];
    alpha_pap = [71.5 27.8 16.4 11.5 8.76 7.09 5.95 5.14 4.52 4.04 ...
                 3.66 3.35 3.08 2.86 2.67 2.50 2.35 2.22 2.10 2.00];
    v_pap     = [5.44 3.47 2.58 2.05 1.68 1.40 1.18 1.01 0.861 0.735 ...
                 0.625 0.528 0.442 0.363 0.291 0.225 0.163 0.106 0.051 0.0];
    m_pap     = [0.981 0.993 1.01 1.03 1.05 1.08 1.12 1.16 1.20 1.25 ...
                 1.30 1.36 1.42 1.49 1.56 1.64 1.72 1.81 1.90 2.00];

    alpha_ew = interp1(x_fine, alpha_ew_fine, x_tab, 'pchip');
    v_ew     = interp1(x_fine, v_ew_fine,     x_tab, 'pchip');

    fprintf(fid, '%6s %10s %10s %10s %10s %10s %10s\n', ...
            'x', 'alpha_s', 'alpha_p', '-v_s', '-v_p', 'm_s', 'm_p');
    for k = 1:numel(x_tab)
        xt = x_tab(k);
        ak = alpha_ew(k);
        vk = v_ew(k);
        mk = xt^2 * ak * (xt - vk);
        fprintf(fid, '%6.2f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f\n', ...
                xt, ak, alpha_pap(k), -vk, v_pap(k), mk, m_pap(k));
    end

    % Reduced mass on the fine grid
    m_ew      = x_fine.^2 .* alpha_ew_fine .* (x_fine - v_ew_fine);
    m_at_xmin = interp1(x_fine, m_ew, x_end, 'pchip');
    m_at_1    = interp1(x_fine, m_ew, 1,     'pchip');

    fprintf(fid, '\nPaper m0 (reduced core mass) = 0.975\n');
    fprintf(fid, 'RK45 m at x=x_min          : %.5f\n', m_at_xmin);
    fprintf(fid, 'RK45 m at x=1              : %.5f\n', m_at_1);

    fclose(fid);
    fprintf('\nDone. Results in %s\n', results_file);
