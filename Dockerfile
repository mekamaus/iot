FROM resin/raspberrypi-python

ENV INITSYSTEM on

RUN apt-get update \
	&& apt-get install -y python

RUN pip install sense-hat

COPY ./app /app
CMD ["python", "/app/main.py"]
