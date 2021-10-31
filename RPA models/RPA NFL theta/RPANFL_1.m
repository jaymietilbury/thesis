function dy = RPANFL_1(t, y, parameters, out_type, steady)
% ode system for rpa theta

% constants
T = parameters(1, 2);
d = parameters(1, 3);

I0 = parameters(1,4);
k1 = parameters(1,5);
k2 = parameters(1,6);
k3 = parameters(1,7);
k4 = parameters(1,8);
% k5 = parameters(1,9);

% dy vector
dy = zeros(2, 1);

% calc input at time t
In = Input(T, d, t);

if steady == 0 % for steady state test
    In = 0;
end

% calculate theta
if (I0 - y(1)) < 0
    theta = 0;
else
    theta = 1;
end

% set up ODE system
dy(1) = k1*y(2) - k2;
dy(2) = k3*(In*theta) - k4*y(2);

    
end
