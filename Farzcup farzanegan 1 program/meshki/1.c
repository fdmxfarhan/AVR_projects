
/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.4 Standard
Automatic Program Generator
� Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 10/31/2015
Author  : 
Company : 
Comments: 


Chip type           : ATmega64
Program type        : Application
Clock frequency     : 11.059200 MHz
Memory model        : Small
External RAM size   : 0
Data Stack size     : 1024
*****************************************************/

#include <mega64.h>
#include <delay.h>
#include <stdio.h>

// I2C Bus functions
#asm
   .equ __i2c_port=0x12 ;PORTD
   .equ __sda_bit=1
   .equ __scl_bit=0
#endasm
#include <i2c.h>
eeprom int c;
//////////////////////////////////////////cmp
 #define EEPROM_BUS_ADDRESS 0xc0 
int cmp;
/* read a byte from the EEPROM */
unsigned char compass_read(unsigned char address) {
unsigned char data;
i2c_start();
i2c_write(EEPROM_BUS_ADDRESS);
i2c_write(address);
i2c_start();
i2c_write(EEPROM_BUS_ADDRESS | 1);
data=i2c_read(0);
i2c_stop();
return data;
}
#define KAF 400 

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x15 ;PORTC
#endasm
#include <lcd.h>

#define RXB8 1
#define TXB8 0
#define UPE 2
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART1 Receiver buffer
#define RX_BUFFER_SIZE1 8
char rx_buffer1[RX_BUFFER_SIZE1];

#if RX_BUFFER_SIZE1<256
unsigned char rx_wr_index1,rx_rd_index1,rx_counter1;
#else
unsigned int rx_wr_index1,rx_rd_index1,rx_counter1;
#endif

// This flag is set on USART1 Receiver buffer overflow
bit rx_buffer_overflow1;
   int t=0;
// USART1 Receiver interrupt service routine
interrupt [USART1_RXC] void usart1_rx_isr(void)
{
char status,data;
status=UCSR1A;
data=UDR1;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer1[rx_wr_index1]=data;
   if (++rx_wr_index1 == RX_BUFFER_SIZE1) rx_wr_index1=0;
   if (++rx_counter1 == RX_BUFFER_SIZE1)
      {
      rx_counter1=0;
      rx_buffer_overflow1=1;
      };
   };
  if (data=='1'){
   lcd_gotoxy(12,1);
   lcd_putchar('1'); 
   t=1;
   }
   else    if (data=='2'){
   lcd_gotoxy(12,1);
   lcd_putchar('2');  
   t=2;
   }
     else    if (data=='3'){
   lcd_gotoxy(12,1);
   lcd_putchar('3'); 
   t=3;
   }
   else    if (data=='4'){
   lcd_gotoxy(12,1);
   lcd_putchar('4');  
   t=4;
   }
   else if (data=='5'){ 
      lcd_gotoxy(12,1);
   lcd_putchar('5');
   t=5;
   }  
      else if (data=='6'){ 
      lcd_gotoxy(12,1);
   lcd_putchar('6');
   t=6;
   }
      else if (data=='7'){ 
      lcd_gotoxy(12,1);
   lcd_putchar('7');
   t=7;
   }
      else if (data=='8'){ 
      lcd_gotoxy(12,1);
   lcd_putchar('8');
   t=8;
   }
      else if (data=='9'){ 
      lcd_gotoxy(12,1);
   lcd_putchar('9');
   t=9;
   }  
      else if (data=='o'){ 
      lcd_gotoxy(12,1);
   lcd_putchar('o');
   t=10;
   }
    else {
   lcd_gotoxy(12,1);
   lcd_putchar('n');
   t=0;}
 }

// Get a character from the USART1 Receiver buffer
#pragma used+
char getchar1(void)
{
char data;
while (rx_counter1==0);
data=rx_buffer1[rx_rd_index1];
if (++rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
#asm("cli")
--rx_counter1;
#asm("sei")
return data;
}
#pragma used-
// Write a character to the USART1 Transmitter
#pragma used+
void putchar1(char c)
{
while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
UDR1=c;
}
#pragma used-

#include <delay.h>

#define ADC_VREF_TYPE 0x40

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}

// Declare your global variables here
void motor(int ML1,int ML2,int MR2,int MR1){
#asm("cli") ;
#asm("wdr");  

if(ML1<-255) ML1=-255;
if(ML2<-255) ML2=-255;
if(MR1<-255) MR1=-255;
if(MR2<-255) MR2=-255;

if(ML1>255) ML1=255;
if(ML2>255) ML2=255;
if(MR1>255) MR1=255;
if(MR2>255) MR2=255;
/////////////////////////////////
if(ML1>=0){
PORTD.7=0;
OCR2=ML1;
#asm("wdr");
}
else if(ML1<0){
PORTD.7=1;
OCR2=ML1;
#asm("wdr");
}



     /////////////////////////
if(ML2>=0){
PORTD.6=0;
OCR1B=ML2;
#asm("wdr");
}
else if(ML2<0){
PORTD.6=1;
OCR1B=ML2;
#asm("wdr");
}

   /////////////////////////
if(MR1>=0){
PORTD.4=0;
OCR0=MR1;
#asm("wdr");
}
else if(MR1<0){
PORTD.4=1;
OCR0=MR1;
#asm("wdr")
}

 ////////////////////////
 if(MR2>=0){
PORTD.5=0;
OCR1A=MR2;
#asm("wdr");
}
else if(MR2<0){
PORTD.5=1;
OCR1A=MR2;
#asm("wdr");
} 
#asm("sei") ; 
}




int SL,SR,SB,RL=0,sum=0;
      void sharp(){
      #asm("cli") ;
      #asm("wdr") ;
      SB=read_adc(5);
      SR=read_adc(4);
      SL=read_adc(3);
       
       lcd_gotoxy(13,1);
      lcd_putchar((SR/100)%10+'0');
      lcd_putchar((SR/10)%10+'0');
      lcd_putchar((SR/1)%10+'0');
//        lcd_gotoxy(8,0);
//      lcd_putchar((SB/100)%10+'0');
//      lcd_putchar((SB/10)%10+'0');
//      lcd_putchar((SB/1)%10+'0');
      
       lcd_gotoxy(8,1);
      lcd_putchar((SL/100)%10+'0');
      lcd_putchar((SL/10)%10+'0');
      lcd_putchar((SL/1)%10+'0');
       
        sum= SR+SL;
       RL=SR-SL;
       
       
       
       //       if(RL>0)
//       {
//       lcd_gotoxy(0,1);
//       lcd_putchar('+');
//       lcd_putchar((RL/100)%10+'0');
//       lcd_putchar((RL/10)%10+'0');
//       lcd_putchar((RL/1)%10+'0');
//                }
//               else  if(RL<0)
//               {
//       lcd_gotoxy(0,1);
//       lcd_putchar('-');
//       lcd_putchar((-RL/100)%10+'0');
//       lcd_putchar((-RL/10)%10+'0');
//       lcd_putchar((-RL/1)%10+'0');
//                }
      
       if(RL>-60 && RL<80) RL=0;

          else if(RL>80) RL=RL*1.25;
          else if(RL<-60) RL=RL;
         
        

      #asm("sei")  ;       
     } 


   int adc[16],min=0,i,kaf[16],mini=0,r=0,l=0,f=0,b=0,h=0,p=0,m=0;
      void sensor() {
       #asm("cli") ;
       #asm("wdr"); 
    for(i=0;i<16;i++)
     {
     #asm("wdr"); 
 PORTA.3=(i/8)%2;
 PORTA.2=(i/4)%2;
 PORTA.1=(i/2)%2;
 PORTA.0=(i/1)%2;
  adc[i]=read_adc(7);  
  kaf[i]=read_adc(6);
////////////////////////////////////////////////////////////moghayese  
  if (adc[i]<adc[min])
  {
    min=i; 
     }
  
   if (kaf[i]<kaf[mini])
   {

   mini=i;  }
  
}
   


  
if (adc[min]<900 && min!=0) {
h=(adc[min]+adc[min+1]+adc[min-1])/3;
if (h<100) m=9;
else  m=(h/100)%10 ;
}
else if (adc[min]>900 ) 
{
h=1023;
m=11;
}
else if (min==0 ){
h=(adc[0]+adc[1]+adc[15])/3;
if (h<100) m=9;
else  m=(h/100)%10 ;
}
 ///////////////////////////////////////////////////////////chap 
  lcd_gotoxy(0,0);
  lcd_putchar((min/10)%10+'0');
  lcd_putchar((min/1)%10+'0');
  lcd_putchar('=');
  lcd_putchar((h/1000)%10+'0');
  lcd_putchar((h/100)%10+'0');
  lcd_putchar((h/10)%10+'0');
  lcd_putchar((h/1)%10+'0');  
  lcd_gotoxy(11,1); 
  lcd_putchar(m +'0');   
  lcd_putchar((t/1)%10 +'0');
 
 lcd_gotoxy(8,0);
 lcd_putchar((l/1)%10 +'0');
 lcd_putchar((r/1)%10 +'0');
 lcd_putchar((f/1)%10 +'0');


 lcd_gotoxy(0,1);
  lcd_putchar((mini/10)%10+'0');
  lcd_putchar((mini/1)%10+'0');
  lcd_putchar('=');
  lcd_putchar((kaf[mini]/1000)%10+'0');
  lcd_putchar((kaf[mini]/100)%10+'0');
  lcd_putchar((kaf[mini]/10)%10+'0');
  lcd_putchar((kaf[mini]/1)%10+'0');

      if ( (kaf[13]<KAF || kaf[12]<KAF || kaf[15]<KAF || kaf[14]<KAF)  && b==0  && l == 0 && r == 0  && f == 0)  l=1; 
      else  if ((kaf[0]<KAF || kaf[1]<KAF || kaf[2]<KAF || kaf[3]<KAF) && b==0  && l == 0 && r == 0 && f == 0) r=1; 
      else if((kaf[10]<KAF || kaf[9]<KAF || kaf[8]<KAF) && f==0 && b==0 && r==0 && l==0) f=1;
      else if ((kaf[4]<KAF || kaf[5]<KAF || kaf[6]<KAF ) && f==0 && b==0 && r==0 && l==0) b=1;
   }



      void follow ()
    { 
          #asm("wdr");  
        if(min==0 ) 
        { 
            motor(255+cmp,255+cmp,-255+cmp,-255+cmp);                                                
          }                                         
         
         else if(min==1) 
         {
             motor(255+cmp,0+cmp,-255+cmp,0+cmp); 
          }
           //motor(255,128,-255,-128);
         else if(min==2)     motor(255+cmp,-255+cmp,-255+cmp,255+cmp);     //motor(255,0,-255,0);
         else if(min==3)     motor(128+cmp,-255+cmp,-128+cmp,255+cmp);    //motor(255,-128,-255,128);
         else if(min==4)     motor(0+cmp,-255+cmp,0+cmp,255+cmp);        //motor(255,-255,-255,255); 
         else if(min==5)     motor(-128+cmp,-255+cmp,128+cmp,255+cmp);   //motor(128,-255,-128,255);
         else if(min==6)     motor(-255+cmp,-255+cmp,255+cmp,255+cmp);    //motor(0,-255,0,255);   
         else if(min==7)     motor(-255+cmp,-128+cmp,255+cmp,128+cmp);    //motor(-128,-255,128,255);  
         else if(min==8)     motor(-255+cmp,0+cmp,255+cmp,0+cmp);    //motor(-255,-255,255,255);
         else if(min==9)     motor(0+cmp,-255+cmp,0+cmp,255+cmp);         //motor(-255,-128,255,128);
         else if(min==10)    motor(-128+cmp,-255+cmp,255+cmp,128+cmp);   //motor(-255,128,255,-128); 
         else if(min==11)  motor(-255+cmp,-255+cmp,255+cmp,255+cmp); 
         else if(min==12)    motor(-255+cmp,0+cmp,255+cmp,0+cmp);    //motor(-255,255,255,-255);
         else if(min==13)    motor(-255+cmp,128+cmp,255+cmp,-128+cmp);         //motor(-128,255,128,-255); 
         else if(min==14)    motor(-255+cmp,128+cmp,255+cmp,-128+cmp);    //motor(0,255,0,-255); 
         else if(min==15)                                                          
         { 
         motor(-255+cmp,255+cmp,255+cmp,-255+cmp); //motor(128,255,-128,-255);
         }   
    } 
          
void sahmi()
{
    if(SB<150 )  motor(-255-RL+cmp,-255+RL+cmp,255+RL-cmp,255-RL+cmp);
    ///////////////////////////////////////////////////////////////
    else if(SB>300  && RL>-80 && RL<40)  motor(255/4+RL+cmp,255/4-RL+cmp,-255/4-RL+cmp,-255/4+RL+cmp);

           //////////////////////////////////////////////////////////////
    else if(SB>300 && (RL<-60|| RL>40 )  )
    { 
            RL=(float)RL*1.2;
            motor(-RL+cmp,RL+cmp,RL+cmp,-RL+cmp); 
    }
    else{
     motor(0+cmp/2,0+cmp/2,0+cmp/2,0+cmp/2); 
     if ((m>t || t==9 ) && SB>200 )
     {
     follow();
     }
     }
   
    #asm ("wdr"); 
          
    }
    
  
     
      


void bt ()
 {     
      if(r!=1 && l!=1 && f!=1 && b!=1 && adc[min]<900 )
      {
            if (m==1) putchar1('1');
       else if (m==2) putchar1('2');
       else if (m==3) putchar1('3');
       else if (m==4) putchar1('4');
       else if (m==5) putchar1('5');
       else if (m==6) putchar1('6');
       else if (m==7) putchar1('7');
       else if (m==8) putchar1('8');
       else if (m==9) putchar1('9'); 
       }
      else if (t!=10 )
      {
         putchar1('o'); 
       #asm ("wdr") ; 
       }  
       #asm ("wdr") ;
 }      
 
   
         
void main(void)
{
#asm("wdr");
// Declare your local variables here
               
// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=Out Func5=Out Func4=In Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=T State6=0 State5=0 State4=T State3=0 State2=0 State1=0 State0=0 
PORTA=0x00;
DDRA=0x6F;

// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0xF0;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0xF0;

// Port E initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTE=0x00;
DDRE=0x00;

// Port F initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTF=0x00;
DDRF=0x00;

// Port G initialization
// Func4=In Func3=In Func2=In Func1=In Func0=In 
// State4=T State3=T State2=T State1=T State0=T 
PORTG=0x00;
DDRG=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 172.800 kHz
// Mode: Fast PWM top=FFh
// OC0 output: Non-Inverted PWM
ASSR=0x00;
TCCR0=0x6C;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 172.800 kHz
// Mode: Fast PWM top=00FFh
// OC1A output: Non-Inv.
// OC1B output: Non-Inv.
// OC1C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
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
OCR1CH=0x00;
OCR1CL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 172.800 kHz
// Mode: Fast PWM top=FFh
// OC2 output: Non-Inverted PWM
TCCR2=0x6B;
TCNT2=0x00;
OCR2=0x00;

// Timer/Counter 3 initialization
// Clock source: System Clock
// Clock value: Timer 3 Stopped
// Mode: Normal top=FFFFh
// Noise Canceler: Off
// Input Capture on Falling Edge
// OC3A output: Discon.
// OC3B output: Discon.
// OC3C output: Discon.
// Timer 3 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR3A=0x00;
TCCR3B=0x00;
TCNT3H=0x00;
TCNT3L=0x00;
ICR3H=0x00;
ICR3L=0x00;
OCR3AH=0x00;
OCR3AL=0x00;
OCR3BH=0x00;
OCR3BL=0x00;
OCR3CH=0x00;
OCR3CL=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
// INT3: Off
// INT4: Off
// INT5: Off
// INT6: Off
// INT7: Off
EICRA=0x00;
EICRB=0x00;
EIMSK=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;
ETIMSK=0x00;

// USART1 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART1 Receiver: On
// USART1 Transmitter: On
// USART1 Mode: Asynchronous
// USART1 Baud Rate: 9600
UCSR1A=0x00;
UCSR1B=0x98;
UCSR1C=0x06;
UBRR1H=0x00;
UBRR1L=0x47;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 691.200 kHz
// ADC Voltage Reference: AVCC pin
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x84;

// I2C Bus initialization
i2c_init();

// LCD module initialization
lcd_init(16);

// Watchdog Timer initialization
// Watchdog Timer Prescaler: OSC/16k
#pragma optsize-
WDTCR=0x18;
WDTCR=0x08;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Global enable interrupts
#asm("sei")
if (PINA.4==1){
c=compass_read(1);
delay_ms(1000);
}     
while (1)
      {
       
       cmp=compass_read(1)-c; 
        lcd_gotoxy(12,0);
      if(cmp<0) cmp=cmp;
      if(cmp>128) cmp=cmp-255;    
      if(cmp<-128) cmp=cmp+255;    
                                    
      if(cmp>=0)
      {
      #asm("wdr");  
       lcd_gotoxy(11,0);
      lcd_putchar('+');
      lcd_putchar((cmp/100)%10+'0');
      lcd_putchar((cmp/10)%10+'0');
      lcd_putchar((cmp/1)%10+'0');
      }
      else if(cmp<0)
      {
      #asm("wdr");  
       lcd_gotoxy(11,0);
      lcd_putchar('-');
      lcd_putchar((-cmp/100)%10+'0');
      lcd_putchar((-cmp/10)%10+'0');
      lcd_putchar((-cmp/1)%10+'0');
      }
        if(cmp>-50  && cmp<50) cmp=(float)-cmp*2.25;
        else cmp=(float)-cmp*1.75;
      sensor();
      sharp();
      bt();       
      #asm("wdr") ;
      if(adc[min]<900  && (t==0 || (m<t && t!=10)|| (m<t && t!=9))) 
      {
      follow();                            
      #asm("wdr");
      }
      else if (t==10 || adc[min]>900)
       {
        sahmi(); 
        #asm("wdr");
       }  
       else if (m>t || t==9 ) 
       {
        if (SB>200 ) follow() ;
        else sahmi();
        }
//        while(l==1 ){
//          sensor();
//            cmp=compass_read(1)-c; 
//          if(cmp>-50  && cmp<50) cmp=(float)-cmp*2.25;
//else cmp=(float)-cmp*1.75; 
//          sharp();
//          #asm("wdr");   
//          if(kaf[15]<KAF || kaf[13]<KAF )
//          {
//               p=0;
//              motor(255+cmp,-255+cmp,-255+cmp,255+cmp);
//              
//          }
//          else if(kaf[0]<KAF || kaf[1]<KAF || kaf[2]<KAF || kaf[3]<KAF || kaf[12]<KAF)
//          {
//              p=1;
//              motor(255+cmp,-255+cmp,-255+cmp,255+cmp);
//          
//          }
//          else if(p==0 &&((min>=8 && min<16 ) || min==0) )
//          {
//              motor(0+cmp/2,0+cmp/2,0+cmp/2,0+cmp/2); 
//          }
//          else if(p==0 && min>0 && min<8)
//          {
//              l=0;        
//              p=0;
//              break;
//            
//          } 
//      }  
//        while(r==1)
//        {
//          sensor();
//            cmp=compass_read(1)-c; 
//          if(cmp>-50  && cmp<50) cmp=(float)-cmp*2.25;
//else cmp=(float)-cmp*1.75;  
//          sharp();   
//          #asm("wdr")
//          if(kaf[3]<KAF || kaf[2]<KAF || kaf[1]<KAF) 
//          {
//               p=0;
//              motor(-255+cmp,255+cmp,255+cmp,-255+cmp ); 
//          }
//          else if(kaf[0]<KAF || kaf[15]<KAF || kaf[12]<KAF || kaf[13]<KAF )
//          {
//              p=1;
//              motor(-255+cmp,255+cmp,255+cmp,-255+cmp);
//          }
//          else if(p==0 && min>=0 && min<8 )
//          {
//              motor(0+cmp/2,0+cmp/2,0+cmp/2,0+cmp/2);                  
//          }
//          else if(p==0 &&(( min>=8 && min<16) ))
//          {                  
//             r=0;
//              p=0;
//              break;
//          } 
//      }
//      while(f==1)
//      {
//          sensor();
//            cmp=compass_read(1)-c; 
//          if(cmp>-50  && cmp<50) cmp=(float)-cmp*2.25;
//else cmp=(float)-cmp*1.75;  
//          sharp();   
//          #asm("wdr") 
//          if( kaf[9]<KAF || kaf[10]<KAF) 
//          {
//               p=0;
//              motor(-255+cmp,-255+cmp,255+cmp,255+cmp);
//              
//          }
//          else if(kaf[4]<KAF || kaf[5]<KAF || kaf[6]<KAF ||kaf[8]<KAF)
//          {
//              p=1;
//              motor(-255+cmp,-255+cmp,255+cmp,255+cmp);
//          } 
//          else if(p==0 && ((min>=0 && min<5 )|| (min>11 && min<16))) 
//          {
//              motor(0+cmp,0+cmp,0+cmp,0+cmp);                                                 
//          }
//          else if(p==0 && min>4 && min<12)
//          { 
//              f=0;
//              p=0;
//              break;
//          }
//      }
//        while(b==1)
//        {
//          sensor();
//          cmp=compass_read(1)-c; 
//          if(cmp>-50  && cmp<50) cmp=(float)-cmp*2.25;
//else cmp=(float)-cmp*1.75;
//           
//          sharp();                   
//          #asm("wdr")
//          if( kaf[6]<KAF || kaf[5]<KAF  )
//          {
//               p=0;
//              motor(255+cmp,255+cmp,-255+cmp,-255+cmp); 
//              
//          }
          ////////////////////////&& beshe ba do taraf
//         else if(kaf[9]<KAF || kaf[10]<KAF  || kaf[8]<KAF || kaf[4]<KAF)
//         {
//            p=1;
//              motor(255+cmp,255+cmp,-255+cmp,-255+cmp);             
//          }
//          else if(p==0 && min>4 && min<12 ) 
//          {
//              motor(0+cmp,0+cmp,0+cmp,0+cmp);                                          
//          }
//          else if(p==0 && ((min>=0 && min<5 )|| (min>11 && min<16)))
//          {
//              b=0;
//              p=0;
//              break;
//          }
//          
//          }     
        
      };
 }
