function p = bungee_bisection(f, a, b, n)
%bungee_bisection method
% Modified bisection method for bungee jumping.
% p = bungee_bisection(f, a, b, n) returns the nearest point to n by
% applying the bisection method for solving f(x) = n, 
% using a while loop instead of iterations to search the point as 
% the function f has a exact value for each index and will stop when
% it reaches the closest index 
if ~isa(f, 'function_handle')
error('Your first input was not a function handle')
end
if f(a) > n && f(b) > n || f(a) < n && f(b) < n
error('a and b must be on opposing sides of n.')
end
while abs(a - b) > 1
    p = round((a+b)/2); % compute the midpoint value for indexing
    if f(p) < n && f(a) < n || f(p) > n && f(a) > n
        a = p; % Move a closer to value n 
    else
        b = p; % Move b closer to value n 
    end
end
if abs(f(a) - n) < abs(f(b) - n) %lastly, find the nearest point to n between a and b
    p = a;
else
    p = b;
end
end
