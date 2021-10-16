function out = hw2_histeq(image)

    [row, col] = size(image);
    out = uint8(zeros(row, col));
    [C, H] = hist_cdf(image);       % using function written in previous section to calculate CDF of the image
    
    for i=1: 1: row
        for j=1: 1: col
            out(i, j) = uint8(C(image(i, j)+1)*255);    % replace pixels of the original image with equalized pixels 
        end
    end
end