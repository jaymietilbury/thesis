function response = interpret_results(T, Y, parameters, nodes)

tol = 0.1; % tolerance

% period and duration parameters
T_period = parameters(1,2);
d = parameters(1,3);


% Find maximum in each oscillation
o = Y(:,nodes); % output heights
o_other = Y(:,nodes-1); % other node heights

% initialise variables
prev_v = 0;
t = 1;
increase = [];
heights = [];
heights_other_node = [];
negative = 0;

% while current time is less than the maximum time
while (t<length(T))
    % find the index of the pulse
    m = floor(T(t)/T_period);
    
    % find end of stimulus time:
    if (T(t) < (m*T_period + d))&&(T(t)>m*T_period)
        in_pulse = 1;
    else
        in_pulse = 0;
    end
    
    % current pulse
    v = (m)*T_period;
    o_t = o(t);
    o_other_t = o_other(t);
    
    % if we are in the first pulse, record the height
    if t == 1
        o_v = [o_t];
        o_other_v = [o_other_t];
        
        prev_o_v = [0 0 0 0 0];
    else
        % if we are still in the pulse, record the height
        if v == prev_v
            o_v = [o_v;o_t];
            o_other_v = [o_other_v; o_other_t];
        else
            % when we reach the end of the pulse, record the maximum height
            % of the outputs
            height = max(o_v);
            height_other_node = max(o_other_v);
            
            % calculate minimum
            min_h = min(o_v);
            
            % record heights
            heights = [heights;height];
            heights_other_node = [heights_other_node; height_other_node];
            
            
            % there has been a response if:
            % if the maximum is greater than the end of the last pulse
            % if the maximum is greater than the start of the current pulse
            % if the start of the current pulse is greater than the end of
            % the last pulse
            % if the gradient at the end of the last pulse is different to
            % the gradient at the start of the current pulse
            % AND heights have to be greater than 1e-3
            %             fprintf('current')
            %             o_v(floor(length(o_v)/2))-o_v(1)
            %             fprintf('previous')
            %             (1+tol2)*(prev_o_v(length(prev_o_v))-prev_o_v(floor(length(prev_o_v)/2)))
            %             (1-tol2)*(prev_o_v(length(prev_o_v))-prev_o_v(floor(length(prev_o_v)/2)))

            if min_h < 0
                increase = [increase;0];
                negative = 1;
            elseif height < 1e-3
                increase = [increase;1];
            elseif (((height > (1+tol)*prev_o_v(length(prev_o_v)))))||(height> (1+tol)*o_v(1))||(o_v(1)>(1+tol)*prev_o_v(length(prev_o_v)))&&(height > 1e-2)
                increase = [increase;0];
            else
                increase = [increase;1];
            end
            
            % set up the counters for the next iteration
            prev_o_v = o_v;
            o_v = [o_t];
            
            o_other_v = [o_other_t];
        end
    end
    
    % set up the counters for the next iteration
    prev_v = v;
    t = t+1;
    
end

% skip the result from the first pulse
heights = heights(2:length(heights));

% initialise the response
response = 0;
if negative == 1
    response = 'negative';
elseif sum(increase(2:end))>=2 % there has been skipping
    response = 1;
    
    % do some further tests to see if it has flatlined:
    for p = 1:length(increase)
        sub_inc = increase(p:end); % test pulse heights
        if sum(sub_inc) ~= length(sub_inc) && sub_inc(1) == 1
            response = 1; % skipping has occured
        elseif sum(sub_inc) == length(sub_inc) && length(sub_inc) > 5
            response = 'flatline';
            % check if there was also a reducing output response
            reduction = reduction_check(heights, heights_other_node); 
            if reduction > 0
                response = 'reduction and flatline';
            end
        elseif sum(sub_inc) == 0 && length(sub_inc) > 5
            response = 'none';
        end
    end

    
else
    % run reduction check
    reduction = reduction_check(heights, heights_other_node);
    if reduction > 0
        response = 'reduction';
    else
        response = 'none';
    end
end

% record the response




