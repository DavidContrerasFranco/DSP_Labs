close all;
clear;
clc;
figure('units','normalized','outerposition',[0 0 1 1])

% Audio signal
[y, Fs] = audioread('Marimba D major fun fair 75.mp3');

t = 0:1/Fs:(length(y) - 1)/Fs;
plot(t, y)
title('Audio Signal', 'FontSize', 15);
xlabel('Time (s)', 'FontSize', 15);
saveas(gcf,'AudioSignal.png');

Harmonic = HighestIdentifierAyalaContreras(y, Fs);

Y = fft(y);
L = length(y);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f, P1)
axis([0 1300 0 0.03])
title('Single-sided FFT for the Audio Signal', 'FontSize', 15);
xlabel('Frequency (Hz)', 'FontSize', 15);
ylabel('Amplitude', 'FontSize', 15);
saveas(gcf,'FFTAudioSignal.png');

% Attenuation parameters
Rp = 1;     % Passband
Rs = 40;	% Stopband

% Frequencies for the filters
    % Component 150, 350, 550 Hz
F_s = [Harmonic - 5, Harmonic + 5];
F_p = [Harmonic - 30, Harmonic + 30];

% Butterworth
X_Butter_Song_B = songIIR_AyalaContreras(F_s, F_p, y, Fs, Rp, Rs, @buttord, @bilinear);
X_Butter_Song_I = songIIR_AyalaContreras(F_s, F_p, y, Fs, Rp, Rs, @buttord, @impinvar);

% Chebyshev Type I
X_Chev1_Song_B = songIIR_AyalaContreras(F_s, F_p, y, Fs, Rp, Rs, @cheb1ord, @bilinear);
X_Chev1_Song_I = songIIR_AyalaContreras(F_s, F_p, y, Fs, Rp, Rs, @cheb1ord, @impinvar);

% Chebyshev Type II
X_Chev2_Song_B = songIIR_AyalaContreras(F_s, F_p, y, Fs, Rp, Rs, @cheb2ord, @bilinear);
X_Chev2_Song_I = songIIR_AyalaContreras(F_s, F_p, y, Fs, Rp, Rs, @cheb2ord, @impinvar);

% Elliptic
X_Ellip_Song_B = songIIR_AyalaContreras(F_s, F_p, y, Fs, Rp, Rs, @ellipord, @bilinear);
X_Ellip_Song_I = songIIR_AyalaContreras(F_s, F_p, y, Fs, Rp, Rs, @ellipord, @impinvar);

Y = fft(X_Butter_Song_B);
L = length(X_Butter_Song_B);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f, P1)
axis([0 1300 0 0.03])
title('Single-sided FFT for the Audio Signal - Bilinear Butterworth Filter', 'FontSize', 15);
xlabel('Frequency (Hz)', 'FontSize', 15);
ylabel('Amplitude', 'FontSize', 15);
saveas(gcf,'AudioSignalBilinearButterworthFilter.png');

Y = fft(X_Chev1_Song_B);
L = length(X_Chev1_Song_B);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f, P1)
axis([0 1300 0 0.03])
title('Single-sided FFT for the Audio Signal - Bilinear Chebyshev Type I Filter', 'FontSize', 15);
xlabel('Frequency (Hz)', 'FontSize', 15);
ylabel('Amplitude', 'FontSize', 15);
saveas(gcf,'AudioSignalBilinearChev1Filter.png');

Y = fft(X_Chev2_Song_B);
L = length(X_Chev2_Song_B);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f, P1)
axis([0 1300 0 0.03])
title('Single-sided FFT for the Audio Signal - Bilinear Chebyshev Type II Filter', 'FontSize', 15);
xlabel('Frequency (Hz)', 'FontSize', 15);
ylabel('Amplitude', 'FontSize', 15);
saveas(gcf,'TestSignalRectangularBilinearChev2Filter.png');

Y = fft(X_Ellip_Song_B);
L = length(X_Ellip_Song_B);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f, P1)
axis([0 1300 0 0.03])
title('Single-sided FFT for the Test Signal - Bilinear Elliptic Filter', 'FontSize', 15);
xlabel('Frequency (Hz)', 'FontSize', 15);
ylabel('Amplitude', 'FontSize', 15);
saveas(gcf,'AudioSignalBilinearEllipticFilter.png');

Y = fft(X_Butter_Song_I);
L = length(X_Butter_Song_I);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f, P1)
axis([0 1300 0 0.03])
title('Single-sided FFT for the Audio Signal - Impulse Invariance Butterworth Filter', 'FontSize', 15);
xlabel('Frequency (Hz)', 'FontSize', 15);
ylabel('Amplitude', 'FontSize', 15);
saveas(gcf,'AudioSignalImpInvButterworthFilter.png');

Y = fft(X_Chev1_Song_I);
L = length(X_Chev1_Song_I);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f, P1)
axis([0 1300 0 0.03])
title('Single-sided FFT for the Test Signal - Impulse Invariance Chebyshev Type I Filter', 'FontSize', 15);
xlabel('Frequency (Hz)', 'FontSize', 15);
ylabel('Amplitude', 'FontSize', 15);
saveas(gcf,'AudioSignalImpInvChev1Filter.png');

Y = fft(X_Chev2_Song_I);
L = length(X_Chev2_Song_I);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f, P1)
axis([0 1300 0 0.03])
title('Single-sided FFT for the Audio Signal - Impulse Invariance Chebyshev Type II Filter', 'FontSize', 15);
xlabel('Frequency (Hz)', 'FontSize', 15);
ylabel('Amplitude', 'FontSize', 15);
saveas(gcf,'AudioSignalImpInvChev2Filter.png');

Y = fft(X_Ellip_Song_I);
L = length(X_Ellip_Song_I);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f, P1)
axis([0 1300 0 0.03])
title('Single-sided FFT for the Audio Signal - Impulse Invariance Elliptic Filter', 'FontSize', 15);
xlabel('Frequency (Hz)', 'FontSize', 15);
ylabel('Amplitude', 'FontSize', 15);
saveas(gcf,'AudioSignalImpInvEllipticFilter.png');
