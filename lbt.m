%% Lapped Bi-orthogonal Transform (LBT)

N = 8; % 8 gives a good compromise between not making edges noisy and not making squares in the sky
X0 = X -128;
I = length(X0);


CN = dct_ii(N);

t = (1 + N/2) : (I - N/2);

ss = [];
steps = [];
compressions = [];


Xq = quantise(X0, 17);
qDiff = Xq - X0;
desiredRmsError = std(qDiff(:));

for s = 1:0.05:2 

    [ Pf, Pr ] = pot_ii(N, s);

    Y = transform(X0, t, CN, Pf);

    %% Quantisation
    f = @(stepSize) std(reshape(recreate(quantise(Y, stepSize), t, CN, Pr) - X0, 1, [])) - desiredRmsError; 

    step_size = fsolve(f, 20, optimoptions('fsolve', 'Display', 'off'));

    
    Yq = quantise(Y, step_size);
    Yr = regroup(Yq, N);
    Zp = recreate(Yq, t, CN, Pr);
    compression = bpp(Xq) / dctbpp(Yr, 16);
    rms_error = std(reshape(Zp - X0, 1, []));
    
    fprintf('N = %d\t| s = %.2f,\t| step size = %.1f,\t| compression = %.4g\t| rms error = %.4g\n', N, s, step_size, compression, rms_error);
    
    ss = [ss s];
    steps = [steps step_size];
    compressions = [compressions compression];
end

figure;
hold on;
yyaxis left
plot(ss, steps);
ylabel("step size");
yyaxis right;
plot(ss, compressions);
ylabel("compression ratio");
xlabel("s");

max_compression = max(compressions);
optimal_s = ss(max_compression == compressions);
optimal_stepSize = steps(max_compression == compressions);

[ Pf, Pr ] = pot_ii(N, optimal_s);
Y = transform(X0, t, CN, Pf);


fprintf("using optimal step size = %.1f\ts = %.3f\t giving compression of %.3g\n", optimal_stepSize, optimal_s, max_compression);

Yq = quantise(Y, optimal_stepSize);
Zp = recreate(Yq, t, CN, Pr);
diff = Zp - X0;
error = std(reshape(Zp - X0, 1, []))

figure('Name', sprintf('N = %d', N));
draw(Zp);


function Zp = recreate(Y, t, CN, Pr)    
    Z = colxfm(colxfm(Y', CN')', CN');
    
    Zp = Z;
    Zp(:, t) = colxfm(Zp(:, t)', Pr')';
    Zp(t, :) = colxfm(Zp(t, :), Pr');
    
end

function Y = transform(X, t, CN, Pf)    
    
    % Pre-filter

    Xp = X;
    Xp(t, :) = colxfm(Xp(t, :), Pf);
    Xp(:, t) = colxfm(Xp(:, t)', Pf)';

    % DCT

    Y = colxfm(colxfm(Xp, CN)', CN)';
    
end






