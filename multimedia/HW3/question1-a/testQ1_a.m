clc
clear all
close all

Image = uint8(imread('2.tif'));

K = hist_median(Image);

