FROM resin/raspberrypi-python

ENV INITSYSTEM on

RUN apt-get update \
	&& apt-get install -y python
  && apt-get install sense-hat
  && pip-3.2 install pillow

COPY ./app /app
CMD ["python", "/app/main.py"]
