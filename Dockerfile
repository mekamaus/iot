FROM resin/raspberrypi-python

ENV INITSYSTEM on

RUN apt-get update \
	&& apt-get install -y python \
	&& rm -rf /var/lib/apt/lists/*

RUN apt-get install sense-hat
RUN pip install pillow

COPY . /app

# run python script when container lands on device
CMD ["python", "/app/main.py"]
