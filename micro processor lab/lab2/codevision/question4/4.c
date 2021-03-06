/*
 * 4.c
 *
 * Created: 2020-10-11 12:54:36 PM
 * Author: KPS
 */

#include <mega16.h>
#include <stdio.h>
#include <delay.h>

void Subroutine_4(char incDec , char syncAsinc)
{
    int counter = 0 , which;
    char array[] = {    0b00111111,      // 9  7_segment
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
    DDRC = 0xFF;
    DDRD = 0xFF;
    switch(syncAsinc) 
    {
		case(0):            // 0 for Synchronous 
            PORTD.0 = 0; PORTD.1 = 0; PORTD.2 = 0; PORTD.3 = 0; 
			switch(incDec) 
            {
				case(0):    // 0 for increasing
				    for (counter = 0; counter < 10; counter++) 
                    {
						PORTC = array[counter];
						delay_ms(1000);
					}
					break;
        
				case(1):    // 1 for decreasing
					for (counter = 9; counter >= 0; counter--) 
                    {
						PORTC = array[counter];
						delay_ms(1000);
					}
					break;
            
				default:
                    printf("Error");    
					break;
			}
			break;
            
        case(1):	        // 1 for Asynchronous
			switch(incDec) 
            {
				PORTD.0 = 1; PORTD.1 = 1; PORTD.2 = 1; PORTD.3 = 1;
                which = 0;
				case(0):    // 0 for increasing
					for (counter = 0; counter < 10; counter++) 
                    {
                        if (which == 4)
							which = 0;
                            
						PORTD &= ~(1 << which);   
						PORTC = array[counter];
						delay_ms(1000);
						PORTD |= 1 << which;    
						
						which++;
					}
					break;
        
				case(1):     // 1 for decreasing
					for (counter = 9; counter >= 0; counter--) 
                    {
                        if (which == 4)
							which = 0;
                            
						PORTD &= ~(1 << which);    
						PORTC = array[counter];
						delay_ms(1000);
						PORTD |= 1 << which;    
						
						which++;	
					}
					break;
            
				default:    
                    printf("Error");    
					break;
			}
			break;
	}	                            
}
void main(void)
{
while (1)
    {
    // Please write your application code here
        Subroutine_4(1 , 0);
    }
}
