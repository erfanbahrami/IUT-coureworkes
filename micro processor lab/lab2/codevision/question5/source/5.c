/*
 * 5.c
 *
 * Created: 2020-10-11 2:00:13 PM
 * Author: KPS
 */

#include <mega16.h>
#include <delay.h>

void Subroutine_5(float deghat)
{
      char arr[] = {    0b00111111,      // 9  7_segment
                        0b00000110,      // 8  7_segment
                        0b01011011,      // 7  7_segment
                        0b01001111,      // 6  7_segment
                        0b01100110,      // 5  7_segment
                        0b01101101,      // 4  7_segment
                        0b01111101,      // 3  7_segment
                        0b00000111,      // 2  7_segment
                        0b01111111,      // 1  7_segment
                        0b01101111       // 0  7_segment
                        };
      char arr2[] = {   0b10111111,      // 9  7_segment with dip points
                        0b10000110,      // 8  7_segment with dip points
                        0b11011011,      // 7  7_segment with dip points
                        0b11001111,      // 6  7_segment with dip points
                        0b11100110,      // 5  7_segment with dip points
                        0b11101101,      // 4  7_segment with dip points
                        0b11111101,      // 3  7_segment with dip points
                        0b10000111,      // 2  7_segment with dip points
                        0b11111111,      // 1  7_segment with dip points
                        0b11101111       // 0  7_segment with dip points
                        };
      int number = 0 , counter = 0 , deghat_10 = deghat*10;     
      unsigned int a0 , a1, a2, a3;
      unsigned int b0 , b1 , b2 , b3;    
      number = PINA;
      number = number * 10;  
      DDRA = 0x00000000;
      DDRD = 0b00001111;
      
      while (number >= 0) 
      { 
            a0 = number % 10;     
            b0 = number / 10;
            
            a1 = b0 % 10;         
            b1 = b0 / 10;
            
            a2 = b1 % 10;        
            b2 = b1 / 10;
            
            a3 = b2 % 10;        
            b3 = b2 / 10;
      
            PORTC = arr[a3];
            PORTD = 0b00001110; delay_ms(5);  PORTD = 0b00001111;
            
            PORTC = arr[a2];    
            PORTD = 0b00001101; delay_ms(5);  PORTD = 0b00001111;
            
            PORTC = arr2[a1];
            PORTD = 0b00001011; delay_ms(5);  PORTD = 0b00001111;
            
            PORTC = arr[a0];
            PORTD = 0b00000111; delay_ms(5);  PORTD = 0b00001111; 
      
            counter = counter + 1;
            if (counter == 20) 
            {  
                  number  = number - deghat_10;
                  counter = 0;
            }
      }                                         
}

    
void main(void)
{
while (1)
    {
    // Please write your application code here
        Subroutine_5(0.3);
        break;
    }
}
