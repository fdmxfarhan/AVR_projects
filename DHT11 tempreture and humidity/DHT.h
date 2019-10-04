#ifndef DHT_H_INCLUDED
#define DHT_H_INCLUDED
/*
||
||  Filename:             DHT.h
||  Title:                 DHTxx Driver
||  Author:             Efthymios Koktsidis
||    Email:                efthymios.ks@gmail.com
||  Compiler:             AVR-GCC
||    Description:        Driver DHT11 and DHT22 sensors.
||
*/

//------ Headers ------//
#include <inttypes.h>
#include <delay.h>
#include <mega16.h> 
#include "IO_MACROS.h"
#include "DHT_CONFIG.h"
//----------------------//

//----- Auxiliary data -------------------//
#define DHT11                         1
#define DHT22                         2

#define _DHT_DELAY_SETUP            2000

enum DHT_STATUS_t
{
    DHT_OK,
    DHT_ERROR_HUMIDITY,
    DHT_ERROR_TEMPERATURE,
    DHT_ERROR_CHECKSUM,
    DHT_ERROR_TIMEOUT
};

extern enum DHT_STATUS_t DHT_STATUS;
//-----------------------------------------//

//----- Prototypes---------------------------//
void DHT_setup(void);
void DHT_readRaw(uint8_t arr[4]);
void DHT_readTemperature(float *temp);
void DHT_readHumidity(float *hum);
void DHT_read(float *temp, float *hum);
float DHT_convertToFahrenheit(float temp);
float DHT_convertToKelvin(float temp);
//-------------------------------------------//
#endif