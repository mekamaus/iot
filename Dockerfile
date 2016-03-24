FROM resin/raspberrypi2-node:0.10.22-onbuild
COPY package.json /usr/src/app/
RUN DEBIAN_FRONTEND=noninteractive JOBS=MAX npm install --unsafe-perm
COPY . /usr/src/app
RUN ln -s /usr/src/app /app

RUN apt-get upgrade
RUN apt-get update
RUN apt-get install libusb-1.0.0-dev
RUN npm install -g coffee-script

CMD npm start
