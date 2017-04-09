[xData, yData] = prepareCurveData( converted, crime_sum );

% Set up fittype and options.
ft = fittype( 'poly5' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, 'Normalize', 'on' );

% Create a figure for the plots.
figure;

% Plot fit with data.
h = plot( fitresult, xData, yData, 'predobs' );
legend( h, 'Total Offences', 'Polynomial Fit', 'Lower bounds', 'Upper bounds', 'Location', 'NorthEast' );
% Label axes
xlabel('Time');
ylabel('Total Offences');
datetick('x', 12);
grid on

% Plot residuals.
figure;
h = plot( fitresult, xData, yData, 'residuals' );
% Label axes
xlabel('Time');
ylabel('Total Offences');
datetick('x', 12);
grid on


