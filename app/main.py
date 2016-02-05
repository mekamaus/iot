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

max_samp = 0
min_samp = 0
while True:
  # Read raw microphone data
  rawsamps = stream.read(1024)
  # Convert raw data to NumPy array
  samps = numpy.fromstring(rawsamps, dtype=numpy.int16)

  if max_samp < max(samps):
    max_samp = max(samps)
  if min_samp > min(samps):
    min_samp = min(samps)
  print(min_samp, max_samp)
  values = [samps[((((i % 8) - 3.5) ** 2 + ((i / 8) - 3.5) ** 2) ** 0.5) * 1024 / (3.5 * 2 ** 0.5 + 0.001)] for i in range(64)]
  pixels = [
    (255 * (v + 1024) / 2048, 255 * (v + 1024) / 2048, 255 * (v + 1024) / 2048)
    for v in values
  ]

  sense.set_pixels(pixels)

  #sense.set_pixels(pixels)

  # Show the volume and pitch
  #print(analyse.loudness(samps), analyse.musical_detect_pitch(samps))


# from picamera import PiCamera
# from picamera.array import PiRGBArray
# from sense_hat import SenseHat
#
# sense = SenseHat()
#
# while True:
#   with PiCamera() as camera:
#     camera.resolution = (64, 64)
#     with PiRGBArray(camera, size=(8, 8)) as stream:
#       camera.capture(stream, format='rgb', resize=(8, 8))
#       image = stream.array
#
#   pixels = [
#     pixel
#     for row in image
#     for pixel in row
#   ]
#
#   sense.set_pixels(pixels)
