/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 2020-10-04
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
#include <delay.h>
// Declare your global variables here

void Subroutine_5(void)
{
      char arr[] = {  0b00111111,      // 9  7_segment
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
      char arr2[] = { 0b10111111,     // 9  7_segment with dip points
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
      int number = 0 , counter = 0;     
      unsigned int a0 , a1, a2, a3;
      unsigned int b0 , b1 , b2 , b3;    
      number = PINA;
      number = number * 10;                   
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
                  number  = number - 2;
                  counter = 0;
            }
      }
}

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

while (1)
      {
      // Place your code here
        Subroutine_5();
      }
}
