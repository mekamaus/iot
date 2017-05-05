FROM resin/raspberrypi2-node

# Install any global packages
RUN apt-get upgrade
RUN apt-get update
RUN apt-get install libusb-1.0.0-dev

# Setup node environment
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY package.json /usr/src/app/
RUN npm install

COPY . /usr/src/app

# Start node environment
EXPOSE 8080
CMD [ "npm", "start" ]
