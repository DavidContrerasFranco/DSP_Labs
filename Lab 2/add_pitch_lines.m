% This functions add the pitch lines to a plot. Pitch lines is defined as
% an horizontla pointed line that represents the freqeuncy level at which
% such pitch is located. It add the pitches corresponding to the range in
% which the fundamental frequencies f0 are. Over such plot draws the pitch
% lines in range from one pith lower to the lowest fundamental frequencies
% ignoring the zero and one higher to the highest fundamental frequency in
% order to not draw pith lines not needed.
function add_pitch_lines(f0)
    % Pitch values considered
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
    
    % Lowest and highest fundamental frequency identifier
    min_F0 = min(f0(f0 >= 82));
    max_F0 = max(f0(f0 > 0));
    
    [~, min_Pitch] = max(pitch_values(pitch_values < min_F0));
    max_Pitch = find(pitch_values == min(pitch_values(pitch_values > max_F0)));
    
    pitch_values = pitch_values(min_Pitch:max_Pitch);
    
    % Pitch lines plot
    horizontalAlignment = containers.Map({0, 1}, {'left', 'right'});
    i = 0;
    for k = pitch_values
        i = i + 1;
        
        y1 = yline(k,':', pitch_map(k),                ...
                   'LabelVerticalAlignment', 'middle', ...
                   'LabelHorizontalAlignment', horizontalAlignment(mod(i, 2)));
        y1.FontSize = 6;
    end
end
    