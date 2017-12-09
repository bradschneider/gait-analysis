function [ filtered ] = movingAvgFilter( data, size )
%MOVINGAVGFILTER Summary of this function goes here
%   Detailed explanation goes here

%pad the array first by replication
padded = padarray(data, size - 1, 'replicate');

coeffs = ones(1, size)/size;
filtered = filter(coeffs, 1, padded);

%cut out the padded values
filtered = filtered(size:(numel(filtered)-(size-1)));

end

