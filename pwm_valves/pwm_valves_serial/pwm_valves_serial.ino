//VARIABLES______________________________________________________

// these are some the PWM pins. note: 5,6 are PWM pins but less reliable - skipped those
const int numValves=3;
int valvePins[numValves] = {3,9,10};
int dutyCylces[numValves];



//_______________________________________________________________

//FUNCTIONS______________________________________________________

//define pwm frequency function
void setPwmFrequency(int pin, int divisor) {
  byte mode;
  if(pin == 5 || pin == 6 || pin == 9 || pin == 10) {
    switch(divisor) {
      case 1: mode = 0x01; break;
      case 8: mode = 0x02; break;
      case 64: mode = 0x03; break;
      case 256: mode = 0x04; break;
      case 1024: mode = 0x05; break;
      default: return;
    }
    if(pin == 5 || pin == 6) {
      TCCR0B = TCCR0B & 0b11111000 | mode;
    } else {
      TCCR1B = TCCR1B & 0b11111000 | mode;
    }
  } else if(pin == 3 || pin == 11) {
    switch(divisor) {
      case 1: mode = 0x01; break;
      case 8: mode = 0x02; break;
      case 32: mode = 0x03; break;
      case 64: mode = 0x04; break;
      case 128: mode = 0x05; break;
      case 256: mode = 0x06; break;
      case 1024: mode = 0x07; break;
      default: return;
    }
    TCCR2B = TCCR2B & 0b11111000 | mode;
  }
}


void saveDutyCycle(int pinIdx, int value){
    dutyCylces[pinIdx]=value;
}


void setDutyCycles(){
    for (int i=0; i<numValves; i++){
        if (dutyCylces[i]==0){
              digitalWrite(valvePins[i],LOW);
            }
        else if (dutyCylces[i]==255){
              digitalWrite(valvePins[i],HIGH);
            }
        else{
        analogWrite(valvePins[i],dutyCylces[i]); 
        }
    }
}


void displayDutyCycles(){
    for (int i=0; i<numValves; i++){
        Serial.print(dutyCylces[i]);
        Serial.print('\t');
    }
    Serial.println();
    Serial.println();
}

//SETUP

void setup() {
    for (int i=0; i<numValves; i++){
        pinMode(valvePins[i], OUTPUT);
        dutyCylces[i]=0;
    }
  
    for (int i=0; i<numValves; i++){
        setPwmFrequency(valvePins[i], 1024);
    }

    Serial.begin(115200);
}


//MAIN LOOP

void loop() {

  while (Serial.available() > 0) {
      for (int i=0; i<numValves; i++){
          saveDutyCycle(i,Serial.parseInt());
      }

      if (Serial.read() == '\n') {
          setDutyCycles();

          displayDutyCycles();
      }
  }
}
