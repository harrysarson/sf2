function Y = interpolate(X, filter)
    Y = rowint(rowint(X', 2*filter')', 2*filter);
end
