
X0 = X - 128;
getRmsError = @(X) std(X(:));
cmps = [];

dwtsteps = cell(6, 1);

for levels = 4

    dwtsteps{levels} = findEqualMseDwtRatios(levels) .^ -0.5;
    % dwtsteps = ones(3, levels+1);

    Y = nlevdwt(X0, levels);
    Xq = quantise(X0, 17);

    desiredRmsError = getRmsError(Xq - X0);

    f = @(stepSize) getRmsError(nlevidwt(quantdwt(Y, levels, dwtsteps{levels} * stepSize), levels) - X0) - desiredRmsError;

    stepSize = fsolve(f, 4);

    [Yq, dwtent] = quantdwt(Y, levels, dwtsteps{levels} * stepSize);
    Z = nlevidwt(Yq, levels);

    dwtDiff = Z - X0;
    qDiff = Xq - X0;
    
    figure('Name', sprintf('LevelsC = %d',levels));
    draw(Z);

    compressionBaseline = bpp(Xq) * numel(Xq);

    fprintf('NAME\t\t\t| mean\t\t| std dev\t| cmpn\t|\n');
    fprintf('Original\t\t| %+.3f\t| %+.3f\t| %.3f\t|\n', 0, 0, compressionBaseline /  bpp(X0) * numel(X0));
    fprintf('Uniform quantisation\t| %+.3f\t| %+.3f\t| %.3f\t|\n', mean(qDiff(:)), std(qDiff(:)), 1); 
    fprintf('DWT quantisation\t| %+.3f\t| %+.3f\t| %.3f\t| \n', mean(dwtDiff(:)), std(dwtDiff(:)), compressionBaseline / sum(dwtent(:))); 
    fprintf('step size for DCT quantisation = %g\n', stepSize);
    
    cmps = [cmps,  compressionBaseline / sum(dwtent(:))];
end


