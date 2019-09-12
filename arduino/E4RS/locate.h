#include <math.h>
#include <cmath>
#define pinA 9
#define pinB 10
#define pinC 11

double divisor;

int time = 0;

int angle = 0;
int micA;
int micB;
int micC;

boolean readOnce = false;
boolean angleRead = false;

boolean help = false;


volatile int newTimeA = 0;
volatile int oldTimeA = 0;
int readItA = 0;

char locationGuess[4];

void isrPINA(){
    oldTimeA = newTimeA;
    if(readItA == 0){
      newTimeA = micros();
    }
    readItA = 1;
    help = true;
    Serial.print("A ");
}


volatile int newTimeB = 0;
volatile int oldTimeB = 0;
int readItB = 0;


void isrPINB(){
    oldTimeB = newTimeB;
    if(readItB == 0){
      newTimeB = micros();
    }
    readItB = 1;
    Serial.print("B ");
}

volatile int newTimeC = 0;
volatile int oldTimeC = 0;
int readItC = 0;


void isrPINC(){
    oldTimeC = newTimeC;
    if(readItC == 0){
      newTimeC = micros();
    }
    readItC = 1;
    Serial.print("C ");
}

void reset(){
  readItA = 0;
  readItB = 0;
  readItC = 0;
  readOnce = false;
  angleRead = false;
}

void printAngle(){
  angleRead = true;
  Serial.print(angle);
  locationGuess[0] = '0' + char(angle / 100);
  locationGuess[1] = '0' + char((angle % 100) / 10);
  locationGuess[2] = '0' + char(angle % 10);
}

void locate(){

    double divisor;
      if(readItA == 1 && readItB == 1 && readItC == 1 && !readOnce){
        readOnce = true;
          micA = newTimeA;
          micB = newTimeB;
          micC = newTimeC;
          //set micA to 0
          if(micA < micB && micA < micC && micA != 0){
              micB -= micA;
              micC -= micA;
              micA = 0;
          //set micB to 0
          }else if(micB < micA && micB < micC && micB != 0){
              micA -= micB;
              micC -= micB;
              micB = 0;
          //set micC to 0
      }else if(micC < micA && micC < micB && micC != 0){
              micA -= micC;
              micB -= micC;
              micC = 0;
          }
      }
      //micA first
      if(micA == 0 && micB != 0 && micC != 0){
          //hextant 1
          if(micC <= micB){
              divisor = 1.0*micC/micB;
              if(divisor > 3.0/4){
                  angle = 90;
              }else if(divisor > 1.0/2){
                  angle = 75;
              }else if(divisor > 1.0/4){
                  angle = 60;
              }else{
                  angle = 45;
              }
          //hextant 2
          }else{
              divisor = 1.0*micB/micC;
              if(divisor > 3.0/4){
                  angle = 90;
              }else if(divisor > 1.0/2){
                  angle = 105;
              }else if(divisor > 1.0/4){
                  angle = 120;
              }else{
                  angle = 135;
              }
          }
//          if(!angleRead){
//            printAngle();
//          }
      //micB first
      }else if(micB == 0 && micA != 0 && micC != 0){
          //hextant 3
          if(micA <= micC){
              divisor = 1.0*micA/micC;
              if(divisor > 3.0/4){
                  angle = 210;
              }else if(divisor > 1.0/2){
                  angle = 195;
              }else if(divisor > 1.0/4){
                  angle = 180;
              }else{
                  angle = 165;
              }
          //hextant 4
          }else{
              divisor = 1.0*micC/micA;
              if(divisor > 3.0/4){
                  angle = 210;
              }else if(divisor > 1.0/2){
                  angle = 225;
              }else if(divisor > 1.0/4){
                  angle = 240;
              }else{
                  angle = 255;
              }
          }
//          if(!angleRead){
//              printAngle();
//          }
      //micC first
  }else if(micC == 0 && micA != 0 && micB != 0){
          //hextant 5
          if(micB <= micA){
              divisor = 1.0*micB/micA;
              if(divisor > 3.0/4){
                  angle = 330;
              }else if(divisor > 1.0/2){
                  angle = 315;
              }else if(divisor > 1.0/4){
                  angle = 300;
              }else{
                  angle = 285;
              }
          //hextant 6
          }else{
              divisor = 1.0*micA/micA;
              if(divisor > 3.0/4){
                  angle = 330;
              }else if(divisor > 1.0/2){
                  angle = 345;
              }else if(divisor > 1.0/4){
                  angle = 0;
              }else{
                  angle = 15;
              }
          }
//          if(!angleRead){
//              printAngle();
//          }
      }

      if(angle < 0){
          angle += 360;
      }
      Serial.print("\n");
      printAngle();
      
}

void lSetup(void){
  //THICC
  attachInterrupt(digitalPinToInterrupt(pinA), isrPINA, FALLING);
  attachInterrupt(digitalPinToInterrupt(pinB), isrPINB, FALLING);
  attachInterrupt(digitalPinToInterrupt(pinC), isrPINC, FALLING);
}

char sendL1(){
    return locationGuess[0];
}

char sendL2(){
    return locationGuess[1];
}

char sendL3(){
    return locationGuess[2];
}







