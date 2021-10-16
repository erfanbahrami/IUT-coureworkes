function Question4(Image)

    % Resize Original Image with Resizing factor = 0.8 with 3 Algorithm
    Nearest_Image = imresize(Image, 0.8, 'nearest');
    Bilinear_Image = imresize(Image, 0.8, 'bilinear');
    Biqubic_Image = imresize(Image, 0.8, 'bicubic');

    % Resize Prevois Images to Original Size
    Nearest_Image = imresize(Nearest_Image, 1.25, 'nearest');
    Bilinear_Image = imresize(Bilinear_Image, 1.25, 'bilinear');
    Biqubic_Image = imresize(Biqubic_Image, 1.25, 'bicubic');

    % Compare Reconstruct Image with Original Image
    Nearest_MSE_Result = HW1_MSE (Image, Nearest_Image);
    Bilinear_MSE_Result = HW1_MSE (Image, Bilinear_Image);
    Biqubic_MSE_Result = HW1_MSE (Image, Biqubic_Image);

    imshow(Nearest_Image);
    title(['Nearest MSE = ' num2str(Nearest_MSE_Result)]);

    figure
    imshow(Bilinear_Image);
    title(['Bilinear MSE = ' num2str(Bilinear_MSE_Result)]);

    figure
    imshow(Biqubic_Image);
    title(['Biqubic MSE = ' num2str(Biqubic_MSE_Result)]);

end

