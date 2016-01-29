FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive
ENV JASPER_HOME /opt/jasper
RUN export JASPER_HOME=$JASPER_HOME

RUN export THREADS=`getconf _NPROCESSORS_ONLN`

RUN export CCFLAGS="-mtune=cortex-a7 -mfpu=neon-vfpv4"; export CPPFLAGS="-mtune=cortex-a7 -mfpu=neon-vfpv4"

RUN apt-get install -y software-properties-common

RUN apt-add-repository -y multiverse

RUN apt-get update; apt-get upgrade -y

RUN apt-get install -y \
        build-essential wget vim git-core python-dev \
        bison libasound2-dev libportaudio-dev python-pyaudio \
        apt-utils alsa-base alsa-utils alsa-oss pulseaudio \
        subversion autoconf libtool automake gfortran \
        python-pymad libttspico-utils

RUN git clone https://github.com/jasperproject/jasper-client.git $JASPER_HOME

RUN git clone https://github.com/xianyi/OpenBLAS.git $JASPER_HOME/OpenBLAS
WORKDIR $JASPER_HOME/OpenBLAS
RUN git checkout v0.2.14
RUN make -j $THREADS TARGET=ARMV7 && make install
RUN echo "/opt/OpenBLAS/lib" > /etc/ld.so.conf.d/openblas.conf && ldconfig
RUN ln -s /opt/OpenBLAS/lib/libopenblas.so /usr/local/lib/libopenblas.so

WORKDIR $JASPER_HOME

RUN wget https://bootstrap.pypa.io/get-pip.py && /usr/bin/python get-pip.py
RUN pip install numpy

RUN echo "options snd-usb-audio index=0" >> /etc/modprobe.d/alsa-base.conf

RUN pip install -r $JASPER_HOME/client/requirements.txt
RUN chmod +x $JASPER_HOME/jasper.py

RUN pip install --upgrade gTTS

