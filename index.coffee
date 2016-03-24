sense = require './rpi-sense-hat'
glob = require 'glob'

console.log glob.sync '/dev/*'
console.log glob.sync '/dev/input/*'

updateDisplay = (a) -> sense.setPixels (x, y) ->
  dist2 = (x - 3.5) * (x - 3.5) + (y - 3.5) * (y - 3.5)
  fac = 0.35 - .25 * a
  intensity = Math.exp -fac * dist2
  if intensity <= 0.5
    color = [
      Math.ceil 255 * intensity * 2
      0
      0
    ]
  else
    color = [
      255
      Math.ceil 255 * (intensity - 0.5) * 2
      Math.ceil 255 * (intensity - 0.5) * 2
    ]
  color
