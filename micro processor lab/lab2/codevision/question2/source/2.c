/*
 * 2.c
 *
 * Created: 2020-10-11 3:25:38 AM
 * Author: KPS
 */

#include <mega16.h>
#include <delay.h>

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


void main(void)
{
while (1)
    {
    // Please write your application code here
        Subroutine_2(3 , 3000);
        break;
    }
}
