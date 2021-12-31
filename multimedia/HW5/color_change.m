function Out = color_change(I, W, new_color)

    new_color = [50, 50, 255];
    
    Out = I;
    imshow(I);
    [Col, Row] = ginput(1);
    Col = round(Col);
    Row = round(Row);
    hold on;
    plot(Col,Row,'xg','MarkerSize',20,'LineWidth',2);

    old_color = I(Row, Col, :);

    [row, col, dim] = size(I);
    for i=1 : 1: row
        for j=1: 1: col
           if I(i, j, 1) >= old_color(1) - W && I(i, j, 1) <= old_color(1) + W && I(i, j, 2) >= old_color(2) - W && I(i, j, 2) <= old_color(2) + W && I(i, j, 3) >= old_color(3) - W && I(i, j, 3) <= old_color(3) + W
              Out(i, j, :) = new_color;
           end        
        end
    end
    
    new_color
    imshow(Out);
end

