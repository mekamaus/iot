import sense from 'rpi-sense-hat';
import glob from 'glob';
import color from 'color';
//import hid from 'node-hid';

//console.log(hid.devices());

var updateDisplay = a => sense.setPixels((x, y) => {
  const dist2 = (x - 3.5) * (x - 3.5) + (y - 3.5) * (y - 3.5);
  const fac = .35 - .25 * a;
  const intensity = Math.exp -fac * dist2;
  color('red').lightness(intensity).rgbArray();
});
