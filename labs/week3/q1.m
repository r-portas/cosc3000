% Load the data
load week3data;

% Normal plots
% plot_data(months, data1, 'Data 1', 1);
% plot_data(months, data2, 'Data 2', 2);
% plot_data(months, data3, 'Data 3', 3);
% plot_data(months, data4, 'Data 4', 4);
% plot_data(months, data5, 'Data 5', 5);

tilemap(data4);

function tilemap(data)
    imagesc(reshape(data, [12, 30]));
    colormap(cold);
    axis square;
end

function recurrence_plot(data)
    imagesc(reshape(data, [12, 30]));
    colormap([1, 1, 1; 0, 0, 0]);
    axis square;
end

function plot_data(x, y, t, subplot_num)
    subplot(2, 3, subplot_num);
    
    hold on;
    plot(x, y);
    title(t);
    hold off;
end