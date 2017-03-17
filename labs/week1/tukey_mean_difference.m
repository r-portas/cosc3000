% Tukey Mean Difference plot

load flu;

% Calculate the vigintiles
q = (1:19)./20;

% Calculate the quartiles for two datasets
x = quantile(flu.NE, q);
y = quantile(flu.WSCentral, q);

% Calculate the mean
mean = (x + y) ./ 2;

% Calculate the difference between the two quantiles
diff = y - x;

hold on;
plot(mean, diff);
plot( [max( mean ), 0], [0, 0], ':k' );
axis( [min( mean ), max( mean ), min( diff ), max( diff )] );
axis square;
hold off;
