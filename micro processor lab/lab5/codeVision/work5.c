/*******************************************************
Project : Assignment 5
Version : 
Date    : 2020-10-28
Author  :  
Company : 
Comments: 
*******************************************************/

#include <headerFile.h>

char b=0;
char f;

interrupt [EXT_INT0] void ext_int0_isr(void)
{
    changeDutyCycle();
}

// Timer2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
    TCNT2=0x3D;
    b = b + 1;
    if (b==4)
    {   
        stepperMotorSignal();
        b = 0;
    }

}

void main(void)
{

    init();

    #asm("sei")
    
    b = 0x01;
    f = 1;
    while (1)
    { 
        flag = 1;
        lcd_clear();   
        lcd_puts("w=1 rps\nClockwise");
        delay_ms(3000);
        flag = 0;
        lcd_clear();   
        lcd_puts("w=0 rps");
        delay_ms(3000);
        flag = 2;
        lcd_clear();   
        lcd_puts("w=1 rps\nCounterclockwise ");
        delay_ms(3000);
        flag = 0;
        lcd_clear();   
        lcd_puts("w=0 rps");
        delay_ms(3000);        
    }
}
