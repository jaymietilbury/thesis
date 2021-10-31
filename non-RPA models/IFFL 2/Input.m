function I = Input(T,d,t)
% function calculates Input at time t

% current pulse number
m = floor(t/T);
T = m*T;

% conditions for input on or off
if t<d
    I = 1;
elseif (d<t)&&(t<T)
    I = 0;
elseif (T<t)&&(t<T+d)
    I = 1;
else
    I = 0;
end

% return input I

end