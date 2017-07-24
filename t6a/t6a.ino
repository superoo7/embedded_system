#define M1 3
#define M2 5
#define MINSPEED 100

#define GREEN 11
#define RED 12

float time;


void setup() {
	pinMode(M1, OUTPUT);
	pinMode(M2, OUTPUT);
	pinMode(GREEN, OUTPUT);
	pinMode(RED, OUTPUT);
}

void loop() {

	// 5 seconds / (255-minspeed) <- number of intervals
	time = (5) / (255 - MINSPEED);

	// clockwise 5 seconds
	digitalWrite(GREEN, HIGH);
	digitalWrite(RED, LOW);
	for (int i = MINSPEED; i <= 255; i++) {
		analogWrite(M1, i);
		analogWrite(M2, 0);
		delay(time);
	}

	// pause 2 seconds
	digitalWrite(GREEN, LOW);
	digitalWrite(RED, LOW);
	analogWrite(M1, 0);
	analogWrite(M2, 0);
	delay(2000);

	// counter clockwise 5 seconds
	digitalWrite(GREEN, LOW);
	digitalWrite(RED, HIGH);
	for (int i = MINSPEED; i <= 255; i++) {
		analogWrite(M1, 0);
		analogWrite(M2, i);
		delay(time);
	}

}
