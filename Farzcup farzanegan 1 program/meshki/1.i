
#pragma used+
sfrb PINF=0;
sfrb PINE=1;
sfrb DDRE=2;
sfrb PORTE=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRR0L=9;
sfrb UCSR0B=0xa;
sfrb UCSR0A=0xb;
sfrb UDR0=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   
sfrb SFIOR=0x20;
sfrb WDTCR=0x21;
sfrb OCDR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrw ICR1=0x26;   
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb ASSR=0x30;
sfrb OCR0=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TIFR=0x36;
sfrb TIMSK=0x37;
sfrb EIFR=0x38;
sfrb EIMSK=0x39;
sfrb EICRB=0x3a;
sfrb XDIV=0x3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

typedef char *va_list;

#pragma used+

char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);

char *gets(char *str,unsigned int len);

void printf(char flash *fmtstr,...);
void sprintf(char *str, char flash *fmtstr,...);
void snprintf(char *str, unsigned int size, char flash *fmtstr,...);
void vprintf (char flash * fmtstr, va_list argptr);
void vsprintf (char *str, char flash * fmtstr, va_list argptr);
void vsnprintf (char *str, unsigned int size, char flash * fmtstr, va_list argptr);
signed char scanf(char flash *fmtstr,...);
signed char sscanf(char *str, char flash *fmtstr,...);

#pragma used-

#pragma library stdio.lib

#asm
   .equ __i2c_port=0x12 ;PORTD
   .equ __sda_bit=1
   .equ __scl_bit=0
#endasm

#pragma used+
void i2c_init(void);
unsigned char i2c_start(void);
void i2c_stop(void);
unsigned char i2c_read(unsigned char ack);
unsigned char i2c_write(unsigned char data);
#pragma used-

eeprom int c;

int cmp;

unsigned char compass_read(unsigned char address) {
unsigned char data;
i2c_start();
i2c_write(0xc0 );
i2c_write(address);
i2c_start();
i2c_write(0xc0  | 1);
data=i2c_read(0);
i2c_stop();
return data;
}

#asm
   .equ __lcd_port=0x15 ;PORTC
#endasm

#pragma used+

void _lcd_ready(void);
void _lcd_write_data(unsigned char data);

void lcd_write_byte(unsigned char addr, unsigned char data);

unsigned char lcd_read_byte(unsigned char addr);

void lcd_gotoxy(unsigned char x, unsigned char y);

void lcd_clear(void);
void lcd_putchar(char c);

void lcd_puts(char *str);

void lcd_putsf(char flash *str);

unsigned char lcd_init(unsigned char lcd_columns);

#pragma used-
#pragma library lcd.lib

char rx_buffer1[8];

unsigned char rx_wr_index1,rx_rd_index1,rx_counter1;

bit rx_buffer_overflow1;
int t=0;

interrupt [31] void usart1_rx_isr(void)
{
char status,data;
status=(*(unsigned char *) 0x9b);
data=(*(unsigned char *) 0x9c);
if ((status & ((1<<4) | (1<<2) | (1<<3)))==0)
{
rx_buffer1[rx_wr_index1]=data;
if (++rx_wr_index1 == 8) rx_wr_index1=0;
if (++rx_counter1 == 8)
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

#pragma used+
char getchar1(void)
{
char data;
while (rx_counter1==0);
data=rx_buffer1[rx_rd_index1];
if (++rx_rd_index1 == 8) rx_rd_index1=0;
#asm("cli")
--rx_counter1;
#asm("sei")
return data;
}
#pragma used-

#pragma used+
void putchar1(char c)
{
while (((*(unsigned char *) 0x9b) & (1<<5))==0);
(*(unsigned char *) 0x9c)=c;
}
#pragma used-

unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (0x40 & 0xff);

delay_us(10);

ADCSRA|=0x40;

while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}

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

lcd_gotoxy(8,1);
lcd_putchar((SL/100)%10+'0');
lcd_putchar((SL/10)%10+'0');
lcd_putchar((SL/1)%10+'0');

sum= SR+SL;
RL=SR-SL;

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

if ( (kaf[13]<400  || kaf[12]<400  || kaf[15]<400  || kaf[14]<400 )  && b==0  && l == 0 && r == 0  && f == 0)  l=1; 
else  if ((kaf[0]<400  || kaf[1]<400  || kaf[2]<400  || kaf[3]<400 ) && b==0  && l == 0 && r == 0 && f == 0) r=1; 
else if((kaf[10]<400  || kaf[9]<400  || kaf[8]<400 ) && f==0 && b==0 && r==0 && l==0) f=1;
else if ((kaf[4]<400  || kaf[5]<400  || kaf[6]<400  ) && f==0 && b==0 && r==0 && l==0) b=1;
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

else if(min==2)     motor(255+cmp,-255+cmp,-255+cmp,255+cmp);     
else if(min==3)     motor(128+cmp,-255+cmp,-128+cmp,255+cmp);    
else if(min==4)     motor(0+cmp,-255+cmp,0+cmp,255+cmp);        
else if(min==5)     motor(-128+cmp,-255+cmp,128+cmp,255+cmp);   
else if(min==6)     motor(-255+cmp,-255+cmp,255+cmp,255+cmp);    
else if(min==7)     motor(-255+cmp,-128+cmp,255+cmp,128+cmp);    
else if(min==8)     motor(-255+cmp,0+cmp,255+cmp,0+cmp);    
else if(min==9)     motor(0+cmp,-255+cmp,0+cmp,255+cmp);         
else if(min==10)    motor(-128+cmp,-255+cmp,255+cmp,128+cmp);   
else if(min==11)  motor(-255+cmp,-255+cmp,255+cmp,255+cmp); 
else if(min==12)    motor(-255+cmp,0+cmp,255+cmp,0+cmp);    
else if(min==13)    motor(-255+cmp,128+cmp,255+cmp,-128+cmp);         
else if(min==14)    motor(-255+cmp,128+cmp,255+cmp,-128+cmp);    
else if(min==15)                                                          
{ 
motor(-255+cmp,255+cmp,255+cmp,-255+cmp); 
}   
} 

void sahmi()
{
if(SB<150 )  motor(-255-RL+cmp,-255+RL+cmp,255+RL-cmp,255-RL+cmp);

else if(SB>300  && RL>-80 && RL<40)  motor(255/4+RL+cmp,255/4-RL+cmp,-255/4-RL+cmp,-255/4+RL+cmp);

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

PORTA=0x00;
DDRA=0x6F;

PORTB=0x00;
DDRB=0xF0;

PORTC=0x00;
DDRC=0x00;

PORTD=0x00;
DDRD=0xF0;

PORTE=0x00;
DDRE=0x00;

(*(unsigned char *) 0x62)=0x00;
(*(unsigned char *) 0x61)=0x00;

(*(unsigned char *) 0x65)=0x00;
(*(unsigned char *) 0x64)=0x00;

ASSR=0x00;
TCCR0=0x6C;
TCNT0=0x00;
OCR0=0x00;

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
(*(unsigned char *) 0x79)=0x00;
(*(unsigned char *) 0x78)=0x00;

TCCR2=0x6B;
TCNT2=0x00;
OCR2=0x00;

(*(unsigned char *) 0x8b)=0x00;
(*(unsigned char *) 0x8a)=0x00;
(*(unsigned char *) 0x89)=0x00;
(*(unsigned char *) 0x88)=0x00;
(*(unsigned char *) 0x81)=0x00;
(*(unsigned char *) 0x80)=0x00;
(*(unsigned char *) 0x87)=0x00;
(*(unsigned char *) 0x86)=0x00;
(*(unsigned char *) 0x85)=0x00;
(*(unsigned char *) 0x84)=0x00;
(*(unsigned char *) 0x83)=0x00;
(*(unsigned char *) 0x82)=0x00;

(*(unsigned char *) 0x6a)=0x00;
EICRB=0x00;
EIMSK=0x00;

TIMSK=0x00;
(*(unsigned char *) 0x7d)=0x00;

(*(unsigned char *) 0x9b)=0x00;
(*(unsigned char *) 0x9a)=0x98;
(*(unsigned char *) 0x9d)=0x06;
(*(unsigned char *) 0x98)=0x00;
(*(unsigned char *) 0x99)=0x47;

ACSR=0x80;
SFIOR=0x00;

ADMUX=0x40 & 0xff;
ADCSRA=0x84;

i2c_init();

lcd_init(16);

#pragma optsize-
WDTCR=0x18;
WDTCR=0x08;
#pragma optsize+

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

};
}
