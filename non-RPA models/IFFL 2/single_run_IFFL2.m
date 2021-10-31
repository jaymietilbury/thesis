%% Run tests of signalling networks

clear all;

%% Set variable sets:

% set maximum time
time = 30;

T = [2];        % period
d = [0.5];      % duration

% model parameters
nodes = 3;
param_no = 4;

% parameter values to test
parameters = [0.5;    % lambda
    1;                % I0 out
    1;                % n out
    1];               % lambda out

out_type = 1; % type 1 or type 2 (with thresholding)


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
                for p3 = 1:size(parameters,2)
                    for p4 = 1:size(parameters,2)
                        if index == 1
                            parameter_set = [index, T(t), d(dur), parameters(1, p1), parameters(2, p2), parameters(3,p3), parameters(4, p4), out_type];
                        else
                            parameter_set = [parameter_set; index, T(t), d(dur), parameters(1, p1), parameters(2, p2), parameters(3, p3), parameters(4, p4), out_type];
                        end
                        index = index + 1;
                    end
                end
                
            end
        end
    end
end

%% Run model

% initialise cell matrix to record response
response_cell = {'Responses for IFFL 2', 0,0,0,0,0,0,0};

% fsolve for steady state
x0 = ones(nodes,1);
options = optimoptions('fsolve', 'Display', 'off');
F = @(y) IFFL_2(0, y, parameter_set(1,:), out_type, 0);
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
    [T_iter,Y_iter] = ode45(@(t, y) IFFL_2(t, y, parameter_set(1,:), out_type, 1), [t_start, t_end], x0);
    To = [To; T_iter];
    Y = [Y; Y_iter];
end

% interpret results
response = interpret_results(To, Y, parameter_set(1,:), nodes);
if response == 1
    response = 'skipping';
end

% record results
row = {response, parameter_set(1,2), parameter_set(1,3), parameter_set(1,4), parameter_set(1,5), parameter_set(1,6), parameter_set(1,7), out_type};
response_cell(1+1, :) = row;

% calulcate input vector
In = To;
for i = 1:length(To)
    In(i) = Input(T(1), d(1), To(i));
end


%% plot results

figure(1); clf;
hold on;
area(To, In, 'FaceColor', '#44b3fc', 'FaceAlpha', 0.55);
plot(To, Y(:,nodes), 'Color', '#ff4271', 'Linewidth', 3);
plot(To, Y(:,1), 'Color', '#0f9929', 'Linewidth', 2);
plot(To, Y(:,2), 'Color', 'k', 'Linewidth', 2);

ax = gca;
ax.FontSize = 16;
legend('Input', 'Output', 'R', 'I', 'Location', 'northeastoutside');
title(['IFFL 2', ', lambda = ', num2str(parameters(1)), ', I0 out = ', num2str(parameters(2)), ', n out = ', num2str(parameters(3)), ', lambda out = ', num2str(parameters(4))', ', out type = ', num2str(out_type)])



response