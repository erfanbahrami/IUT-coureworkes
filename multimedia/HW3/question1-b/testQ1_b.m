clc
clear all
close all

Image1 = uint8(imread('1.tif'));
Image2 = uint8(imread('2.tif'));

K1 = hist_median(Image1,3);
K2 = hist_median(Image2,3);
