/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 12/26/2016
Author  : 
Company : 
Comments: 


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>

// Standard Input/Output functions
#include <stdio.h>

// Declare your global variables here

void motor(int ML,int MR)
    {
    if(ML>=255)       ML=255;
    else if(ML<=-255) ML=-255;
    if(MR>=255)       MR=255;
    else if(MR<=-255) MR=-255;
    if(ML>0)
        {
        ////////////////////ML
        PORTB.5=1;
        PORTB.0=0;
        OCR1A=ML;
        }
    else if(ML<0)
        {
        ////////////////////ML
        PORTB.5=0;
        PORTB.0=1;
        OCR1A=-ML;
        } 
    else
        {
        ////////////////////ML
        PORTB.5=1;
        PORTB.0=1;
        OCR1A=255;
        }
    if(MR>0)
        {
        ////////////////////MR
        PORTB.6=1;
        PORTB.7=0;
        OCR1B=MR;
        }
    else if(MR<0)
        {
        ////////////////////MR
        PORTB.6=0;
        PORTB.7=1;
        OCR1B=-MR;
        } 
    else
        {
        ////////////////////MR
        PORTB.6=1;
        PORTB.7=1;
        OCR1B=255;
        }
    }
    
    
void main(void)
{
// Declare your local variables here
unsigned char buffer[200];
int cnt=0;
// Input/Output Ports initialization
// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0xFF;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTD=0x00;
DDRD=0xFF;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 125.000 kHz
// Mode: Fast PWM top=0x00FF
// OC1A output: Non-Inv.
// OC1B output: Non-Inv.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0xA1;
TCCR1B=0x0B;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=0x00;
UCSRB=0x18;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x33;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

while (1)
      {
      // Place your code here
      buffer[0]=getchar();
      if(buffer[0]=='F')        motor(100,-100);
      else if(buffer[0]=='R')   motor(100,0);
      else if(buffer[0]=='L')   motor(0,-100);
      else if(buffer[0]=='B')   motor(-100,100);
      else if(buffer[0]=='f')   motor(255,-255);
      else if(buffer[0]=='r')   motor(255,0);
      else if(buffer[0]=='l')   motor(0,-255);
      else if(buffer[0]=='b')   motor(-255,255);    
      else if(buffer[0]=='Z')   motor(-100,-100);
      else if(buffer[0]=='X')   motor(100,100);
      else if(buffer[0]=='S')   motor(0,0);
      }
}
