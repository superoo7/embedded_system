const int G = 13;
const int R = 10;
const int B =  3;
const int A =  2;

void blink();
void goAndBack();
void flash();
void binary();
// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  pinMode(G, OUTPUT);
  pinMode(R, OUTPUT);
  pinMode(B, OUTPUT);
  pinMode(A, OUTPUT);
}

// the loop function runs over and over again forever
void loop() {
  binary();
  blink();
  blink();
  blink();
  goAndBack();
  goAndBack();
  goAndBack();
  flash();
  flash();
}

void binary() {
  for (int i = 0; i <= 9; i++) {
    int b1 = i%2;       // A (LSB)
    int b2 = i/2 %2;    // B
    int b3 = i/4 %2;    // R 
    int b4 = i/8 %2;    // G (MSB)
    digitalWrite(A,b1); // A (LSB)
    digitalWrite(B,b2); // B
    digitalWrite(R,b3); // R 
    digitalWrite(G,b4); // G (MSB)
    delay(500);
  } // end of for loop
  digitalWrite(G,LOW);
  digitalWrite(R, LOW);
  digitalWrite(B, LOW);
  digitalWrite(A, LOW);
  delay(500);
  
}

void blink() {
  
  digitalWrite(G,HIGH);
  delay(500);
  digitalWrite(G, LOW);
  delay(500);
  digitalWrite(R, HIGH);
  delay(500);
  digitalWrite(R, LOW);
  delay(500);
  digitalWrite(B, HIGH);
  delay(500);
  digitalWrite(B, LOW);
  delay(500);
  digitalWrite(A, HIGH);
  delay(500);
  digitalWrite(A, LOW);
  delay(500);
}

void goAndBack() {
  digitalWrite(G,HIGH);
  delay(500);
  digitalWrite(R, HIGH);
  delay(500);
  digitalWrite(B, HIGH);
  delay(500);
  digitalWrite(A, HIGH);
  delay(500);
  digitalWrite(A, LOW);
  delay(500);
  digitalWrite(B,LOW);
  delay(500);
  digitalWrite(R, LOW);
  delay(500);
  digitalWrite(G, LOW);
  delay(500);
}

void flash() {
  digitalWrite(G,HIGH);
  digitalWrite(R, HIGH);
  digitalWrite(B, HIGH);
  digitalWrite(A, HIGH);
  delay(500);
  digitalWrite(G, LOW);
  digitalWrite(R, LOW);
  digitalWrite(B, LOW);
  digitalWrite(A, LOW);
  delay(500);
}

