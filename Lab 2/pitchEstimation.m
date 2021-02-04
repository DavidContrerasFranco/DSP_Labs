% This function receives an audio sample and returns a vector corresponding
% to the fundamental frequencies of the audio sample. It uses the STFT with
% a Hamming Window of 80 ms and a 75% Overlaping.
% Input:
%     - Sound: Audio sample
%     - Fs: Sampling Frequency of the audio
% Output:
%     - Frequencies: Vector corresponding to the fundamental frequencies of
%     the audio sample at each time window of 80 ms.
%     - t: Vector representing the time in the audio for each fundamental
%     frequency in the Frequencies vector.

function [Frequencies, t] = pitchEstimation(Sound, Fs)
    % Get STFT Data
    NWin = round(0.08 * Fs);
    NOv = round(NWin * 0.5);
    NDFT = max(Fs, 2^nextpow2(NWin));
    [s, f, t] = stft(Sound, Fs,              ...
                    'Window', hamming(NWin), ...
                    'OverlapLength', NOv,    ...
                    'FFTLength', NDFT,       ...
                    'Centered', false);

    % Fundamental Frequencies per Time Segment Identifier
    [~, idx] = max(s);
    freqs = f(idx);
    
    % Frequencies above the Nyquist Criterion are not coinsidered
    freqs(freqs > Fs/2) = Fs - freqs(freqs > Fs/2);

    % Ignore inconsistent Frequencies
    Frequencies = freqs;
    Frequencies(Frequencies < 27) = 0;
    Frequencies(Frequencies > 1800) = 0;
end