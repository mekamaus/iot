# FROM ubuntu
#
# ENV DEBIAN_FRONTEND noninteractive
#
# MAINTAINER Sam Adams
#
# RUN echo "deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc) main universe" >> /etc/apt/sources.list
#
# RUN apt-get update
#
# RUN apt-get install -y tar git curl nano wget dialog net-tools build-essential
#
# RUN apt-get install -y libblas3 liblapack3 gcc gfortran libc6
# RUN apt-get build-dep -y python-imaging
# RUN apt-get install -y libjpeg8 libjpeg62-dev libfreetype6 libfreetype6-dev
# RUN apt-get install -y python python-dev python-distribute python-pip
# RUN pip install -r /app/requirements.txt
#
# ADD ./app /app
#
# EXPOSE 80
#
# WORKDIR /app
#
# CMD ["python", "/app/main.py"]

FROM resin/raspberrypi-python

# Enable systemd
ENV INITSYSTEM on

# Install Python.
RUN apt-get update \
	&& apt-get install -y sudo usbutils python python-dev git-core cmake g++ module-init-tools
# RUN apt-get update \
# 	&& apt-get install -y python \
# 	# Remove package lists to free up space
# 	&& rm -rf /var/lib/apt/lists/*
  # Install dependencies
	#&& apt-get install -y tar git curl nano wget net-tools build-essential \
	#&& apt-get install -y gcc libc6 \
	#&& apt-get build-dep -y python-imaging \
	#&& apt-get install -y libjpeg8 libjpeg62-dev libfreetype6 libfreetype6-dev \
	#&& apt-get install -y python python-dev python-distribute python-pip \
	#&& apt-get install -y python-dev \

# Install RTIMULib
# RUN git clone https://github.com/richards-tech/RTIMULib.git /RTIMULib \
# 	&& cd /RTIMULib/RTIMULib \
# 	&& mkdir build \
# 	&& cd build \
# 	&& cmake \
# 	&& make \
# 	&& make install \
# 	&& ldconfig

RUN git clone https://github.com/richards-tech/RTIMULib.git

RUN cd /RTIMULib/Linux/RTIMULibCal \
	&& make \
	&& make install

RUN cd /RTIMULib/Linux/python \
  && python setup.py build \
	&& python setup.py install

	# && cd ./RTIMULib/Linux/python \
	# && python setup.py build \
	# && python setup.py install \
	# && cd ../../.. \
	# Install sense-hat API
	&& pip install sense-hat

# copy current directory into /app
COPY ./app /app

# run python script when container lands on device
CMD ["python", "/app/main.py"]
