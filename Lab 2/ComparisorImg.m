close all;
clear all;
clc;
figure('units','normalized','outerposition',[0 0 1 1])
load FurElise.mat song fs

Voice = song;
Fs = fs;
L = length(Voice)/Fs;

t = 0:1/Fs:L-1/Fs;
subplot(3, 3, 1)
plot(t, Voice);
title('Für Elise');
xlabel("Time (s)");
ylabel('Amplitude');

subplot(3, 3, 2)
colormap('jet');
NWin = round(0.08 * Fs);
NOv = round(NWin * 0.5);
NDFT = max(Fs, 2^nextpow2(NWin));
[s, f, t] = stft(Voice, Fs,...
                'Window', hamming(NWin),...
                'OverlapLength', NOv,...
                'FFTLength', NDFT,...
                'Centered', false);
stft(Voice, Fs,...
    'Window', hamming(NWin),...
    'OverlapLength', NOv,...
    'FFTLength', NDFT,...
    'Centered', false)
axis([0 inf 0 1.8]);
title('STFT - Für Elise');
xlabel("Time (s)");
ylabel("Frequency (kHz)");
axis([0 inf 0 1.8])

% Fundamental Frequencies per Time Segment Identifier
[data_freqs, t] = pitchEstimation(Voice, Fs);

% Plot Fundamental Frequencies
subplot(3, 3, 3)
stairs(t, data_freqs)
title({'Fundamental Frequency Level'; 'Calculated with STFT'});
xlabel("Time (s)");
ylabel('Pitch (Hz)');
add_pitch_lines(data_freqs)
    
% Alternate Plot Fundamental Frequencies with Pitch function PEF
subplot(3, 3, 4)
[f0, loc] = pitch(Voice, Fs, ...
                 'Method', 'PEF', ...
                 'Range', [11 3999], ...
                 'WindowLength', round(Fs * 0.08), ...
                 'OverlapLength', round(Fs * 0.05));
t = loc/Fs;
stairs(t, f0)
title({'Fundamental Frequency Level'; 'Pitch Function PEF'});
xlabel("Time (s)");
ylabel('Pitch (Hz)');
    
% Alternate Plot Fundamental Frequencies with Pitch function NCF
subplot(3, 3, 5)
[f0, loc] = pitch(Voice, Fs, ...
                 'Method', 'NCF', ...
                 'Range', [13 700], ...
                 'WindowLength', round(Fs * 0.08), ...
                 'OverlapLength', round(Fs * 0.05));
t = loc/Fs;
stairs(t, f0)
title({'Fundamental Frequency Level'; 'Pitch Function NCF'});
ylabel('Pitch (Hz)');
xlabel('Time (s)');
    
% Alternate Plot Fundamental Frequencies with Pitch function CEP
subplot(3, 3, 6)
[f0, loc] = pitch(Voice, Fs, ...
                 'Method', 'CEP', ...
                 'Range', [70 1800], ...
                 'WindowLength', round(Fs * 0.08), ...
                 'OverlapLength', round(Fs * 0.05));
t = loc/Fs;
stairs(t, f0)
title({'Fundamental Frequency Level'; 'Pitch Function CEP'});
ylabel('Pitch (Hz)');
xlabel('Time (s)');
    
% Alternate Plot Fundamental Frequencies with Pitch function LHS
subplot(3, 3, 7)
[f0, loc] = pitch(Voice, Fs, ...
                 'Method', 'LHS', ...
                 'Range', [2 700], ...
                 'WindowLength', round(Fs * 0.08), ...
                 'OverlapLength', round(Fs * 0.05));
t = loc/Fs;
stairs(t, f0)
title({'Fundamental Frequency Level'; 'Pitch Function LHS'});
ylabel('Pitch (Hz)');
xlabel('Time (s)');
    
% Alternate Plot Fundamental Frequencies with Pitch function SRH
subplot(3, 3, 8)
[f0, loc] = pitch(Voice, Fs, ...
                 'Method', 'SRH', ...
                 'Range', [2 250], ...
                 'WindowLength', round(Fs * 0.08), ...
                 'OverlapLength', round(Fs * 0.05));
t = loc/Fs;
stairs(t, f0)
title({'Fundamental Frequency Level'; 'Pitch Function SRH'});
ylabel('Pitch (Hz)');
xlabel('Time (s)');