function Out = H4_hybrid(I, J, m, n)

    Kernel = fspecial ('gaussian', [15, 15], m);
    Kernel2 = fspecial ('gaussian', [15, 15], n);
    I = imfilter(I, Kernel);
    J = J - 0.1*imfilter(J, Kernel2);
    Out = 0.5*I+0.5*J;
    
    subplot(1, 3, 1)
    imshow(I);
    title('Low Frequency Image');

    subplot(1, 3, 3)
    imshow(J, []);
    title('High Frequency Image');
    
    subplot(1, 3, 2)
    imshow(Out, []);
    title('Hybrid Image');
    
end