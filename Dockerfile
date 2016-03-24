FROM resin/raspberrypi2-node:0.10.22-onbuildfuriedjkfjskdfsd

# Install any global packages
RUN echo "here"
RUN apt-get upgrade
RUN apt-get update
RUN apt-get install libusb-1.0.0-dev
RUN npm install -g coffee-script

# Setup node environment
COPY package.json /usr/src/app/
RUN TEST_ENVVAR=test DEBIAN_FRONTEND=noninteractive JOBS=MAX npm install --unsafe-perm
COPY . /usr/src/app
RUN ln -s /usr/src/app /app

# Start node environment
CMD npm start
