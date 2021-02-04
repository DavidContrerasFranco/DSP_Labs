% This functions shifts and audio signal by delta frequency using the
% complex exponential in the frequency domain.
% Input:
%     - DeltaFreq: Vector corresponding to the difference in frequency that
%     must be shifted.
%     - Sound: Audio sample
%     - Fs: Sampling Frequency of the audio
% Output:
%     - Sound_Shifted: Vector corresponding to the sound shifted.
%     - T: Vector corresponding to the time of the sound shifted.

function [Sound_Shifted, T] = frequencyShiftExpConv(DeltaFreq, Sound, Fs)
    % Calculate the time vector
    L = length(Sound)/Fs;
    T = 0:1/Fs:L-1/Fs;

    % UpSample DeltaFreq to match T vector length
    DeltaFreq_UpSampled = squareUpSampler(DeltaFreq, length(T));

    % Calculate the complex exponential for each delta freqeuncy in the
    % corresponding time unit. It is considred with twice the amplitude to
    % compensate later extracting the real part which ignores the sine
    % component of the complex exponential.
    DeltaFreq_Exp = exp(1j*2*pi*DeltaFreq_UpSampled.*T');
    
    % Get STFT Data
    NWin = round(0.08 * Fs);
    NOv = round(NWin * 0.5);
    NDFT = max(Fs, 2^nextpow2(NWin));
    [SoundS, ~, ~] = stft(Sound, Fs,               ...
                                    'Window', hamming(NWin), ...
                                    'OverlapLength', NOv,    ...
                                    'FFTLength', NDFT,       ...
                                    'Centered', false);
    [ExpS, ~, ~] = stft(DeltaFreq_Exp, Fs,                   ...
                              'Window', hamming(NWin),       ...
                              'OverlapLength', NOv,          ...
                              'FFTLength', NDFT,             ...
                              'Centered', false);

    % Shifts sound by doing the convolution between matrix SoundS and ExpS
    ConvSoundExp = conv2(SoundS, ExpS, 'same');
    
    % Calculates de Inverse STFT to return the data to the time domain
    [Sound_Shifted, T] = istft(ConvSoundExp, Fs,             ...
                               'Window', hamming(NWin),      ...
                               'OverlapLength', NOv,         ...
                               'FFTLength', NDFT,            ...
                               'Centered', false);
end