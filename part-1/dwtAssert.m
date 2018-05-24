%% Discrete Wavelet Transform (DWT)

X0 = X - 128;

h1 = [ -1, 2, 6, 2, -1] / 8;
h2 = [ -1, 2, -1] / 4;

g1 = [1, 2, 1] / 2;
g2 = [-1, -2, 6, -2, -1] / 4;


% draw(beside(U, V, 0));

%% Apply to Image

U = rowdec(X0, h1);
V = rowdec2(X0, h2);

UU = rowdec(U', h1)';
UV = rowdec2(U', h2)';
VU = rowdec(V', h1)';
VV = rowdec2(V', h2)';

fprintf('Image | Energy\t\n');
fprintf('X0    | %.3g\t\n', var(X0(:)));
fprintf('U     | %.3g\t\n', var(U(:)));
fprintf('V     | %.3g\t\n', var(V(:)));
fprintf('UU    | %.3g\t\n', var(UU(:)));
fprintf('UV    | %.3g\t\n', var(UV(:)));
fprintf('VU    | %.3g\t\n', var(VU(:)));
fprintf('VV    | %.3g\t\n', var(VV(:)));

draw(formatImg(below(beside(UU, VU, 0), beside(UV, VV, 0), 0)));

%% Reconstruction

Ur = rowint(UU', g1)' + rowint2(UV', g2)';
Vr = rowint(VU', g1)' + rowint2(VV', g2)';

assert(all(reshape(Ur - U == 0, 1, [])));
assert(all(reshape(Vr - V == 0, 1, [])));

Xr = rowint(Ur, g1) + rowint2(Vr, g2);

assert(all(reshape(Xr - X0 == 0, 1, [])));

%% Rolled up function

assert(all(reshape([UU VU; UV VV] - dwt(X0) == 0, 1, [])))

assert(all(reshape(X0 - idwt([UU VU; UV VV]) == 0, 1, [])))

