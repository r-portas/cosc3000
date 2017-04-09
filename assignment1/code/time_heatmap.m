% Requires the 'crimes' array to be loaded
% i.e. Run import_data

crime_sum = sum(transpose(crimes));
crime_sum = crime_sum(1:192);

imagesc(transpose(reshape(crime_sum, [12, 16])));
colormap(hot)
axis square

h = set(gca, 'XTickLabels', {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'});
set(h, 'Rotation', 90);
set(gca, 'XTick', 1:12);
xlabel('Month');

h = set(gca, 'YTickLabels', {2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016});
set(gca, 'YTick', 1:16);
ylabel('Year');

colorbar;

% Plot the sum of crime on a line
months = sort(unique(d.MonthYear));
converted = datenum(months);
crime_sum = sum(transpose(crimes));
converted = transpose(converted);

% Estimate the line
x1 = linspace(min(converted), max(converted));
[p, S] = polyfit(converted, crime_sum, 2);
y1 = polyval(p, x1);


figure;
hold on;
plot(converted, crime_sum);
% plot(x1, y1, 'g-');
% plot(converted, fft(crime_sum));
% 12 is MMMyy
datetick('x', 12);
hold off;
xlabel('Time')
ylabel('Total offences');
