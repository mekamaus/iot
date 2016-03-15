var fs = require('fs');
var glob = require('glob');
var path = require('path');
var stream = require('streamjs');

var namefile = function (framebuffer) {
  return path.join(framebuffer, 'name');
};

var isSenseHatMatrix = function (dir) {
  try {
    return fs.readFileSync(namefile(dir)).toString().trim() === 'RPi-Sense FB';
  } catch (e) {
    return false;
  }
};

var devname = function (path) {
  return '/dev/' + path.split('/').reverse()[0];
};

var files = glob.sync('/sys/class/graphics/fb*');
var a = stream(files)
  .filter(isSenseHatMatrix)
  .findFirst();

if (!a.isPresent()) {
  console.error(
    'Cannot find a Raspberry Pi Sense HAT matrix LED! Are we running on a Pi?'
  );
  return;
}

var fb = devname(a.get());
console.log('Found framebuffer ' + fb);

var pos = function (x, y) {
  return 2 * (y * 8 + x);
};

var clear = function (fb) {
  for (var y = 8; --y >= 0;) {
    for (var x = 8; --x >= 0;) {
      setPixel(fb, x, y, [0, 0, 0]);
    }
  }
};

var random = function (low, high) {
  return Math.floor(Math.random() * (high - low) + low);
};

var unpack = function (n) {
  var r = (n & 0xF800) >> 11;
  var g = (n & 0x7E0) >> 5;
  var b = (n & 0x1F);
  var rc = [r << 3, g << 2, b << 3];
  return rc;
};

var pack = function (rgb) {
  if (rgb.length !== 3)
    throw new Error('length = ' + rgb.length + ' violates length = 3');
  var r = (rgb[0] >> 3) & 0x1F;
  var g = (rgb[1] >> 2) & 0x3F;
  var b = (rgb[2] >> 3) & 0x1F;
  var bits = (r << 11) + (g << 5) + b;
  return bits;
};

var getPixel = function (fb, x, y) {
  if (x < 0 || x > 7) throw new Error('x = ' + x + ' violates 0 <= x <= 7');
  if (y < 0 || y > 7) throw new Error('y = ' + y + ' violates 0 <= y <= 7');

  var buf = fs.readFileSync(fb);
  var n = buf.readUInt16LE(pos(x, y));
  return unpack(n);
};

var setPixel = function (fb, x, y, rgb) {
  if (x < 0 || x > 7) throw new Error('x = ' + x + ' violates 0 <= x <= 7');
  if (y < 0 || y > 7) throw new Error('y = ' + y + ' violates 0 <= y <= 7');

  rgb.map(function (col) {
    if (col < 0 || col > 255) throw new Error('RGB color ' + rgb +
      ' violates [0, 0, 0] <= RGB <= [255, 255, 255]');
    return col;
  });
  var fd = fs.openSync(fb, 'w');
  var buf = new Buffer(2);
  var n = pack(rgb);
  buf.writeUInt16LE(n, 0);
  fs.writeSync(fd, buf, 0, buf.length, pos(x, y), function (error, written, _) {
    console.log('Wrote ' + written + ' bytes');
  });
  fs.closeSync(fd);
};

console.log('Pixel (0,0) = ' + getPixel(fb, 0, 0));
for (var n = 1; --n >= 0;) {
  for (var y = 8; --y >= 0;) {
    for (var x = 8; --x >= 0;) {
      setPixel(fb, x, y, [random(0, 255), random(0, 255), random(0, 255)]);
    }
  }
}
console.log('Pixel (0,0) = ' + getPixel(fb, 0, 0));

var sense = {
  namefile: namefile,
  isSenseHatMatrix: isSenseHatMatrix,
  devname: devname,
  unpack: unpack,
  pack: pack,
  pos: pos,
  getPixel: getPixel,
  setPixel: setPixel,
  clear: clear,
  random: random
};

//sense.setPixel(fb, 0, 0, [0, 0, 0]);
