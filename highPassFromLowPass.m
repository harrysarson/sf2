%% 5. Simple Image Filtering

%% High Pass

figure;
colormap(map)
plots = 5;

% Odd length of half-cosine filter
for i = 1:(plots-1)
    N = floor(5 ^ (i-1)), 255;

    h = halfcos(N);

    LP = conv2se(h', h, X);
    HP = X - LP;

    subplot(2, plots, i);
    image(LP);
    title (sprintf('Filter length %g', N))
    axis image
    axis off;
    subplot(2, plots, i + plots);
    image(HP);
    axis image
    axis off;
end

N = floor(5 ^ (i-1)), 255;

% Keep DC only


LP = ones(size(X)) * mean(X(:));
HP = X - LP;

subplot(2, plots, plots);
image(LP);
title (sprintf('Filter length %g', N))
axis image
axis off;
subplot(2, plots, 2*plots);
image(HP);
axis image
axis off;

