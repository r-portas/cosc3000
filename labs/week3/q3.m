load week3data;

% part2_plot(f1, f2, f3, t);

% Fourier Transforms

dt = t(2) - t(1); % Time between datapoints

f_sampling = 1 / dt;
f_max = f_sampling / 2;
freq1 = linspace(0, f_max, length(t) / 2);
freq2 = linspace(-f_max, f_max, length(t) + 1);
freq2 = freq2(2:end);

F1 = fft(f1);
F1a = abs(F1).^2;
F1b = F1a(1:length(t)/2);
F1a = fftshift(F1a);

figure;
plot(freq2, F1a);
xlabel('Frequency');
ylabel('|F_1|^2');
figure;
plot(freq1, F1b);
xlabel('Frequency');
ylabel('|F_1|^2');


function part2_plot(f1, f2, f3, t) 
    
    hold on;
    plot(f1, t);
    plot(f2, t);
    plot(f3, t);
    
    hold off;
    
end