/*
 * 6.c
 *
 * Created: 2020-10-11 2:33:20 PM
 * Author: KPS
 */

#include <mega16.h>
#include <delay.h>
#include <stdio.h>
#include <all_of_subroutins.h>

#define portA 1
#define portB 2
#define portC 3
#define portD 4


void main(void)
{
while (1)
    {
        Subroutine_1(4, portB, 500);
	    Subroutine_2(3, 3000);
	    Subroutine_3(portA, portB);
	    Subroutine_4(0, 1);
	    Subroutine_5(0.3);
    }
}
