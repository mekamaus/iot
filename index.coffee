sense = require './rpi-sense-hat'
glob = require 'glob'
color = require 'color'
hid = require 'node-hid'

console.log hid.devices()

updateDisplay = (a) -> sense.setPixels (x, y) ->
  dist2 = (x - 3.5) * (x - 3.5) + (y - 3.5) * (y - 3.5)
  fac = 0.35 - .25 * a
  intensity = Math.exp -fac * dist2
  color('red').lightness(intensity).rgbArray()
