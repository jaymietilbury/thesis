function dy = Original_RPAIFFL_1(t, y, parameters, out_type, steady)
% ode system for IFFL original

% constants
T = parameters(1, 2);
d = parameters(1, 3);

k1 = parameters(1,4);
k2 = parameters(1,5);
k3 = parameters(1,6);
k4 = parameters(1,7);
k5 = parameters(1,8);
k6 = parameters(1,9);

% set up dy vector
dy = zeros(2, 1);

% input at time t
In = Input(T, d, t);

if steady == 0 % for steady state test
    In = 0;
end


% y1 - B
% y2 - D
% y3 - C

% set up ODE system
dy(1) = k1*y(2) - k2*y(1);
dy(2) = k5*In - k6*y(2);
dy(3) = k3*y(2) - k4*y(1)*y(3);

    
end
