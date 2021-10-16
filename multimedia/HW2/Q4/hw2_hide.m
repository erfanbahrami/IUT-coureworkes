function [WaterMarked, UnWaterMarked] = hw2_hide(image, logo, L)

    [row, col] = size(image);
    WaterMarked = uint8(zeros(row, col));
    UnWaterMarked = logical(zeros(row, col));
    
    logo = imresize(logo, size(image)); % Set the size of logo the same as cover image size
    BW = dither(logo);  % make logo image black/white
    
    for i=1: 1: row
        for j=1: 1: col
            WaterMarked(i, j) = bitset(image(i, j), L, BW(i, j)); % take logo bit in the L th bit of the cover image
        end
    end
    
    for i=1: 1: row
        for j=1: 1: col
            UnWaterMarked(i, j) = bitget(WaterMarked(i, j), L); % extract bits of logo image from cover image
        end
    end
    
    mse = HW1_MSE(image, WaterMarked)
    imshow([image WaterMarked]);
    title(['1-Cover Image         2-WaterMarked Image                MSE : ' num2str(mse)]);
    

end