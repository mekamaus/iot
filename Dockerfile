# FROM resin/raspberrypi-python
#
# # Enable systemd
# ENV INITSYSTEM on
#
# # Install Python.
# RUN apt-get update \
# 	&& apt-get install -y \
# 		sudo \
# 		usbutils \
# 		python \
# 		python-dev \
# 		git-core \
# 		cmake \
# 		g++ \
# 		module-init-tools \
# 		multimedia-jack
#
# # Enable camera
# COPY ./set-camera.sh /set-camera.sh
# RUN chmod +x /set-camera.sh && /set-camera.sh
#
# # Install RTIMULib
# RUN git clone https://github.com/
#
# RUN cd /RTIMULib/Linux/RTIMULibCal \
# 	&& make \
# 	&& make install
#
# RUN cd /RTIMULib/Linux/python \
#   && python setup.py build \
# 	&& python setup.py install
#
# RUN rm -r /RTIMULib
#
# # Install sense hat API
# RUN pip install --upgrade pip \
#  	&& pip install sense-hat
#
# # Install audio library
# RUN apt-get install python-pyaudio libasound2-dev swig
#
# # Install sound analysis package
# RUN pip install SoundAnalyse picamera
#
# # copy current directory into /app
# COPY /app /app
#
# # run python script when container lands on device
# CMD ["python", "/app/main.py"]


FROM resin/rpi-raspbian

ENV TERM dumb

RUN apt-get update && apt-get install -y \
  curl \
  build-essential \
  python-dev \
  git \
  python-pip \
  python-smbus \
  i2c-tools

RUN printf "\ni2c-bcm2708\ni2c-dev" >> /etc/modules

RUN printf "\ndtparam=i2c1=on\ndtparam=i2c_arm=on" >> /boot/config.txt

RUN pip install --upgrade pip && pip install pianohat

# COPY ./pianohat.sh /pianohat.sh
#
# RUN chmod +x ./pianohat.sh
#
# RUN ./pianohat.sh -y

RUN apt-get clean

# RUN pip install --upgrade pip
#
# RUN pip install smbus-cffi cap1xxx RPi.GPIO

RUN curl -sS get.pimoroni.com/i2c | bash -s - "-y"

RUN i2cdetect -y 1

COPY . /app/

CMD ["python", "/app/main.py"]
