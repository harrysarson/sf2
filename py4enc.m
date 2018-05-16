function [ Y0, Y1, Y2, Y3, X4, X3, X2, X1, X0 ] = py4enc(image, filter)
%py4enc Create a four layer Laplcian pyramid from an image 
%  [X4, Y0, Y1, Y2, Y3] = py4enc(image, filter) Create a pyramid from image
%  using filter. The low pass image X4 which is tiny along with four high
%  pass images (of full, quarter, 1/16th and 1/256th sizes) are returned.

    % Ensure filter has 0 DC gain
    h = filter/norm(filter, 1);
    
    X0 = image;
    
    % Create half size LP image and full size HP image
    X1 = decimate(X0, h);
    Y0 = X0 - interpolate(X1, h);
    
    X2 = decimate(X1, h);
    Y1 = X1 - interpolate(X2, h);
    
    X3 = decimate(X2, h);
    Y2 = X2 - interpolate(X3, h);
    
    X4 = decimate(X3, h);
    Y3 = X3 - interpolate(X4, h);
end

function Y = decimate(X, filter)
    Y = rowdec(rowdec(X', filter')', filter);
end

