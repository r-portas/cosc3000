% Q1 - Curve Fitting

data = importdata('week2.mat');

% Generate the polynomial lines of best fit
n = 5;

polya = polyfit(data.a, data.x, n);
pa = polyval(polya, data.x);

polyb = polyfit(data.b, data.x, n);
pb = polyval(polyb, data.x);

polyc = polyfit(data.c, data.x, n);
pc = polyval(polyc, data.x);

subplot(2, 2, 1);
hold on;
% A points
scatter(data.a, data.x)
plot(pa, data.x);
hold off;

subplot(2, 2, 2);
hold on;
% B points
scatter(data.b, data.x);
plot(pb, data.x);
hold off;

subplot(2, 2, 3);
hold on;
% C points
scatter(data.c, data.x);
plot(pc, data.x);
hold off;
