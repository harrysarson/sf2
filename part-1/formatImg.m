function Y = formatImg(X)
%formatImg bring images into range 0 to 255

a = min(X(:));
b = max(X(:));

Y = 255 / (b - a) * (X - a);


end

