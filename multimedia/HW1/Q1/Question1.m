function Question1 (Input_Image)

    [row, col, dim] = size(Input_Image);
    Horizental_Flipped = uint8(zeros(row, col, dim));
    Transpose = uint8(zeros(col, row, dim));
    Croped= uint8(zeros(uint16(col/2), uint16(row/2), dim));
    Right_Shifted = uint8(zeros(row, col, dim));
    Left_Shifted = uint8(zeros(row, col, dim));
    Up_Shifted = uint8(zeros(row, col, dim));
    Down_Shifted = uint8(zeros(row, col, dim));
    Diagonal_Up_Right = uint8(zeros(row, col, dim));
    Diagonal_Up_Left = uint8(zeros(row, col, dim));
    Diagonal_Down_Right = uint8(zeros(row, col, dim));
    Diagonal_Down_Left = uint8(zeros(row, col, dim));
    
    for i=1: 1: col
        Horizental_Flipped(:, i, :) = Input_Image(:, col-i+1, :); % Flipe Image Horizentaly
    end

    for i=1: 1: row
         Transpose(:, i, :) = Input_Image(i, :, :); % Transpose Image
    end

    for i=uint16(1+row/4): 1: uint16(3*row/4)
        for j=uint16(1+col/4): 1: uint16(3*col/4)
            Croped(uint16(i-row/4), uint16(j-col/4), :) = Input_Image(i, j, :); % Crop 25% of Image from Left, Right, Up and Down
        end
    end
    
    Down_Shifted(3:row, :, :) = Input_Image(1:row-2, :, :);  % Shif Pixels 2 unit to the Up
    Down_Shifted(1:2, :, :) = Input_Image(row-1:row, :, :);
    
    Up_Shifted(1:row-2, :, :) = Input_Image(3:row, :, :);  % Shif Pixels 2 unit to the Down
    Up_Shifted(row-1:row, :, :) = Input_Image(1:2, :, :);
    
    Right_Shifted(:, 3:col, :) = Input_Image(:, 1:col-2, :);  % Shif Pixels 2 unit to the Right
    Right_Shifted(:, 1:2, :) = Input_Image(:, col-1:col, :);
    
    Left_Shifted(:, 1:col-2, :) = Input_Image(:, 3:col, :);  % Shif Pixels 2 unit to the Left
    Left_Shifted(:, col-1:col, :) = Input_Image(:, 1:2, :);

    n=0;
    m=0;
    t=0;
    for i=1: 1: row
        for j=1: 1: col
            n=i;
            m=j;
            for k=1: 1: 2
                if n == 1 ||m == col
                   t=n;
                   n=m;
                   m=t;
                else
                    n = n - 1;
                    m = m + 1;
                end
            end
            
            Diagonal_Up_Right(i, j, :) = Input_Image(n, m, :); % Shift Pixels 2 unit Diagonal Top Right
        end
    end
    
    n=0;
    m=0;
    t=0;
    for i=1: 1: row
        for j=1: 1: col
            n=i;
            m=j;
            
            for k=1: 1: 2
                if n == row ||m == 1
                   t=n;
                   n=m;
                   m=t;
                else
                    n = n + 1;
                    m = m - 1;
                end
            end
            
            Diagonal_Down_Left(i, j, :) = Input_Image(n, m, :); % Shift Pixels 2 unit Diagonal Down Left
        end
    end
    
    n=0;
    m=0;
    t=0;
    for i=1: 1: row
        for j=1: 1: col
            n=i;
            m=j;            
            for k=1: 1: 2
                if n == 1 ||m == 1
                   t=n;
                   n=row-m+1;
                   m=col-t+1;
                else
                    n = n - 1;
                    m = m - 1;
                end
            end
            
            Diagonal_Up_Left(i, j, :) = Input_Image(n, m, :); % Shift Pixels 2 unit Diagonal Top Left
        end
    end
    
    n=0;
    m=0;
    t=0;
    for i=1: 1: row
        for j=1: 1: col
            n=i;
            m=j;
            for k=1: 1: 2
                if n == row ||m == col
                   t=n;
                   n=row-m+1;
                   m=col-t+1;
                else
                    n = n + 1;
                    m = m + 1;
                end
            end
            
            Diagonal_Down_Right(i, j, :) = Input_Image(n, m, :); % Shift Pixels 2 unit Diagonal Down Right
        end
    end
    
    
    subplot(2, 2, 1)
    imshow(Horizental_Flipped)
    title('Horizental Flipped');
    
    subplot(2, 2, 2)
    imshow(Transpose)
    title('Transpose');
    
    subplot(2, 2, 3)
    imshow(Croped)
    title('Croped');
    
    figure
    subplot(2, 2, 1)
    imshow(Right_Shifted)
    title('Right Shift');
    
    subplot(2, 2, 2)
    imshow(Left_Shifted)
    title('Left Shift');
    
    subplot(2, 2, 3)
    imshow(Up_Shifted)
    title('Up Shift');
    
    subplot(2, 2, 4)
    imshow(Down_Shifted)
    title('Down Shift');
    
    figure
    subplot(2, 2, 1)
    imshow(Diagonal_Up_Right)
    title('Diagonal Up Right');
    
    subplot(2, 2, 2)
    imshow(Diagonal_Down_Left)
    title('Diagonal Down Left');
    
    subplot(2, 2, 3)
    imshow(Diagonal_Up_Left)
    title('Diagonal Up Left');
    
    subplot(2, 2, 4)
    imshow(Diagonal_Down_Right)
    title('Diagonal Down Right');
    
    
end