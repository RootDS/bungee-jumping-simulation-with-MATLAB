function f_dash = bungee_second_order_central(f, x, m, h)
%SECOND_ORDER_CENTRAL Second order central difference approximation of f'.
% fdash = second_order_central(f, x, i, h) returns the f',
% (f(x + i) - f(x - i)) / (2 * h) where f is a function handle, i is the mesh spacing,
% and h is the subinterval with regards to time.
if ~isa(f, 'function_handle')
error('Your first argument was not a function handle')
end
f_dash = (f(x + m) - f(x - m)) / (2 * h);
end