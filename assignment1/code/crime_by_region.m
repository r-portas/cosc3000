% 
% Processes crimes by region
%

regions = d(:, :);

% Get the totals
totals = zeros(height(regions), 1);

for i = 1:height(regions)
    totals(i) = sum(table2array(regions(i, 3:end)));
    regions(i, :).Division = lower(regions(i, :).Division);
end

% Get the totals for each region
regions.Total = totals;
