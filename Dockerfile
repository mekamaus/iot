FROM resin/raspberrypi-python

ENV INITSYSTEM on

RUN apt-get update \
	&& apt-get install -y python \

COPY ./requirements.txt /requirements.txt
RUN apt-get install python-sense-hat

CMD ["python", "/app/main.py"]