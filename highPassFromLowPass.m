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
    plotColumn(HP, LP, sprintf('Filter length %g', N))
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
    data = [ LP; whitespace; HP + 128; whitespace; whitespace];
    image(data);
    text(4, dimensions(1) + 16, sprintf('Energy %g', sum(LP(:).^2)));
    text(4, 2*dimensions(1) + 60 + 16, sprintf('Energy %g', sum(HP(:).^2)));
    text(4, 2*dimensions(1) + 60 + 16 + 30, sprintf('Total %g', sum(LP(:).^2 + HP(:).^2)));
    title(columnTitle);
    axis image;
    axis off;
    xlabel(sprintf('Energy %g', sum(LP(:).^2)));
    xlabel(sprintf('Energy %g', sum(HP(:).^2)));
end


