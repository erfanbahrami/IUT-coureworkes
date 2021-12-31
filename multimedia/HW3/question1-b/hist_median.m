function Out = hist_median(Image,n)
n=2^n;
    [CDF, Histogram] = hist_cdf(Image);
    for i=1:n
        Cut = i*CDF(256, 1)/n;
        for j=1: 1: 256
         if CDF(j, 1) >= Cut
             T(1,i) = j;
             break;
         end
        end
    end


     [Row, Col] = size(Image);
     Immage=Image;
     Num=[0,T,255];
     Out = uint8(zeros(Row, Col));
     for i=1:Row
         for j=1:Col
             for k=1:n
              if( (k==1) && ( Immage(i,j)<T(1,1) ) )
                Out(i,j)=T(1,1)/2;
              end
              if((k==n) && (Immage(i,j)>T(1,n-1)))
                Out(i,j)=(255+T(1,n-1))/2;
              end
              if( (k~=n) && (k~=1) )
                if ((Immage(i,j)>T(1,k-1)) && ((Immage(i,j)<T(1,k))))
                   Out(i,j)=(T(1,k-1)+T(1,k))/2;
                end 
               end
             end
         end
     end
     
SJ64=uint8(Out./64);
BJ64=SJ64.*64;
     
figure;
 imshowpair(Out,BJ64,'montage');% 
end