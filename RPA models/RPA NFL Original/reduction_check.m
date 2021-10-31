function response = reduction_check(heights, heights_other_node)
% initialise response
reduction = [0];

% record heights from the other node
heights_other_node = heights_other_node(2:length(heights_other_node));

% calculate the ratio of heights at current node to heights at other node
ratio = heights ./ heights_other_node;

% tolerance
tol = 0.1;

for i = 1:length(heights)-1
    
    % if the ratio has decreased within the tolerance and the heights at
    % the node have not changed to outside the tolerance range:
    
    if ratio(i) > tol * ratio(i+1) && heights(i) > (1-tol)*heights(i+1) && heights(i) < (1+tol)*heights(i+1)
        reduction = [reduction; 1];
    else
        reduction = [reduction; 0];
    end
end

response = sum(reduction); % record response
end