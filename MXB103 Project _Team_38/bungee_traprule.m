function I = bungee_traprule(f, a, b, n, h)
%BUNGEE_TRAPRULE modified Trapezoidal rule integration for bungee jumping.
% I = bungee_traprule(F, A, B, N,H) returns the trapezoidal rule approximation for
% the integral of f(x) from x=A to x=B, using N subintervals,
% where F is a function handle.
if ~isa(f, 'function_handle')
error('Your first argument was not a function handle')
end
m = (b-a) / n;
x = a:m:b; % an array of length n+1
S = 0;
for j = 2:n
S = S + f(x(j));
end
I = h/2 * (f(a) + 2*S + f(b));