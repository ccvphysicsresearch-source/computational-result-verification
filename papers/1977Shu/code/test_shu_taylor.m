% Automated Taylor-series verification for Shu (1977), A = 2.4.
% Compare Taylor and RK45 at the same endpoint and initial condition.

clear;
format long e;

A       = 2.4;
x_start = 10;
x_end   = 1e-3;
K       = 30;
tol     = 1e-14;
allowed_absolute_error = 1e-8;

addpath(fileparts(mfilename('fullpath')));

% Use the same asymptotic initial conditions as rk45_integrate.m.
v0 = -(A-2)/x_start ...
     - (1-A/6)*(A-2)/x_start^3;
a0 = A/x_start^2 ...
     - A*(A-2)/(2*x_start^4);

% Taylor-series integration, marching inward.
[v_t, a_t, n_t] = shu_tay_march( ...
    x_start, v0, a0, x_end, K, tol);

m_t = x_end^2 * a_t * (x_end-v_t);

% RK45 reference, using the same initial conditions and endpoint.
opts = odeset('RelTol', 1e-11, ...
              'AbsTol', 1e-13, ...
              'MaxStep', 0.005);

[m0_rk, x_rk, alpha_rk, v_rk, ok_rk] = ...
    rk45_integrate(A, x_start, x_end, opts);
n_rk = numel(x_rk) - 1;

if ~ok_rk
    error('RK45 did not reach the requested endpoint.');
end

% Compare endpoint mass, not the extrapolated central mass m0.
m_rk = x_rk(end)^2 * alpha_rk(end) * ...
       (x_rk(end)-v_rk(end));

abs_error = abs(m_t-m_rk);
passed = isfinite(m_t) && isfinite(m_rk) && ...
         isfinite(v_t) && isfinite(a_t) && ...
         a_t > 0 && abs_error <= allowed_absolute_error;

fprintf('\n=== Shu (1977): Taylor vs RK45 ===\n');
fprintf('A                         : %.16g\n', A);
fprintf('Endpoint                  : %.8g\n', x_end);
fprintf('Taylor order              : %d\n', K);
fprintf('Taylor tolerance          : %.1e\n', tol);
fprintf('Taylor endpoint mass      : %.15g\n', m_t);
fprintf('RK45 endpoint mass        : %.15g\n', m_rk);
fprintf('Absolute difference       : %.6e\n', abs_error);
fprintf('Allowed difference        : %.6e\n', allowed_absolute_error);
fprintf('Taylor steps              : %d\n', n_t);
fprintf('RK45 accepted steps       : %d\n', n_rk);
fprintf('RK45 extrapolated m0      : %.15g (informational)\n', m0_rk);

if passed
    fprintf('Verification status       : PASS\n');
else
    fprintf('Verification status       : FAIL\n');
end

% Save machine-readable results.
script_dir = fileparts(mfilename('fullpath'));
results_dir = fullfile(script_dir, '..', 'results');
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

report = struct();
report.test = 'shu1977_taylor_vs_rk45_A2.4';
if passed
    report.status = 'pass';
else
    report.status = 'fail';
end
report.configuration = struct( ...
    'A', A, ...
    'x_start', x_start, ...
    'x_end', x_end, ...
    'Taylor_order', K, ...
    'Taylor_tolerance', tol, ...
    'RK45_RelTol', 1e-11, ...
    'RK45_AbsTol', 1e-13, ...
    'RK45_MaxStep', 0.005);
report.result = struct( ...
    'Taylor_endpoint_mass', m_t, ...
    'RK45_endpoint_mass', m_rk, ...
    'RK45_extrapolated_m0', m0_rk, ...
    'Taylor_steps', n_t, ...
    'RK45_steps', n_rk);
report.absolute_error = abs_error;
report.allowed_absolute_error = allowed_absolute_error;
report.endpoint = x_end;
report.finite_values = isfinite(m_t) && isfinite(m_rk);
report.comparison = ...
    'Endpoint mass comparison; not a comparison of extrapolated m0 values.';

json_file = fullfile(results_dir, 'taylor_verification.json');
fid = fopen(json_file, 'w');
if fid == -1
    error('Cannot write JSON report: %s', json_file);
end
fwrite(fid, jsonencode(report), 'char');
fprintf(fid, '\n');
fclose(fid);

fprintf('JSON report               : %s\n', json_file);

if ~passed
    error('Taylor/RK45 verification failed.');
end
