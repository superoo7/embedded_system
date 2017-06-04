var five = require("johnny-five");
var board = new five.Board();

board.on("ready", function() {
  var solenoid = new five.Led(5);
  var fan = new five.Led(6);


  // This will grant access to the led instance
  // from within the REPL that's created when
  // running this program.
  this.repl.inject({
    solenoid: solenoid,
    fan: fan
  });


});

