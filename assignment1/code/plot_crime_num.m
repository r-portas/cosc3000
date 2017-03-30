
% Load the data
x = d(d.MonthYear == '01-Jan-2017', :);



hold on;

for i = 3:90
    % total = total + x.(i);
    plot(x.(i));
end

xtickangle(90);
set(gca, 'XTickLabel', x.Division);
set(gca, 'XTick', 1:length(x.Division));
hold off;



months = sort(unique(d.MonthYear));

crimes = zeros(length(months), 88);

num_of_months = length(months);

for i = 1:num_of_months

    sprintf('Processing %d of %d', i, num_of_months)

    total = zeros(1, 88);
    temp = d(d.MonthYear == months(i), 3:end);

    for j = 1:height(temp)
        total = total + table2array(temp(j, :));
    end

    crimes(i, :) = total(:);
end

labels = x.Properties.VariableNames(3:90);

figure;

hold on;
surf(crimes);
h = set(gca, 'XTickLabels', labels);
set(h, 'Rotation', 90);
set(gca, 'XTick', 1:88);
set(gca, 'YTickLabels', char(months));
set(gca, 'YTick', length(months));

hold off;
