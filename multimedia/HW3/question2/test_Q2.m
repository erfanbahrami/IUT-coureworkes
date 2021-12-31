clc
clear all
close all

Image1 = uint8(imread('1.tif'));
Image2 = uint8(imread('2.tif'));

K1 = HW3_dct(Image1, 8, 50);
figure
K2 = HW3_dct(Image2, 8, 50);