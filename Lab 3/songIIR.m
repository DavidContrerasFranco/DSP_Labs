function XFiltered = songIIR(F_s, F_p, X, Fs, Rp, Rs, FuncOrd, DiscFunc)
    % Sampling time
    T = 1/Fs;

    % Angular frequencies
    ws = 2*pi.* F_s ./ Fs;
    wp = 2*pi.* F_p ./ Fs;

    % Pre-Warping
    Ws = (2/T)*tan(ws ./ 2);
    Wp = (2/T)*tan(wp ./ 2);

    % Bandwidth
    BW = Ws(:,2) - Ws(:,1);

    % Frequencies product
    Wo_sqr = Ws(:,1) .* Ws(:,2);

    % New W_SB
    Wp(:,1) = Wo_sqr ./ Wp(:, 2);

    % Prototype filter
    W_P = (Wp(:,1) .* BW) ./ (Wo_sqr - Wp(:,1).^2);

    % Filter
    [n, Wn] = FuncOrd(W_P(1), 1, Rp, Rs, 's');
    if (isequal(FuncOrd, @buttord))
        [b, a] = butter(n, Wn, 's');
    elseif (isequal(FuncOrd, @cheb1ord))
        [b, a] = cheby1(n, Rp, Wn, 's');
    elseif (isequal(FuncOrd, @cheb2ord))
        [b, a] = cheby2(n, Rs, Wn, 's');
    elseif (isequal(FuncOrd, @ellipord))
        [b, a] = ellip(n, Rp, Rs, Wn, 's');
    end
    [bt, at] = lp2bs(b, a, sqrt(Wo_sqr(1)), BW(1));
    [numd, dend] = DiscFunc(bt, at, Fs);

    XFiltered = filtfilt(numd, dend, X);
end