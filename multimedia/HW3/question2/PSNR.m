function  out = PSNR (I, J)
    out = 10 * log10(1/HW1_MSE(I, J));
end