function dy = NFL_fig1(t, y, parameters, out_type)
% ode solver for nfl theta system

% set up parameters
T = parameters(1, 2);
d = parameters(1, 3);
p1 = parameters(1, 4);
p2 = parameters(1, 5);
p3 = parameters(1,6);

% set up dy
dy = zeros(2, 1);

% calculate input at time t
In = Input(T, d, t);

% calculate theta
if p1 < y(1)
    theta = 0;
else
    theta = 1;
end

% steady state test with output type = 2
if out_type == 2
    In = 0;
end

% set up ODE system
dy(2) = In*theta-p3*y(2);
dy(1) = y(2)-p2*y(1);
    
end
