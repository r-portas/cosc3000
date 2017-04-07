hold on;
worldmap([-30, -9.5], [136.10, 155.68]);
land = shaperead('landareas.shp', 'UseGeoCoords', true);
geoshow(land, 'FaceColor', [0.15, 0.5, 0.15]);

S = shaperead('QPS_DIVISIONS.shp', 'UseGeoCoords', true);

areas = zeros(1, length(S));
for i = 1:length(S)
    box = S(i).BoundingBox;

    area = abs(box(2) - box(1)) * abs(box(4) - box(3));
    areas(i) = area;
    S(i).area = area;
end

max_area = max(areas);
color = parula(numel(S));
densityColors = makesymbolspec('Polygon', {'area', [0, max_area], 'FaceColor', color});
geoshow(S, 'DisplayType', 'polygon', 'SymbolSpec', densityColors);
title('Police division by size')
colorbar;
hold off;
