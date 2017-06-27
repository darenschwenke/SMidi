#include <ResponsiveAnalogRead.h>

const int pinCount = 16;
const int velocityThreshold = 65;
const int afterThreshold = 75;
const int velocityTime = 55;
const int afterTime = 200;
const int defaultMax = 150;
const float chargeTime = 1; //rise time for external capacitors in us.

ResponsiveAnalogRead pinReader[pinCount] = {
  ResponsiveAnalogRead(A0,true),
  ResponsiveAnalogRead(A1,true),
  ResponsiveAnalogRead(A2,true),
  ResponsiveAnalogRead(A3,true),
  ResponsiveAnalogRead(A4,true),
  ResponsiveAnalogRead(A5,true),
  ResponsiveAnalogRead(A6,true),
  ResponsiveAnalogRead(A7,true),
  ResponsiveAnalogRead(A8,true),
  ResponsiveAnalogRead(A9,true),
  ResponsiveAnalogRead(A15,true),
  ResponsiveAnalogRead(A16,true),
  ResponsiveAnalogRead(A17,true),
  ResponsiveAnalogRead(A18,true),
  ResponsiveAnalogRead(A19,true),
  ResponsiveAnalogRead(A20,true)
};
int pin[] = {A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A15,A16,A17,A18,A19,A20};
int note[] = {60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76};       //MIDI notes
const int midiMin = 10;

int pinMin[pinCount];
int pinMax[pinCount];
int pinTimer[pinCount];
int velocityMask[pinCount];


void setup() {
  //Serial.begin (32500);
  Serial.begin (115200);
  analogReadResolution(10);
  //analogReadAveraging(4);
  // Set baseline capacitance for offset.  Read 20, average, set.
  for (int c = 0; c < 20; c++ ) {
    for (int i = 0; i < pinCount; i++) {
      pinMode(pin[i],INPUT_PULLUP);
      delayMicroseconds(chargeTime);
      pinReader[i].update();
      pinMode(pin[i],OUTPUT);
      digitalWrite(pin[i],LOW);
      delayMicroseconds(20);
    }
  }
  for (int i = 0; i < pinCount; i++) {
      pinMin[i] = pinReader[i].getValue();
      pinMax[i] = defaultMax;
  }
}

void loop () {
  for (int i = 0; i < pinCount; i++) {
    pinMode(pin[i],INPUT_PULLUP);
    delayMicroseconds(chargeTime);
    pinReader[i].update();
    int value = pinMin[i] - pinReader[i].getValue();
    pinMode(pin[i],OUTPUT);
    digitalWrite(pin[i],LOW);
    if (value > velocityThreshold) {
      pinTimer[i] ++;
      if ( value > pinMax[i] ) {
        pinMax[i] = value;
      }
      if (!(velocityMask[i] & (1 << i)) && (pinTimer[i] == velocityTime)) {
        velocityMask[i] |= (1 << i);
        pinTimer [i] = 0;
        int velocity = map (value, 0, pinMax[i], midiMin, 127);
        usbMIDI.sendNoteOn (note[i], velocity, 1);
        Serial.print("NoteOn: ");
        Serial.print(note[i]);
        Serial.print(" : ");
        Serial.println(velocity);
      }
      if (pinTimer [i] == afterTime) {
        pinTimer [i] = 0;
        if (value > afterThreshold) {
          int aftertouch = map (value, 0, pinMax[i], midiMin, 127);
          usbMIDI.sendPolyPressure (note[i], aftertouch, 1);
          Serial.print("PolyPressure: ");
          Serial.print(note[i]);
          Serial.print(" : ");
          Serial.println(aftertouch);
        }
      }
    }
    else {
      if (velocityMask[i] & (1 << i)) {
        velocityMask[i] &= ~ (1 << i);
        usbMIDI.sendNoteOff (note[i], 0, 1);
        Serial.print("NoteOff: ");
        Serial.print(note[i]);
        Serial.print(" : ");
        Serial.println("0");
        pinTimer [i] = 0;
      }
    }
  }
}
