%% 5. Simple Image Filtering

%% High Pass

figure;
colormap(map)
plots = 5;

% Odd length of half-cosine filter
for i = 1:(plots-1)
    N = floor(5 ^ (i-1));

    h = halfcos(N);

    LP = conv2se(h', h, X);
    HP = X - LP;

    subplot(1, plots, i);
    plotColumn(HP, LP, sprintf('Filter $$N = %g$$', N))
end

% Keep DC only

LP = ones(size(X)) * mean(X(:));
HP = X - LP;

subplot(1, plots, plots);
plotColumn(HP, LP, 'Filter DC only')

%% plot column

function plotColumn (HP, LP, columnTitle)
    dimensions = size(LP);
    whitespace = ones(60, dimensions(2)) * 255;
    data = [ LP; whitespace; HP + 128];
    image(data);
    axis image;
    axis off;
    title(sprintf('%s\nLow pass $$E = %.4g$$\nHigh pass $$E = %.4g$$\nTotal $$E = %.4g$$', ...
        columnTitle, sum(LP(:).^2) / 1e6, sum(HP(:).^2) / 1e6, sum(LP(:).^2 + HP(:).^2) / 1e6), 'interpreter', 'latex');
end


