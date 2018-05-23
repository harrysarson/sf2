function step = findStepSize(X, Y, desiredRmsError, initialStepSize)
    %findStepSize Find step size that gives desired rms error
    %   Detailed explanation goes here


    g = @(stepSize) getRmsErrorDCT(X, Y, stepSize) - desiredRmsError;
    
    step = fsolve(g, initialStepSize);    
end

function rmsError = getRmsError(X, X4, Y0, Y1, Y2, Y3, stepSize, h)
    QX4 = quantise(X4, stepSize);
    QY0 = quantise(Y0, stepSize);
    QY1 = quantise(Y1, stepSize);
    QY2 = quantise(Y2, stepSize);
    QY3 = quantise(Y3, stepSize);
  
    [ Z0 ] = py4dec(QX4, QY0, QY1, QY2, QY3, h);
    
    diff = Z0 - X;
    
    rmsError = std(diff(:));
end

function rmsError = getRmsErrorMSE(X, X4, Y0, Y1, Y2, Y3, stepSize, h)
    QX4 = quantise(X4, stepSize / 5.38);
    QY0 = quantise(Y0, stepSize / 1);
    QY1 = quantise(Y1, stepSize / 2.75);
    QY2 = quantise(Y2, stepSize / 1.5);
    QY3 = quantise(Y3, stepSize / 2.75);
  
    [ Z0 ] = py4dec(QX4, QY0, QY1, QY2, QY3, h);
    
    diff = Z0 - X;
    
    rmsError = std(diff(:));
end

function rmsError = getRmsErrorDCT(X, Y, stepSize)
    Yq = quantise(Y, stepSize);
    
    C8 = dct_ii(8);
  
    Z = colxfm(colxfm(Yq', C8')', C8');
    
    diff = Z - X;
    
    rmsError = std(diff(:));
end

