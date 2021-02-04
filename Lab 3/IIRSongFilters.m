close all;
clear;
clc;

[y, Fs] = audioread('Marimba D major fun fair 75.mp3');
Harmonic = HighestIdentifier(y, Fs);
T = 1/Fs;

% Attenuation parameters
Rp = 1;     % Passband
Rs = 40;	% Stopband

% Frequencies for the filter
F_s = [Harmonic - 5, Harmonic + 5];
F_p = [Harmonic - 30, Harmonic + 30];

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

% Butterworth filter
[n, Wn] = buttord(W_P(1), 1, Rp, Rs, 's');
[b, a] = butter(n, Wn, 's');
[bt, at] = lp2bs(b, a, sqrt(Wo_sqr(1)), BW(1));
[numd, dend] = bilinear(bt, at, Fs);
fvtool(numd, dend, 'Fs', Fs);

[n, Wn] = buttord(W_P(1), 1, Rp, Rs, 's');
[b, a] = butter(n, Wn, 's');
[bt, at] = lp2bs(b, a, sqrt(Wo_sqr(1)), BW(1));
[numd, dend] = impinvar(bt, at, Fs);
fvtool(numd, dend, 'Fs', Fs);

% Chebyshev Type I
[n, Wn] = cheb1ord(W_P(1), 1, Rp, Rs, 's');
[b, a] = cheby1(n, Rp, Wn, 's');
[bt, at] = lp2bs(b, a, sqrt(Wo_sqr(1)), BW(1));
[numd, dend] = bilinear(bt, at, Fs);
fvtool(numd, dend, 'Fs', Fs);

[n, Wn] = cheb1ord(W_P(1), 1, Rp, Rs, 's');
[b, a] = cheby1(n, Rp, Wn, 's');
[bt, at] = lp2bs(b, a, sqrt(Wo_sqr(1)), BW(1));
[numd, dend] = impinvar(bt, at, Fs);
fvtool(numd, dend, 'Fs', Fs);

% Chebyshev Type II
[n, Wn] = cheb2ord(W_P(1), 1, Rp, Rs, 's');
[b, a] = cheby2(n, Rs, Wn, 's');
[bt, at] = lp2bs(b, a, sqrt(Wo_sqr(1)), BW(1));
[numd, dend] = bilinear(bt, at, Fs);
fvtool(numd, dend, 'Fs', Fs);

[n, Wn] = cheb2ord(W_P(1), 1, Rp, Rs, 's');
[b, a] = cheby2(n, Rs, Wn, 's');
[bt, at] = lp2bs(b, a, sqrt(Wo_sqr(1)), BW(1));
[numd, dend] = impinvar(bt, at, Fs);
fvtool(numd, dend, 'Fs', Fs);

% Elliptic
[n, Wn] = ellipord(W_P(1), 1, Rp, Rs, 's');
[b, a] = ellip(n, Rp, Rs, Wn, 's');
[bt, at] = lp2bs(b, a, sqrt(Wo_sqr(1)), BW(1));
[numd, dend] = bilinear(bt, at, Fs);
fvtool(numd, dend, 'Fs', Fs);

[n, Wn] = ellipord(W_P(1), 1, Rp, Rs, 's');
[b, a] = ellip(n, Rp, Rs, Wn, 's');
[bt, at] = lp2bs(b, a, sqrt(Wo_sqr(1)), BW(1));
[numd, dend] = impinvar(bt, at, Fs);
Num = numd; Den = dend;
fvtool(numd, dend, 'Fs', Fs);