FROM resin/raspberrypi-python

ENV INITSYSTEM on

RUN apt-get update \
	&& apt-get install -y python \
	&& rm -rf /var/lib/apt/lists/*

COPY . /app

# run python script when container lands on device
CMD ["python", "/app/main.py"]
