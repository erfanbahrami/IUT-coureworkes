function out = hw2_local_histeq(image, n)

    [row, col] = size(image);
    temp = uint8(zeros(n, n));
    
    a=uint16(1);
    b=uint16(1);
    for i=1: n: row                        
        for j=1: n: col
            a=1;
            b=1;
            for m=i: 1: i+n-1           % devide image to n*n images
                for p=j: 1: j+n-1       
                    if m>row || p>col   % Zero padding
                        temp(a, b) = 0;
                    else
                       temp(a, b) = image(m, p); % local parts are stored in n*n image named "temp"
                    end
                    b=b+1;
                end
                a=a+1;
                b=1;
            end

            temp = hw2_histeq(temp);    % Using prevoius section function for equalization the histogram of the local parts
            
            a=1;
            b=1;
            for m=i: 1: i+n-1
                for p=j: 1: j+n-1
                    if m <= row && p <= col
                        image(m, p) = temp(a, b); % replace local parts of Original image with equalized parts 
                    end
                    b=b+1;
                end
                a=a+1;
                b=1;
            end
            
        end
    end

    out = image;
    
end