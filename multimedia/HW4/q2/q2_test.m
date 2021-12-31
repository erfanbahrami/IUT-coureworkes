clc 
clear all
close all

I = imread('Low.bmp');
J = imread('High.bmp');
K = H4_hybrid(I, J, 5, 10);