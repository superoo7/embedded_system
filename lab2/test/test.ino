// Potentiometer
// pin A0
const int val = 0;

// Motor
int motor[] = {5,6}; // 5,6 - pwm
const int lowerVal = 0;
int higherVal;
const float maxSpeed = 255.0;
const int minimumSpeed = 93;

// led
const int led1 = 7;   // red
const int led2 = 8;   // green

// Interrupt
// for ISR, has to be volatile when is used in interrupt
// volatile int interruptControl;
volatile byte state = LOW;

const int ledInterrupt = 13;

// Declare Function
void reset();
void interrupt();

void setup() {

  // create interrupt at Digital pin 2
  // attachInterrupt(0, interruptFunction, RISING);
  attachInterrupt(0, toggle, CHANGE);
  attachInterrupt(0, toggle, CHANGE);
  pinMode(ledInterrupt, OUTPUT);

  // Declare motor output
  int counter;
  for (counter=0; counter<2; counter++) {
    pinMode(motor[counter], OUTPUT);
  }

  // Declare led as output
  pinMode(led1, OUTPUT);
  pinMode(led2, OUTPUT);

  // for serial print to show
  Serial.begin(9600);

  
}

void loop() {
  

  if (state) {
    interrupt();
    
   
    
  } else {
    
    int analogVal1 = analogRead(val);
  
    // print
    Serial.print("value: ");
    Serial.println(analogVal1);
    Serial.println("");
  
    // if 0 <= analogVal < 300
    // Turn Left / Anti-Clockwise
    // red LED
    if (analogVal1 >= 0 && analogVal1 <= 300) {
     digitalWrite(led1, HIGH);
     digitalWrite(led2, LOW); 
     // Motor Go Anti-Clockwise
     // use PWM control the output
    
     // lowerVal = 0

     // higherVal (0<=X<=200) 
     // 0 <= analogVal1 < 300
     float higherValA = maxSpeed - (analogVal1 / 300.0 * maxSpeed);
     higherVal = (int) higherValA;

     // Make minimum speed PWM = minimumSpeed
     if (higherVal <= minimumSpeed) {
      higherVal = minimumSpeed;
     }

     
     
     analogWrite(motor[0], lowerVal);
     analogWrite(motor[1], higherVal);
    }
    // if 723 <= analogVal1 < 1024
    // Turn Right / Clockwise
    // green LED
    else if (analogVal1 >= 724 && analogVal1 <= 1023) {
      digitalWrite(led1, LOW);
      digitalWrite(led2, HIGH);
      // Motor Go Clockwise
      // use PWM control the output

      // lowerVal = 0

     // higherVal (0<=X<=255) 
     // 723 <= analogVal1 < 1024
     int convertedVal = analogVal1 - 724;
     float higherValB = (convertedVal / 300.0 * maxSpeed);
     higherVal = (int) higherValB;

     // Make minimum speed PWM = minimumSpeed
     if (higherVal <= minimumSpeed) {
      higherVal = minimumSpeed;
     }
     
     analogWrite(motor[1], lowerVal);
     analogWrite(motor[0], higherVal);
      
    }
    // if 300 <= analogVal1 <= 722
    // Pause
    else {
      reset();
    }

    Serial.print("higherVal: ");

    Serial.println(higherVal);
    
    

    delay(100);

  }
  
  delay(150);

}



void toggle() {
  state = !state;
}

void reset() {
  // reset
  higherVal = 0;
  digitalWrite(led1, LOW);
  digitalWrite(led2, LOW);  
  analogWrite(motor[0], lowerVal);
  analogWrite(motor[1], lowerVal);
  
}

void interrupt() {
  reset();
  digitalWrite(ledInterrupt, HIGH);
  delay(300);
  digitalWrite(ledInterrupt, LOW);
  delay(300);
}

// MOTOR

