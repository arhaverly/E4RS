#include <arduinoFFT.h>
#include "send.h"

#define START 10
#define SAMPLES 64             //Must be a power of 2
#define SAMPLING_FREQUENCY 2320 //Hz, must be less than 10000 due to ADC

#define NUMARRAYS   15
#define LOWCUTOFF   160
#define HIGHCUTOFF  1470
#define SAMERANGE   50
#define OUTOFRANGES 8

#define INPUT_DIM    435
int input[INPUT_DIM+1];

double real[NUMARRAYS][SAMPLES];
double imag[SAMPLES];

double peaks[NUMARRAYS];
double guess[NUMARRAYS];

arduinoFFT FFT = arduinoFFT();

unsigned int sampling_period_us;
unsigned long microseconds;

double calcVar(int x){
  double sum = 0;
  for(int i = 0; i < SAMPLES; i++){
    sum += real[x][i];
  }
  double mean = sum / SAMPLES;
  sum = 0;
  for(int i = 0; i < SAMPLES; i++){
    sum += (real[x][i] - mean)*(real[x][i] - mean);
  }
  return (sum / SAMPLES);
}

void setup() {
  // put your setup code here, to run once:
  sampling_period_us = round(1000000*(1.0/SAMPLING_FREQUENCY));
}

void loop() {
  // put your main code here, to run repeatedly:
  /*SAMPLING*/
    unsigned int x;
    int readInt;
    int counter = 0;
    for(int i=0; i<NUMARRAYS; i++){
      for(int j=0; j<SAMPLES; j++){
          microseconds = micros();
          readInt = analogRead(1);
          real[i][j] = readInt;
          x = (microseconds + sampling_period_us);
          while(micros() < x){
          }
      }
      if(i == 0){
        if(calcVar(0) < 20){
          i--;
        }
      }
    }

    int z;
    int inCounter = 0;
    for(int i=0; i<NUMARRAYS; i++){
      FFT.Windowing(real[i], SAMPLES, FFT_WIN_TYP_HAMMING, FFT_FORWARD);
      FFT.Compute(real[i], imag, SAMPLES, FFT_FORWARD);
      FFT.ComplexToMagnitude(real[i], imag, SAMPLES);
      double peak = FFT.MajorPeak(real[i], SAMPLES, SAMPLING_FREQUENCY);
      for(int m = 4; m < SAMPLES/2 + 1; m++){
        z = real[i][m]*0.6;
        if(z < 255){
          input[inCounter] = z;
        }else{
          input[inCounter] = 255;
        }
        inCounter++;
      }
      for(int j = 0; j < SAMPLES; j++){
        imag[j] = 0;
      }
    }

    // 0 = horn
    // 1 = siren
    for(int i=0; i<435; i++){
        Serial.print(input[i]);
        Serial.print(", ");
    }
    Serial.println("0");
}
