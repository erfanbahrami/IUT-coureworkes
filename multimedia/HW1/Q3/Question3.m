clc
clear all
close all

Image = uint8(imread ('Hi.tif'));
[row col] = size(Image);

Darker_Image = Image - 20; % Subtract 20 from Pixels of Image

MSE_Result1 = HW1_MSE (Image, Darker_Image)

% _______________________________________________________________________________________________________________

Right_Shifted = uint8(zeros(row, col));
Left_Shifted = uint8(zeros(row, col));
    
Right_Shifted(:, 3:col, :) = Image(:, 1:col-2, :);  % Shif Pixels 2 unit to the Right
Right_Shifted(:, 1:2, :) = Image(:, col-1:col, :);
    
Left_Shifted(:, 1:col-2, :) = Image(:, 3:col, :);  % Shif Pixels 2 unit to the Left
Left_Shifted(:, col-1:col, :) = Image(:, 1:2, :);

Mean_Image = (Image + Right_Shifted + Left_Shifted)/3; % Average of Original Image, Left Shifted Image and Right Shifted Image

MSE_Result2 = HW1_MSE (Image, Mean_Image)
