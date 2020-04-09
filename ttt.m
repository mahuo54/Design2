% test pour sim7
plot(y7.Time,y7.Data);

[PSD,f] =  FT_FromVector(y7.Data,y7.Time);
plot(f, PSD);

% Comparaison avec le second modèle...

plot(out.y.Time,out.y.Data);

[PSD2,f2] =  FT_FromVector(out.y.Data,out.y.Time);
plot(f2, PSD2);


% 
% Fs = 1000;            % Sampling frequency                    
% T = 1/Fs;             % Sampling period       
% L = 1500;             % Length of signal
% t = (0:L-1)*T;        % Time vector
% 
% S = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);
% X = S + 2*randn(size(t));
% 
% plot(1000*t(1:50),X(1:50))
% title('Signal Corrupted with Zero-Mean Random Noise')
% xlabel('t (milliseconds)')
% ylabel('X(t)')
% Y = fft(X);
% 
% P2 = abs(Y/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% 
% f = Fs*(0:(L/2))/L;
% plot(f,P1) 
% title('Single-Sided Amplitude Spectrum of X(t)')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')
% 
% [PSD,f] =  FT_FromVector(X,t);
% plot(f, PSD);