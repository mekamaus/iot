FROM resin/raspberrypi2-node:0.10.22-onbuild
COPY package.json /usr/src/app/
RUN DEBIAN_FRONTEND=noninteractive JOBS=MAX npm install --unsafe-perm
COPY . /usr/src/app
RUN ln -s /usr/src/app /app

RUN apt-get update
RUN apt-get install libusb-dev
RUN npm install -g coffee-script

CMD npm start
