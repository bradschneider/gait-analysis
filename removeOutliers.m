function [ output ] = removeOutliers( data, factor )
%REMOVEOUTLIERS Summary of this function goes here
%   Detailed explanation goes here

dev = std(data);
m = mean(data);

lowLim = m - (factor * dev);
upLim = m + (factor * dev);

output = data(data >= lowLim & data <= upLim);

end

