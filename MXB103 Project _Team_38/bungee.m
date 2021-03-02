%% 
% Parameters

H = 74; % Height of jump point (m)
D = 31; % Deck height (m)
c = 0.9; % Drag coefficient (kg/m)
m = 80; % Mass of the jumper (kg)
L = 25; % Length of bungee rope (m)
k = 90; % Spring constant of bungee rope (N/m)
g = 9.8; % Gravity (m/s^2)
C = c/m; % Drag coefficient
K = k/m; % Spring constant

T = 60; % Final time in simulation (s)
n = 10000; % Number of intervals, 10000 is the limit and 
% should be accurate enough for calculation
%% 
% Question1.
% 
% The ordinary differential equations are solved using modified Euler's method. 
% The distance changing is plotted below
%%
[t, y, v, h] = m_euler_bungee(T, n, g, C, K, L);
figure(1)
plot(t, y);
xlabel('time (s)');
ylabel('distance fallen (m)');
title('Figure 1: Distance change over time.');
%% 
% A for loop to compare each y value, find the turning points.
%%
peaks = 0;
for i = 3:n
 if(y(i) < y(i-1) && y(i-1) > y(i-2))
     %Compare the last point and next point to find a peak
 peaks = peaks + 1;
 end
end
fprintf('Question1. In %d seconds, %d bounces experienced.\n', T, peaks);
%% 
% Question2. Plot jumper's velocity over time.
%%
figure(2)
plot(t, v);
xlabel('time (s)');
ylabel('velocity (m/s)');
title('Figure 2: Velocity over time.');
[value, m] = max(abs(v));
fprintf('Question2. Maximum speed of %.2fm/s occurs at %.2f seconds', value,t(m));
%% 
% Question3. 
% 
% The acceleration is the differentiation of velocity function. The Second  
% Order Central method is used to find the fdash for velocity function. The maximum 
% value for accleration is 18.461m/s^2 which is less than 2g.
%%
f = @(t) v(t); % Function for velocity
a = zeros(1,n+1);% 
a(1) = g; % Starting value for acceleration is gravity
m = 1; % Mesh space for central diffrentiation
for j = 2:n % Indexing through all values of v from 0 to 60 seconds
 a(j) = bungee_second_order_central(f, j, m, h);
end

figure(3)
plot(t, a);
xlabel('time (s)');
ylabel('fall acceleration (m/s^2)');
title('Figure 3: Acceleration over time.');
fprintf(['Question3. A maximum of %.3fm/s^2 acceleration ' ...
    'is experienced by jumper during the 60 second jump'], max(abs(a)));
%% 
% Question4. 
% 
% The Trapezium rule is used to calculate the area for function absolute 
% velocity which is the total distance travled by the jumper.

% function for absolute value v
f_v = @(t) abs(v(t));
% Index for velocity at 0 seconds and at 60 seconds
a = 1;
b = 10001;
% Traprule for calculating total distance of the jump.
distance = bungee_traprule(f_v, a, b, n, h);
fprintf('Question4. The jumper has traveled %.2f metres in 60 seconds', distance);
%% 
% 
% 
% Question5. As the requirement, nearest point to the camera is determined 
% first by conditioned while loop. Then retrive the adjacent 4 points around that 
% point. Use these four points with forward difference interpolating polynomial. 
% And solve the polynomial using bisection method to find the root(again the nearest 
% point to 43m). Finally, the time for triggering camera is found.
%%
cam = H - D; % Distance from the jumper to the camera
cam_index = 1; % Indexing through y to find the closest value to y_cam
% Find a nearest point to y_cam from y values, and save four y values 
% that next to this point so we can later use interpolation
while y(cam_index) < cam
 cam_index = cam_index + 1;
end
Y_p = [y(cam_index - 2) y(cam_index - 1) y(cam_index) y(cam_index + 1)];
% Also save the time for the correponding points of Y_p
T_p = [t(cam_index - 2) t(cam_index - 1) t(cam_index) t(cam_index + 1)];
% As the y values are all equally spaced by interval h with time
% we could use Newton's forward difference

% generate the interpolating polynomial for the four points gathered
M = forward_differences(Y_p);
t_interpol = T_p(1):h/10:T_p(length(T_p));% make it 10 steps based on the scale of h
y_interpol = forward_eval(T_p, M, t_interpol);
% Applying the bisection method to find the root of the interpolating
% polynomial at 43m
f_root = @(x) y_interpol(x);
% Indexes of the first and last values 
root_a = 1;
root_b = length(y_interpol);
% Apply the bisection method to find the index
p = bungee_bisection(f_root, root_a, root_b, cam);
figure(4)
plot (T_p, Y_p, 'bo');
hold on
plot (t_interpol, y_interpol,'r');
plot (t_interpol(p), y_interpol(p), 'kx');
xlabel('time (s)');
ylabel('distance (m)');
title('Figure 4: Interpolating polynomial through the nearest four points to camera.');
legend('points near the camera(43m)', 'forward difference polynomial', 'target point at camera');
fprintf('Question5. The camera should trigger at %.4f seconds after the jumper falls.', t_interpol(p));
%% 
% Question6.
% 
% The solution is found by adjusting decrement on spring constant K and increment  
% on rope length L in a while loop. The while loop will terminate when the maximum 
% jumper position exceeds 74 which is the water touch position. The ideal result 
% is to decrease K by 0.0001 and increase L by 0.0004 at each iteration. The new 
% K value is 78.8 and new L value is 42.54. To meet the requirement that the max 
% accleration should never exceed 2g (19.6m/s^2), the jumper's bounces number 
% is sacrificed and reduced from 10 to 9 and half.
%%
jumper_h = 1.75; %Jumper's Height 
j=1; % A counter to start with
y_w=zeros(n);

K1=K; % Spring constant variable that will be adjusted for water touch
L1=L; % Bungee length variable that will be adjusted for water touch
while max(abs(y_w))<H-jumper_h
    % While loop condition: stop when jumperjust touch the water
    [t_w, y_w, v_w, h_w] = m_euler_bungee(T, n, g, C, K1, L1);
    j=j+1;
    K1=(1-0.00001)*K1;% Spring constant decrease by 0.01 for each iteration
    L1=(1+0.00004)*L1;% Rope length increase by 0.04 for each iteration
end
k_new=K1*80; % Adjusted spring constant
L_new=L1; % Adjusted rope length
max_fall_distance = max(abs(y_w)) + jumper_h; % Water touch point reached

peaks_1 = 0;% Same method to find the turning point as Question 3
for i = 3:n
 if(y_w(i) < y_w(i-1) && y_w(i-1) > y_w(i-2))
 peaks_1 = peaks_1 + 1;
 end
end

fprintf('In %d seconds, %d bounces experienced.\n', T, peaks_1);
fprintf('The maximum y value is %.2fm\n.', max(abs(y_w)));
fprintf('By adding the height of jumper, the water touch position will be reached at %.2fm\n.', max_fall_distance);
fprintf('The adjusted spring constant is %.2f k/m and rope length is %.2fm\n', k_new, L_new);
figure(5)
plot(t_w, y_w);
xlabel('time (s)');
ylabel('distance fallen (m)');
title('Figure 5: Distance change over time(Water Touch).');


f_w = @(t_w)v_w(t_w); % Function for velocity
a_w= zeros(1,n+1); 
a_w(1) = g; % Starting acceleration is gravity
for j = 3:n % Indexing through all values of v from 0 to 60 seconds
 a_w(j) = bungee_second_order_central(f_w, j, m, h_w);
end

figure(6)
plot(t, a_w);
xlabel('time (s)');
ylabel('fall acceleration (m/s^2)');
title('Figure 6: Acceleration over time(Water Touch).');
fprintf(['Question6. A maximum of %.3fm/s^2 (less than 2g) acceleration ' ...
    'is experienced by jumper during the 60 second jump with "water touch"'], max(abs(a_w)));