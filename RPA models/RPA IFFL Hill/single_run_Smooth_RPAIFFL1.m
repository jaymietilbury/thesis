%% Run tests of signalling networks

clear all;

%% Set variable sets:

% set maximum time
time = 15;

% period and duration
T = [1];
d = [0.5];

% model parameters
nodes = 2;
param_no = 5;
%I0
parameters1 = [0.5];
%k1
parameters2 = [1];
%k2
parameters3 = [1];
%k3
parameters4 = [1];
%k4
parameters5 = [1];
%n
parameters6 = [25];
% no output options in this model
outputs = [1];


%% Create parameter set
% cycle through parameter values to record combination
index = 1;
for t = 1:length(T)
    for dur = 1:length(d)
        if d(dur) >= T(t)
            continue
        end
        for p1 = 1:size(parameters1,2)
            for p2 = 1:size(parameters2,2)
                for p3 = 1:size(parameters3,2)
                    for p4 = 1:size(parameters4,2)
                        for p5 = 1:size(parameters5,2)
                            for p6 = 1:size(parameters6,2)
                                if index == 1
                                    parameter_set = [index, T(t), d(dur), parameters1(p1), parameters2(p2), parameters3(p3), parameters4(p4), parameters5(p5), parameters6(p6),1];
                                else
                                    parameter_set = [parameter_set; index, T(t), d(dur), parameters1(p1), parameters2(p2), parameters3(p3), parameters4(p4), parameters5(p5), parameters6(p6),1];
                                end
                                index = index + 1;
                            end
                        end
                    end
                end
            end
            
        end
    end
end

%% Run model

% initialise cell matrix to record response
response_cell = {'Responses for Smooth_RPAIFFL_1', 0,0,0,0,0,0,0,0,0};

for i = 1:length(parameter_set(:,1))

    % parameter values
    out_type = parameter_set(i,10);
    T = parameter_set(i,2);
    d = parameter_set(i,3);
    
    
    % fsolve for steady state
    x0 = ones(nodes,1);
    options = optimoptions('fsolve', 'Display', 'off');
    F = @(y) Smooth_RPAIFFL_1(0, y, parameter_set(i,:), out_type, 0);
    [x0,fval] = fsolve(F, x0, options);
    steady_state = x0;
    
    % initialise results vectors
    To = [];
    Y = [];
    
    % run ode45 piecewise
    for k = 1:2*(time/T)
        if k == 1
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
        [T_iter,Y_iter] = ode45(@(t, y) Smooth_RPAIFFL_1(t, y, parameter_set(i,:), out_type, 1), [t_start, t_end], x0);
        To = [To; T_iter];
        Y = [Y; Y_iter];
    end
    % interpret results
    response = interpret_results(To, Y, parameter_set(i,:), nodes);
    skip = 1;
    
    if response == skip
        response = 'skipping';
    end
        
    % calculate input vector
    In = To;
    for s = 1:length(To)
        In(s) = Input(T(1), d(1), To(s));
    end
    
    % record results
    row = {response, parameter_set(i,2), parameter_set(i,3), parameter_set(i,4), parameter_set(i,5), parameter_set(i,6), parameter_set(i,7), parameter_set(i,8), parameter_set(i,10), out_type};
    response_cell(i+1, :) = row;
end

% calculate input vector
In = To;
for i = 1:length(To)
    In(i) = Input(T(1), d(1), To(i));
end

% vector of length T for plotting
steady_line = ones(1, length(To));

%% plot results
figure(1);clf;
hold on;
area(To, In, 'FaceColor', '#44b3fc', 'FaceAlpha', 0.55);
plot(To, Y(:,nodes), 'Color', '#ff4271', 'Linewidth', 3);
plot(To, Y(:,1), 'Color', '#0f9929', 'Linewidth', 2);
plot(To, parameters1(1)*steady_line, 'Color', '#4b42ff', 'Linewidth', 3, 'Linestyle', ':');


legend('Input', 'Output', 'R', 'R0 line', 'Fontsize', 16, 'Location', 'northeastoutside');
title(['RPA IFFL Hill', ', R0 = ', num2str(parameters1(1)), ', k1 = ', num2str(parameters2(1)), ', k2 = ', num2str(parameters3(1)), ', k3 = ', num2str(parameters4(1)), ', k4 = ', num2str(parameters5(1)), ', n = ', num2str(parameters6(1))], 'Fontsize', 10)

ax = gca;
ax.FontSize = 16;
xlabel('Time');
ylabel('Response');

response


