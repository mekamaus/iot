FROM resin/rpi-raspbian

ENV INITSYSTEM on

RUN apt-get update \
	&& apt-get install -y python

RUN pip-3.2 install sense-hat

COPY ./app /app
CMD ["python", "/app/main.py"]
