clear all;
clc;
close all;
Fs = 2000;

% t is the Time Vector at frequency Fs
t = (0:1/Fs:0.6)';

% Signal composition
x_1 = sin(2*pi*150*t) + sin(2*pi*250*t);
x_2 = sin(2*pi*350*t) + sin(2*pi*450*t);
x_3 = sin(2*pi*550*t) + sin(2*pi*650*t);

% Hamming window to lower Gibbs Effect in the composed signal
Win_Size = 0.3;
Hm_W = padarray(hamming(round(Win_Size * Fs + 1)), (0.6 - Win_Size)*Fs, 0, 'post');
Hm_W_1 = delayseq(Hm_W, -0.05, Fs);
Hm_W_2 = delayseq(Hm_W, 0.15, Fs);
Hm_W_3 = delayseq(Hm_W, 0.35, Fs);
X_H = Hm_W_1.*x_1 + Hm_W_2.*x_2 + Hm_W_3.*x_3;

N=50; %Orden
deltaF = 100; %Diferencia de frecuencia
YfF = X_H;
for i = 1:3
Fc2 = 200*i; %Corte superior
Fc1 = Fc2 - deltaF; %Corte inferior
wc1 = Fc1/Fs*2;
wc2 = Fc2/Fs*2;
fpts=[0 wc1-0.02 wc1 wc2 wc2+0.02 1]; %Definicion de Frecuencias
mag=[1 1 0 0 1 1]; %Definicion de pesos
wt=[1 10 1]; % Error en las bandas
[b,err,RES] = firpm(N,fpts,mag,wt);
YfF = filter(b,1,YfF);
% fvtool(b, 1, 'Fs', Fs)
end

% Y_C = fft(YfF);
% L = length(YfF);
% P2 = abs(Y_C/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% f = Fs*(0:(L/2))/L;
% plot(f, P1) 
% title({'Transformada rapida de fourier para la señal filtrada'}, 'FontSize', 15);
% xlabel('Frequency (Hz)', 'FontSize', 15);
% ylabel('Amplitude', 'FontSize', 15);
% saveas(gcf,'filtradoCH.png');

[y, Fs] = audioread('Marimba D major fun fair 75.mp3');
yf = y;
Fc2 = 500; %Corte superior
Fc1 = Fc2 - deltaF; %Corte inferior
wc1 = Fc1/Fs*2;
wc2 = Fc2/Fs*2;
fpts=[0 wc1-0.0001 wc1 wc2 wc2+0.0001 1]; %Definicion de Frecuencias
mag=[1 1 0 0 1 1]; %Definicion de pesos
wt=[1 10 1]; % Error en las bandas
[b,err,RES] = firpm(N,fpts,mag,wt);
fvtool(b, 1, 'Fs', Fs)
yf = filter(b,1,yf);

Y_C = fft(yf);
L = length(yf);
P2 = abs(Y_C/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f, P1) 
title({'Transformada rapida de fourier para la señal filtrada'}, 'FontSize', 15);
xlabel('Frequency (Hz)', 'FontSize', 15);
ylabel('Amplitude', 'FontSize', 15);
saveas(gcf,'filtradoCH.png');

