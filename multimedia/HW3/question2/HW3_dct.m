function Out = HW3_dct(Image, K, T)

    [row, col] = size(Image);
     
    row = row + K - rem(row, K);
    col = col + K - rem(col, K);

    J = imresize(Image, [row, col]);    % Fit Size of the Image according to the K
    temp = uint8(zeros(K, K));
    Counter = 0;
    
    
    a=uint16(1);
    b=uint16(1);
    for i=1: K: row                        
        for j=1: K: col
            a=1;
            b=1;
            for m=i: 1: i+K-1           % devide image to K*K images
                for p=j: 1: j+K-1       
                    temp(a, b) = J(m, p); % local parts are stored in K*K image named "temp"
                    b=b+1;
                end
                a=a+1;
                b=1;
            end

            temp = dct2(temp);      % Calculate DCT Coefficients
            for r=1: 1: K
                for c=1: 1: K
                   if abs(temp(r, c)) < T  % Set Coefficients with value less than T to 0
                       temp(r,c) = 0;
                       Counter = Counter + 1;
                   end
                end
            end
            temp = uint8(idct2(temp));  % Calculate IDCT
               
            a=1;
            b=1;
            for m=i: 1: i+K-1
                for p=j: 1: j+K-1
                    Out(m, p) = temp(a, b);
                    b=b+1;
                end
                a=a+1;
                b=1;
            end
            
        end
    end
    
    subplot(1, 3, 1)
    imshow(J);
    title('Original');

    subplot(1, 3, 2)
    imshow(Out);
    title('after DCT');
    
    subplot(1, 3, 3)
    imshow(abs(J-Out),[]);
    title(['Difference (' num2str(Counter*100/(row*col)) ' % of Coefficients are Zero)']);
    psnr = PSNR(J, Out)

end