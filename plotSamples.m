function plotSamples(dimN, data, digit, samples, legendS, titleS)
% Function to plot explanatory samples
% dimN - dimensions number,
% data - data for plotting,
% digit - digit to plot (1, 2, 3 ...),
% samples - array of samples to plot [1,2,3,4],
% legendS - legend for a figure,
% titleS - title to print.
digit=digit+1;
switch dimN
    case 2
        for i=1:length(samples)
            plot(data{digit}{samples(i)}(:,1),...
                data{digit}{samples(i)}(:,2));hold on;
        end
    case 3
        for i=1:length(samples)
            plot3(data{digit}{samples(i)}(:,1),...
                data{digit}{samples(i)}(:,2),...
                data{digit}{samples(i)}(:,3));hold on;
        end
end
legend(legendS);
title(titleS);
grid on;
end

