function dy = RPAIFFL_1(t, y, parameters, out_type, steady)
% ode system for iffl theta

% constants
T = parameters(1, 2);
d = parameters(1, 3);

I0 = parameters(1,4);
k1 = parameters(1,5);
k2 = parameters(1,6);
k3 = parameters(1,7);
k4 = parameters(1,8);

% set up dy
dy = zeros(2, 1);

% get input at time t
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


% y1 - B
% y2 - D
% y3 - C


% set up ODE system
dy(1) = k1*In - k2*y(1);
dy(2) = k3*In*theta - k4*y(1)*y(2);



    
end
