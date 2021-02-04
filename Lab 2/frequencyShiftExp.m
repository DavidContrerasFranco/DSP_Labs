% This functions shifts and audio signal by delta frequency using the
% complex exponential in the time domain.
% Input:
%     - DeltaFreq: Vector corresponding to the difference in frequency that
%     must be shifted.
%     - Sound: Audio sample
%     - Fs: Sampling Frequency of the audio
% Output:
%     - Sound_Shifted: Vector corresponding to the sound shifted.

function Sound_Shifted = frequencyShiftExp(DeltaFreq, Sound, Fs)
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

    % Shifts sound by multiplying the original sound with the complex
    % exponential calculated
    Sound_Shifted = Sound.*DeltaFreq_Exp;
end