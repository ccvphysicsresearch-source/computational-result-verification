%% ========================================================================
%  Adaptive RK45 integration of Shu's similarity ODEs
%% ========================================================================
function [m0, x_s, alpha_s, v_s, ok] = rk45_integrate(A, x_start, x_end, opts)
% Integrate Shu's ODEs from x_start down to x_end using ode45, with
% automatic fallback to ode15s if the adaptive step controller stalls
% near the critical point x = 1.
%
% Returns m0, the reduced core mass, obtained by extrapolating m(x_end)
% to x = 0 using the analytic asymptote m(x) = m0 + sqrt(m0/2) * x^{3/2}.

    x0     = x_start;
    alpha0 = A/x0^2 - A*(A-2)/(2*x0^4);
    v0     = -(A-2)/x0 - (1 - A/6)*(A-2)/x0^3;

    % ---- primary attempt: ode45 (adaptive Dormand-Prince RK45) ----
    [x_s, y_s] = ode45(@shu_odes, [x_start, x_end], [alpha0; v0], opts);

    % Grid truncated?  (ode45 returns silently on failure)
    ok = abs(x_s(end) - x_end) < 1e-6;

    if ~ok
        % ---- fallback: ode15s (stiff) ----
        opts15 = odeset('RelTol', 1e-11, 'AbsTol', 1e-13, 'MaxStep', 0.005);
        [x_s, y_s] = ode15s(@shu_odes, [x_start, x_end], [alpha0; v0], opts15);
        ok = abs(x_s(end) - x_end) < 1e-6;
    end

    alpha_s = y_s(:,1);
v_s     = y_s(:,2);

if ~ok
    warning('RK45/RK15s integration did not reach the requested endpoint.');
    m0 = NaN;
    return;
end

% Extrapolate m(x_end) to m0 using the analytic O(x^(3/2)) correction.
m_here = x_s(end)^2 * alpha_s(end) * (x_s(end) - v_s(end));
m0 = m_here;

for it = 1:8
    m0 = m_here - sqrt(max(m0, 0)/2) * x_s(end)^1.5;
end
end
