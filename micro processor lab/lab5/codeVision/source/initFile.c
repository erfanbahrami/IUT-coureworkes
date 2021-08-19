#include <headerFile.h>

void ioInit(void)
{
    DDRA = 0x00;
    DDRB = 0xFF;  
    DDRC = 0xFF;
    DDRD = 0x00;
    
    PORTB=0X00;
}

void timer0Init(void)
{
    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: 7.813 kHz
    // Mode: Phase correct PWM top=0xFF
    // OC0 output: Non-Inverted PWM
    // Timer Period: 65.28 ms
    // Output Pulse(s):
    // OC0 Period: 65.28 ms Width: 32.768 ms
    TCCR0=(1<<WGM00) | (1<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
    TCNT0=0x00;
    OCR0=0x80;
}


void timer2Init(void)
{
    // Timer/Counter 2 initialization
    // Clock source: System Clock
    // Clock value: 7.813 kHz
    // Mode: Normal top=0xFF
    // OC2 output: Disconnected
    // Timer Period: 24.96 ms
    ASSR=0<<AS2;
    TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (1<<CS22) | (1<<CS21) | (1<<CS20);
    TCNT2=0x3D;
    OCR2=0x00;

}

void interruptsInit(void)
{
    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

    // External Interrupt(s) initialization
    // INT0: On
    // INT0 Mode: Falling Edge
    // INT1: Off
    // INT2: Off
    GICR|=(0<<INT1) | (1<<INT0) | (0<<INT2);
    MCUCR=(0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
    MCUCSR=(0<<ISC2);
    GIFR=(0<<INTF1) | (1<<INTF0) | (0<<INTF2);
}

void lcdInit(void)
{
    // Alphanumeric LCD initialization
    // Connections are specified in the
    // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
    // RS - PORTC Bit 0
    // RD - PORTC Bit 1
    // EN - PORTC Bit 2
    // D4 - PORTC Bit 4
    // D5 - PORTC Bit 5
    // D6 - PORTC Bit 6
    // D7 - PORTC Bit 7
    // Characters/line: 16
    lcd_init(16);
}

void init(void)
{
    ioInit();   
    timer0Init();  
    timer2Init();
    interruptsInit();
    lcdInit();
}
