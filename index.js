var sense = require('./rpi-sense-hat/index');
var sleep = require('sleep').sleep;

var g = [0, 255, 0];
var h = [0, 127, 0];
var e = [0, 0, 0];

var pixels = [
  [e, e, e, h, h, e, e, e],
  [e, e, h, g, g, h, e, e],
  [e, h, g, g, g, g, h, e],
  [h, g, g, g, g, g, g, h],
  [e, e, g, g, g, g, e, e],
  [e, e, g, g, g, g, e, e],
  [e, e, g, g, g, g, e, e],
  [e, e, g, g, g, g, e, e]
];

var t = 0;
var dt = 0.1;
var w = 1.0 / (2 * Math.PI);
while(true) {
  for (var y = 8; --y >= 0;) {
    for (var x = 8; --x >= 0;) {
      var dist2 = (x - 3.5) * (x - 3.5) + (y - 3.5) * (y - 3.5);
      var intensity = Math.exp(-(0.2 + (0.15 * Math.cos(w * t))) * dist2);
      var color = [0, 0, 0];
      if (intensity <= 0.5) {
        color = [
          Math.ceil(255 * intensity * 2),
          0,
          0
        ];
      } else {
        color = [
          255,
          Math.ceil(255 * (intensity - 0.5) * 2),
          Math.ceil(255 * (intensity - 0.5) * 2)
        ];
      }
      pixels[y][x] = color;
    }
  }
  sense.setPixels(pixels);
  sleep(dt);
  t += dt;
}

// while (true) {
//   sleep(1);
//   sense.rotation = (sense.rotation + 90) % 360;
// }
