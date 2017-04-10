% 
% Processes crimes by region
%

MONTH = '01-Feb-2001';

regions = d(d.MonthYear == MONTH, :);

% Get the totals
totals = zeros(height(regions), 1);

for i = 1:height(regions)
    totals(i) = sum(table2array(regions(i, 3:end)));
    regions(i, :).Division = lower(regions(i, :).Division);
end

% Get the totals for each region
regions.Total = totals;

% Get the 10 suburbs with most crime
[x, i] = sort(totals, 'descend');
crime_totals = x(1:10);
most_crimes = i(1:10);

hold on;
worldmap([-30, -9.5], [136.10, 155.68]);
land = shaperead('landareas.shp', 'UseGeoCoords', true);
geoshow(land, 'FaceColor', [0.15, 0.5, 0.15]);

S = shaperead('QPS_DIVISIONS.shp', 'UseGeoCoords', true);

crime_num = zeros(1, length(S));
for i = 1:length(S)
    box = S(i);
    name = lower(S(i).NAME);
    indices = contains(regions.Division, name);
    S(i).totalCrime = regions(indices, :).Total(1);

    crime_num(i) = regions(indices, :).Total(1);
end

max_crimes = max(crime_num);
color = parula(numel(S));
densityColors = makesymbolspec('Polygon', {'totalCrime', [0, max_crimes], 'FaceColor', color});
geoshow(S, 'DisplayType', 'polygon', 'SymbolSpec', densityColors);

for i = 1:length(most_crimes)
    temp = S(most_crimes(i))
    textm(nanmean(temp.Lat), nanmean(temp.Lon), temp.NAME, 'FontWeight', 'Bold', 'Color', 'r');
end

colorbar;
hold off;
