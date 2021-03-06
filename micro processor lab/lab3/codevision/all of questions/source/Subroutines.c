#include <mega16.h>
#include <delay.h>
#include <alcd.h>
#include <string.h>
// ba komak az site https://www.electronicwings.com/avr-atmega/4x4-keypad-interfacing-with-atmega1632
#define KEY_PRT        PORTB
#define KEY_DDR        DDRB
#define KEY_PIN        PINB

void init ( void )
{
    // Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: On
// INT1 Mode: Rising Edge
// INT2: Off
GICR|=(1<<INT1) | (0<<INT0) | (0<<INT2);
MCUCR=(1<<ISC11) | (1<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);
GIFR=(1<<INTF1) | (0<<INTF0) | (0<<INTF2);

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTA Bit 0
// RD - PORTA Bit 1
// EN - PORTA Bit 2
// D4 - PORTA Bit 4
// D5 - PORTA Bit 5
// D6 - PORTA Bit 6
// D7 - PORTA Bit 7
// Characters/line: 16
lcd_init(16);

// Global enable interrupts
#asm("sei")
}

void Subroutine_1(void)
{
      lcd_gotoxy(0, 0);
      lcd_puts("Erfan Bahrami");
      lcd_gotoxy(0, 1);
      lcd_puts("9624513");
      delay_ms(3000);
}

void Subroutine_2(void)
{
        char string[] = "Welcome to the online lab classes due to Corona disease.";
        char show[16];
         //  char show2[] = "---------------";
        int counter = 0;
        delay_ms(500);
        for(counter = 0; counter<strlen(string); counter++) 
        {
            lcd_gotoxy(0, 1);
            strncpy(show, &string[counter], 16);
         //   lcd_gotoxy(0, 0);
         //   lcd_puts(show2);
            lcd_puts(show);
            delay_ms(200);
            lcd_clear();
        }
}
unsigned char Subroutine_3(void)
{
        unsigned char col, row , temp;
        unsigned char array[4][4] = {   {'0','1','2','3'},
                                        {'4','5','6','7'},
                                        {'8','9','A','B'},
                                        {'C','D','E','F'}};   
        KEY_DDR = 0xf0;
        KEY_PRT = 0xff;
        /*  check for columns */ 
        do {
            KEY_PRT = 0xff;
            col= (KEY_PIN & 0x0f);
        } while (col != 0x00);
     
        do {
            KEY_PRT = 0xff;
            col= (KEY_PIN & 0x0f);
        } while (col == 0x00); 
            
        do {
            do {
                  delay_ms(20);
                  col = (KEY_PIN & 0x0f);
            } while (col == 0x00);
            
            delay_ms(20);
            col = (KEY_PIN & 0x0f);
            
        } while (col == 0x00);
        
        /* now check for rows */
        while(1) 
        {
                KEY_PRT = 0x1f;
                col = (KEY_PIN & 0x0f);
                if (col != 0x00) 
                {
                    row=0;
                    break;
                }
            
                KEY_PRT = 0x2f;
                col = (KEY_PIN & 0x0f);
                if (col != 0x00) 
                {
                    row=1;
                    break;
                }
            
                KEY_PRT = 0x4f;
                col = (KEY_PIN & 0x0f);
                if (col != 0x00) 
                {
                    row=2; 
                    break;
                }
            
                KEY_PRT = 0x8f;
                col = (KEY_PIN & 0x0f);
                if (col != 0x00) 
                {
                    row=3;
                    break;
                }
      }
      
        if (col == 0x01)
                temp = (array[row][0]);
        else if (col == 0x02)
                temp =(array[row][1]);
        else if (col == 0x04)
                temp =(array[row][2]);
        else
                temp =(array[row][3]);  
        return temp ;
}

void Subroutine_5(void)
{
        unsigned char first_number, second_number , number;
        
         while(1)
        {   
                lcd_clear();
                lcd_gotoxy(0, 0);
                lcd_puts("Speed??(0-50)");
                lcd_gotoxy(0, 1);

                first_number = Subroutine_3();
                lcd_putchar(first_number);
                        
                second_number = Subroutine_3();
                lcd_putchar(second_number); 
                
                number = (int)(first_number)*10  +  (int)(second_number) ;
                delay_ms(500);

                if ( number >= 0 && number <=50 ) 
                {
                        
                        delay_ms(1500);
                        break;
                }
                else 
                {
                        lcd_clear();
                        lcd_gotoxy(0, 0);
                        lcd_puts("EE");
                        delay_ms(1500);
                }
      }
      
        while(1)
        {   
                lcd_clear();
                lcd_gotoxy(0, 0);
                lcd_puts("Time:??(0-99s)");
                lcd_gotoxy(0, 1);

                first_number = Subroutine_3();
                lcd_putchar(first_number);
                        
                second_number = Subroutine_3();
                lcd_putchar(second_number); 
                
                number = (int)(first_number)*10  +  (int)(second_number) ;
                delay_ms(500);

                if ( number >= 0 && number <=99 ) 
                {
                        lcd_putchar(first_number);
                        lcd_putchar(second_number);
                        delay_ms(1500);
                        break;
                }
                else 
                {
                        lcd_clear();
                        lcd_gotoxy(0, 0);
                        lcd_puts("EE");
                        delay_ms(1500);
                }
      }
       
      while(1)
        {   
                lcd_clear();
                lcd_gotoxy(0, 0);
                lcd_puts("Weigt:??(0-99F)");
                lcd_gotoxy(0, 1);

                first_number = Subroutine_3();
                lcd_putchar(first_number);
                        
                second_number = Subroutine_3();
                lcd_putchar(second_number); 
                
                number = (int)(first_number)*10  +  (int)(second_number) ;
                delay_ms(500);

                if ( number >= 0 && number <=99 ) 
                {
                        lcd_putchar(first_number);
                        lcd_putchar(second_number);
                        delay_ms(1500);
                        break;
                }
                else 
                {
                        lcd_clear();
                        lcd_gotoxy(0, 0);
                        lcd_puts("EE");
                        delay_ms(1500);
                }
      }
      
       while(1)
        {   
                lcd_clear();
                lcd_gotoxy(0, 0);
                lcd_puts("Temp:??(20-80C)");
                lcd_gotoxy(0, 1);

                first_number = Subroutine_3();
                lcd_putchar(first_number);
                        
                second_number = Subroutine_3();
                lcd_putchar(second_number); 
                
                number = (int)(first_number)*10  +  (int)(second_number) ;
                delay_ms(500);

                if ( number >= 20 && number <=80 ) 
                {
                        lcd_putchar(first_number);
                        lcd_putchar(second_number);
                        delay_ms(1500);
                        break;
                }
                else 
                {
                        lcd_clear();
                        lcd_gotoxy(0, 0);
                        lcd_puts("EE");
                        delay_ms(1500);
                }
      }
      
     
}
