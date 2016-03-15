var fs = require('fs');
var glob = require('glob');
var path = require('path');
var stream = require('streamjs');

var rotation = 0;

var namefile = function(framebuffer) {
  return path.join(framebuffer, 'name');
};

var isSenseHatMatrix = function(dir) {
  try {
    return fs.readFileSync(namefile(dir)).toString().trim() === 'RPi-Sense FB';
  } catch (e) {
    return false;
  }
};

var devname = function(path) {
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

var pos = function(x, y, r) {
  if (r === 0) {
    return 2 * (y * 8 + x);
  }
  if (r === 90) {
    return 2 * (x * 8 + 7 - y);
  }
  if (r === 180) {
    return 2 * ((7 - y) * 8 + 7 - x);
  }
  return 2 * ((7 - x) * 8 + y);
};

var clear = function(fb) {
  for (var y = 8; --y >= 0;) {
    for (var x = 8; --x >= 0;) {
      setPixel(fb, x, y, [0, 0, 0]);
    }
  }
};

var validateRGB = function(rgb) {
  rgb.map(function(col) {
    if (col < 0 || col > 255) throw new Error('RGB color ' + rgb +
      ' violates [0, 0, 0] <= RGB <= [255, 255, 255]');
    return col;
  });
};

var setPixels = function(fb, pixels) {
  var fd = fs.openSync(fb, 'w');
  var buf = new Buffer(2);
  for (var y = 8; --y >= 0;) {
    for (var x = 8; --x >= 0;) {
      var rgb = pixels[y][x];
      validateRGB(rgb);
      var n = pack(rgb);
      fs.writeSync(fd, buf, 0, buf.length, pos(x, y, rotation), function (err, n, _) {});
    }
  }
  fs.closeSync(fd);
};

var getPixels = function (fb) {
  var buf = fs.readFileSync(fb);
  pixels = [];
  for (var y = 8; --y >= 0;) {
    var row = [];
    for (var x = 8; --x >= 0;) {
      var n = buf.readUInt16LE(pos(x, y, rotation));
      var rgb = unpack(n);
      row.push(rgb);
    }
    pixels.push(row);
  }
  return pixels;
};

var unpack = function(n) {
  var r = (n & 0xF800) >> 11;
  var g = (n & 0x7E0) >> 5;
  var b = (n & 0x1F);
  var rc = [r << 3, g << 2, b << 3];
  return rc;
};

var pack = function(rgb) {
  if (rgb.length !== 3)
    throw new Error('length = ' + rgb.length + ' violates length = 3');
  var r = (rgb[0] >> 3) & 0x1F;
  var g = (rgb[1] >> 2) & 0x3F;
  var b = (rgb[2] >> 3) & 0x1F;
  var bits = (r << 11) + (g << 5) + b;
  return bits;
};

var getPixel = function(fb, x, y) {
  if (x < 0 || x > 7) throw new Error('x = ' + x + ' violates 0 <= x <= 7');
  if (y < 0 || y > 7) throw new Error('y = ' + y + ' violates 0 <= y <= 7');

  var buf = fs.readFileSync(fb);
  var n = buf.readUInt16LE(pos(x, y, rotation));
  return unpack(n);
};

var setPixel = function(fb, x, y, rgb) {
  if (x < 0 || x > 7) throw new Error('x = ' + x + ' violates 0 <= x <= 7');
  if (y < 0 || y > 7) throw new Error('y = ' + y + ' violates 0 <= y <= 7');

  rgb.map(function(col) {
    if (col < 0 || col > 255) throw new Error('RGB color ' + rgb +
      ' violates [0, 0, 0] <= RGB <= [255, 255, 255]');
    return col;
  });
  var fd = fs.openSync(fb, 'w');
  var buf = new Buffer(2);
  var n = pack(rgb);
  buf.writeUInt16LE(n, 0);
  fs.writeSync(fd, buf, 0, buf.length, pos(x, y, rotation), function(error, written, _) {
    console.log('Wrote ' + written + ' bytes');
  });
  fs.closeSync(fd);
};

var rot90 = function (matrix) {
  var result = matrix.map(function (row) {
    return row.slice();
  });
  for (var y = 8; --y >= 0;) {
    for (var x = 8; --x >= 0;) {
      result[x][7 - y] = matrix[y][x];
    }
  }
  return result;
};

var pixMap0 = [
  [ 0,  1,  2,  3,  4,  5,  6,  7],
  [ 8,  9, 10, 11, 12, 13, 14, 15],
  [16, 17, 18, 19, 20, 21, 22, 23],
  [24, 25, 26, 27, 28, 29, 30, 31],
  [32, 33, 34, 35, 36, 37, 38, 39],
  [40, 41, 42, 43, 44, 45, 46, 47],
  [48, 49, 50, 51, 52, 53, 54, 55],
  [56, 57, 58, 59, 60, 61, 62, 63]
];
var pixMap90 = rot90(pixMap0);
var pixMap180 = rot90(pixMap90);
var pixMap270 = rot90(pixMap180);

var pixMap = {
    0: pixMap0,
   90: pixMap90,
  180: pixMap180,
  270: pixMap270
};

var rotation = 0;

var setRotation = function (fb, r) {
  if(pixMap[r] === undefined) {
    throw RangeError('Rotation must be 0, 90, 180 or 270 degrees');
  }
  var pixels = getPixels(fb);
  rotation = r;
  setPixels(fb, pixels);
};

var flipHorizontal = function (fb) {
  var pixels = getPixels(fb);
  var flippedPixels = pixels.map(function (row) {
    var flippedRow = row.slice();
    for (var x = 8; --x >= 0;) {
      flippedRow[7 - x] = row[x];
    }
    return flippedRow;
  });
  setPixels(fb, flippedPixels);
};

var flipVertical = function (fb) {
  var pixels = getPixels(fb);
  var flippedPixels = pixels.map(function (row) {
    return row.slice();
  });
  for (var x = 8; --x >= 0;) {
    for (var y = 8; --y >= 0;) {
      flippedPixels[7 - y][x] = pixels[y][x];
    }
  }
  setPixels(fb, flippedPixels);
};

module.exports = {
  getPixel: function(x, y) {
    return getPixel(fb, x, y);
  },
  setPixel: function(x, y, rgb) {
    setPixel(fb, x, y, rgb);
  },
  getPixels: function () {
    return getPixels(fb);
  },
  setPixels: function(pixels) {
    setPixels(fb, pixels);
  },
  clear: function() {
    clear(fb);
  },
  set rotation(r) {
    setRotation(fb, r);
  },
  get rotation() {
    return r;
  }
};
