% 
% Processes crimes by region
%

MONTH = '01-Feb-2017';

regions = d(d.MonthYear == MONTH, :);

% Get the totals
totals = zeros(height(regions), 1);

for i = 1:height(regions)
    totals(i) = sum(table2array(regions(i, 3:end)));
    regions(i, :).Division = lower(regions(i, :).Division);
end

% Get the totals for each region
regions.Total = totals;

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
title('Police division by crime density')
colorbar;
hold off;
