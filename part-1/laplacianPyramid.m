%% 6. Laplacian Pyramid

lp_coeffs = [1 2 1];
lp_coeffs = lp_coeffs / norm(lp_coeffs, 1);
X0 = X - 128;

%% Encoding

[ Y0, Y1, Y2, Y3, X4, X3, X2, X1 ] = py4enc(X0, lp_coeffs);

fprintf('Entropy\n\t');
printEntropy('X', X0, 1)
fprintf('\t');
printEntropy('X1', X1, 1)
fprintf('\t');
printEntropy('Y0', Y0, 1)


fprintf('\n\nQuantisation with step = 17\n\t');
printEntropy('X', X0, 17)
fprintf('\t');
printEntropy('X1', X1, 17)
fprintf('\t');
printEntropy('Y0', Y0, 17)


%% Decoding

[ Z0, Z1, Z2, Z3 ] = py4dec(X4, Y0, Y1, Y2, Y3, lp_coeffs);


%% Quantisation & Decoding

% for uniform stepsize
stepSize = 10.30;

QX0 = quantise(X0, 17);
QX1 = quantise(X1, stepSize);
QX2 = quantise(X2, stepSize);
QX3 = quantise(X3, stepSize);
QX4 = quantise(X4, stepSize);
QY0 = quantise(Y0, stepSize);
QY1 = quantise(Y1, stepSize);
QY2 = quantise(Y2, stepSize);
QY3 = quantise(Y3, stepSize);

[ QZ0, QZ1, QZ2, QZ3 ] = py4dec(QX4, QY0, QY1, QY2, QY3, lp_coeffs);

% for MSE method
stepSize = 17.3958; 

MSEX = quantise(X0, 17);
MSEX4 = quantise(X4, stepSize / 5.38);
MSEY0 = quantise(Y0, stepSize / 1.00);
MSEY1 = quantise(Y1, stepSize / 2.75);
MSEY2 = quantise(Y2, stepSize / 1.5);
MSEY3 = quantise(Y3, stepSize / 2.75);

[ MSEZ0, MSEZ1, MSEZ2, MSEZ3 ] = py4dec(MSEX4, MSEY0, MSEY1, MSEY2, MSEY3, lp_coeffs);


%% Reduction in entropy

bits = [
  numel(X0) * bpp(X0);
  numel(Y0) * bpp(Y0) + numel(X1) * bpp(X1);
  numel(Y0) * bpp(Y0) + numel(Y1) * bpp(Y1) + numel(X2) * bpp(X2);
  numel(Y0) * bpp(Y0) + numel(Y1) * bpp(Y1) + numel(Y2) * bpp(Y2) + numel(X3) * bpp(X3);
  numel(Y0) * bpp(Y0) + numel(Y1) * bpp(Y1) + numel(Y2) * bpp(Y2) + numel(Y3) * bpp(Y3) + numel(X4) * bpp(X4);
];

Qbits = [
  numel(QX0) * bpp(QX0);
  numel(QY0) * bpp(QY0) + numel(QX1) * bpp(QX1);
  numel(QY0) * bpp(QY0) + numel(QY1) * bpp(QY1) + numel(QX2) * bpp(QX2);
  numel(QY0) * bpp(QY0) + numel(QY1) * bpp(QY1) + numel(QY2) * bpp(QY2) + numel(QX3) * bpp(QX3);
  numel(QY0) * bpp(QY0) + numel(QY1) * bpp(QY1) + numel(QY2) * bpp(QY2) + numel(QY3) * bpp(QY3) + numel(QX4) * bpp(QX4);
];

MSEbits = numel(MSEY0) * bpp(MSEY0) + numel(MSEY1) * bpp(MSEY1) + numel(MSEY2) * bpp(MSEY2) + numel(MSEY3) * bpp(MSEY3) + numel(MSEX4) * bpp(MSEX4);
 
figure;
hold on;
 
plot(0:4, Qbits / (bpp(X0) * numel(X0)), '-o');
ylabel('Fraction of original image entropy');
xlabel('depth of pyramid');

ylim([0, 0.5]);
xlim([-1, 5]);
xticks([0 1 2 3 4]);
xticklabels({'Direct quantistion', 'Depth 1', 'Depth 2', 'Depth 3', 'Depth 4'});

%% Energy

fprintf('Energy\n');
fprintf('\tEnergy in %s\t= %g\n', 'X', sum(X0(:).^2));
fprintf('\tEnergy in %s\t= %g\n', 'X4', sum(X4(:).^2));
fprintf('\tEnergy in %s\t= %g\n', 'Y0', sum(Y0(:).^2));
fprintf('\tEnergy in %s\t= %g\n', 'Y1', sum(Y1(:).^2));
fprintf('\tEnergy in %s\t= %g\n', 'Y2', sum(Y2(:).^2));
fprintf('\tEnergy in %s\t= %g\n', 'Y3', sum(Y3(:).^2));
fprintf('\tEnergy in %s\t= %g\n', 'Z0', sum(Z0(:).^2));

%% One layer pyramid


QW0 = interpolate(QX1, lp_coeffs) + QY0;

%% Error


diff = Z0 - X0;
qDiff = QZ0 - X0;
mseDiff = MSEZ0 - X0;
refDiff = QX0 - X0;
originalEntropy = entropy(X0);

fprintf('\n\nNAME\t\t\t| mean\t\t| std dev\t| cmpn\t|\n');
fprintf('Original\t\t| %+.3f\t| %+.3f\t| %.3f\t|\n', mean(diff(:)), std(diff(:)), entropy(QX0) / entropy(Z0));
fprintf('Uniform quantisation\t| %+.3f\t| %+.3f\t| %.3f\t|\n', mean(qDiff(:)), std(qDiff(:)), entropy(QX0) / Qbits(4));
fprintf('MSE quantisation\t| %+.3f\t| %+.3f\t| %.3f\t|\n', mean(mseDiff(:)), std(mseDiff(:)), entropy(QX0) / MSEbits);
fprintf('Direct quantisation\t| %+.3f\t| %+.3f\t| %.3f\t|\n', mean(refDiff(:)), std(refDiff(:)), 1);
% 
% figure('Name', '1/256th sized image (below with quantisation)');
% draw(below(X4, QX4)); 
% 
% 
% figure('Name', 'Encoding Pyramid (below with quantisation, uniform and MSE)');
% draw(below(...
%     beside(Y0 + 128, beside(Y1 + 128, beside(Y2 + 128, beside(Y3 + 128, X4)))), ...
%     below(beside(QY0 + 128, beside(QY1 + 128, beside(QY2 + 128, beside(QY3 + 128, QX4)))), ...
%     beside(MSEY0 + 128, beside(MSEY1 + 128, beside(MSEY2 + 128, beside(MSEY3 + 128, MSEX4)))) ...
%     )));
%     
% 
% figure('Name', 'Decoding Pyramid (below with quantisation, uniform and MSE)');
% draw(below(...
%     beside(Z0, beside(Z1, beside(Z2, beside(Z3, X4)))), ...
%     below(beside(QZ0, beside(QZ1, beside(QZ2, beside(QZ3, QX4)))), ...
%     beside(MSEZ0, beside(MSEZ1, beside(MSEZ2, beside(MSEZ3, MSEX4)))) ...
%     )));


figure('Name', 'Original Image -- Directly Quantised -- Equal Step Size -- Equal MSE');
draw(beside(X0, beside(QX0, beside(QZ0, MSEZ0))));

function printEntropy(name, image, step)

    bitsperpixel = bpp(quantise(image, step));
    pixels = numel(image);

    fprintf('Entropy of %s \t= (%g bpp)\t* (%g pixels)\t= %g\n', name, bitsperpixel, pixels, bitsperpixel*pixels);
end

function n = entropy(image)

    n = bpp(image) * numel(image);
end

