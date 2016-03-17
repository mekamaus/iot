sense = require './rpi-sense-hat'
coreAudio = require 'node-core-audio'

audioEngine = coreAudio.createNewAudioEngine()

average = (numbers) ->
  sum = 0
  for i in [0...numbers.length]
    sum += numbers[i]
  sum / numbers.length

updateDisplay = (volume) -> sense.setPixels (x, y) ->
  dist2 = (x - 3.5) * (x - 3.5) + (y - 3.5) * (y - 3.5)
  minVolume = 0
  maxVolume = 0.25
  clampedVolume = max(min(volume, maxVolume), minVolume)
  v = (clampedVolume - minVolume) / (maxVolume - minVolume)
  fac = 0.35 - .25 * v
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


engine.addAudioCallback (inputBuffer) ->
  volume = average(Math.abs(x) for x in inputBuffer[0])
  updateDisplay volume
  inputBuffer
