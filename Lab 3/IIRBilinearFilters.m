close all;
clear all;
clc;

% Sampling frequency and corresponding time vector
Fs = 2000;
T = 1/Fs;
t = (0:1/Fs:0.6)';

% Signal composing by rectangular and hamming windows
Win_Size = 0.3;
Hm_W = padarray(hamming(round(Win_Size * Fs + 1)), (0.6 - Win_Size)*Fs, 0, 'post');
Hm_W_1 = delayseq(Hm_W, -0.05, Fs);
Hm_W_2 = delayseq(Hm_W, 0.15, Fs);
Hm_W_3 = delayseq(Hm_W, 0.35, Fs);

x_1 = sin(2*pi*150*t) + sin(2*pi*250*t);
x_2 = sin(2*pi*350*t) + sin(2*pi*450*t);
x_3 = sin(2*pi*550*t) + sin(2*pi*650*t);

X_R = x_1.*(t >= 0 & t <= 0.2)   ...
    + x_2.*(t >= 0.2 & t <= 0.4) ...
    + x_3.*(t >= 0.4 & t <= 0.6);

X_H = Hm_W_1.*x_1 + Hm_W_2.*x_2 + Hm_W_3.*x_3;

% Attenuation parameters
Rp = 1;     % Passband
Rs = 40;	% Stopband

% Frequencies for the filters
    % Component 150, 350, 550 Hz
F_s = [145, 155; ...
       345, 355; ...
       545, 555];
F_p = [120, 180; ...
       320, 380; ...
       520, 580];

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
Num = numd; Den = dend;

[n, Wn] = buttord(W_P(2), 1, Rp, Rs, 's');
[b, a] = butter(n, Wn, 's');
[bt, at] = lp2bs(b, a, sqrt(Wo_sqr(2)), BW(2));
[numd, dend] = bilinear(bt, at, Fs);
Num = conv(Num, numd) ; Den = conv(Den, dend) ;

[n, Wn] = buttord(W_P(3), 1, Rp, Rs, 's');
[b, a] = butter(n, Wn, 's');
[bt, at] = lp2bs(b, a, sqrt(Wo_sqr(3)), BW(3));
[numd, dend] = bilinear(bt, at, Fs);
Num = conv(Num, numd) ; Den = conv(Den, dend) ;
fvtool(Num, Den, 'Fs', Fs);

% Chebyshev Type I
[n, Wn] = cheb1ord(W_P(1), 1, Rp, Rs, 's');
[b, a] = cheby1(n, Rp, Wn, 's');
[bt, at] = lp2bs(b, a, sqrt(Wo_sqr(1)), BW(1));
[numd, dend] = bilinear(bt, at, Fs);
Num = numd; Den = dend;

[n, Wn] = cheb1ord(W_P(2), 1, Rp, Rs, 's');
[b, a] = cheby1(n, Rp, Wn, 's');
[bt, at] = lp2bs(b, a, sqrt(Wo_sqr(2)), BW(2));
[numd, dend] = bilinear(bt, at, Fs);
Num = conv(Num, numd) ; Den = conv(Den, dend) ;

[n, Wn] = cheb1ord(W_P(3), 1, Rp, Rs, 's');
[b, a] = cheby1(n, Rp, Wn, 's');
[bt, at] = lp2bs(b, a, sqrt(Wo_sqr(3)), BW(3));
[numd, dend] = bilinear(bt, at, Fs);
Num = conv(Num, numd) ; Den = conv(Den, dend) ;
fvtool(Num, Den, 'Fs', Fs);

% Chebyshev Type II
[n, Wn] = cheb2ord(W_P(1), 1, Rp, Rs, 's');
[b, a] = cheby2(n, Rs, Wn, 's');
[bt, at] = lp2bs(b, a, sqrt(Wo_sqr(1)), BW(1));
[numd, dend] = bilinear(bt, at, Fs);
Num = numd; Den = dend;

[n, Wn] = cheb2ord(W_P(2), 1, Rp, Rs, 's');
[b, a] = cheby2(n, Rs, Wn, 's');
[bt, at] = lp2bs(b, a, sqrt(Wo_sqr(2)), BW(2));
[numd, dend] = bilinear(bt, at, Fs);
Num = conv(Num, numd) ; Den = conv(Den, dend) ;

[n, Wn] = cheb2ord(W_P(3), 1, Rp, Rs, 's');
[b, a] = cheby2(n, Rs, Wn, 's');
[bt, at] = lp2bs(b, a, sqrt(Wo_sqr(3)), BW(3));
[numd, dend] = bilinear(bt, at, Fs);
Num = conv(Num, numd) ; Den = conv(Den, dend) ;
fvtool(Num, Den, 'Fs', Fs);

% Elliptic
[n, Wn] = ellipord(W_P(1), 1, Rp, Rs, 's');
[b, a] = ellip(n, Rp, Rs, Wn, 's');
[bt, at] = lp2bs(b, a, sqrt(Wo_sqr(1)), BW(1));
[numd, dend] = bilinear(bt, at, Fs);
Num = numd; Den = dend;

[n, Wn] = ellipord(W_P(2), 1, Rp, Rs, 's');
[b, a] = ellip(n, Rp, Rs, Wn, 's');
[bt, at] = lp2bs(b, a, sqrt(Wo_sqr(2)), BW(2));
[numd, dend] = bilinear(bt, at, Fs);
Num = conv(Num, numd) ; Den = conv(Den, dend) ;

[n, Wn] = ellipord(W_P(3), 1, Rp, Rs, 's');
[b, a] = ellip(n, Rp, Rs, Wn, 's');
[bt, at] = lp2bs(b, a, sqrt(Wo_sqr(3)), BW(3));
[numd, dend] = bilinear(bt, at, Fs);
Num = conv(Num, numd) ; Den = conv(Den, dend) ;
fvtool(Num, Den, 'Fs', Fs);
