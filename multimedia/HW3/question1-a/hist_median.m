function Out = hist_median(Image)

    [CDF, Histogram] = hist_cdf(Image);
    
     Cut = CDF(256, 1)/2;
     T0 = 0;
     for i=1: 1: 256
         if CDF(i, 1) >= Cut
             T0 = i;
             break;
         end
     end
     
     Cut = CDF(T0, 1)/2;
     T01 = 0;
     for i=1: 1: T0
         if CDF(i, 1) >= Cut
             T01 = i;
             break;
         end
     end
     
     Cut = ((CDF(256, 1) - CDF(T0, 1))/2) + CDF(T0);
     T02 = 0;
     for i=T01+1: 1: 256
         if CDF(i, 1) >= Cut
             T02 = i;
             break;
         end
     end

     [Row, Col] = size(Image);
     Out = uint8(zeros(Row, Col));
     
     for i=1: 1: Row
         for j=1: 1: Col
            if Image(i, j) <= T0
                Out(i, j) = (T0+T01)/2;
            elseif Image(i, j) <= T01
                Out(i, j) = T01/2;
            elseif Image(i, j) <= T02
                Out(i ,j) = (T02+T0)/2;
            else
                Out(i, j) = (255+T02)/2;
            end
         end
     end
    
    SJ64=uint8(Out./64);
    BJ64=SJ64.*64;

    imshow(Out, []);
    title(['T01 : ' num2str(T01) '          T0 : ' num2str(T0) '          T02 : ' num2str(T02) ]);
    figure
    imshow(BJ64, []);
    title(['simple quantized']);

end