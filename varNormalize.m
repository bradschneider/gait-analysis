function [ norm ] = varNormalize( signal, range )
%VARNORMALIZE normalize the discrete signal to occur between [-range/2,
% +range/2]

%mn = min(signal);
%mx = max(signal);

%norm = range * ((signal-mn)/(mx-mn) - 0.5);

%ver 2
norm = signal - mean(signal(:));
norm = norm/std(norm(:));

end

