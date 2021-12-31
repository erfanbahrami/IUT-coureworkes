clc 
clear all
close all

I = im2double(imread('IUT_H4.bmp'));
I = H4_Shadow(I, 10, 10);


