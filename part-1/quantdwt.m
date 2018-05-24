function [Y, dwtent] = quantdwt(Y, levels, dwtstep)
%QUANTDWT Quantise DWT sub-images of Y


m  = length(Y);
dwtent = zeros(3, levels + 1);

for i = 1:levels
    subImageWidth = m / 2^i;
    t = 1:subImageWidth;
    steps = dwtstep(:, i);
    
    
    sub = quantise(Y(subImageWidth + t, t), steps(1));
    dwtent(1, i) = bpp(sub) * subImageWidth^2;
    Y(subImageWidth + t, t) = sub;
    
    sub = quantise(Y(t, subImageWidth + t), steps(2));
    dwtent(2, i) = bpp(sub) * subImageWidth^2;
    Y(t, subImageWidth + t) = sub;    
    
    sub = quantise(Y(subImageWidth + t,  subImageWidth + t), steps(3)); 
    dwtent(3, i) = bpp(sub) * subImageWidth^2;
    Y(subImageWidth + t,  subImageWidth + t) = sub;
    
    if i == levels
        sub = quantise(Y(t, t), dwtstep(1, levels+1));
        dwtent(1, levels+1) = bpp(sub)  * subImageWidth^2;
        Y(t, t) = sub;
    end
    
end

end

