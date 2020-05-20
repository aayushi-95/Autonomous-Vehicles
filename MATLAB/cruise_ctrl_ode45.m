function cruise_ctrl_ode45

tspan = [0, 30];  % Time interval of simulation
x0 = [15; 0]; % Initial speed = 15 m/s, integration of error = 0

[t, x] = ode45(@cruise_model, tspan, x0);

v = x(:,1);

s_info = stepinfo(v, t);
fprintf('Rise Time: %g\n', s_info.RiseTime);
fprintf('Settling Time: %g\n', s_info.SettlingTime);
fprintf('Overshoot: %g%%\n', (s_info.Peak - v(end)) / abs(v(end) - x0(1)) * 100);

figure; plot(t, v); xlabel('Time t [s]'); ylabel('Speed v [m/s]');

end

function x_dot = cruise_model(t, x)
% CDDL, 15 Feb 08
% State space model of car + PI cruise controller
% x(1): v (actual speed)
% x(2): z (integration of the error signal)

r = 20;  % Reference speed
v_err = r - x(1); % Error signal

Kp = .95; Ki = .08; % Controller gain

% Set the throttle
u = Kp*v_err + Ki*x(2);

% Saturate the input of the throttle
u = min(u, 1);  u = max(0, u);

% Parameters for defining the system dynamics (agree with simulink model)
m = 1000;               % mass of the vehcile
alpha = [40, 25, 16, 12, 10];		% gear ratios
Tm = 190;				% engine torque constant, Nm
omega_m = 420;				% peak torque rate, rad/sec
beta = 0.4;				% torque coefficient
Cr = 0.01;				% coefficient of rolling friction
rho = 1.3;				% density of air, kg/m^3
Cd = 0.32;				% drag coefficient
A = 2.4;				% car area, m^2
g = 9.8;				% gravitational constant
gear = 3;               % choose the desired gear
theta = 0;              % the angle of the surface you're driving on

% Determine the driving force
omega = alpha(gear)*x(1);
torque = u * Tm * ( 1 - beta * (omega/omega_m - 1)^2 );
F = alpha(gear) * torque;
        
% Determine the opposing forces
Fr = m * g * Cr;                    % Rolling friction
Fa = 0.5 * rho * Cd * A * (x(1))^2;		% Aerodynamic drag
Fg = m * g * sin(theta);            % Road slope force
Fd = Fr + Fa + Fg;                  % total deceleration

% Determine the right side of the state equation
x_dot = [ (F - Fd)/m; v_err ];

end
