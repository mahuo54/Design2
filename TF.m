for k =2:22
    L=length(position.Data(20:end,k));
    Fs=2000;                           % or whatever is actual sampling frequency
    y = position.Data(20:end,k);
    f = Fs*linspace(0,1,L/2+1);         % single-sided positive frequency
    X = fft(y)/L;                     % normalized fft
    PSD=2*abs(X(1:L/2+1));            % one-sided amplitude spectrum
    plot(f, PSD);
    xlim([0 3500])
    title('Fourier');
    hold on
end


