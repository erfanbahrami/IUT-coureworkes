/*
 * 3.c
 *
 * Created: 2020-10-11 3:41:22 AM
 * Author: KPS
 */

#include <mega16.h>
#include <stdio.h>

#define portA 1
#define portB 2
#define portC 3
#define portD 4

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
void main(void)
{
while (1)
    {
    // Please write your application code here
        Subroutine_3(1,2);
        break;
    }
}
