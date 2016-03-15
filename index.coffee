sense = require './rpi-sense-hat'
usleep = require('sleep').usleep

sleep = (delay) =>
  usleep delay * 1000000

t = 0
dt = 0.02
w = 2 * Math.PI

while true
  sense.setPixels (x, y) =>
    dist2 = (x - 3.5) * (x - 3.5) + (y - 3.5) * (y - 3.5)
    intensity = Math.exp -(0.225 + (0.125 * Math.cos(w * t))) * dist2
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
  sleep dt
  t += dt
