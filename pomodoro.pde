#include <Servo.h>

const int ledPins[] = {3,5,6,9,10};
const int speakerPin = 13;
const int ledCount = 5;
const int servoPin = 11;
int startTime;
int active;
boolean finish = false;
Servo servo;

byte names[] = {'c', 'd', 'e', 'f', 'g', 'a', 'b', 'C'};
int tones[] = {1915, 1700, 1519, 1432, 1275, 1136, 1014, 956};
byte melody[] = "2c2p2c2p2c2p2e2p2d2p2d2p2d2p2f2p2e2p2e2p2d2p2d2p4c4p";
int MAX_COUNT = 26;

void setup() {
  pinMode(speakerPin, OUTPUT);
  for (int i=0; i < ledCount; i++) { pinMode(ledPins[i], OUTPUT); }
  servo.attach(servoPin);
  servo.write(90);
  delay(1000);
  servo.detach();
  startTime = millis();

}

void playMelody() {
  for (int count = 0; count < MAX_COUNT; count++) {
    for (int count3 = 0; count3 <= (melody[count*2] - 48) * 30; count3++) {
      for (int count2=0;count2<8;count2++) {
        if (names[count2] == melody[count*2 + 1]) {
          analogWrite(speakerPin,500);
          delayMicroseconds(tones[count2]);
          analogWrite(speakerPin, 0);
          delayMicroseconds(tones[count2]);
        }
        if (melody[count*2 + 1] == 'p') {
          analogWrite(speakerPin, 0);
          delayMicroseconds(500);
        }
      }
    }
  }
}

void fadeLed(int pin) {
  digitalWrite(pin, HIGH);
  delay(200);
  digitalWrite(pin, LOW);
  delay(200);
}

void loop() {
  active = (millis() - startTime)/1000/60/5;
  if (active < 5) {
    fadeLed(ledPins[active]);
  } else {
    if (!finish) {
      finish = true;
      servo.attach(servoPin);
      servo.write(0);
      playMelody();
      servo.detach();
    }
    for (int i=0; i < ledCount; i++) { fadeLed(ledPins[i]); }
  }
}

