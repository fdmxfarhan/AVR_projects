//*****************************************************************************
// Usefull Function With I2C 4 Setup MPU6050
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
#include <math.h>
#include "LIB\MPU6050 LIB\RA_MPU6050.h"
#include "LIB\MPU6050 LIB\MPU6050_PR.h"

#ifndef __MPU6050_H
    #define __MPU6050_H
#pragma used+

#ifndef X
    #define   X  0
#endif
#ifndef Y
    #define   Y  1
#endif
#ifndef Z
    #define   Z  2
#endif
#ifndef on
    #define on   1
#endif
#ifndef off
    #define off  0
#endif

extern float Accel_Raw_Val[3];
extern float AvrgAccel_Raw_Val[3];
extern float Accel_In_g[3];
extern float Accel_Offset_Val[3];
extern float Accel_Angle[3];

extern float Gyro_Raw_Val[3];
extern float AvrgGyro_Raw_Val[3];
extern float Gyro_Offset_Val[3];
extern float GyroRate_Val[3];

extern float Temp_Val;

//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
#ifndef RD_I2C_FUNC
  #define RD_I2C_FUNC
extern unsigned char read_i2c(unsigned char BusAddres , unsigned char Reg , unsigned char Ack );
#endif
#ifndef WR_I2C_FUNC
  #define WR_I2C_FUNC
extern void write_i2c(unsigned char BusAddres , unsigned char Reg , unsigned char Data);
#endif
extern unsigned char MPU6050_Test_I2C();
extern void MPU6050_Sleep(char ON_or_OFF);
extern void MPU6050_Reset();
extern void MPU6050_Init();
extern void Get_Accel_Offset();
extern void Get_Accel_Val();
extern void Get_AvrgAccel_Val();
extern void Get_Accel_Angles();
extern void Get_Gyro_Offset();
extern void Get_Gyro_Val();
extern void Get_AvrgGyro_Val();
extern void Get_Temp_Val();
//////--<><><>----<><><>  S_Ahmad  <<<<  www.RoboticNGO.com  >>>>  MPU6050 Lib  <><><>----<><><>--
#pragma used-
#endif
