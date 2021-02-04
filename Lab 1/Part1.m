MuRuido = 0;
SigmaRuido = 0.05;
I = imread('Blink-182.png');
Im = im2double(I);
M = [5, 10, 20, 50, 100];

[ImPromOutput, PSNRvec] = imagPromedio(Im, M, MuRuido, SigmaRuido);
[rows, columns, numberOfColorChannels] = size(Im);

subplot(3, 3, 1);
stem(M, PSNRvec)
subplot(3, 3, 2);
imshow(Im)

for w = 1:length(M)
    subplot(3, 3, 2 + w);
    imshow(ImPromOutput(1:rows, (1:columns) + columns * (w - 1), 1:numberOfColorChannels))
end
