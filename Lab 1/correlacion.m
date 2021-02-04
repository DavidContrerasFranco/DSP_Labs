% x , y are the vectors that contain the sequences in which the correlation will be applied
% x0, y0 are the moments zero for each sequence
% rang is the interval [-rang , rang] on which the correlation is calculated
% rnorm is the resulting normalized sequence
% The function plots r vs l between -rang and rang.

function [rnorm, rangs] = correlacion (x, x0, y, y0, rang)
    xlow = x(1:x0);
    ylow = y(1:y0);
    low_len = max(length(x(1:x0)), length(y(1:y0)));
    
    xhigh = x(x0+1:end);
    yhigh = y(y0+1:end);
    high_len = max(length(xhigh), length(yhigh));

    x = [zeros(1, low_len - length(xlow)) x zeros(1, high_len - length(xhigh))];
    y = [zeros(1, low_len - length(ylow)) y zeros(1, high_len - length(yhigh))];
    
    len = low_len + high_len;
    size_norm = 2*len;
    rnorm = zeros(1, size_norm + 1);

    mov_x = [zeros(1, len) x zeros(1, len)];
    for k = 1:size_norm
        start_x = size_norm + 1 - k;
        end_x = start_x + len - 1;

        rnorm(k) = sum(mov_x(start_x:end_x) .* y);
    end
    
    new_p0 = len + 2;
    rnorm = flip(rnorm);
    rnorm = rnorm(new_p0 - rang : new_p0 + rang);
    autoCorrXTheta = sum(abs(x).^2);
    autoCorrYTheta = sum(abs(y).^2);
    rnorm = rnorm./sqrt(autoCorrXTheta*autoCorrYTheta);
    rangs = -rang:rang;
end
