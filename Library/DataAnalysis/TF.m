for k =1:21
    L=length(out.simout.Data(:,k));
    Fs=2000;                           % or whatever is actual sampling frequency
    y = out.simout.Data(20:end,k);
    f = Fs*(0:(L/2))/L;         % single-sided positive frequency
    X = fft(y)/L;                     % normalized fft
    PSD=2*abs(X(1:L/2+1));            % one-sided amplitude spectrum
    plot(f, PSD);
    title('Fourier');
    hold on
end


plot(out.corde_mesure.Time( out.corde_mesure.Time > 1 & out.corde_mesure.Time < 1.11), out.corde_mesure.Data(( out.corde_mesure.Time > 1 & out.corde_mesure.Time < 1.11),12),'r')
hold on
plot(t1(t1 > 1 & t1 < 1.11), x1(t1 > 1 & t1 < 1.11),'b')
hold off


