function [PSD,f] = FT_FromVector(x,t)
%FT_FromVector Summary of this function goes here
%   Detailed explanation goes here
L = length(t);                % Length of signal ///
assert(L == length(x),'Both vectors must have the same size.');

dt = diff(t);
assert(all(dt), 'Time vector must be uniform');

T = dt(1);
Fs = 1/T;                           % Sampling frequency ///

Y = fft(x);
P2 = abs(Y/L);
PSD = P2(1:L/2+1);
PSD(2:end-1) = 2*PSD(2:end-1);
f = Fs*(0:(L/2))/L;

end

