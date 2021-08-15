#include <mega16.h>
#include <delay.h>
#include <stdio.h>

#define portA 1
#define portB 2
#define portC 3
#define portD 4
void Subroutine_1(int number , char selectPort , int time)
{
    int counter = 0;
    delay_ms(500);
    switch (selectPort)
    {
        case(portA):
        DDRA = 0xFF;
        for (counter = 0; counter < number; counter++) 
        {
            PORTA = 0xFF;
            delay_ms(time);
            PORTA = 0x00;
            delay_ms(time);
        }
        break;
        
        case(portB):
        DDRB = 0xFF;
        for (counter = 0; counter < number; counter++) 
        {
            PORTB = 0xFF;
            delay_ms(time);
            PORTB = 0x00;
            delay_ms(time);
        }
        break;
        
        case(portC):
        DDRC = 0xFF;
        for (counter = 0; counter < number; counter++) 
        {
            PORTC = 0xFF;
            delay_ms(time);
            PORTC = 0x00;
            delay_ms(time);
        }
        break;
        
        case(portD):
        DDRD = 0xFF;
        for (counter = 0; counter < number; counter++) 
        {
            PORTD = 0xFF;
            delay_ms(time);
            PORTD = 0x00;
            delay_ms(time);
        }
        break;
        
        default:
        printf("Out of range");
        break;
    }    
}

void Subroutine_2(int location , int time)
{
    int counter = location-1;
    int d = (time / ( 8 - location ));
    DDRB = 0xFF;
    while ( counter < 8 )
    {
        PORTB |= 1 << counter;   
        delay_ms(d);
        PORTB &= ~(1 << counter);
        counter++;   
    }  
}

void Subroutine_3(char select_input , char select_output)
{
    int value;
    switch(select_input) 
    {
        case(portA):
            DDRA = 0x00; value = PINA; break;
        
        case(portB):
            DDRB = 0x00; value = PINB; break;
            
        case(portC):
            DDRC = 0x00; value = PINC; break;
            
        case(portD):
            DDRD = 0x00; value = PIND; break;
            
        default:
            printf("out of range");
            break;
    }
    
    switch(select_output) 
    {
        case(portA):
            DDRA = 0xFF; PORTA = value; break;
        
        case(portB):
            DDRB = 0xFF; PORTB = value; break;
            
        case(portC):
            DDRC = 0xFF; PORTC = value; break;
            
        case(portD):
            DDRD = 0xFF; PORTD = value; break;
            
        default:
            printf("out of range");
            break;
    }
}

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