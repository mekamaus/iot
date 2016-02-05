from sense_hat import SenseHat
from random import randint
from time import sleep
import numpy
import pyaudio
import analyse
import pyaudio
import analyse

# Initialize PyAudio
pyaud = pyaudio.PyAudio()

sense = SenseHat()

# Open input stream, 16-bit mono at 44100 Hz
# On my system, device 4 is a USB microphone
stream = pyaud.open(
  format = pyaudio.paInt16,
  channels = 1,
  rate = 48000,
  input_device_index = 3,
  input = True)

max = 0
min = 0
while True:
  # Read raw microphone data
  rawsamps = stream.read(1024)
  # Convert raw data to NumPy array
  samps = numpy.fromstring(rawsamps, dtype=numpy.int16)

  if max < max(samps):
    max = max(samps)
  if min > min(samps):
    min = min(samps)
  print(min, max)
  #pixels = [samps[((((i % 8) - 3.5) ** 2 + ((i / 8) - 3.5) ** 2) ** 0.5) * 1024 / (3.5 * 2 ** 0.5 + 0.001)] for i in range(64)]

  #sense.set_pixels(pixels)

  # Show the volume and pitch
  #print(analyse.loudness(samps), analyse.musical_detect_pitch(samps))
