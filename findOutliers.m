function [ out ] = findOutliers( data, factor )
%FINDOUTLIERS Summary of this function goes here
%   Detailed explanation goes here

dev = std(data);
m = mean(data);

lowLim = m - (factor * dev);
upLim = m + (factor * dev);

isOutlier = (data < lowLim) | (data > upLim);
out = find(isOutlier);


end

