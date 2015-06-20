#
# Pushpin Dockerfile
#
# https://github.com/johnjelinek/pushpin-docker
#

# Pull the base image
FROM ubuntu:15.04
MAINTAINER John Jelinek IV <john@johnjelinek.com>

ENV PUSHPIN_VERSION 1.1.0

# Install dependencies
RUN \
  apt-get update && \
  apt-get install -y pkg-config libqt4-dev libqca2-dev \
  libqca2-plugin-ossl libqjson-dev libzmq3-dev python-zmq \
  python-setproctitle python-jinja2 python-tnetstring \
  mongrel2-core zurl git

# Build Pushpin
RUN \
  git clone git://github.com/fanout/pushpin.git /pushpin && \
  cd /pushpin && \
  git checkout tags/v"$PUSHPIN_VERSION" && \
  git submodule init && git submodule update && \
  make

# Configure Pushpin
RUN \
  cd /pushpin && \
  cp examples/config/* . && \
  sed -i -e 's/push_in_sub_spec=tcp:\/\/127.0.0.1:5562/push_in_sub_spec=tcp:\/\/0.0.0.0:5562/' pushpin.conf

# Cleanup
RUN \
  apt-get clean && \
  rm -fr /var/lib/apt/lists/* && \
  rm -fr /tmp/*

# Define working directory
WORKDIR /pushpin

# Copy scripts
ADD ./scripts /pushpin

# Define default command
CMD ["/pushpin/configure_and_run.sh"]

# Expose ports.
# - 7999: HTTP port to forward on to the app
# - 5562: ZMQ port to receive PUB connections
EXPOSE 7999
EXPOSE 5562
