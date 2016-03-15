var sense = require('rpi-sense-hat/index');
var sleep = require('sleep').sleep;

var g = [0, 255, 0];
var h = [0, 127, 0];
var e = [0, 0, 0];

var pixels = [
  [e, e, e, h, h, e, e, e],
  [e, e, h, g, g, h, e, e],
  [e, h, g, g, g, g, h, e],
  [h, g, g, g, g, g, g, h],
  [e, e, e, g, g, e, e, e],
  [e, e, e, g, g, e, e, e],
  [e, e, e, g, g, e, e, e],
  [e, e, e, g, g, e, e, e]
];

sense.setPixels(pixels);

while (true) {
  sleep(1);
  sense.rotation = (sense.rotation + 90) % 360;
}
