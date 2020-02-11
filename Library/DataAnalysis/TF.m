for k =2:6
    L=length(out.position_5.Data(:,k));
    Fs=2000;                           % or whatever is actual sampling frequency
    y = out.position_5.Data(20:end,k);
    f = Fs*(0:(L/2))/L;         % single-sided positive frequency
    X = fft(y)/L;                     % normalized fft
    PSD=2*abs(X(1:L/2+1));            % one-sided amplitude spectrum
    plot(f, PSD);
    title('Fourier');
    hold on
end


