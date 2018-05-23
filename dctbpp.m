function bitsperpixel = dctbpp(regroupedTranformedCoeffs, N)

Yr = regroupedTranformedCoeffs;

block_size = length(Yr) / N;

assert(range(size(Yr)) == 0, 'Image must be sqaure')
assert(rem(block_size, 1) == 0)

bpp_blocks = zeros(N, N);

for i = 0:N-1
    for j = 0:N-1
       bpp_blocks(i+1, j+1) = bpp(Yr(i*block_size + (1:block_size), j*block_size + (1:block_size)));
    end
end

bitsperpixel = mean(bpp_blocks(:));