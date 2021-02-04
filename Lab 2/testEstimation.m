close all;
clear all;
clc;

% Pitch values for Human Voice
pitch_values = [82, 87, 98, 110, 123, 131, 147, 165, 175, 196, 220, 247, ...
                262, 294, 330, 349, 392, 440, 494, 523, 587, 659, 698, 784, ...
                880, 988, 1047, 1177, 1319, 1397, 1568, 1760];

% Recorder: Single channel, 16 bits per sample, 44.1 kHz sample rate for
% audio device 1.
% Fs = 44100;
% recObj = audiorecorder(Fs, 16, 1, 1);

% Record L sec audio 
% L = 3;
% disp('Start speaking.')
% recordblocking(recObj, L);
% disp('End of Recording.');

% Get audio data and plot
% y = getaudiodata(recObj);
% sound(song, fs)

Voice = song;
Fs = fs;
L = length(Voice)/Fs;

t0 = 0:1/Fs:L-1/Fs;
subplot(3, 3, 1);
plot(t0, Voice);
title('Audio Signal');
xlabel("Time (s)");

% Spectrogram calculated over audio signal y
subplot(3, 3, 2);
NWin = round(0.08 * Fs);
NOv = round(NWin * 0.5);
NDFT = max(Fs, 2^nextpow2(NWin));
colormap('jet');
spectrogram(Voice,         ...
            hamming(NWin), ...
            NOv,           ...
            NDFT,          ...
            Fs,            ...
            'yaxis');
axis([0 inf 0 1.8]);
title('Spectrogram of Audio Recorded Signal');

% Short-time Fourier Transform
subplot(3, 3, 3);
stft(Voice, Fs,...
    'Window', hamming(NWin),...
    'OverlapLength', NOv,...
    'FFTLength', NDFT,...
    'Centered', false)
[s, f, t1] = stft(Voice, Fs,...
                'Window', hamming(NWin),...
                'OverlapLength', NOv,...
                'FFTLength', NDFT,...
                'Centered', false);
axis([0 inf 0 1.8]);
% Fundamental Frequencies per Time Segment Identifier
[~, idx] = max(s);
data_freqs = f(idx);
data_freqs(data_freqs > 22050) = 44100 - data_freqs(data_freqs > 22050);

% Ignore inconsistent Frequencies
data_freqs_adjusted = data_freqs;
data_freqs_adjusted(data_freqs < 25) = 0;
% data_freqs_adjusted(data_freqs > 22050) = 44100 - data_freqs_adjusted(data_freqs > 22050);
data_freqs_adjusted(data_freqs > 1800) = 0;

% Plot Fundamental Frequencies
subplot(3, 3, 4);
stairs(t1, data_freqs_adjusted)
title('Fundamental Frequency Level Calculated with STFT');
xlabel("Time (s)");
ylabel('Pitch (Hz)');
    
subplot(3, 3, 5);
[Frequencies, t] = pitchEstimation(Voice, Fs);
stairs(t, Frequencies)
title('Fundamental Frequency Level Calculated with Spectrogram');
xlabel("Time (s)");
ylabel('Pitch (Hz)');

subplot(3, 3, 6);
[f0, loc] = pitch(Voice, Fs, ...
                 'Method', 'PEF', ...
                 'Range', [70 1800], ...
                 'WindowLength', round(Fs * 0.08), ...
                 'OverlapLength', round(Fs * 0.05));
t = loc/Fs;
stairs(t, f0)
title('Fundamental Frequency Level Pitch Function PEF');
xlabel("Time (s)");
ylabel('Pitch (Hz)');

subplot(3, 3, 7);
[f0, loc] = pitch(Voice, Fs, ...
                 'Method', 'NCF', ...
                 'Range', [70 1800], ...
                 'WindowLength', round(Fs * 0.08), ...
                 'OverlapLength', round(Fs * 0.05));
t = loc/Fs;
stairs(t, f0)
title('Fundamental Frequency Level with Pitch Function NCF');
ylabel('Pitch (Hz)')
xlabel('Time (s)')

subplot(3, 3, 8);
[f0, loc] = pitch(Voice, Fs, ...
                 'Method', 'CEP', ...
                 'Range', [70 1800], ...
                 'WindowLength', round(Fs * 0.08), ...
                 'OverlapLength', round(Fs * 0.05));
t = loc/Fs;
stairs(t, f0)
title('Fundamental Frequency Level with Pitch Function CEP');
ylabel('Pitch (Hz)')
xlabel('Time (s)')

subplot(3, 3, 9);
[f0, loc] = pitch(Voice, Fs, ...
                 'Method', 'LHS', ...
                 'Range', [70 1800], ...
                 'WindowLength', round(Fs * 0.08), ...
                 'OverlapLength', round(Fs * 0.05));
t = loc/Fs;
stairs(t, f0)
title('Fundamental Frequency Level with Pitch Function LHS');
ylabel('Pitch (Hz)')
xlabel('Time (s)')
% pause
% saveas(gcf,'TestBase.png')






