FROM resin/raspberrypi-python

# Enable systemd
ENV INITSYSTEM on

# Install Python.
RUN apt-get update \
	&& apt-get install -y \
		sudo \
		usbutils \
		python \
		python-dev \
		git-core \
		cmake \
		g++ \
		module-init-tools

# Enable camera
RUN chmod +x /set-camera.sh && /set-camera.sh

RUN git clone https://github.com/richards-tech/RTIMULib.git

RUN cd /RTIMULib/Linux/RTIMULibCal \
	&& make \
	&& make install

RUN cd /RTIMULib/Linux/python \
  && python setup.py build \
	&& python setup.py install

# Install sense hat API
RUN pip install --upgrade pip \
 	&& pip install sense-hat

# Install audio library
RUN apt-get install python-pyaudio

# Install sound analysis package
RUN pip install SoundAnalyse picamera

# copy current directory into /app
COPY ./app /app

# run python script when container lands on device
CMD ["python", "/app/main.py"]
