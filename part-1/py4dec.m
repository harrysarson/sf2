function [Z0, Z1, Z2, Z3] = py4dec(X4, Y0, Y1, Y2, Y3, filter)
%py4dec Convert a four layer Laplacian pyramid into an image 
%  [Z0, Z1, Z2, Z3] = py4dec(X4, Y0, Y1, Y2, Y3) Decode a (small) low pass 
%  image X4 and four high pass images (of full, quarter, 1/16th and 
%  1/256th sizes).

    h = filter / norm(filter, 1);
    
    Z3 = interpolate(X4, h) + Y3;
    Z2 = interpolate(Z3, h) + Y2;
    Z1 = interpolate(Z2, h) + Y1;
    Z0 = interpolate(Z1, h) + Y0;
    
end

