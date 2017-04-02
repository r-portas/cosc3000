load week2.mat;

% D contains the distances to the nearest 5 points
[IDX, D] = knnsearch(xy(:, 1), xy(:, 2), 'k', 5);

boxplot(D);