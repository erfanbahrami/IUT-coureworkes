/*
 * 1.c
 *
 * Created: 2020-10-11 2:54:29 AM
 * Author: KPS
 */

#include <mega16.h>
#include <delay.h>
#include <stdio.h>

#define portA 1
#define portB 2
#define portC 3
#define portD 4
void subroutine_1(int number , char selectPort , int time)
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
void main(void)
{
while (1)
    {
    // Please write your application code here
        subroutine_1(4,portB,500);
        break;
    }
}
