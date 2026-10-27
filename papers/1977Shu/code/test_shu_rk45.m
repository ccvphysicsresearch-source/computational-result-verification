% Controlled numerical verification test for Shu (1977).
% Run from the repository root using GNU Octave.

function test_shu_rk45()
    code_dir = fullfile(pwd, 'papers', '1977Shu', 'code');
    report_dir = fullfile(pwd, 'papers', '1977Shu', 'results');
    report_file = fullfile(report_dir, 'rk45_verification.json');

    if ~exist(code_dir, 'dir')
        error('Solver directory not found: %s', code_dir);
    end
    if ~exist(report_dir, 'dir')
        mkdir(report_dir);
    end

    addpath(code_dir);

    % Explicit, reproducible configuration.
    A = 2.4;
    x_start = 10;
    x_end = 1e-3;
    rel_tol = 1e-11;
    abs_tol = 1e-13;
    max_step = 0.005;

    % Comparison target from the existing RK45 reference run.
    reference_m0 = 1.885209332537;
    allowed_abs_error = 1e-8;

    opts = odeset('RelTol', rel_tol, ...
                  'AbsTol', abs_tol, ...
                  'MaxStep', max_step);

    [m0, x, alpha, v, ok] = ...
        rk45_integrate(A, x_start, x_end, opts);

    endpoint_ok = ~isempty(x) && abs(x(end) - x_end) <= 1e-10;
    finite_ok = isfinite(m0) && all(isfinite(alpha)) ...
                && all(isfinite(v)) && all(isfinite(x));

    if isfinite(m0)
        abs_error = abs(m0 - reference_m0);
    else
        abs_error = Inf;
    end

    pass = logical(ok) && endpoint_ok && finite_ok ...
           && abs_error <= allowed_abs_error;

    % Produce valid JSON, including explicit configuration and evidence.
    fid = fopen(report_file, 'w');
    if fid < 0
        error('Could not write report: %s', report_file);
    end

    if isfinite(m0)
        m0_json = sprintf('%.17g', m0);
        error_json = sprintf('%.17g', abs_error);
    else
        m0_json = 'null';
        error_json = 'null';
    end

    fprintf(fid, '{\n');
    fprintf(fid, '  "test": "shu1977_rk45_A2.4",\n');
    fprintf(fid, '  "status": "%s",\n', ...
            ternary(pass, 'pass', 'fail'));
    fprintf(fid, '  "configuration": {\n');
    fprintf(fid, '    "A": %.17g,\n', A);
    fprintf(fid, '    "x_start": %.17g,\n', x_start);
    fprintf(fid, '    "x_end": %.17g,\n', x_end);
    fprintf(fid, '    "RelTol": %.17g,\n', rel_tol);
    fprintf(fid, '    "AbsTol": %.17g,\n', abs_tol);
    fprintf(fid, '    "MaxStep": %.17g\n', max_step);
    fprintf(fid, '  },\n');
    fprintf(fid, '  "reference": {"m0": %.17g},\n', reference_m0);
    fprintf(fid, '  "result": {"m0": %s},\n', m0_json);
    fprintf(fid, '  "absolute_error": %s,\n', error_json);
    fprintf(fid, '  "allowed_absolute_error": %.17g,\n', ...
            allowed_abs_error);
    fprintf(fid, '  "endpoint": {"actual": %.17g, "ok": %s},\n', ...
            x(end), ternary(endpoint_ok, 'true', 'false'));
    fprintf(fid, '  "finite_values": %s,\n', ...
            ternary(finite_ok, 'true', 'false'));
    fprintf(fid, '  "integration_points": %d\n', numel(x));
    fprintf(fid, '}\n');
    fclose(fid);

    fprintf('Verification status: %s\n', ternary(pass, 'PASS', 'FAIL'));
    fprintf('Computed m0: %.15g\n', m0);
    fprintf('Absolute error: %.6e\n', abs_error);
    fprintf('JSON report: %s\n', report_file);

    if ~pass
        error('Shu RK45 verification failed.');
    end
end

function out = ternary(condition, yes_value, no_value)
    if condition
        out = yes_value;
    else
        out = no_value;
    end
end
