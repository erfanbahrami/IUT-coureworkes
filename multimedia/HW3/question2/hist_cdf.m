function [c, h] = hist_cdf (image)

    [row, col] = size(image);
    h = zeros(256, 1);
    c = zeros(256, 1);

    for i=1: 1: row
        for j=1: 1: col
            temp = image(i, j)+1;
            if(image(i, j) == 255)
                h(256, 1)= h(256, 1) + 1;   % Calculate histogram of the image and store it in h
            else
            h(temp, 1)= h(temp, 1) + 1;
            end
        end
    end
    
    c(1, 1) = h(1, 1);
    for i=2: 1: 256
        c(i, 1) = h(i, 1) + c(i-1, 1); % Calculate CDF using h(histogram of the image)
    end
end