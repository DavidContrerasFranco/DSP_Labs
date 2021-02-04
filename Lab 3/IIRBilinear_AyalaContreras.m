close all;
clear;
clc;
figure('units','normalized','outerposition',[0 0 1 1])

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

% Butterworth
X_Butter_Rect = generalIIR_AyalaContreras(F_s, F_p, X_R, Fs, Rp, Rs, @buttord, @bilinear);
X_Butter_Hamm = generalIIR_AyalaContreras(F_s, F_p, X_H, Fs, Rp, Rs, @buttord, @bilinear);

% Chebyshev Type I
X_Chev1_Rect = generalIIR_AyalaContreras(F_s, F_p, X_R, Fs, Rp, Rs, @cheb1ord, @bilinear);
X_Chev1_Hamm = generalIIR_AyalaContreras(F_s, F_p, X_H, Fs, Rp, Rs, @cheb1ord, @bilinear);

% Chebyshev Type II
X_Chev2_Rect = generalIIR_AyalaContreras(F_s, F_p, X_R, Fs, Rp, Rs, @cheb2ord, @bilinear);
X_Chev2_Hamm = generalIIR_AyalaContreras(F_s, F_p, X_H, Fs, Rp, Rs, @cheb2ord, @bilinear);

% Elliptic
X_Ellip_Rect = generalIIR_AyalaContreras(F_s, F_p, X_R, Fs, Rp, Rs, @ellipord, @bilinear);
X_Ellip_Hamm = generalIIR_AyalaContreras(F_s, F_p, X_H, Fs, Rp, Rs, @ellipord, @bilinear);

Y = fft(X_Butter_Rect);
L = length(X_Butter_Rect);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f, P1)
title({'Single-sided FFT for the Test Signal - Bilinear Butterworth Filter'; ...
       'Composed with Rectangular Windows'}, 'FontSize', 15);
xlabel('Frequency (Hz)', 'FontSize', 15);
ylabel('Amplitude', 'FontSize', 15);
saveas(gcf,'TestSignalRectangularBilinearButterworthFilter.png');

Y = fft(X_Chev1_Rect);
L = length(X_Chev1_Rect);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f, P1)
title({'Single-sided FFT for the Test Signal - Bilinear Chebyshev Type I Filter'; ...
       'Composed with Rectangular Windows'}, 'FontSize', 15);
xlabel('Frequency (Hz)', 'FontSize', 15);
ylabel('Amplitude', 'FontSize', 15);
saveas(gcf,'TestSignalRectangularBilinearChev1Filter.png');

Y = fft(X_Chev2_Rect);
L = length(X_Chev2_Rect);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f, P1)
title({'Single-sided FFT for the Test Signal - Bilinear Chebyshev Type II Filter'; ...
       'Composed with Rectangular Windows'}, 'FontSize', 15);
xlabel('Frequency (Hz)', 'FontSize', 15);
ylabel('Amplitude', 'FontSize', 15);
saveas(gcf,'TestSignalRectangularBilinearChev2Filter.png');

Y = fft(X_Ellip_Rect);
L = length(X_Ellip_Rect);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f, P1)
title({'Single-sided FFT for the Test Signal - Bilinear Elliptic Filter'; ...
       'Composed with Rectangular Windows'}, 'FontSize', 15);
xlabel('Frequency (Hz)', 'FontSize', 15);
ylabel('Amplitude', 'FontSize', 15);
saveas(gcf,'TestSignalRectangularBilinearEllipticFilter.png');

Y = fft(X_Butter_Hamm);
L = length(X_Butter_Hamm);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f, P1)
title({'Single-sided FFT for the Test Signal - Bilinear Butterworth Filter'; ...
       'Composed with Hamming Windows with 25% Overlap'}, 'FontSize', 15);
xlabel('Frequency (Hz)', 'FontSize', 15);
ylabel('Amplitude', 'FontSize', 15);
saveas(gcf,'TestSignalHammingBilinearButterworthFilter.png');

Y = fft(X_Chev1_Hamm);
L = length(X_Chev1_Hamm);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f, P1)
title({'Single-sided FFT for the Test Signal - Bilinear Chebyshev Type I Filter'; ...
       'Composed with Hamming Windows with 25% Overlap'}, 'FontSize', 15);
xlabel('Frequency (Hz)', 'FontSize', 15);
ylabel('Amplitude', 'FontSize', 15);
saveas(gcf,'TestSignalHammingBilinearChev1Filter.png');

Y = fft(X_Chev2_Hamm);
L = length(X_Chev2_Hamm);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f, P1)
title({'Single-sided FFT for the Test Signal - Bilinear Chebyshev Type II Filter'; ...
       'Composed with Hamming Windows with 25% Overlap'}, 'FontSize', 15);
xlabel('Frequency (Hz)', 'FontSize', 15);
ylabel('Amplitude', 'FontSize', 15);
saveas(gcf,'TestSignalHammingBilinearChev2Filter.png');

Y = fft(X_Ellip_Hamm);
L = length(X_Ellip_Hamm);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f, P1)
title({'Single-sided FFT for the Test Signal - Bilinear Elliptic Filter'; ...
       'Composed with Hamming Windows with 25% Overlap'}, 'FontSize', 15);
xlabel('Frequency (Hz)', 'FontSize', 15);
ylabel('Amplitude', 'FontSize', 15);
saveas(gcf,'TestSignalHammingBilinearEllipticFilter.png');