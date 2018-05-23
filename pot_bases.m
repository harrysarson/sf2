bases = cell(4, 1);
Xp = cell(4, 1);

X0 = X - 128;
t = (1 + N/2) : (I - N/2);

figure(1);

for i = 0:3
    [ Pf, Pr ] = pot_ii(N, 1 + i / 3);
    bases{i+1} = [ zeros(1, 8); Pf'; zeros(1, 8) ];
    
    Xp{i+1} = X0;
    Xp{i+1}(t, :) = colxfm(Xp{i+1}(t, :), Pf);
    Xp{i+1}(:, t) = colxfm(Xp{i+1}(:, t)', Pf)';
end

format = @(X) 255 / (max(X(:)) - min(X(:))) * (X - min(X(:)));




draw(below(format(beside(bases{1}(:) * bases{1}(:)', beside(bases{2}(:) * bases{2}(:)', beside(bases{3}(:) * bases{3}(:)', bases{4}(:) * bases{4}(:)')))), ...
        format(beside(Xp{1}(1:80, 111:190),  beside(Xp{2}(1:80, 111:190),  beside(Xp{3}(1:80, 111:190), Xp{4}(1:80, 111:190)))))));

    