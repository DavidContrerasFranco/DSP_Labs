% Im is the image without noise
% M = [N1 Nj . . . Nz] is the vector that contains the 
% amount of times that the signale must be averaged.
% MuRuido is the mean of the noise.
% SigmaRuido is the std of the noise.
%
% ImPromOutput must contain z images resulting from averaging.
% PSNRvec is the vector with z values of peak signal to noise ratio
% PSNR of each of the output images from ImPromOutput.

function [ImPromOutput, PSNRvec] = imagPromedio(Im, M, MuRuido, SigmaRuido)
    [rows, columns, numberOfColorChannels] = size(Im);
    
    ImPromOutput = zeros(rows, columns*length(M), numberOfColorChannels);
    PSNRvec = zeros(1, length(M));
    
    for k = 1:length(M)
        promImg = imnoise(Im,'gaussian', MuRuido, SigmaRuido);
        
        for h = 1:(M(k) - 1)
            promImg = promImg + imnoise(Im,'gaussian', MuRuido, SigmaRuido);
        end
        
        promImg = promImg./M(k);
        peaksnr = psnr(promImg, Im);
        
        ImPromOutput(:, (1:columns) + (k - 1)*columns, :) = promImg;
        PSNRvec(k) = peaksnr;
    end
end
