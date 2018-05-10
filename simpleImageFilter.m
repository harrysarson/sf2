%% 5. Simple Image Filtering

D = 256;
N = 15;

h = halfcos(N);

Xf = conv2(1, h, X, 'same');

draw(Xf);












