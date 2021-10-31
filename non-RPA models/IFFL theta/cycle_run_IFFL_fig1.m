%% Run tests of signalling networks

clear all;

%% Set variable sets:

% set maximum time
time = 100;

% period and duration values
T = [0.1, 0.5, 1, 1.5, 2, 2.5, 5];
d = [0.05, 0.1, 0.25, 0.5, 0.9, 1, 1.25, 1.5, 1.9, 2, 2.25, 2.4, 2.5, 3, 4, 4.9];

% model parameters
nodes = 2;
param_no = 3;

% parameter values to test
parameters = [ 0.05, 0.1, 0.25, 0.5, 0.75, 1, 1.5, 2, 5;... %p1
    0.1, 0.25, 0.5, 0.75, 0.9, 1, 1.1, 1.5, 2;              %p2
    0.1, 0.25, 0.5, 0.75, 0.9, 1, 1.1, 1.5, 2];             %p3

% only one output type
outputs = [1];
out_type = 1;

%% Create parameter set
% cycle through all the parameter values to test and record combinations
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
                        parameter_set = [index, T(t), d(dur), parameters(1, p1), parameters(2, p2), parameters(3,p3), out_type];
                    else
                        parameter_set = [parameter_set; index, T(t), d(dur), parameters(1, p1), parameters(2, p2), parameters(3,p3), out_type];
                    end
                    index = index + 1;
                end
                
                
            end
        end
    end
end

%% Run all combinations

% initialise cell matrix to record responses
response_cell = {'Responses for IFFL almost perfect', 0,0,0,0,0,0};

% for all combinations, run test and record results
parfor i = 1:length(parameter_set(:,1))
    % initialise response
    response = 'none';
    
    % record progress
    fprintf('iteration %f of %f - ', length(parameter_set(:,1)) - i, length(parameter_set(:,1)));
    fprintf('percentage %f \n', 100*(length(parameter_set(:,1)) - i)/ length(parameter_set(:,1)));
    
    % parameters
    out_type = parameter_set(i,7);
    T = parameter_set(i,2);
    d = parameter_set(i,3);
    
    % fsolve for steady state
    x0 = ones(nodes,1);
    options = optimoptions('fsolve', 'Display', 'off');
    F = @(y) IFFL_fig1(0, y, parameter_set(i,:), 2);
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
        t_interval = [t_start, t_end];
        [T_iter,Y_iter] = ode45(@(t, y) IFFL_fig1(t, y, parameter_set(i,:), out_type), t_interval, x0);
        To = [To; T_iter];
        Y = [Y; Y_iter];
    end
    % interpret results
    response = interpret_results(To, Y, parameter_set(i,:), nodes);
    skip = 1;
    
    if response == skip
        response = 'skipping';
    end
    
    % calculate input vector with same length as To vector
    In = To;
    for s = 1:length(To)
        In(s) = Input(T(1), d(1), To(s));
    end

    % record results for current iteration
    row = {response, parameter_set(i,2), parameter_set(i,3), parameter_set(i,4), parameter_set(i,5), parameter_set(i,6), out_type};
    response_cell(i+1, :) = row;
    
end
%% Record results
response_cell
T = cell2table(response_cell(1:end,:));
writetable(T,'IFFL_fig1.csv');

