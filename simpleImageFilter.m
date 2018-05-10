%% 5. Simple Image Filtering

D = 256;
N = 15;

h = halfcos(N);

Xf = conv2se(1, h, X);

draw(Xf);












