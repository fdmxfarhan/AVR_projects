/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 8/2/2018
Author  : 
Company : 
Comments: 


Chip type               : ATmega8A
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega8.h>
#include <delay.h>


// I2C Bus functions
#include <i2c.h>

// Declare your global variables here

#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)

// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index=0,rx_rd_index=0;
#else
unsigned int rx_wr_index=0,rx_rd_index=0;
#endif

#if RX_BUFFER_SIZE < 256
unsigned char rx_counter=0;
#else
unsigned int rx_counter=0;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index++]=data;
#if RX_BUFFER_SIZE == 256
   // special case for receiver buffer size=256
   if (++rx_counter == 0) rx_buffer_overflow=1;
#else
   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      }
#endif


    if(data=='o') PORTD.2=1;
    else       PORTD.2=0;
    
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>








#include <stdlib.h>
#include "LIB\MPU6050 LIB\MPU6050.h"
#include "LIB\MPU6050 LIB\RA_MPU6050.h"
#include "LIB\MPU6050 LIB\MPU6050_PR.h"

float Accel_Raw_Val[3]={0,0,0};
float AvrgAccel_Raw_Val[3]={0,0,0};
float Accel_In_g[3]={0,0,0};
float Accel_Offset_Val[3]={0,0,0};
float Accel_Angle[3]={0,0,0};

float Gyro_Raw_Val[3]={0,0,0};
float AvrgGyro_Raw_Val[3]={0,0,0};
float Gyro_Offset_Val[3]={0,0,0};
float GyroRate_Val[3]={0,0,0};

float Temp_Val;
#pragma warn-
//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
unsigned char read_i2c(unsigned char BusAddres , unsigned char Reg , unsigned char Ack )
{
unsigned char Data;
i2c_start();
i2c_write(BusAddres);
i2c_write(Reg);
i2c_start();
i2c_write(BusAddres + 1);
delay_us(10);
Data=i2c_read(Ack);
i2c_stop();
return Data;
}
//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
void write_i2c(unsigned char BusAddres , unsigned char Reg , unsigned char Data)
{
i2c_start();
i2c_write(BusAddres);
i2c_write(Reg);
i2c_write(Data);
i2c_stop();
}
//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
// This function can test i2c communication MPU6050
unsigned char MPU6050_Test_I2C()
{
    unsigned char Data = 0x00;
    Data=read_i2c(MPU6050_ADDRESS, RA_WHO_AM_I, 0);
    if(Data == 0x68)
        return 1;       // Means Comunication With MPU6050 is Corect
    else
        return 0;       // Means ERROR, Stopping
}
//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
// This function can move MPU6050 to sleep
void MPU6050_Sleep(char ON_or_OFF)
{
    if(ON_or_OFF == on)
        write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_1, (1<<6)|(CYCLE<<5)|(TEMP_DIS<<3)|CLKSEL);
    else if(ON_or_OFF == off)
        write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_1, (0)|(CYCLE<<5)|(TEMP_DIS<<3)|CLKSEL);
}
//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
// This function can restor MPU6050 to default
void MPU6050_Reset()
{
    // When set to 1, DEVICE_RESET bit in RA_PWR_MGMT_1 resets all internal registers to their default values.
    // The bit automatically clears to 0 once the reset is done.
    // The default values for each register can be found in RA_MPU6050.h
    write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_1, 0x80);
    // Now all reg reset to default values
}
//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
// MPU6050 sensor initialization
void MPU6050_Init()
{
    //Sets sample rate to 1000/1+4 = 200Hz
    write_i2c(MPU6050_ADDRESS, RA_SMPLRT_DIV, SampleRateDiv);
    //Disable FSync, 42Hz DLPF
    write_i2c(MPU6050_ADDRESS, RA_CONFIG, (EXT_SYNC_SET<<3)|(DLPF_CFG));
    //Disable all axis gyro self tests, scale of 2000 degrees/s
    write_i2c(MPU6050_ADDRESS, RA_GYRO_CONFIG, ((XG_ST|YG_ST|ZG_ST)<<5)|GFS_SEL);
    //Disable accel self tests, scale of +-16g, no DHPF
    write_i2c(MPU6050_ADDRESS, RA_ACCEL_CONFIG, ((XA_ST|YA_ST|ZA_ST)<<5)|AFS_SEL);
    //Disable sensor output to FIFO buffer
    write_i2c(MPU6050_ADDRESS, RA_FIFO_EN, FIFO_En_Parameters);

    //Freefall threshold of |0mg|
    write_i2c(MPU6050_ADDRESS, RA_FF_THR, 0x00);
    //Freefall duration limit of 0
    write_i2c(MPU6050_ADDRESS, RA_FF_DUR, 0x00);
    //Motion threshold of 0mg
    write_i2c(MPU6050_ADDRESS, RA_MOT_THR, 0x00);
    //Motion duration of 0s
    write_i2c(MPU6050_ADDRESS, RA_MOT_DUR, 0x00);
    //Zero motion threshold
    write_i2c(MPU6050_ADDRESS, RA_ZRMOT_THR, 0x00);
    //Zero motion duration threshold
    write_i2c(MPU6050_ADDRESS, RA_ZRMOT_DUR, 0x00);

//////////////////////////////////////////////////////////////
//  AUX I2C setup
//////////////////////////////////////////////////////////////
    //Sets AUX I2C to single master control, plus other config
    write_i2c(MPU6050_ADDRESS, RA_I2C_MST_CTRL, 0x00);
    //Setup AUX I2C slaves
    write_i2c(MPU6050_ADDRESS, RA_I2C_SLV0_ADDR, 0x00);
    write_i2c(MPU6050_ADDRESS, RA_I2C_SLV0_REG, 0x00);
    write_i2c(MPU6050_ADDRESS, RA_I2C_SLV0_CTRL, 0x00);

    write_i2c(MPU6050_ADDRESS, RA_I2C_SLV1_ADDR, 0x00);
    write_i2c(MPU6050_ADDRESS, RA_I2C_SLV1_REG, 0x00);
    write_i2c(MPU6050_ADDRESS, RA_I2C_SLV1_CTRL, 0x00);

    write_i2c(MPU6050_ADDRESS, RA_I2C_SLV2_ADDR, 0x00);
    write_i2c(MPU6050_ADDRESS, RA_I2C_SLV2_REG, 0x00);
    write_i2c(MPU6050_ADDRESS, RA_I2C_SLV2_CTRL, 0x00);

    write_i2c(MPU6050_ADDRESS, RA_I2C_SLV3_ADDR, 0x00);
    write_i2c(MPU6050_ADDRESS, RA_I2C_SLV3_REG, 0x00);
    write_i2c(MPU6050_ADDRESS, RA_I2C_SLV3_CTRL, 0x00);

    write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_ADDR, 0x00);
    write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_REG, 0x00);
    write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_DO, 0x00);
    write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_CTRL, 0x00);
    write_i2c(MPU6050_ADDRESS, RA_I2C_SLV4_DI, 0x00);

    //Setup INT pin and AUX I2C pass through
    write_i2c(MPU6050_ADDRESS, RA_INT_PIN_CFG, 0x00);
    //Enable data ready interrupt
    write_i2c(MPU6050_ADDRESS, RA_INT_ENABLE, 0x00);

    //Slave out, dont care
    write_i2c(MPU6050_ADDRESS, RA_I2C_SLV0_DO, 0x00);
    write_i2c(MPU6050_ADDRESS, RA_I2C_SLV1_DO, 0x00);
    write_i2c(MPU6050_ADDRESS, RA_I2C_SLV2_DO, 0x00);
    write_i2c(MPU6050_ADDRESS, RA_I2C_SLV3_DO, 0x00);
    //More slave config
    write_i2c(MPU6050_ADDRESS, RA_I2C_MST_DELAY_CTRL, 0x00);

    //Reset sensor signal paths
    write_i2c(MPU6050_ADDRESS, RA_SIGNAL_PATH_RESET, 0x00);
    //Motion detection control
    write_i2c(MPU6050_ADDRESS, RA_MOT_DETECT_CTRL, 0x00);
    //Disables FIFO, AUX I2C, FIFO and I2C reset bits to 0
    write_i2c(MPU6050_ADDRESS, RA_USER_CTRL, 0x00);

    //Sets clock source to gyro reference w/ PLL
    write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_1, (SLEEP<<6)|(CYCLE<<5)|(TEMP_DIS<<3)|CLKSEL);
    //Controls frequency of wakeups in accel low power mode plus the sensor standby modes
    write_i2c(MPU6050_ADDRESS, RA_PWR_MGMT_2, (LP_WAKE_CTRL<<6)|(STBY_XA<<5)|(STBY_YA<<4)|(STBY_ZA<<3)|(STBY_XG<<2)|(STBY_YG<<1)|(STBY_ZG));
    //Data transfer to and from the FIFO buffer
    write_i2c(MPU6050_ADDRESS, RA_FIFO_R_W, 0x00);

//  MPU6050 Setup Complete
}
//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
// get accel offset X,Y,Z
void Get_Accel_Offset()
{
  #define    NumAve4AO      100
  float Ave=0;
  unsigned char i= NumAve4AO;
  while(i--)
  {
    Accel_Offset_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_H, 0)<<8)|
                            read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_L, 0)   );
    Ave = (float) Ave + (Accel_Offset_Val[X] / NumAve4AO);
    delay_us(10);
  }
  Accel_Offset_Val[X] = Ave;
  Ave = 0;
  i = NumAve4AO;
  while(i--)
  {
    Accel_Offset_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_H, 0)<<8)|
                            read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_L, 0)   );
    Ave = (float) Ave + (Accel_Offset_Val[Y] / NumAve4AO);
    delay_us(10);
  }
  Accel_Offset_Val[Y] = Ave;
  Ave = 0;
  i = NumAve4AO;
  while(i--)
  {
    Accel_Offset_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_H, 0)<<8)|
                            read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_L, 0)   );
    Ave = (float) Ave + (Accel_Offset_Val[Z] / NumAve4AO);
    delay_us(10);
  }
  Accel_Offset_Val[Z] = Ave;
}
//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
// Gets raw accelerometer data, performs no processing
void Get_Accel_Val()
{
    Accel_Raw_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_H, 0)<<8)|
                         read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_L, 0)    );
    Accel_Raw_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_H, 0)<<8)|
                         read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_L, 0)    );
    Accel_Raw_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_H, 0)<<8)|
                         read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_L, 0)    );

    Accel_In_g[X] = Accel_Raw_Val[X] - Accel_Offset_Val[X];
    Accel_In_g[Y] = Accel_Raw_Val[Y] - Accel_Offset_Val[Y];
    Accel_In_g[Z] = Accel_Raw_Val[Z] - Accel_Offset_Val[Z];

    Accel_In_g[X] = Accel_In_g[X] / ACCEL_Sensitivity;
    Accel_In_g[Y] = Accel_In_g[Y] / ACCEL_Sensitivity;
    Accel_In_g[Z] = Accel_In_g[Z] / ACCEL_Sensitivity;
}
//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
// Gets n average raw accelerometer data, performs no processing
void Get_AvrgAccel_Val()
{
  #define    NumAve4A      50
  float Ave=0;
  unsigned char i= NumAve4A;
  while(i--)
  {
    AvrgAccel_Raw_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_H, 0)<<8)|
                             read_i2c(MPU6050_ADDRESS, RA_ACCEL_XOUT_L, 0)   );
    Ave = (float) Ave + (AvrgAccel_Raw_Val[X] / NumAve4A);
    delay_us(10);
  }
  AvrgAccel_Raw_Val[X] = Ave;
  Ave = 0;
  i = NumAve4A;
  while(i--)
  {
    AvrgAccel_Raw_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_H, 0)<<8)|
                             read_i2c(MPU6050_ADDRESS, RA_ACCEL_YOUT_L, 0)   );
    Ave = (float) Ave + (AvrgAccel_Raw_Val[Y] / NumAve4A);
    delay_us(10);
  }
  AvrgAccel_Raw_Val[Y] = Ave;
  Ave = 0;
  i = NumAve4A;
  while(i--)
  {
    AvrgAccel_Raw_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_H, 0)<<8)|
                             read_i2c(MPU6050_ADDRESS, RA_ACCEL_ZOUT_L, 0)   );
    Ave = (float) Ave + (AvrgAccel_Raw_Val[Z] / NumAve4A);
    delay_us(10);
  }
  AvrgAccel_Raw_Val[Z] = Ave;

  Accel_In_g[X] = AvrgAccel_Raw_Val[X] - Accel_Offset_Val[X];
  Accel_In_g[Y] = AvrgAccel_Raw_Val[Y] - Accel_Offset_Val[Y];
  Accel_In_g[Z] = AvrgAccel_Raw_Val[Z] - Accel_Offset_Val[Z];

  Accel_In_g[X] = Accel_In_g[X] / ACCEL_Sensitivity;  //  g/LSB
  Accel_In_g[Y] = Accel_In_g[Y] / ACCEL_Sensitivity;  //  g/LSB
  Accel_In_g[Z] = Accel_In_g[Z] / ACCEL_Sensitivity;  //  g/LSB

}
//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
// Gets angles from accelerometer data
void Get_Accel_Angles()
{
// If you want be averaged of accelerometer data, write (on),else write (off)
#define  GetAvrg  on

#if GetAvrg == on
    Get_AvrgAccel_Val();
//  Calculate The Angle Of Each Axis
    Accel_Angle[X] = 57.295*atan((float) AvrgAccel_Raw_Val[X] / sqrt(pow((float)AvrgAccel_Raw_Val[Z],2)+pow((float)AvrgAccel_Raw_Val[Y],2)));
    Accel_Angle[Y] = 57.295*atan((float) AvrgAccel_Raw_Val[Y] / sqrt(pow((float)AvrgAccel_Raw_Val[Z],2)+pow((float)AvrgAccel_Raw_Val[X],2)));
    Accel_Angle[Z] = 57.295*atan((float) sqrt(pow((float)AvrgAccel_Raw_Val[X],2)+pow((float)AvrgAccel_Raw_Val[Y],2))/ AvrgAccel_Raw_Val[Z] );
#else
    Get_Accel_Val();
//  Calculate The Angle Of Each Axis
    Accel_Angle[X] = 57.295*atan((float) Accel_Raw_Val[X] / sqrt(pow((float)Accel_Raw_Val[Z],2)+pow((float)Accel_Raw_Val[Y],2)));
    Accel_Angle[Y] = 57.295*atan((float) Accel_Raw_Val[Y] / sqrt(pow((float)Accel_Raw_Val[Z],2)+pow((float)Accel_Raw_Val[X],2)));
    Accel_Angle[Z] = 57.295*atan((float) sqrt(pow((float)Accel_Raw_Val[X],2)+pow((float)Accel_Raw_Val[Y],2))/ Accel_Raw_Val[Z] );
#endif

}
//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
// get gyro offset X,Y,Z
void Get_Gyro_Offset()
{
  #define    NumAve4GO      100

  float Ave = 0;
  unsigned char i = NumAve4GO;
  Gyro_Offset_Val[X] = Gyro_Offset_Val[Y] = Gyro_Offset_Val[Z] = 0;

  while(i--)
  {
    Gyro_Offset_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_H, 0)<<8)|
                           read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_L, 0)   );
    Ave = (float) Ave + (Gyro_Offset_Val[X] / NumAve4GO);
    delay_us(1);
  }
  Gyro_Offset_Val[X] = Ave;
  Ave = 0;
  i = NumAve4GO;
  while(i--)
  {
    Gyro_Offset_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_H, 0)<<8)|
                           read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_L, 0)   );
    Ave = (float) Ave + (Gyro_Offset_Val[Y] / NumAve4GO);
    delay_us(1);
  }
  Gyro_Offset_Val[Y] = Ave;
  Ave = 0;
  i = NumAve4GO;
  while(i--)
  {
      Gyro_Offset_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_H, 0)<<8)|
                             read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_L, 0)   );
    Ave = (float) Ave + (Gyro_Offset_Val[Z] / NumAve4GO);
    delay_us(1);
  }
  Gyro_Offset_Val[Z] = Ave;

}
//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
// Function to read the gyroscope rate data and convert it into degrees/s
void Get_Gyro_Val()
{
    Gyro_Raw_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_H, 0)<<8) |
                        read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_L, 0))    ;
    Gyro_Raw_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_H, 0)<<8) |
                        read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_L, 0))    ;
    Gyro_Raw_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_H, 0)<<8) |
                        read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_L, 0))    ;

    GyroRate_Val[X] = Gyro_Raw_Val[X] - Gyro_Offset_Val[X];
    GyroRate_Val[Y] = Gyro_Raw_Val[Y] - Gyro_Offset_Val[Y];
    GyroRate_Val[Z] = Gyro_Raw_Val[Z] - Gyro_Offset_Val[Z];

    GyroRate_Val[X] = GyroRate_Val[X] / GYRO_Sensitivity;
    GyroRate_Val[Y] = GyroRate_Val[Y] / GYRO_Sensitivity;
    GyroRate_Val[Z] = GyroRate_Val[Z] / GYRO_Sensitivity;

}
//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
// Function to read the Avrrage of gyroscope rate data and convert it into degrees/s
void Get_AvrgGyro_Val()
{
  #define    NumAve4G      50

  float Ave = 0;
  unsigned char i = NumAve4G;
  AvrgGyro_Raw_Val[X] = AvrgGyro_Raw_Val[Y] = AvrgGyro_Raw_Val[Z] = 0;

  while(i--)
  {
    AvrgGyro_Raw_Val[X] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_H, 0)<<8)|
                            read_i2c(MPU6050_ADDRESS, RA_GYRO_XOUT_L, 0)   );
    Ave = (float) Ave + (AvrgGyro_Raw_Val[X] / NumAve4G);
    delay_us(1);
  }
  AvrgGyro_Raw_Val[X] = Ave;
  Ave = 0;
  i = NumAve4G;
  while(i--)
  {
    AvrgGyro_Raw_Val[Y] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_H, 0)<<8)|
                            read_i2c(MPU6050_ADDRESS, RA_GYRO_YOUT_L, 0)   );
    Ave = (float) Ave + (AvrgGyro_Raw_Val[Y] / NumAve4G);
    delay_us(1);
  }
  AvrgGyro_Raw_Val[Y] = Ave;
  Ave = 0;
  i = NumAve4G;
  while(i--)
  {
    AvrgGyro_Raw_Val[Z] = ((read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_H, 0)<<8)|
                            read_i2c(MPU6050_ADDRESS, RA_GYRO_ZOUT_L, 0)   );
    Ave = (float) Ave + (AvrgGyro_Raw_Val[Z] / NumAve4G);
    delay_us(1);
  }
  AvrgGyro_Raw_Val[Z] = Ave;

  GyroRate_Val[X] = AvrgGyro_Raw_Val[X] - Gyro_Offset_Val[X];
  GyroRate_Val[Y] = AvrgGyro_Raw_Val[Y] - Gyro_Offset_Val[Y];
  GyroRate_Val[Z] = AvrgGyro_Raw_Val[Z] - Gyro_Offset_Val[Z];

  GyroRate_Val[X] = GyroRate_Val[X] / GYRO_Sensitivity;   // (�/s)/LSB
  GyroRate_Val[Y] = GyroRate_Val[Y] / GYRO_Sensitivity;   // (�/s)/LSB
  GyroRate_Val[Z] = GyroRate_Val[Z] / GYRO_Sensitivity;   // (�/s)/LSB

}
//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
// Function to read the Temperature
void Get_Temp_Val()
{
    Temp_Val = ((read_i2c(MPU6050_ADDRESS, RA_TEMP_OUT_H, 0)<< 8)|
                  read_i2c(MPU6050_ADDRESS, RA_TEMP_OUT_L, 0)   );
// Compute the temperature in degrees
    Temp_Val = (Temp_Val /TEMP_Sensitivity) + 36.53;
}


// Declare your global variables here
void WaitInPrint()
    {
    getchar();
    }






void print();
int cnt1,x,y;

int action;
void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (1<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;

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
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x33;

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
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Bit-Banged I2C Bus initialization
// I2C Port: PORTC
// I2C SDA bit: 3
// I2C SCL bit: 2
// Bit Rate: 100 kHz
// Note: I2C settings are specified in the
// Project|Configure|C Compiler|Libraries|I2C menu.
i2c_init();

// Global enable interrupts
#asm("sei")
PORTD.2=1;
delay_ms(100);
PORTD.2=0;
delay_ms(100);
PORTD.2=1;
delay_ms(100);
PORTD.2=0;
delay_ms(100);

MPU6050_Init();
Get_Accel_Offset();
Get_Gyro_Offset();


while (1)
    {
    
    //Get_Temp_Val();

    //Get_Gyro_Val();
    //Get_AvrgGyro_Val();
    Get_Accel_Val();
    //Get_AvrgAccel_Val();
    //Get_Accel_Angles();
                      
    x=Accel_Raw_Val[X]/100;
    y=Accel_Raw_Val[Y]/100;    
    
    
    if(x>80)
        {
        if(y>=80)                 action='Q';
        else if(y<80 && y>=-80)   action='F';
        else if(y<-80)            action='E';
        }
    else if(x<80 && x>=-80)
        {
        if(y>=80)                 action='L';
        else if(y<80 && y>=-80)  action='S';
        else if(y<-80)  action='R';
        }
    else if(x<-80)
        {
        if(y>=80)                action='Z';
        else if(y<80 && y>=-80)  action='G';
        else if(y<-80)           action='C';
        }
    
    putchar(action);
    }
}

void print()
    {
    puts("X:");
    if(x>=0)
        {
        putchar('+');
        putchar((x/100)%10+'0');
        putchar((x/10)%10+'0');
        putchar((x/1)%10+'0');
        }
    else if(x < 0)
        {
        putchar('-');
        putchar((-x/100)%10+'0');
        putchar((-x/10)%10+'0');
        putchar((-x/1)%10+'0');
        }             
    puts("_Y:");
    
    if(y>=0)
        {
        putchar('+');
        putchar((y/100)%10+'0');
        putchar((y/10)%10+'0');
        putchar((y/1)%10+'0');
        }
    else if(y < 0)
        {
        putchar('-');
        putchar((-y/100)%10+'0');
        putchar((-y/10)%10+'0');
        putchar((-y/1)%10+'0');
        }             
    puts("_______________________");
    delay_ms(10);
    }