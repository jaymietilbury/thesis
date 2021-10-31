function dy = NFL_1(t, y, parameters, out_type, steady)
% ode solver for nfl 1

% set up parameters
T = parameters(1, 2);
d = parameters(1, 3);

I0 = parameters(1,4);
n = parameters(1,5);
lambda = parameters(1,6);
I0_out = parameters(1,7);
n_out = parameters(1,8);
lambda_out = parameters(1,9);

% set up dy equation variables
dy = zeros(3, 1);

% calculate input at time t
In = Input(T, d, t);

if steady == 0 % for steady state test
    In = 0;
end

% set up ODE system
dy(1) = In/(1+(I0/y(2))^n) - y(1);
dy(2) = y(1) - lambda*y(2);

% enter output equation depending on entered type
if out_type == 1
    dy(3) = y(1)^n_out - lambda_out*y(3);
elseif out_type == 2
    dy(3) = (y(1)^n_out)/(1+(I0_out/y(1))^n_out) - lambda_out*y(3);
    
end
