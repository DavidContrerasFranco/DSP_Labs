close all;
clear all;
clc;
load FurElise.mat song fs

% Pitch values for Human Voice
values = {'A0', 'B0', 'C1', 'D1', 'E1', 'F1', 'G1', 'A1', 'B1', 'C2', ...
          'D2', 'E2', 'F2', 'G2', 'A2', 'B2', 'C3', 'D3', 'E3', 'F3', ...
          'G3', 'A3', 'B3', 'C4', 'D4', 'E4', 'F4', 'G4', 'A4', 'B4', ...
          'C5', 'D5', 'E5', 'F5', 'G5', 'A5', 'B5', 'C6', 'D6', 'E6', ...
          'F6', 'G6', 'A6'};
keys   = {  28,   31,   33,   37,   41,   44,   49,   55,   61,   65, ...
            73,   82,   87,   98,  110,  123,  131,  147,  165,  175, ...
           196,  220,  247,  262,  294,  330,  349,  392,  440,  494, ...
           523,  587,  659,  698,  784,  880,  988, 1047, 1175, 1319, ...
          1397, 1568, 1760};
pitch_map = containers.Map(keys, values);

pitch_values = [28, 31, 33, 37, 41, 44, 49, 55, 61, 65, 73,82, 87, 98, ...
                110, 123, 131, 147, 165, 175, 196, 220, 247, 262, 294, ...
                330, 349, 392, 440, 494, 523, 587, 659, 698, 784, 880, ...
                988, 1047, 1175, 1319, 1397, 1568, 1760];

Voice = song;
Fs = fs;
L = length(Voice)/Fs;

t0 = 0:1/Fs:L-1/Fs;

% Sound Plot
subplot(3, 3, 1);
plot(t0, Voice);
title('Audio Signal');
xlabel("Time (s)");

% Spectrogram calculated over audio signal
subplot(3, 3, 4);
colormap('jet');
NWin = round(0.08 * Fs);
NOv = round(NWin * 0.75);
NDFT = max(Fs, 2^nextpow2(NWin));
spectrogram(Voice,         ...
            hamming(NWin), ...
            NOv,           ...
            NDFT,          ...
            Fs,            ...
            'yaxis');
axis([0 inf 0 1.8]);
title('Spectrogram of Für Elise');
xlabel("Time (s)");
ylabel("Frequency (kHz)");

% Fundamental Frequencies per Time Segment Identifier
[data_freqs, t1] = pitchEstimation(Voice, Fs);

% Plot Fundamental Frequencies
subplot(3, 3, 2);
stairs(t1, data_freqs)
title('Fundamental Frequency Level Calculated with Spectrogram');
xlabel("Time (s)");
ylabel('Pitch (Hz)');
    
% Alternate Plot Fundamental Frequencies with Pitch function PEF
subplot(3, 3, 3);
[f0, loc] = pitch(Voice, Fs, ...
                 'Method', 'PEF', ...
                 'Range', [11 3999], ...
                 'WindowLength', round(Fs * 0.08), ...
                 'OverlapLength', round(Fs * 0.05));
t2 = loc/Fs;
stairs(t2, f0)
title('Fundamental Frequency Level Pitch Function PEF');
xlabel("Time (s)");
ylabel('Pitch (Hz)');

% Plot Fundamental Frequencies with Pitch Lines
subplot(3, 3, 5);
stairs(t1, data_freqs)
title('Fundamental Frequency Level Calculated with Spectrogram');
xlabel("Time (s)");
ylabel('Pitch (Hz)');
add_pitch_lines(data_freqs)
    
% Alternate Plot Fundamental Frequencies with Pitch function PEF with Pitch
% Lines
subplot(3, 3, 6);
stairs(t2, f0)
title('Fundamental Frequency Level Pitch Function PEF');
xlabel("Time (s)");
ylabel('Pitch (Hz)');
add_pitch_lines(f0)

% Differente in frequency to pitch values possible and voice recorded
% & closest pitch to such freqeuncy identifier.
    % Change data and pitches into matrixes to be able to evaluate each
    % data point for each pitch frequency.
diff_values_data  = data_freqs'.*ones(length(pitch_values), length(data_freqs));
diff_values_pitch = pitch_values'.*ones(length(pitch_values), length(data_freqs));

    % Calculate the absolute difference between the pitch values
    % defined and the fundamental frequencies found ignoring difference
    % values where the fundamental frequency is too big or too small.
diff_values = (diff_values_pitch - diff_values_data) .* (data_freqs ~= 0)';

    % Calculate position and difference between pitches and fundamental
    % frequencies found
[~, idx] = min(abs(diff_values));

    % Select pitch closest to fundamental frequency per time segment
PitchesxSegments = size(diff_values);
delta_freq = zeros(PitchesxSegments(1), 1);
for k = 1:PitchesxSegments(2)
    delta_freq(k) = diff_values(idx(k), k);
end

delta_freqs_resampled = squareUpSampler(delta_freq, length(t0));

    % Select pitches closest to 
closest_pitch = pitch_values(idx) .* (data_freqs ~= 0)';

delta_freq_exp = 2*cos(2*pi*delta_freqs_resampled.*t0');

Voice_Shifted = Voice.*delta_freq_exp;
            
% sound(Voice, Fs)
% pause
% sound(Voice_Shifted, Fs)

% Graph Spectrogram 
subplot(3, 3, 7);
spectrogram(Voice_Shifted, hamming(NWin), NOv, NDFT, Fs, 'yaxis');
axis([0 inf 0 1.8]);
title('Spectrogram of Audio Recorded Signal Shifted');
xlabel("Time (s)");
ylabel("Frequency (Hz)");

[shifted, t3] = pitchEstimation(Voice_Shifted, Fs);
subplot(3, 3, 8);
stairs(t3, shifted)
title({'Fundamental Frequency Level'; 'Calculated with Specgram'; 'Shifted'});
xlabel("Time (s)");
ylabel('Pitch (Hz)');
add_pitch_lines(shifted)

subplot(3, 3, 9);
[f0, loc] = pitch(Voice_Shifted, Fs, ...
                 'Method', 'PEF', ...
                 'Range', [11 3999], ...
                 'WindowLength', round(Fs * 0.08), ...
                 'OverlapLength', round(Fs * 0.05));
t4 = loc/Fs;
stairs(t4, f0)
title({'Fundamental Frequency Level'; 'Pitch Function PEF'; 'Shifted'});
xlabel("Time (s)");
ylabel('Pitch (Hz)');
add_pitch_lines(f0)
