function Harmonic = HighestIdentifierAyalaContreras(y, Fs)
    Y = fft(y);
    [~, argmax] = max(abs(Y));
    L = length(y);
    f = Fs*(0:(L/2))/L;
    Harmonic = f(argmax);
end
