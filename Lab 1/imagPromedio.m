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
    ImPromOutput = [];
    PSNRvec = [];
    
    [rows, columns, numberOfColorChannels] = size(Im);
    
    for k = M
        J = noised_images (Im, k, MuRuido, SigmaRuido);
        promImg = J(1:rows, 1:columns, 1:numberOfColorChannels);

        for h = 1:(k - 1)
            promImg = promImg + J(1:rows, (1:columns) + columns*h, 1:numberOfColorChannels);
        end
        
        promImg = promImg./k;
        peaksnr = psnr(promImg, Im);
        
        ImPromOutput = [ImPromOutput promImg];
        PSNRvec = [PSNRvec peaksnr];
    end
end
