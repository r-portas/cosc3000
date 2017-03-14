% Q1 - Curve Fitting

data = importdata('week2.mat');

% Generate the polynomial lines of best fit
n = 5;

polya = polyfit(data.x, data.a, n);
pa = polyval(polya, data.x);

polyb = polyfit(data.x, data.b, n);
pb = polyval(polyb, data.x);

polyc = polyfit(data.x, data.c, n);
pc = polyval(polyc, data.x);

% A points
subplot(2, 2, 1);
hold on;
scatter(data.x, data.a)
plot(data.x, pa);
title('A points');
hold off;

% B points
subplot(2, 2, 2);
hold on;
scatter(data.x, data.b);
plot(data.x, pb);
title('B points');
hold off;

% C points
subplot(2, 2, 3);
hold on;
scatter(data.x, data.c);
plot(data.x, pc);
title('C points');
hold off;

% Generate error bars for the first one
[p, S] = polyfit(data.x, data.a, 2);
[Y, DELTA] = polyconf(p, data.x, S, 'alpha', 0.05);

subplot(2, 2, 4);
hold on;
scatter(data.x, data.a);

% Draw the prediction intervals
handle1 = plot(data.x, Y-DELTA);
handle2 = plot(data.x, Y+DELTA);
title('Prediction Intervals');
hold off;

% Modify the handles
set(handle1, 'LineStyle', '--');
set(handle1, 'Color', 'b');
set(handle2, 'LineStyle', '--');
set(handle2, 'Color', 'r');
