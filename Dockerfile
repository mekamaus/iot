FROM resin/raspberrypi-python

ENV INITSYSTEM on

RUN apt-get update \
	&& apt-get install -y python \

COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

CMD ["python", "/app/main.py"]
