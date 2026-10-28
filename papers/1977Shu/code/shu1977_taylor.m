% SHU1977_TAYLOR
% Reproduction of Shu (1977), ApJ 214, 488 with a high-order Taylor-series
% method (no Runge-Kutta, no collocation):
%
%   * collapse solutions (A > 2): variable-step Taylor integration inward
%     from Shu's asymptotic series, Eq. (19)
%   * expansion wave (A -> 2+): Taylor series about the critical point
%     x = 1 (v = 0, alpha = 2) with v' = 1, alpha' = -2, v'' = -1, alpha'' = 4
%     (see shu_tay_crit.m for the local analysis), then Taylor marching
%
% Needs: shu_tay_coeffs.m, shu_tay_crit.m, shu_tay_march.m, sc_write_profile.m
% -------------------------------------------------------------------------

    script_dir  = fileparts(mfilename('fullpath'));
    results_dir = fullfile(script_dir, '..', 'results');
    if ~exist(results_dir, 'dir'), mkdir(results_dir); end
    results_file = fullfile(results_dir, 'shu1977_results_taylor.txt');

    fid = fopen(results_file, 'w');
    if fid == -1, error('Could not open results file: %s', results_file); end

    K       = 30;          % Taylor order
    tol     = 1e-14;       % truncation tolerance per step
    x_start = 110;          % start of the collapse integration
    x_core  = 1e-3;        % x at which m is reported for comparison with the
                           % spectral code
    x_midzero=1e-4;
    x_zero  = 1e-6;        % m(x_zero) = m0 + (2/3) sqrt(m0/2) x_zero^1.5
                           % -> m0 to ~1e-9

    fprintf(fid, '===============================================================\n');
    fprintf(fid, 'Reproduction of Shu (1977) ApJ 214, 488\n');
    fprintf(fid, 'Taylor-series method, order K = %d, tol = %.0e\n', K, tol);
    fprintf(fid, '===============================================================\n\n');

%% ---------------- TABLE 1 : m0(A) ----------------
    A_list   = [2.2 2.4 2.6 2.8 3.0 3.2 3.4 3.6 3.8 4.0];
    paper_m0 = [1.45 1.88 2.31 2.74 3.18 3.63 4.10 4.58 5.08 5.58];
    x_out    = [logspace(1, -3, 201)'; x_midzero; x_zero];      % decreasing, < x_start
    m_core   = zeros(size(A_list));
    m_midcore   = zeros(size(A_list));
    m0_tay   = zeros(size(A_list));
    nsteps   = zeros(size(A_list));
    x_store = cell(size(A_list));  v_store = cell(size(A_list));
    a_store = cell(size(A_list));
%% ---------------- TABLE 1a : m0(A) ----------------
    fprintf(fid, 'TABLE 1a: Relation between A and m0 (x_start = 110, x_zero  = 1e-6)\n');
    fprintf(fid, '------------------------------------------------------------------------------------\n');
    fprintf(fid, '%6s %14s %14s %14s %12s %12s %8s\n', 'A', 'm0 (1e-6)', 'm (1e-4)', ...
            'm(1e-3)', 'm0 (paper)', 'abs.error', 'steps*');

    for k = 1:numel(A_list)
        A  = A_list(k);
        v0 = -(A-2)/x_start - (1 - A/6)*(A-2)/x_start^3;     % Eq. (19)
        a0 =  A/x_start^2   - A*(A-2)/(2*x_start^4);
        fprintf('=== Collapse case A = %.2f ===\n', A);

        [vo, ao, ns] = shu_tay_march(x_start, v0, a0, x_out, K, tol);
        m_all = x_out.^2 .* ao .* (x_out - vo);

        m0_tay(k)  = m_all(end);                  % x = x_zero
        m0mid_tay(k)  = m_all(end-1);
        m_core(k)  = m_all(end-2);                % x = 1e-3
        % step count of the integration itself (the run above also stops at
        % all 202 output points, which is why it needs ~220 steps)
        [~, ~, nsteps(k)] = shu_tay_march(x_start, v0, a0, [x_core;x_midzero; x_zero], K, tol);
        fprintf(fid, '%6.2f %14.7f %14.7f %14.7f %12.2f %12.3e %8d\n', A, m0_tay(k), m0mid_tay(k), ...
                m_core(k), paper_m0(k), abs(m0_tay(k) - paper_m0(k)), nsteps(k));
    end
    fprintf(fid, '   * Taylor steps from x = 110 to x = 1e-6 without intermediate output stops\n\n');

    err1 = abs(m0_tay - paper_m0);
    out1 = find(err1 > 0.005 + 1e-9);
    fprintf(fid, '   Shu prints m0 to 0.01 -> rounding bound 0.005\n');
    fprintf(fid, '   max |m0 - paper|            : %.3e\n', max(err1));
    fprintf(fid, '   rows outside rounding bound : %d of %d', numel(out1), numel(A_list));
    if ~isempty(out1)
        fprintf(fid, '   (A = %s)', strtrim(sprintf('%.1f ', A_list(out1))));
    end
    fprintf(fid, '\n   signed mean (Taylor - paper) : %+.3e  (%d of %d rows positive)\n\n', ...
            mean(m0_tay - paper_m0), sum(m0_tay > paper_m0), numel(A_list));

%% ---------------- TABLE 1b : m0(A) ----------------

    fprintf(fid, 'TABLE 1b: Relation between A and m0(x_start = 60, x_zero  = 1e-6)\n');
    fprintf(fid, '------------------------------------------------------------------------------------\n');
    fprintf(fid, '%6s %14s %14s %14s %12s %12s %8s\n', 'A', 'm0 (1e-6)', 'm (1e-4)', ...
            'm(1e-3)', 'm0 (paper)', 'abs.error', 'steps*');


    x_start_b = 60;
    x_out_b = [logspace(log10(10), -3, 201)'; x_midzero; x_zero];

    for k = 1:numel(A_list)
        A = A_list(k);

        v0 = -(A-2)/x_start_b ...
             - (1 - A/6)*(A-2)/x_start_b^3;
        a0 = A/x_start_b^2 ...
             - A*(A-2)/(2*x_start_b^4);

        [vo, ao, ~] = shu_tay_march( ...
            x_start_b, v0, a0, x_out_b, K, tol);

        m_all = x_out_b.^2 .* ao .* (x_out_b - vo);

        m0_tay(k)    = m_all(end);
        m0mid_tay(k) = m_all(end-1);
        m_core(k)    = m_all(end-2);

        % Count steps from the same initial radius and state.
        [~, ~, nsteps(k)] = shu_tay_march( ...
            x_start_b, v0, a0, [x_core; x_midzero; x_zero], K, tol);

        fprintf(fid, ...
            '%6.2f %14.7f %14.7f %14.7f %12.2f %12.3e %8d\n', ...
            A, m0_tay(k), m0mid_tay(k), m_core(k), ...
            paper_m0(k), abs(m0_tay(k)-paper_m0(k)), nsteps(k));
    end

    fprintf(fid, ['   * Taylor steps from x = 60 to x = 1e-6 ' ...
                  'without intermediate output stops\n\n']);

    err1 = abs(m0_tay - paper_m0);
    out1 = find(err1 > 0.005 + 1e-9);
    fprintf(fid, '   Shu prints m0 to 0.01 -> rounding bound 0.005\n');
    fprintf(fid, '   max |m0 - paper|            : %.3e\n', max(err1));
    fprintf(fid, '   rows outside rounding bound : %d of %d', numel(out1), numel(A_list));
    if ~isempty(out1)
        fprintf(fid, '   (A = %s)', strtrim(sprintf('%.1f ', A_list(out1))));
    end
    fprintf(fid, '\n   signed mean (Taylor - paper) : %+.3e  (%d of %d rows positive)\n\n', ...
            mean(m0_tay - paper_m0), sum(m0_tay > paper_m0), numel(A_list));

%% ---------------- TABLE 1c : m0(A) ----------------

    fprintf(fid, 'TABLE 1c: Relation between A and m0(x_start = 10, x_zero  = 1e-6)\n');
    fprintf(fid, '------------------------------------------------------------------------------------\n');
    fprintf(fid, '%6s %14s %14s %14s %12s %12s %8s\n', 'A', 'm0 (1e-6)', 'm (1e-4)', ...
            'm(1e-3)', 'm0 (paper)', 'abs.error', 'steps*');


    x_start_c = 10;
    x_out_c = [logspace(log10(9.9), -3, 201)'; x_midzero; x_zero];

    for k = 1:numel(A_list)
        A = A_list(k);

        v0 = -(A-2)/x_start_c ...
             - (1 - A/6)*(A-2)/x_start_c^3;
        a0 = A/x_start_c^2 ...
             - A*(A-2)/(2*x_start_c^4);

        [vo, ao, ~] = shu_tay_march( ...
            x_start_c, v0, a0, x_out_c, K, tol);

        m_all = x_out_c.^2 .* ao .* (x_out_c - vo);

        m0_tay(k)    = m_all(end);
        m0mid_tay(k) = m_all(end-1);
        m_core(k)    = m_all(end-2);

        [~, ~, nsteps(k)] = shu_tay_march( ...
            x_start_c, v0, a0, [x_core; x_midzero; x_zero], K, tol);

        fprintf(fid, ...
            '%6.2f %14.7f %14.7f %14.7f %12.2f %12.3e %8d\n', ...
            A, m0_tay(k), m0mid_tay(k), m_core(k), ...
            paper_m0(k), abs(m0_tay(k)-paper_m0(k)), nsteps(k));
    end

    fprintf(fid, ['   * Taylor steps from x = 10 to x = 1e-6 ' ...
                  'without intermediate output stops\n\n']);

    err1 = abs(m0_tay - paper_m0);
    out1 = find(err1 > 0.005 + 1e-9);
    fprintf(fid, '   Shu prints m0 to 0.01 -> rounding bound 0.005\n');
    fprintf(fid, '   max |m0 - paper|            : %.3e\n', max(err1));
    fprintf(fid, '   rows outside rounding bound : %d of %d', numel(out1), numel(A_list));
    if ~isempty(out1)
        fprintf(fid, '   (A = %s)', strtrim(sprintf('%.1f ', A_list(out1))));
    end
    fprintf(fid, '\n   signed mean (Taylor - paper) : %+.3e  (%d of %d rows positive)\n\n', ...
            mean(m0_tay - paper_m0), sum(m0_tay > paper_m0), numel(A_list));






%% TABLE 1d: convergence for A = 2.2, x_start = 20
x_start_conv = 20;
A = 2.2;

v0 = -(A-2)/x_start_conv ...
     - (1-A/6)*(A-2)/x_start_conv^3;
a0 = A/x_start_conv^2 ...
     - A*(A-2)/(2*x_start_conv^4);

fprintf(fid, ['TABLE 1d: convergence of m0 with Taylor order K ' ...
              'and tolerance (A = 2.2, x_start = 20)\n']);
fprintf(fid, '---------------------------------------------------------------\n');
fprintf(fid, '%4s %10s %16s %14s %8s\n', ...
        'K', 'tol', 'm0', 'm0 - reference', 'steps');

cases = [10 1e-8;  10 1e-10; 10 1e-12; 10 1e-14;
         15 1e-8;  15 1e-10; 15 1e-12; 15 1e-14;
         20 1e-8;  20 1e-10; 20 1e-12; 20 1e-14;
         25 1e-8;  25 1e-10; 25 1e-12; 25 1e-14;
         30 1e-8;  30 1e-10; 30 1e-12; 30 1e-14];

res_conv = zeros(size(cases,1), 2);

for c = 1:size(cases,1)
    [vo, ao, ns] = shu_tay_march( ...
        x_start_conv, v0, a0, x_zero, cases(c,1), cases(c,2));

    res_conv(c,:) = [x_zero^2 * ao * (x_zero-vo), ns];
end

m_ref = res_conv(end,1);

for c = 1:size(cases,1)
    fprintf(fid, '%4d %10.0e %16.10f %+14.3e %8d\n', ...
        cases(c,1), cases(c,2), res_conv(c,1), ...
        res_conv(c,1)-m_ref, res_conv(c,2));
end
fprintf(fid, '\n');


%% TABLE 1e: convergence for A = 4.0, x_start = 20
A = 4.0;

v0 = -(A-2)/x_start_conv ...
     - (1-A/6)*(A-2)/x_start_conv^3;
a0 = A/x_start_conv^2 ...
     - A*(A-2)/(2*x_start_conv^4);

fprintf(fid, ['TABLE 1e: convergence of m0 with Taylor order K ' ...
              'and tolerance (A = 4.0, x_start = 20)\n']);
fprintf(fid, '---------------------------------------------------------------\n');
fprintf(fid, '%4s %10s %16s %14s %8s\n', ...
        'K', 'tol', 'm0', 'm0 - reference', 'steps');

res_conv = zeros(size(cases,1), 2);

for c = 1:size(cases,1)
    [vo, ao, ns] = shu_tay_march( ...
        x_start_conv, v0, a0, x_zero, cases(c,1), cases(c,2));

    res_conv(c,:) = [x_zero^2 * ao * (x_zero-vo), ns];
end

m_ref = res_conv(end,1);

for c = 1:size(cases,1)
    fprintf(fid, '%4d %10.0e %16.10f %+14.3e %8d\n', ...
        cases(c,1), cases(c,2), res_conv(c,1), ...
        res_conv(c,1)-m_ref, res_conv(c,2));
end
fprintf(fid, '\n');











 %% ---------------- TABLE 2 : expansion wave ----------------
    fprintf('=== Expansion wave (critical-point series) ===\n');
    rho_c = 0.1;                         % scaling of the critical-point series
    sig_d = -0.5;                        % depart at sigma = -0.5, i.e. x = 0.95
    Kc    = 24;                          % order of the critical-point series
    x_dep = 1 + sig_d * rho_c;

    [vc, ac] = shu_tay_crit(Kc, rho_c);
    v_dep = polyval(flipud(vc), sig_d);
    a_dep = polyval(flipud(ac), sig_d);

    x_tab     = [0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 ...
                 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00];
    alpha_pap = [71.5 27.8 16.4 11.5 8.76 7.09 5.95 5.14 4.52 4.04 ...
                 3.66 3.35 3.08 2.86 2.67 2.50 2.35 2.22 2.10 2.00];
    v_pap     = [5.44 3.47 2.58 2.05 1.68 1.40 1.18 1.01 0.861 0.735 ...
                 0.625 0.528 0.442 0.363 0.291 0.225 0.163 0.106 0.051 0.0];
    m_pap     = [0.981 0.993 1.01 1.03 1.05 1.08 1.12 1.16 1.20 1.25 ...
                 1.30 1.36 1.42 1.49 1.56 1.64 1.72 1.81 1.90 2.00];

    % points reached by marching: the table entries below x_dep, plus the
    % core points; entries with x >= x_dep come straight from the series
    x_prof_m = logspace(log10(0.9), -3, 150)';
    x_prof_m = x_prof_m(2:end-2);                       % endpoints are in the list already
    x_mar    = unique([x_tab(x_tab < x_dep - 1e-12)'; x_prof_m; x_core;x_midzero; x_zero]);
    x_mar    = flipud(x_mar);                           % decreasing
    [vm, am, ns_ew] = shu_tay_march(x_dep, v_dep, a_dep, x_mar, K, tol);

    alpha_s = zeros(size(x_tab));  v_s = zeros(size(x_tab));
    for k = 1:numel(x_tab)
        xt = x_tab(k);
        if xt >= x_dep - 1e-12                          % inside the series disc
            sg = (xt - 1) / rho_c;
            v_s(k)     = polyval(flipud(vc), sg);
            alpha_s(k) = polyval(flipud(ac), sg);
        else
            [~, ik] = min(abs(x_mar - xt));
            v_s(k)     = vm(ik);
            alpha_s(k) = am(ik);
        end
    end
    m_s = x_tab.^2 .* alpha_s .* (x_tab - v_s);

    fprintf(fid, 'TABLE 2a: Expansion-wave collapse solution (A -> 2+)\n');
    fprintf(fid, '---------------------------------------------------------------------\n');
    fprintf(fid, '%6s %10s %10s %10s %10s %10s %10s\n', ...
            'x', 'alpha_s', 'alpha_p', '-v_s', '-v_p', 'm_s', 'm_p');
    for k = 1:numel(x_tab)
        fprintf(fid, '%6.2f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f\n', ...
                x_tab(k), alpha_s(k), alpha_pap(k), -v_s(k), v_pap(k), m_s(k), m_pap(k));
    end

    [~, i_core] = min(abs(x_mar - x_core));
    [~, i_midzero] = min(abs(x_mar - x_midzero));
    [~, i_zero] = min(abs(x_mar - x_zero));
    m_core_ew = x_mar(i_core)^2 * am(i_core) * (x_mar(i_core) - vm(i_core));
    m0mid_ew  = x_mar(i_midzero)^2 * am(i_midzero) * (x_mar(i_midzero) - vm(i_midzero));
    m0_ew     = x_mar(i_zero)^2 * am(i_zero) * (x_mar(i_zero) - vm(i_zero));


    % residuals in units of the paper's last printed digit (x < 1)
    res_alpha = [0.1*ones(1,4), 0.01*ones(1,16)];
    res_v     = [0.01*ones(1,8), 0.001*ones(1,12)];
    res_m     = [0.001*ones(1,2), 0.01*ones(1,18)];
    inner     = 1:numel(x_tab)-1;
    d_alpha = alpha_s - alpha_pap;   d_v = -v_s - v_pap;   d_m = m_s - m_pap;
    fprintf(fid, '\nTable 2a error in units of the paper''s last printed digit (x < 1):\n');
    fprintf(fid, '   max |d alpha|/ulp = %.2f   max |d v|/ulp = %.2f   max |d m|/ulp = %.2f\n', ...
            max(abs(d_alpha(inner)) ./ res_alpha(inner)), ...
            max(abs(d_v(inner))     ./ res_v(inner)), ...
            max(abs(d_m(inner))     ./ res_m(inner)));
    n_out2 = sum(abs(d_alpha(inner)) > 0.5*res_alpha(inner) + 1e-9) + ...
             sum(abs(d_v(inner))     > 0.5*res_v(inner)     + 1e-9) + ...
             sum(abs(d_m(inner))     > 0.5*res_m(inner)     + 1e-9);
    fprintf(fid, '   entries outside rounding bound (0.5 ulp): %d of %d\n', ...
            n_out2, 3*numel(inner));

    % sensitivity of the expansion wave to the series order / departure point
    fprintf(fid, '\n TABLE 2b: Expansion-wave sensitivity against Kc &xd (m0 at x -> 0):\n');
     fprintf(fid, '                                Paper m0 (reduced core mass) = 0.975\n');
    fprintf(fid, '---------------------------------------------------------------------\n');
    fprintf(fid, '%4s %8s %12s %33s %8s\n', ...
            'Kc', 'xd', 'm0', 'm0 - m0(Kc=24,xd=0.95)','steps');
    %Reference m0
        Kc_t =24;
        sg_t=-0.5;
        [vc_t, ac_t] = shu_tay_crit(Kc_t, rho_c);
         xd = 1 + sg_t * rho_c;
        [vq, aq] = shu_tay_march(xd, polyval(flipud(vc_t), sg_t), ...
                                     polyval(flipud(ac_t), sg_t), x_zero, K, tol);
         m0_ref=x_zero^2 * aq * (x_zero - vq);


    for Kc_t = [6 12 18 24]
        for sg_t = [-0.9 -0.7 -0.5 -0.3]
            [vc_t, ac_t] = shu_tay_crit(Kc_t, rho_c);
            xd = 1 + sg_t * rho_c;
            [vq, aq, nsteps_ex] = shu_tay_march(xd, polyval(flipud(vc_t), sg_t), ...
                                     polyval(flipud(ac_t), sg_t), x_zero, K, tol);
            fprintf(fid, '  %2d %9.2f %17.10f %18.2e %14d\n', ...
                    Kc_t, xd, x_zero^2 * aq * (x_zero - vq), x_zero^2 * aq * (x_zero - vq)-m0_ref, nsteps_ex);
        end
    end


        % sensitivity of the expansion wave to the series order / departure point
    fprintf(fid, '\n TABLE 2c: Expansion-wave sensitivity against K, tol & x_zero (m0 at x -> 0 with Kc=24,xd=0.95):\n');
    fprintf(fid, '                                 m0*=m0(K=30,x_zero=1e-6, tol=1e-14):\n');
    fprintf(fid, '                                 Paper m0 (reduced core mass) = 0.975\n');
    fprintf(fid, '---------------------------------------------------------------------\n');
    fprintf(fid, '%2s %8s %11s %15s %18s %8s\n', ...
            'K', 'tol', 'x_zero', 'm0', 'm0 - m0*','steps');
      Kc_t =24;
      sg_t=-0.5;
      for K = [10 20 30]
        for tol = [1e-8 1e-11 1e-14]
          for x_zero=[1e-3 1e-4 1e-6]
            [vc_t, ac_t] = shu_tay_crit(Kc_t, rho_c);
            xd = 1 + sg_t * rho_c;
            [vq, aq, nsteps_ex] = shu_tay_march(xd, polyval(flipud(vc_t), sg_t), ...
                                     polyval(flipud(ac_t), sg_t), x_zero, K, tol);
            fprintf(fid, '%2d %10.2e %10.2e %17.10f %14.2e %10d\n', ...
                    K, tol, x_zero, x_zero^2 * aq * (x_zero - vq), x_zero^2 * aq * (x_zero - vq)-m0_ref,
                    nsteps_ex);
          end
        end
    end


    % Write an expansion-wave profile over the full inner domain.
    x_profile = unique([logspace(-3, log10(x_dep), 300)'; 1]);
    x_profile = sort(x_profile, 'descend');

    % Evaluate the critical-point series where it applies.
    v_profile = zeros(size(x_profile));
    a_profile = zeros(size(x_profile));

    for j = 1:numel(x_profile)
        xx = x_profile(j);

        if xx >= x_dep
            sigma = (xx - 1) / rho_c;
            v_profile(j) = polyval(flipud(vc), sigma);
            a_profile(j) = polyval(flipud(ac), sigma);
        end
    end

    % March from x_dep down through the inner points.
    inner_idx = find(x_profile < x_dep);
    if ~isempty(inner_idx)
        [v_inner, a_inner] = shu_tay_march( ...
            x_dep, v_dep, a_dep, x_profile(inner_idx), K, tol);
        v_profile(inner_idx) = v_inner;
        a_profile(inner_idx) = a_inner;
    end

    profile_file = fullfile(results_dir, 'shu1977_expansion_profile.txt');
    sc_write_profile(profile_file, ...
        'expansion wave, critical-point Taylor series and inward Taylor marching', ...
        x_profile, v_profile, a_profile);

    fprintf(fid, '\nExpansion-wave profile written to: %s\n', profile_file);



   fclose(fid);
   fprintf('\nDone. Results in %s\n', results_file);
