close all;
clear all;
clc;

Fs = 2000;                                  % Frecuencia de muestreo
deltaF = 100;                               % Diferencia de frecuencia

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

X_HF = X_H;
deltaFnorm = deltaF/Fs;
MBla = 5.5 / deltaFnorm;
M = MBla;                                   % Orden del filtro
L = (M-1)/2; 
for i = 1:3
Fc2 = 200*i;                                % Corte superior
Fc1 = Fc2 - deltaF;                         % Corte inferior

wc1 = (2*pi*Fc1)/(Fs);                      % Frecuenciad de corte wc1
wc2 = (2*pi*Fc2)/(Fs);                      % Frecuenciad de corte wc2


for n = 1:M
    if (n-1)-((M-1)/2)==0
        hd(n) = wc1/pi - wc2/pi + 1 ;       % Indeterminacion cuando es igual a 0
    else
        hd(n) = (1/((M-1)/2-(n-1))*pi)*(-sin(wc2*((M-1)/2-(n-1))) + sin(wc1*((M-1)/2-(n-1))) + sin(pi*((M-1)/2-(n-1))));
    end
    w(n) = 0.54 - 0.46*cos(2*pi*((n-1)/M)); % Ventana de Blackman
end

h = hd.*w; %Ventana resultande
%fvtool(h, 'Fs', Fs);
X_HF = conv(X_HF,h);
end

%% Metodo de ventana para Marimba %%
[y, Fs] = audioread('Marimba D major fun fair 75.mp3');
yf = y;
deltaFnorm = deltaF/Fs;
MBla = 5.5 / deltaFnorm;
M = MBla;                                   %O rden del filtro
L = (M-1)/2; 
Fc2 = 500;                                  % Corte superior
Fc1 = Fc2 - deltaF;                         % Corte inferior

wc1 = (2*pi*Fc1)/(Fs);                      % Frecuenciad de corte wc1
wc2 = (2*pi*Fc2)/(Fs);                      % Frecuenciad de corte wc2

for n = 1:M
    if (n-1)-((M-1)/2)==0
        hd(n) = wc1/pi - wc2/pi + 1 ;       % Indeterminacion cuando es igual a 0
    else
        hd(n) = (1/((M-1)/2-(n-1))*pi)*(-sin(wc2*((M-1)/2-(n-1))) + sin(wc1*((M-1)/2-(n-1))) + sin(pi*((M-1)/2-(n-1))));
    end
    w(n) = 0.54 - 0.46*cos(2*pi*((n-1)/M)); % Ventana de Blackman
end

h = hd.*w;                                  % Ventana resultande
% fvtool(h, 'Fs', Fs);
yf = conv(yf,h);
