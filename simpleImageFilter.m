%% 5. Simple Image Filtering

D = 256;
N = 15;

Xf = zeros(D, D + N - 1);

h = halfcos(N);

for row = 1:D
   Xf(row, :) = conv(X(row, :), h);
end

draw(Xf(:,(1:D)+floor(N/2)));












