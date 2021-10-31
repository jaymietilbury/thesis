function dy = Smooth_RPANFL_1(t, y, parameters, out_type, steady)
% ode for nfl with hill function

% constants
T = parameters(1, 2);
d = parameters(1, 3);

I0 = parameters(1,4);
k1 = parameters(1,5);
k2 = parameters(1,6);
k3 = parameters(1,7);
k4 = parameters(1,8);
n = parameters(1,9);

% dy vector
dy = zeros(2, 1);

% calculate input at time t
In = Input(T, d, t);

if steady == 0 % for steady state test
    In = 0;
end

% calculate hill function value
theta = 1/(1+(I0/y(1))^n);

% set up ODE system
dy(1) = k1*y(2) - k2;
dy(2) = k3*(In*theta) - k4*y(2);

    
end
