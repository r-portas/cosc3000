% Load sample data
load flu;

% Load the dates
dates = datenum(flu.Date, 'mm/dd/yyyy');

% Get the region names, except the first column (date)
regions = flu.Properties.VarNames(2:end);
% Get the number of regions
numOfRegions = length(regions);

hold on
x = 1;
% Loop through the regions
for i = regions
	subplot(numOfRegions, 1, x)
	plot(dates, flu.(char(i)))
	% Display the region name above the chart
	title(i)
	
	% Display as dates along the x axis
	datetick('x', 'mmm-yy');
	
	% Increment the counter
	x = x + 1;
end
hold off

