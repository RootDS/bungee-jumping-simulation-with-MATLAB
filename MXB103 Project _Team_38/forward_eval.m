function y = forward_eval(X, T, x)
% Evaluate Newton's forward difference form of the interpolating polynomial.
% y = forward_eval(X, T, x) returns y = P(x), where P is the interpolating
% polynomial constructed using the abscissas X = [x0,x1,...,xn] and forward
% difference table T.
n=length(T);
h=X(2)-X(1); %step length
r = (x - X(1)) / h;
y=T(1,1);
P=1;
for k=1:n-1 %Calculation of result
   P = P .* (r-k+1)/k; % Repetative pattern 
   y=y+P*T(k+1,k+1);
end
end