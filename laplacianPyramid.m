%% 6. Laplacian Pyramid

lp_coeffs = [1 2 1];
lp_coeffs = lp_coeffs/norm(lp_coeffs, 1);


X1 = rowdec(rowdec(X, lp_coeffs)', lp_coeffs')';

X1_int = rowint(rowint(X1, 2*lp_coeffs)', 2*lp_coeffs')';

Y1 = X - X1_int;

draw(Y1)
