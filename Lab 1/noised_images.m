function J = noised_images (Img, N, med, desv)
    J =[];
    for k = 1:N
        j = imnoise(Img,'gaussian', med, desv);
        J = [J j];
    end
end