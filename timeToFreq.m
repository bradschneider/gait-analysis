function [f, P1] = timeToFreq( signal, rate )
%TIMETOFREQ Summary of this function goes here
%   Detailed explanation goes here

L = size(signal);

Y = fft(signal);
P2 = abs(Y/L(1));
P1 = P2(1:(L(1)/2)+1);
P1(2:end-1) = 2*P1(2:end-1);

f = rate * (0:L/2)/L(1);
end

