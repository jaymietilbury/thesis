function dy = IFFL_2(t, y, parameters, out_type, steady)
% ode solver for iffl 2 system

% set up parameters
T = parameters(1, 2);
d = parameters(1, 3);

lambda = parameters(1,4);
I0_out = parameters(1,5);
n_out = parameters(1,6);
lambda_out = parameters(1,7);

% set up dy
dy = zeros(3, 1);

% calulcate input at time t
In = Input(T, d, t);

if steady == 0 % for steady state test
    In = 0;
end

% set up ODE system
dy(1) = In - y(1)*y(2);
dy(2) = In - lambda*y(2);

% enter output equation depending on entered type
if out_type == 1
    dy(3) = y(1)^n_out - lambda_out*y(3);
elseif out_type == 2
    dy(3) = (y(1)^n_out)/(1+(I0_out/y(1))^n_out) - lambda_out*y(3);
    
end
