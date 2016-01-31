FROM resin/rpi-raspbian

ENV INITSYSTEM on

RUN apt-get update \
	&& apt-get install -y python

RUN pip3 install sense-hat

COPY ./app /app
CMD ["python", "/app/main.py"]
