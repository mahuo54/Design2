
Test = fft(position.Data);

%%% Note. On peut appliquer directement fft sur une matrice.
%Aussi, valider les fréquences d'échantillonage vs la fréquence à mesurer. 

%On connait la fréquence d'échantillonage, la longueur et la durée du signal.
%Paramètre de la simulation 
T = position.TimeInfo.Increment;    % Sampling period       
Fs = 1/T;                           % Sampling frequency ///                    
L = position.Length;                % Length of signal ///
t = position.Time;                  % Time vector %On l'a déjà depuis la timeseries

%Signal et signal corrumpu
% S = 0.7*sin(2*pi*5*t) + sin(2*pi*9*t);
% X = S + 1*randn(size(t));
k=5;
X = position.Data(:,k);

Y = fft(X);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
