/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 1/7/2017
Author  : 
Company : 
Comments: 


Chip type               : ATmega16A
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega16a.h>
#include <delay.h>
#include <math.h>
// Graphic Display functions
#include <glcd.h>

// Font used for displaying text
// on the graphic display
#include <font5x7.h>

// Declare your global variables here
int i,j,cnt1=0,x=50,y=20,cntx=2,cnty=3,cntx1=3,cnty1=2,cnt2=0,x1,y1,x2,y2,x3,y3,x4=10,y4=10,cnt6=0,cnt7=0,cnt8=0;
float cnt3=4.71239,cnt4=4.71239,cnt5=4.71239;


void main(void)
{
// Declare your local variables here
// Variable used to store graphic display
// controller initialization data
GLCDINIT_t glcd_init_data;

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
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

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
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
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Graphic Display Controller initialization
// The PCD8544 connections are specified in the
// Project|Configure|C Compiler|Libraries|Graphic Display menu:
// SDIN - PORTC Bit 0
// SCLK - PORTC Bit 1
// D /C - PORTC Bit 2
// /SCE - PORTC Bit 3
// /RES - PORTC Bit 4

// Specify the current font for displaying text
glcd_init_data.font=font5x7;
// No function is used for reading
// image data from external memory
glcd_init_data.readxmem=NULL;
// No function is used for writing
// image data to external memory
glcd_init_data.writexmem=NULL;
// Set the LCD temperature coefficient
glcd_init_data.temp_coef=PCD8544_DEFAULT_TEMP_COEF;
// Set the LCD bias
glcd_init_data.bias=PCD8544_DEFAULT_BIAS;
// Set the LCD contrast control voltage VLCD
glcd_init_data.vlcd=PCD8544_DEFAULT_VLCD;

glcd_init(&glcd_init_data);

while (1)
      {
      // Place your code here
//      glcd_putcharxy(10,10,'F');
      if(PINA.1 == 0) 
        {
        cnt2++;
        delay_ms(300);   
        glcd_clear();
        }      
      cnt2%=4;
      if (cnt2 == 0)
          {        
          glcd_clear();
          glcd_fillcircle(x,y,5);
          glcd_fillcircle(x4,y4,5);
          glcd_rectangle(0,0,84,48);
          if (x < 6 || x > 78) cntx*=-1;
          if (y < 6 || y > 42) cnty*=-1;   
          if (x4 < 6 || x4 > 78) cntx1*=-1;
          if (y4 < 6 || y4 > 42) cnty1*=-1;   
          if (x-x4<10 && y-y4<10 && x-x4>-10 && y-y4>-10)
            {
            cntx*=-1;
            cntx1*=-1;
            }
          x+=cntx;
          y+=cnty; 
          x4+=cntx1;
          y4+=cnty1;
          }
      else if (cnt2 == 1)
        {
        PORTB.0=1;
        delay_us(10);
        PORTB.0=0;
        cnt1=0;
        while(PINA.0==0);
        while(PINA.0==1)
            {
            cnt1++;
            delay_us(1);
            }   
        cnt1/=22; 
        glcd_outtextxy(10,0,"Distance:");
        glcd_putcharxy(13,20,((cnt1/100)%10+'0'));
        glcd_putcharxy(20,20,((cnt1/10)%10+'0'));
        glcd_putcharxy(27,20,((cnt1/1)%10+'0'));
        glcd_outtextxy(33,20,"cm");
        } 
      else if (cnt2 == 2)
        {
        glcd_clear();    
        if (cnt3 >=11)
            {
            cnt4+=0.10472;
            cnt7++;
            cnt3 = 4.71239;
            }             
        if (cnt4 >=11)
            {
            cnt5+=0.523599;  
            cnt8++;
            cnt4 = 4.71239;
            } 
        glcd_circle(62,24,20);
        y1=sin(cnt3)*15;
        x1=cos(cnt3)*15; 
        y2=sin(cnt4)*12;
        x2=cos(cnt4)*12;
        y3=sin(cnt5)*8;
        x3=cos(cnt5)*8;
        glcd_line( 62,24, 62 + x1, 24 + y1); 
        glcd_line( 62,24, 62 + x2, 24 + y2); 
        glcd_line( 62,24, 62 + x3, 24 + y3);  
        cnt6%=60;
        cnt7%=60;
        cnt8%=12;
        glcd_putcharxy(0,0,((cnt8/10)%10+'0'));
        glcd_putcharxy(6,0,((cnt8/1)%10+'0'));
        glcd_putcharxy(12,0,':');
        glcd_putcharxy(16,0,((cnt7/10)%10+'0'));
        glcd_putcharxy(22,0,((cnt7/1)%10+'0'));
        glcd_putcharxy(28,0,':');   
        glcd_putcharxy(32,0,((cnt6/10)%10+'0'));
        glcd_putcharxy(38,0,((cnt6/1)%10+'0'));
        delay_ms(1000);
        cnt3+=0.10472;                         
        cnt6++;    
        }
      }
}
