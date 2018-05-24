function X = nlevdwt(X, levels)
%NLEVDWT Create an image from X made by performing levels of the DWT

m  = length(X);

for i = 0:levels-1
    t = 1:m/2^i;
    X(t, t) = dwt(X(t,t));
end

end

