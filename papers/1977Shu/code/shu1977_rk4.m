function [m0, x, alpha, v, ok] = shu1977_rk4(A, x_start, x_end, h)
% SHU1977_RK4
% Fixed-step classical fourth-order Runge-Kutta integration
% of Shu's isothermal similarity ODEs, integrating inward.
%
% Inputs:
%   A       - outer density parameter
%   x_start - starting similarity radius (e.g. 10)
%   x_end   - ending similarity radius (e.g. 1e-3)
%   h       - positive nominal step size (e.g. 1e-4)
%
% Outputs:
%   m0      - estimated central reduced mass
%   x       - integration radii, descending
%   alpha   - density profile at x
%   v       - velocity profile at x
%   ok      - true if the requested endpoint was reached
%
% This is a fixed-step RK4 implementation using the same ODE
% right-hand side and outer asymptotic conditions as shu_odes.m
% and rk45_integrate.m. It is not yet claimed to reproduce every
% numerical detail of Shu's original integration.

    if nargin ~= 4
        error('Usage: shu1977_rk4(A, x_start, x_end, h)');
    end
    if ~(isscalar(A) && isscalar(x_start) && isscalar(x_end) && ...
         isscalar(h) && x_start > x_end && x_end > 0 && h > 0)
        error('Require x_start > x_end > 0 and h > 0.');
    end

    % Outer asymptotic initial conditions, matching rk45_integrate.m.
    alpha0 = A/x_start^2 - A*(A-2)/(2*x_start^4);
    v0 = -(A-2)/x_start ...
         - (1-A/6)*(A-2)/x_start^3;

    % Construct a uniform grid that lands exactly on x_end.
    n = ceil((x_start - x_end)/h);
    x = linspace(x_start, x_end, n+1)';
    y = zeros(n+1, 2);
    y(1,:) = [alpha0, v0];

    % Classical fourth-order Runge-Kutta.
    for i = 1:n
        xi = x(i);
        hi = x(i+1) - x(i);  % negative because integration is inward
        yi = y(i,:)';

        k1 = shu_odes(xi, yi);
        k2 = shu_odes(xi + hi/2, yi + hi*k1/2);
        k3 = shu_odes(xi + hi/2, yi + hi*k2/2);
        k4 = shu_odes(xi + hi, yi + hi*k3);

        y(i+1,:) = (yi + hi*(k1 + 2*k2 + 2*k3 + k4)/6)';

        if any(~isfinite(y(i+1,:))) || any(y(i+1,1) <= 0)
            x = x(1:i+1);
            y = y(1:i+1,:);
            break;
        end
    end

    alpha = y(:,1);
    v = y(:,2);
    endpoint_tol = max(10*eps(max(1,abs(x_end))), 1e-12*abs(x_end));
ok = abs(x(end) - x_end) <= endpoint_tol;

    if ~ok
    warning('RK4 did not reach the requested endpoint.');
    m0 = NaN;
else
    m_here = x(end)^2 * alpha(end) * (x(end) - v(end));
    m0 = m_here;

    for it = 1:8
        m0 = m_here - sqrt(max(m0, 0)/2) * x(end)^1.5;
    end
end
end
