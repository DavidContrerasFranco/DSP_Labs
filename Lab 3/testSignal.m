close all;
clear;
clc;
figure('units','normalized','outerposition',[0 0 1 1])

% Fs is the sampling frequency
Fs = 5000;

% t is the Time Vector at frequency Fs
t = (0:1/Fs:0.6)';

% Signal composition
x_1 = sin(2*pi*150*t) + sin(2*pi*250*t);
x_2 = sin(2*pi*350*t) + sin(2*pi*450*t);
x_3 = sin(2*pi*550*t) + sin(2*pi*650*t);

% X_C is the test signal composed with rectangular windows
X_R = x_1.*(t >= 0 & t <= 0.2)   ...
    + x_2.*(t >= 0.2 & t <= 0.4) ...
    + x_3.*(t >= 0.4 & t <= 0.6);

plot(t, X_R)
title({'Test Signal'; 'Composed with Rectangular Windows'}, ...
       'FontSize', 15);
xlabel('Time (s)', 'FontSize', 15);
saveas(gcf,'TestSignalRectangular.png');

% FFT for test signal with rectangular window
Y_R = fft(X_R);
L = length(X_R);
P2 = abs(Y_R/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
plot(f, P1)
title({'Single-sided FFT for the Test Signal'; ...
       'Composed with Rectangular Windows'}, 'FontSize', 15);
xlabel('Frequency (Hz)', 'FontSize', 15);
ylabel('Amplitude', 'FontSize', 15);
saveas(gcf,'FFTTestSignalRectangular.png');

% Hamming window to lower Gibbs Effect in the composed signal
Win_Size = 0.3;
Hm_W = padarray(hamming(round(Win_Size * Fs + 1)), (0.6 - Win_Size)*Fs, 0, 'post');
Hm_W_1 = delayseq(Hm_W, -0.05, Fs);
Hm_W_2 = delayseq(Hm_W, 0.15, Fs);
Hm_W_3 = delayseq(Hm_W, 0.35, Fs);

plot(t, Hm_W_1); hold on
plot(t, Hm_W_2);
plot(t, Hm_W_3); hold off
title('Hamming Windows with 25% Overlap', 'FontSize', 15);
xlabel('Time (s)', 'FontSize', 15);
saveas(gcf,'HammingWindows.png');

% X_H is the test signal composed with hamming windows
X_H = Hm_W_1.*x_1 + Hm_W_2.*x_2 + Hm_W_3.*x_3;

plot(t, X_H)
title({'Test Signal'; ...
       'Composed with Hamming Windows with 25% Overlap'}, 'FontSize', 15);
xlabel('Time (s)', 'FontSize', 15);
saveas(gcf,'TestSignalHamming.png');

% FFT for test signal with hamming window
Y_C = fft(X_H);
L = length(X_H);
P2 = abs(Y_C/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
plot(f, P1)
title({'Single-sided FFT for the Test Signal'; ...
       'Composed with Hamming Windows with 25% Overlap'}, 'FontSize', 15);
xlabel('Frequency (Hz)', 'FontSize', 15);
ylabel('Amplitude', 'FontSize', 15);
saveas(gcf,'FFTTestSignalHamming.png');
