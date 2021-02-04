% Function that upsamples data fixed to certaint values. It extends each
% data point in the vector Data by UpSize times. This means that the same
% data point will be repeated  UpSize times.
function DataResampled = squareUpSampler(Data, UpSize)
    DataResampled = zeros(UpSize, 1);
    diff = floor(1 + UpSize/length(Data));
    for k = 1:UpSize
        DataResampled(k) = Data(floor(1 + k/diff));
    end
end