function ratios = findEqualMseDwtRatios(levels);
    x = floor(200 * 2 .^ -(0:levels));
    ratios = zeros(3, levels + 1);

    for i = 1:levels

        Y = zeros(256, 256);
        Y(10, x(i)) = 255;
        Z = nlevidwt(Y, levels);
        ratios(1, i) = sum(Z(:) .^ 2);
        ratios(2, i) = ratios(1, i);

        Y = zeros(256, 256);
        Y(x(i), x(i)) = 255;
        Z = nlevidwt(Y, levels);
        ratios(3, i) = sum(Z(:) .^ 2);
    end

    i = levels + 1;
    Y = zeros(256, 256);
    Y(x(i), x(i)) = 255;
    Z = nlevidwt(Y, levels);
    ratios(1, i) = sum(Z(:) .^ 2);

    ratios = ratios / max(ratios(:));

end

