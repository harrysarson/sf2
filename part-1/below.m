function y = below(x1, x2, border)

%BELOW  Arrange two images above/below each other.
%  Y = BELOW(X1, X2) puts X1 abovend X2 in Y.
%  Y is padded with zeros as necessary and the images are
%  separated by a blank row.



if nargin <= 2, border = 3; end

% work out size of Y
[ m1, n1 ]=size(x1);
[ m2, n2 ]=size(x2);
n = max(n1, n2);
y = zeros(m1 + m2 + border, n) + max([x1(:); x2(:)]);

y(1:m1, (n - n1)/2 + (1:n1)) = x1;
y(m1 + border + (1:m2), (n - n2)/2 + (1:n2)) = x2;

return
