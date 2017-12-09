function [ data, per ] = generatePeriodogram( data, outFilename, sampleRate, filterSize )
%GENERATEPERIODOGRAM Summary of this function goes here
%   Detailed explanation goes here

per=[];

% data = movingAvgFilter(data, filterSize);
% [b,a] = butter(2, [0.5,3]/(sampleRate/2), 'bandpass');
[b,a] = butter(3, 5/(sampleRate/2));
var1 = var(data);
data = filter(b,a,data);
var2 = var(data);
[var1, var2]

[P1, f1] = periodogram(data, [],[], sampleRate, 'power');
per = [f1 P1];
%csvwrite(outFilename, per)
        
end

