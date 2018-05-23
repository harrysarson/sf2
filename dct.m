
N = 8;
X0 = X - 128;
Xq = quantise(X0, 17);

%% Encoding Image

CN = dct_ii(N);
Y = colxfm(colxfm(X0,CN)', CN)';


%% Decoding Exact Image

Z = colxfm(colxfm(Y', CN')', CN');
figure(3);
draw(regroup(Y, N) / N);

diff = Z - X0;
assert(max(diff(:)) < 1e-10)

%% Bases

bases = [ zeros(1, N); CN'; zeros(1, N) ];
figure(1);
draw(255 * bases(:)*bases(:)');


%% Quantisation

qDiff = Xq - X0;
desiredRmsError = std(qDiff(:));

f = @(stepSize) getRmsErrorDct(X0, Y, CN, stepSize) - desiredRmsError; 

step_size = fsolve(f, 17, optimoptions('fsolve', 'Display', 'off'));

Yq = quantise(Y, step_size);
Yr = regroup(Yq, N);
Zq = colxfm(colxfm(Yq', CN')', CN');
figure(2);
draw(beside(Z, beside(Xq, X0)));

dctDiff = Zq - X0;

entropy = @(Z) bpp(Z) * numel(Z);

bbpN = 8;

fprintf('N  = %g\n', N);
fprintf('NAME\t\t\t| mean\t\t| std dev\t| cmpn\t|\n');
fprintf('Original\t\t| %+.3f\t| %+.3f\t| %.3f\t|\n', 0, 0, entropy(Z));
fprintf('Uniform quantisation\t| %+.3f\t| %+.3f\t| %.3f\t|\n', mean(qDiff(:)), std(qDiff(:)), entropy(Xq)); %entropy(Z0) / originalEntropy); Qbits(4) / originalEntropy);
fprintf('DCT quantisation\t| %+.3f\t| %+.3f\t| %.3f\t| (N" = %G)\n', mean(dctDiff(:)), std(dctDiff(:)), dctbpp(Yr, bbpN) * numel(Yr), bbpN); %entropy(Z0) / originalEntropy); Qbits(4) / originalEntropy);
fprintf('step size for DCT quantisation = %g\n', step_size);


function rmsError = getRmsErrorDct(X, Y, CN, stepSize)
    Yq = quantise(Y, stepSize);
    
    Z = colxfm(colxfm(Yq', CN')', CN');
    
    diff = Z - X;
    
    rmsError = std(diff(:));
end





