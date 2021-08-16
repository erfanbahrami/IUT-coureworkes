/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 2020-10-19
Author  : 
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/
#include <mega16.h>
#include <string.h>
#include <delay.h>
#include <Subroutines.h>

// Alphanumeric LCD functions
#include <alcd.h>

// Declare your global variables here

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
    PORTC.0 = 1;
    Subroutine_3();
}

void main(void)
{
init();

while (1)
      {
            Subroutine_1();
            Subroutine_2();
            lcd_puts("use keypad:  ");
            lcd_putchar(Subroutine_3());
            delay_ms(1000);
            Subroutine_5();
            lcd_clear();
      }
}
