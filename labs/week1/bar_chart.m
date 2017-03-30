load flu;

region = flu.Pac;

hold on;
subplot(2, 1, 1);
bar(region);
subplot(2, 1, 2);
barh(region);
hold off;
