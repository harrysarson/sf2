%% 5. Simple Image Filtering

%% Low pass

D = 256;
N = 15;

h = halfcos(N);

filteredColsFirst = conv2se(h', h, X);
filteredRowsFirst = conv2se(h, h', X')';

diff = abs(filteredColsFirst - filteredRowsFirst);

draw(diff ./ max(diff(:)) * 256);

fprintf('Max absolute difference = %g\n', max(abs(diff(:))));
fprintf('Average difference = %g\n', mean(diff(:)));
fprintf('Variance of differences = %g = %g^2\n', ...
    var(diff(:)), sqrt(var(diff(:))));























