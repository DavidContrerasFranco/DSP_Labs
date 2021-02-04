% This function receives an audio sample with its sampling frequency and
% return the adjusted to pitch (pitch shifted) audio by forcing a shift in
% the frequency columns using the circshift.
% Input:
%     - Sound: Audio sample
%     - Fs: Sampling Frequency of the audio
% Output:
%     - Sound_Shifted: Vector corresponding to the sound shifted.
%     - T: Vector corresponding to the time of the sound shifted.
function [Sound_Shifted, T] = forceShift(Sound, Fs)
    % Pitch Values Considered: All notes in the human vocal range ignoring
    % semitones
    DataPitch = [28, 31, 33, 37, 41, 44, 49, 55, 61, 65, 73,82, 87, 98, ...
                110, 123, 131, 147, 165, 175, 196, 220, 247, 262, 294,  ...
                330, 349, 392, 440, 494, 523, 587, 659, 698, 784, 880,  ...
                988, 1047, 1175, 1319, 1397, 1568, 1760];
            
    % Get STFT Data
    NWin = round(0.08 * Fs);
    NOv = round(NWin * 0.5);
    NDFT = max(Fs, 2^nextpow2(NWin));
    [SoundS, SoundF, ~] = stft(Sound, Fs,                    ...
                                    'Window', hamming(NWin), ...
                                    'OverlapLength', NOv,    ...
                                    'FFTLength', NDFT,       ...
                                    'Centered', false);

    % Fundamental Frequencies per Time Segment Identifier
    [~, idx] = max(SoundS);
    freqs = SoundF(idx);
    
    % Frequencies above the Nyquist Criterion are not coinsidered
    freqs(freqs > Fs/2) = Fs - freqs(freqs > Fs/2);

    % Ignore inconsistent Frequencies
    DataFrequencies = freqs;
    DataFrequencies(DataFrequencies < 27) = 0;
    DataFrequencies(DataFrequencies > 1800) = 0;
                
    % Change data and pitches into matrixes to be able to evaluate each
    % data point for each pitch frequency.
    DataFrequencies_Matrix  = DataFrequencies'.*ones(length(DataPitch), length(DataFrequencies));
    DataPitch_Matrix = DataPitch'.*ones(length(DataPitch), length(DataFrequencies));

    % Calculate the absolute difference between the pitch values
    % defined and the fundamental frequencies found ignoring difference
    % values where the fundamental frequency is too big or too small.
    FreqDifference = (DataPitch_Matrix - DataFrequencies_Matrix) .* (DataFrequencies ~= 0)';

    % Calculate position of the least absolute difference between each
    % frequency and each pitch value
    [~, idx] = min(abs(FreqDifference));

    % Select pitch closest to fundamental frequency per time segment
    PitchesxSegments = size(FreqDifference);
    
    % Shift frequency columns for the STFT Data using the circshift
    Shifted = SoundS;
    for k = 1:PitchesxSegments(2)
        Shifted(:,k) = circshift(SoundS(:,k), FreqDifference(idx(k), k));
    end
    
    % Calculates de Inverse STFT to return the data to the time domain
    [Sound_Shifted, T] = istft(Shifted, Fs,                  ...
                               'Window', hamming(NWin),      ...
                               'OverlapLength', NOv,         ...
                               'FFTLength', NDFT,            ...
                               'Centered', false);
end