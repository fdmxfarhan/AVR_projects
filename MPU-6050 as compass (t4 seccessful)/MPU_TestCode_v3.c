/*****************************************************
CodeWizardAVR V2.05.3 Standard

Project : Test & Start MPU6050 Sensor With I2C Comunication & Usart Monitoring
Version : 3.0
Date    : 1392/9/20
Author  : S_Ahmad
Company : www.RoboticNGO.com    www.ECA.ir
Comments:

Chip type               : ATmega32
AVR Core Clock frequency: 8.000000 MHz
*****************************************************/
#include <mega32.h>
#include <i2c.h>
#include <delay.h>
#include <stdio.h>
#include <stdlib.h>
#include "LIB\MPU6050 LIB\MPU6050.h"
//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
void WaitInPrint()
{
    getchar();
}
//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
void main(void)
{
PORTA=0x00;
DDRA=0x00;

PORTB=0x00;
DDRB=0x00;

PORTC=0x00;
DDRC=0x00;

PORTD=0x60;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
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
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

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

// I2C Bus initialization
// I2C Port: PORTC
// I2C SDA bit: 1
// I2C SCL bit: 0
// Bit Rate: 100 kHz
// Note: I2C settings are specified in the
// Project|Configure|C Compiler|Libraries|I2C menu.
i2c_init();
//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
printf("\n\rwww.RoboticNGO.com\n\rwww.ECA.ir\n\r\n\r");
WaitInPrint();

    if(MPU6050_Test_I2C())
    {
        printf("Correct, MPU6050 Addr is 0x%X \n\r",MPU6050_ADDRESS);
        WaitInPrint();
    }
    else
    {
        printf("ERROR, Stopping \n\r");
        WaitInPrint();
    }

MPU6050_Init();
printf("MPU6050 Setup ==> Complete\n\r\n\r");

Get_Accel_Offset();
Get_Gyro_Offset();
printf("Accel Offset Val: %.2f , %.2f , %.2f \n\r",Accel_Offset_Val[X],Accel_Offset_Val[Y],Accel_Offset_Val[Z]);
printf("Gyro  Offset Val: %.2f , %.2f , %.2f \n\r",Gyro_Offset_Val[X],Gyro_Offset_Val[Y],Gyro_Offset_Val[Z]);
WaitInPrint();

    while (1)
    {
        WaitInPrint();
        puts("\n");

        Get_Temp_Val();

        Get_Gyro_Val();
        Get_AvrgGyro_Val();

        Get_Accel_Val();
        Get_AvrgAccel_Val();
        Get_Accel_Angles();

        printf("Temp Val is: %.1f degree Celsius \n\r",Temp_Val);

        printf("\n");

        printf("    Gyro Raw  Val: %.0f , %.0f , %.0f \n\r",Gyro_Raw_Val[X],Gyro_Raw_Val[Y],Gyro_Raw_Val[Z]);
        printf("AvrgGyro Raw  Val: %.0f , %.0f , %.0f \n\r",AvrgGyro_Raw_Val[X],AvrgGyro_Raw_Val[Y],AvrgGyro_Raw_Val[Z]);
        printf("    Gyro Rate Val: %.1f , %.1f , %.1f \n\r",GyroRate_Val[X],GyroRate_Val[Y],GyroRate_Val[Z]);

        printf("\n");

        printf("    Accel Raw Val: %.1f , %.1f , %.1f \n\r",Accel_Raw_Val[X],Accel_Raw_Val[Y],Accel_Raw_Val[Z]);
        printf("AvrgAccel Raw Val: %.1f , %.1f , %.1f \n\r",AvrgAccel_Raw_Val[X],AvrgAccel_Raw_Val[Y],AvrgAccel_Raw_Val[Z]);
        printf("  Accel In 1G Val: %.1f , %.1f , %.1f \n\r",Accel_In_g[X],Accel_In_g[Y],Accel_In_g[Z]);
        printf("Accel  Angle  Val: %.1f , %.1f , %.1f \n\r",Accel_Angle[X],Accel_Angle[Y],Accel_Angle[Z]);

    }
}
