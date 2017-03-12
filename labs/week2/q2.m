% Q3 - Car Prices

data = readtable('CarsRetailPrice.csv');

% Find the line of best fit for price and mileage
p = polyfit(data.Price, data.Mileage, 1)
f = polyval(p, data.Price);

hold on;
scatter(data.Price, data.Mileage);
plot(data.Price, f);
hold off;

% Using Engine Size and Make as multiple regression to fit the price data
