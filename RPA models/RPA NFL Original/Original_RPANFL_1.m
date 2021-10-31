function dy = Original_RPANFL_1(t, y, parameters, out_type, steady)
% ode function for rpa nfl original

% constants
T = parameters(1, 2);
d = parameters(1, 3);

k1 = parameters(1,4);
k2 = parameters(1,5);
k3 = parameters(1,6);
k4 = parameters(1,7);
k5 = parameters(1,8);

% dy vector
dy = zeros(2, 1);

% input at time t
In = Input(T, d, t);

if steady == 0 % for steady state test
    In = 0;
end

% set up ODE system
dy(1) = k1*y(2) - k2;
dy(2) = k3*(In) - k4*y(2)-k5*y(1);

    
end
