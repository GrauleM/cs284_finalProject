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

// these are some the PWM pins. note: 5,6 are PWM pins but less reliable - skipped those
int Actu1 = 3;
int Actu2 = 9;
int Actu3 = 10;

int transtime1 = 500;
int transtime2 = 1000;
int transtime3=20;
int transtime4=10;
int transtime_between=1000;

int pwmDutyCycles[5] = {0, 75, 120, 170, 255};

void setup() {
   pinMode(Actu1, OUTPUT);
   pinMode(Actu2, OUTPUT);
   pinMode(Actu3, OUTPUT);

   setPwmFrequency(Actu1, 1024); //pins 3,9,10 have base frequency 31250 Hz - devide this value by 1024 (check online - can only devide by specific values)
   setPwmFrequency(Actu2, 1024);
   setPwmFrequency(Actu3, 1024);
}

void loop() {
  if (0){
  for (int i=0;i<5;i++){
    for (float a=0;a<630;a++)
    {
      analogWrite(Actu1,int(180+75*(sin(a/100))));
      analogWrite(Actu2,int(180+75*(sin((a+210.)/100))));
      analogWrite(Actu3,int(180+75*(sin((a+420.)/100))));

      delay(transtime3);
    }
  }
  }
  
  delay(transtime_between); 
    for (int i=0;i<5;i++){
    for (float a=0;a<630;a++)
    {
      analogWrite(Actu1,int(150+95*(sin(a/100))));
      analogWrite(Actu2,int(150-95*(sin(a/100))));
      analogWrite(Actu3,int(150-95*(sin(a/100))));

      delay(transtime4);
    }
  }
  
  delay(transtime_between); 

  for (int i=0;i<5;i++)
  {
    if (pwmDutyCycles[i]==0)
    {
      digitalWrite(Actu1,LOW);
      digitalWrite(Actu1,LOW);
      digitalWrite(Actu1,LOW);
    }
     if (pwmDutyCycles[i]==255)
    {
      digitalWrite(Actu1,HIGH);
      digitalWrite(Actu1,HIGH);
      digitalWrite(Actu1,HIGH);
    }
    analogWrite(Actu1,pwmDutyCycles[i]);
    analogWrite(Actu2,pwmDutyCycles[i]);
    analogWrite(Actu3,pwmDutyCycles[i]);
    delay(transtime2); 

  }
  delay(transtime_between); 
  for (int i=0;i<3;i++)
  {
    digitalWrite(Actu1, HIGH);
    digitalWrite(Actu2, LOW);
    digitalWrite(Actu3, LOW);
    delay(transtime1); 
  
    digitalWrite(Actu1, LOW);
    digitalWrite(Actu2, HIGH);
    digitalWrite(Actu3, LOW);
    delay(transtime1); 
    
    digitalWrite(Actu1, LOW);
    digitalWrite(Actu2, LOW);
    digitalWrite(Actu3, HIGH);
    delay(transtime1); 
  }
}
