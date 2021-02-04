close all;
clear all;
clc;
load FurElise.mat song fs

Voice = song;
Fs = fs;

% STFT calculated over audio signal
subplot(2, 3, 1);
colormap('jet');
NWin = round(0.08 * Fs);
NOv = round(NWin * 0.5);
NDFT = max(Fs, 2^nextpow2(NWin));
stft(Voice, Fs,...
    'Window', hamming(NWin),...
    'OverlapLength', NOv,...
    'FFTLength', NDFT,...
    'Centered', false)
axis([0 inf 0 1.8]);
title('STFT - Für Elise');
xlabel("Time (s)");
ylabel("Frequency (kHz)");

% Fundamental Frequencies per Time Segment Identifier
[data_freqs, t0] = pitchEstimation(Voice, Fs);

% Plot Fundamental Frequencies
subplot(2, 3, 2);
stairs(t0, data_freqs)
title({'Fundamental Frequency Level'; 'Calculated with STFT'});
xlabel("Time (s)");
ylabel('Pitch (Hz)');
add_pitch_lines(data_freqs)
    
% Alternate Plot Fundamental Frequencies with Pitch function PEF
subplot(2, 3, 3);
[f0, loc] = pitch(Voice, Fs, ...
                 'Method', 'PEF', ...
                 'Range', [11 3999], ...
                 'WindowLength', round(Fs * 0.08), ...
                 'OverlapLength', round(Fs * 0.05));
t1 = loc/Fs;
stairs(t1, f0)
title({'Fundamental Frequency Level'; 'Pitch Function PEF'});
xlabel("Time (s)");
ylabel('Pitch (Hz)');
add_pitch_lines(f0)

% Delta Frequency Calculator
delta_freq = deltaFreqCalc(data_freqs);

% Voice Shifter with Exponential Algorithm
[Voice_Shifted, T] = frequencyShiftExpConv(delta_freq, Voice, Fs);
            
% sound(Voice, Fs)
% pause
% sound(real(Voice_Shifted), Fs)

% Graph STFT 
subplot(2, 3, 4);
stft(Voice_Shifted, Fs,...
    'Window', hamming(NWin),...
    'OverlapLength', NOv,...
    'FFTLength', NDFT,...
    'Centered', false)
axis([0 inf 0 1.8]);
title('STFT - Für Elise Shifted');
xlabel("Time (s)");
ylabel("Frequency (kHz)");

[shifted, t2] = pitchEstimation(Voice_Shifted, Fs);
subplot(2, 3, 5);
stairs(t2, shifted)
title({'Fundamental Frequency Level'; 'Calculated with STFT Shifted'});
xlabel("Time (s)");
ylabel('Pitch (Hz)');
add_pitch_lines(shifted)

subplot(2, 3, 6);
[f0, loc] = pitch(Voice_Shifted, Fs, ...
                 'Method', 'PEF', ...
                 'Range', [11 3999], ...
                 'WindowLength', round(Fs * 0.08), ...
                 'OverlapLength', round(Fs * 0.05));
t3 = loc/Fs;
stairs(t3, f0)
title({'Fundamental Frequency Level'; 'Pitch Function PEF Shifted'});
xlabel("Time (s)");
ylabel('Pitch (Hz)');
add_pitch_lines(f0)