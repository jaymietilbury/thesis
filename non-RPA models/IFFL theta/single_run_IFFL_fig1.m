%% Run tests of signalling networks

clear all;

%% Set variable sets:

% set maximum time
time = 15;

% period and duration
T = [1.5];
d = [0.5];
T1 = T;
d1 = d;

% model parameters
nodes = 2;
param_no = 3;

% parameter values to test
parameters = [ 0.3;...  %I0
    1;                  % parameter one - lambda
    1];                 % parameter two - kappa (we added this to multiply by R)
out_type = 8; % choose a large number here to test for steady state
% this system has no output types

%% Create parameter set
% cycle through parameter values to record combination
index = 1;
for t = 1:length(T)
    for dur = 1:length(d)
        if d(dur) >= T(t)
            continue
        end
        for p1 = 1:size(parameters,2)
            for p2 = 1:size(parameters,2)
                for p3 = 1:size(parameters,3)
                    
                    if index == 1
                        parameter_set = [index, T(t), d(dur), parameters(1, p1), parameters(2, p2), parameters(3,p3)];
                    else
                        parameter_set = [parameter_set; index, T(t), d(dur), parameters(1, p1), parameters(2, p2), parameters(3,p3)];
                    end
                    index = index + 1;
                end
                
                
            end
        end
    end
end

%% Run model

% initialise cell matrix to record response
response_cell = {'Responses for IFFL theta', 0,0,0,0,0,0};

% period and duration variables
T = T1;
d = d1;
To = 0;

%    fsolve for steady state
x0 = ones(nodes,1);
options = optimoptions('fsolve', 'Display', 'off');
F = @(y) IFFL_fig1(0, y, parameter_set(1,:), 2);
[x0,fval] = fsolve(F, x0, options);
steady_state = x0;

% initialise results vectors
To = [];
Y = [];

% run ode45 piecewise
for i = 1:2*(time/T)
    if i == 1
        % initialise tracking variables
        t_start = 0;
        t_end = d;
        pulse = 1;
    else
        if pulse == 1
            t_start = t_end;
            t_end = t_start +(T-d);
            pulse = 0;
        else
            t_start = t_end;
            t_end = t_start + d;
            pulse = 1;
        end
        x0 = Y_iter(end, :);
    end
    % calculate solution with ode45
    t_interval = [t_start, t_end];
    [T_iter,Y_iter] = ode45(@(t, y) IFFL_fig1(t, y, parameter_set(1,:), out_type), t_interval, x0);
    To = [To; T_iter];
    Y = [Y; Y_iter];
end

% interpret results
response = interpret_results(To, Y, parameter_set(1,:), nodes);
if response == 1
    response = 'skipping';
end

% record results
row = {response, parameter_set(1,2), parameter_set(1,3), parameter_set(1,4), parameter_set(1,5), parameter_set(1,6), out_type};
response_cell(1+1, :) = row;

% calculate input vector
In = To;
for i = 1:length(To)
    In(i) = Input(T(1), d(1), To(i));
end

% vector of length T
steady_line = ones(1, length(To));

%% Plotting
figure(1); clf;
hold on;
area(To, In, 'FaceColor', '#44b3fc', 'FaceAlpha', 0.55);
plot(To, Y(:,nodes), 'Color', '#ff4271', 'Linewidth', 3);
plot(To, parameters(1,1)*steady_line, 'Color', '#4b42ff', 'Linewidth', 3, 'Linestyle', ':');

plot(To, Y(:,1), 'Color', 'k', 'Linewidth', 2);
legend('Input', 'Output', 'I0', 'Other node', 'Fontsize', 16, 'Location', 'northeastoutside');
title(['IFFL theta: ' 'period = ', num2str(parameter_set(1,2)), ', duration = ', num2str(parameter_set(1,3)), ', I0 = ', num2str(parameter_set(1,4)), ', lambda = ', num2str(parameter_set(1,6)), ', kappa = ', num2str(parameter_set(1,5))], 'Fontsize', 12)
xlabel('Time');
ylabel('Response');
ax = gca;
ax.FontSize = 18;

response