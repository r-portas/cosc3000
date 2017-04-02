[x, index] = sort(mean(crimes), 'descend');
top = index(1:5);
top_labels = labels(top);


months = sort(unique(d.MonthYear));
converted = datenum(months);

figure;
hold on;

for i = 1:5
    plot(converted, crimes(:, index(i)));
end

datetick('x', 12);
xlabel('Time');
ylabel('Number of offences');
legend(top_labels);

hold off;
