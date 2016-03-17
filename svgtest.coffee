coreAudio = require 'node-core-audio'

engine = coreAudio.createNewAudioEngine()

average = (numbers) ->
  sum = 0
  for i in [0...numbers.length]
    sum += numbers[i]
  sum / numbers.length

engine.addAudioCallback (inputBuffer) ->
  global volume
  volume = average(Math.abs(x) for x in inputBuffer[0])
  inputBuffer
