% This function receives a vector of fundamental frequencies over a time
% period and returns the difference in frequency from each fundamental
% frequency and the closest pitch. It assumes the data in DataFrequencies
% its uniformly distributed, which means that each data point represents
% the date for equal time windows.
% Input:
%     - DataFrequencies: Vector corresponding to the fundamental
%     frequencies
% Output:
%     - DeltaFreq: Vector corresponding to the difference in frequency
%     values and its closest pitch
function DeltaFreq = deltaFreqCalc(DataFrequencies)
    % Pitch Values Considered: All notes in the human vocal range ignoring
    % semitones
    DataPitch = [28, 31, 33, 37, 41, 44, 49, 55, 61, 65, 73,82, 87, 98, ...
                110, 123, 131, 147, 165, 175, 196, 220, 247, 262, 294,  ...
                330, 349, 392, 440, 494, 523, 587, 659, 698, 784, 880,  ...
                988, 1047, 1175, 1319, 1397, 1568, 1760];
                
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
    DeltaFreq = zeros(PitchesxSegments(1), 1);
    for k = 1:PitchesxSegments(2)
        DeltaFreq(k) = FreqDifference(idx(k), k);
    end
end