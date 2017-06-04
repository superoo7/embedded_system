var five = require("johnny-five");

var state = "";

five.Board().on("ready", function() {
	// AC (pin5)
	var solenoid = new five.Led(5);
  solenoid.off();
	// Fan (pin6)
	var fan = new five.Led(4);
	fan.off();
	// LCD
	lcd = new five.LCD({
	    pins: [7, 8, 9, 10, 11, 12],
			backlight: 6,
			rows: 2,
			cols: 20
			});
	lcd.useChar("circle");
	lcd.clear().print("Started lcd");


	var temperature = new five.Thermometer({
    controller: "LM35",
    pin: "A0"
  });

  temperature.on("change", function() {
    console.log(this.celsius + "°C", this.fahrenheit + "°F");
  	lcd.clear().cursor(0,0);
		lcd.print(this.celsius + " :circle:C " + this.fahrenheit + " :circle:F");
		if (this.celsius > 24) {
			state = "A/C on";
			solenoid.on();
			fan.off();
		} else if (this.celsius > 22){
			state = "Fan on";
			solenoid.off();
			fan.on();
		} else {
			state = "Both off";
			solenoid.off();
			fan.off();
		}
		lcd.cursor(1,0).print(state);
		console.log(state);
		pause(500);
	});

  this.repl.inject({
    lcd: lcd,
    fan: fan,
    solenoid: solenoid
  });

});



function pause(milliseconds) {
	var dt = new Date();
		while ((new Date()) - dt <= milliseconds) { /* Do nothing */ }
}
