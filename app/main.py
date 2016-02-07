from sense_hat import SenseHat
from random import randint
from time import sleep
import numpy
import pyaudio
import analyse
import pyaudio
import analyse

audio_rate = 44100
num_samples = 8192

# Initialize PyAudio
pyaud = pyaudio.PyAudio()

sense = SenseHat()

# Open input stream, 16-bit mono at 44100 Hz
# On my system, device 4 is a USB microphone
stream = pyaud.open(
  format = pyaudio.paInt16,
  channels = 1,
  rate = audio_rate,
  input_device_index = 3,
  input = True)

min_samp = -512
max_samp = 512

while True:
  # Read raw microphone data
  print(stream.get_read_available())
  rawsamps = stream.read(num_samples)
  # Convert raw data to NumPy array
  samps = numpy.fromstring(rawsamps, dtype=numpy.int16)

  distances = [
    ((((i % 8) - 3.5) ** 2 + ((i / 8) - 3.5) ** 2) ** 0.5)
    for i in range(64)
  ]
  indices = [
    dist * len(samps) / (3.5 * 2 ** 0.5 + 0.001)
    for dist in distances
  ]
  values = [
    samps[index]
    for index in indices
  ]
  pixels = [
    (
      max(min(255 * (v - min_samp) / (max_samp - min_samp), 255), 0),
      max(min(255 * (v - min_samp) / (max_samp - min_samp), 255), 0),
      max(min(255 * (v - min_samp) / (max_samp - min_samp), 255), 0)
    )
    for v in values
  ]

  sense.set_pixels(pixels)

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
