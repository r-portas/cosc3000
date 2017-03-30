load flu;

% hist(flu.Pac)

dates = datenum(flu.Date, 'mm/dd/yyyy');

hold on;
plot(dates, flu.Pac);
plot(dates, flu.WtdILI);
plot(dates, flu.Mtn);
plot(dates, flu.WNCentral);
datetick('x', 'mmm-yy');
hold off;
