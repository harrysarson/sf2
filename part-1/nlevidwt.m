function X = nlevidwt(X, levels)
%NLEVIDWT Create an image from X made by performing levels of the DWT

m  = length(X);

for i = levels-1:-1:0
    t = 1:m/2^i;
    X(t, t) = idwt(X(t,t));
end

end

