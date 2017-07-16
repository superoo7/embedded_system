// #include "calc.h"
#include <Keypad.h>
#include <LiquidCrystal.h> 

// KeyPad
const byte ROWS = 4; // Four rows
const byte COLS = 4; // Four columns
// Define the Keymap
char keys[ROWS][COLS] = {
  {'1','2','3','*'},
  {'4','5','6','/'},
  {'7','8','9','+'},
  {'C','0','=','-'}
};

// Connect keypad ROW0, ROW1, ROW2 and ROW3 to these Arduino pins.
byte rowPins[ROWS] = { 2, 3, 4, 5 };
// Connect keypad COL0, COL1 and COL2 to these Arduino pins.
byte colPins[COLS] = { 14, 15, 16, 17 };

// Create the Keypad
Keypad kpd = Keypad( makeKeymap(keys), rowPins, colPins, ROWS, COLS );

// LCD
LiquidCrystal lcd(7, 8, 9, 10, 11, 12);

/* Calculator
  1 2 3 *
  4 5 6 /
  7 8 9 +
  C 0 = -
*/
enum class Operation :char {
  divide = '/',
  multiply = '*',
  add = '+',
  subtract = '-',
  empty = 'e'
};
 

Operation currentOperation = Operation::empty;         // current Operator is empty
String runningNumber = "";
String leftValString = "";
String rightValString = "";
String result = "";

boolean state = false;

void setup()
{

  // set up the LCD's number of columns and rows:
  lcd.begin(20, 2);
  Serial.begin(9600);
  lcd.setCursor(0,0);
  lcd.print("Calculator");
  lcd.setCursor(0,1);
  lcd.print("by superoo7"); 
  delay(2000);
  printNumber(runningNumber);
}

void loop()
{ 
  
  char key = kpd.getKey();  
  
  if (!state) {
      if(key != NO_KEY && (key=='1'||key=='2'||key=='3'||key=='4'||key=='5'||key=='6'||key=='7'||key=='8'||key=='9'||key=='0')){         
      // number (0-9) pressed
      if (runningNumber != String('0')) {
        runningNumber += String(key);
      } else {
        runningNumber = String(key);
      }
      printNumber(runningNumber);
      Serial.println(runningNumber);
    } else if (key != NO_KEY && (key == '/' || key == '*' || key == '-' || key == '+')){
      if (key == '/') {
        processOperation(Operation::divide);
      } else if (key == '*') {
        processOperation(Operation::multiply);
      } else if (key == '-') {
        processOperation(Operation::subtract);
      } else if (key == '+') {
        processOperation(Operation::add);
      }
  
      
    } else if (key != NO_KEY && key == '=') {
        processOperation(currentOperation);
    } else if (key != NO_KEY && key == 'C'){
        onClearPressed();
    }
    delay(10);
  } else {
    if (key != NO_KEY && key == 'C'){
        onClearPressed();
        state = false;
    } 
  }


}



void processOperation(Operation operation) {
  // if currentOperation is not first time
  if (currentOperation != Operation::empty) {
    // if runningNumber has value
    if (runningNumber != "") {
      rightValString = runningNumber;
      runningNumber = "";
      if (currentOperation == Operation::multiply) {
        result = String( leftValString.toInt() * rightValString.toInt() );
      } else if (currentOperation == Operation::divide) {
        if (rightValString != "0") {
          float resultInFloat = leftValString.toFloat() / rightValString.toFloat();
          // int resultInInt = round(resultInFloat);
          result = String(resultInFloat, 4);
        } else {
          // if rightValString is 0
           state = true;
           printNumber("Value cannot");
           lcd.setCursor(0,1);
           lcd.print("divide by 0");
           return;
        }
      } else if (currentOperation == Operation::add) {
        result = String( leftValString.toInt() + rightValString.toInt() );
      } else if (currentOperation == Operation::subtract) {
        result = String( leftValString.toInt() - rightValString.toInt() );
      }
      leftValString = result;
      printNumber(result);

    }
    currentOperation = operation;  // save currentOperation based on the input operation
     
  } else {
    // first time
     leftValString = runningNumber;
     runningNumber = "";
     currentOperation = operation;          // save currentOperation based on the input operation
  }
}

void onClearPressed() {
  lcd.clear();
  lcd.setCursor(0,0);
  delay(30);
  runningNumber="0";
  printNumber(runningNumber);
  currentOperation = Operation::empty;
  
}

void printNumber(String val){
  lcd.setCursor(0,0);
  lcd.clear();
  lcd.print(val);
}
