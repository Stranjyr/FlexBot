#include <SoftwareSerial.h>

int sensorPin = 0;
int rawVal = 0;
float EMGval = 0;

void setup() {
Serial.begin(9600);
}

void loop() {
  rawVal = analogRead(sensorPin);
  EMGval = rawVal * 4.80 / 1024;

  Serial.println(EMGval);

  delay(300);

}
