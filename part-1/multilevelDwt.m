
X0 = X - 128;
m  = length(X0);
levels = 4;

%% Create sub-images

Y = nlevdwt(X0, levels);

%% Reconstruct

Z = nlevidwt(Y, levels);

draw(formatImg(Y));

diff = X0 - Z;

assert( max(diff(:)) == 0 );
