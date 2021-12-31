function Out = H4_Shadow (I, s, d)

    Kernel = fspecial('gaussian', [s*2+1, s*2+1], d);
    Kernel(s+1:2*s+1, 1:2*s+1) = 0;
    Kernel(1:s*2+1, s+1:s*2+1) = 0;
    Out = 0.4*I + 0.6*imfilter(I, Kernel, 'symmetric');
    
    subplot(1, 2, 1)
    imshow(I);
    title('Original Image');

    subplot(1, 2, 2)
    imshow(Out, []);
    title('Shadowed Image');

end