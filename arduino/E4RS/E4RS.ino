#include "locate.h"
#include "identify.h"
#include "send.h"

char bleOut[5];
char * recLoc;

int lastTime = 0;
int currentTime = 0;

void setup() {
    Serial.begin(115200);
    lSetup();
    bleOut[4] = '\0';
    Serial.println("setup");
    iSetup();
    BLESetup();
}
void loop() {

  currentTime = micros();
  
  if(readItA == 1 && readItB == 1 && readItC == 1 && (currentTime - lastTime) > 2000000){
    locate();
    printAngle();
    bleOut[0] = iLoop();
    reset();
    lastTime = currentTime;

    bleOut[1] = sendL1();
    bleOut[2] = sendL2();
    bleOut[3] = sendL3();
    BLESend(bleOut);
  }

}
