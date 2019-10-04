//*****************************************************************************
// Usefull Library With I2C 4 Setup MPU6050
// Copyright :              WWW.RoboticNGO.com      &      www.ECA.ir
// Author :                 S_Ahmad (Seyyed Ahmad Mousavi)
// Remarks :
// known Problems :         None
// Version :                1.5
// Date :                   1392/10/23
// Company :                www.RoboticNGO.com      &      www.ECA.ir
// Compiler:                CodeVisionAVR V2.05.3+
//
// -----------------
//                  |                 ----------------
//                  |- 5v  ----- Vcc -| MPU 6050     |
// MicroController  |- GND ----- GND -| Acceleration,|
// Board            |- SDA ----- SDA -| Gyro, Temp   |
//                  |- SCL ----- SCL -|   Module     |
//                  |                 ----------------
//------------------
//
//*****************************************************************************
#include <delay.h>
#include <i2c.h>
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

  GyroRate_Val[X] = GyroRate_Val[X] / GYRO_Sensitivity;   // (º/s)/LSB
  GyroRate_Val[Y] = GyroRate_Val[Y] / GYRO_Sensitivity;   // (º/s)/LSB
  GyroRate_Val[Z] = GyroRate_Val[Z] / GYRO_Sensitivity;   // (º/s)/LSB

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
//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
#pragma warn+

