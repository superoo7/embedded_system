// constant
// pin number
const int fanPin = 9;
const int acPin = 10;
const int tempPin = 0;

// LCD


// variable
float inputVal, v;
int tempInC, tempInF;


// declare function
int calcCelcius(float volt);
int calcFarh(int cel);
void acOn();
void fanOn();
void allOff();

void setup() {
  // LCD

  // other Pin
  pinMode(fanPin, OUTPUT);
  pinMode(acPin, OUTPUT);

  // Serial
  Serial.begin(9600);
  
}

void loop() {
    // Temperature LM35
    inputVal = analogRead(tempPin);
    // celcius = ( val/1024.0)*5000/10
    v = map(inputVal, 0, 1024, 0, 500);
    tempInC = calcCelcius(v);
    tempInF = calcFarh(tempInC);

    Serial.println(tempInC);
    Serial.println(tempInF);
    Serial.println("");

    // Print at LCD
    
    
    // A/C and Fan control system
    if (tempInC > 24) {
      acOn();
    } else if (tempInC > 22 && tempInC <= 24) {
      fanOn();
    } else {
      allOff();
    }
    
    
    delay(100);
}

// function that calculate celcius
int calcCelcius(float volt) {
  int cel = (int) volt;
  return cel;
}

// function that calculate farenheit
int calcFarh(int cel) {
  int farh = (int) ((cel*9)/5 + 32);
  return farh;
}

// function that turn A/C on
void acOn() {
  digitalWrite(acPin, HIGH);
  digitalWrite(fanPin, LOW);
}

// function that turn fan on
void fanOn() {
  digitalWrite(acPin, LOW);
  digitalWrite(fanPin, HIGH);  
}

// function that turn everything off
void allOff() {
  digitalWrite(acPin, LOW);
  digitalWrite(fanPin, LOW);  
}

