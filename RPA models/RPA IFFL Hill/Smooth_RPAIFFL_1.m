function dy = Smooth_RPAIFFL_1(t, y, parameters, out_type, steady)
% ode solver for iffl hill system

% set up parameters
T = parameters(1, 2);
d = parameters(1, 3);

I0 = parameters(1,4);
k1 = parameters(1,5);
k2 = parameters(1,6);
k3 = parameters(1,7);
k4 = parameters(1,8);
n = parameters(1,9);

% set up dy
dy = zeros(2, 1);

% calculate input at time t
In = Input(T, d, t);

if steady == 0 % for steady state test
    In = 0;
end

% calculate Hill function theta
theta = 1/(1+(I0/y(1))^n);

% set up ODE system
dy(1) = k1*In - k2*y(1);
dy(2) = k3*In*theta - k4*y(1)*y(2);


end
