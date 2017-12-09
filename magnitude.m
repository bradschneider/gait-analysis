function [ out_data ] = magnitude( in_data, filterSize )
%MAGNITUDE Summary of this function goes here
%   Detailed explanation goes here

fil = movingAvgFilter(in_data, filterSize);

[m,n] = size(in_data);
for i = 1:m
      out_data(i) = norm(fil(i,:));
end

end

