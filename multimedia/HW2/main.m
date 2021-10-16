clc
clear all
close all

I = uint8(imread('Hi.tif'));
J = uint8(imread('iut.tif'));

% Question1 test
[c, h] = hist_cdf(I); 
subplot(2, 2, 1)
plot(h);
title('Histogram');
    
subplot(2, 2, 2)
plot(c);
title('CDF');




% Question2 test
E = hw2_histeq(I);
subplot(2, 2, 1)
imhist(I);
title('Original Image');
    
subplot(2, 2, 2)
imhist(E);
title('Equalized Image');




% Question3 test
E2 = hw2_local_histeq(I, 50);
subplot(2, 2, 1)
imhist(I);
title('Original Image');
    
subplot(2, 2, 2)
imhist(E2);
title('Localy Equalized Image');




% Question4 test
hw2_hide(I, J, 5);

