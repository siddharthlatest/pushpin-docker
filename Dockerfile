#
# Pushpin Dockerfile
#
# https://github.com/sacheendra/pushpin-docker
#

# Pull the base image
FROM ubuntu:15.04
MAINTAINER Sacheendra Talluri <sacheendra.t@gmail.com>

# Install dependencies
RUN \
  apt-get update && \
  apt-get install -y pkg-config libqt4-dev libqca2-dev \
  libqca2-plugin-ossl libqjson-dev libzmq3-dev python-zmq \
  python-setproctitle python-jinja2 python-tnetstring \
  python-blist libcurl4-openssl-dev mongrel2-core git 

# Build Zurl
ENV ZURL_VERSION 1.4.3
RUN \
  git clone https://github.com/fanout/zurl.git /zurl && \
  cd /zurl && \
  git checkout tags/v"$ZURL_VERSION" && \
  git submodule init && git submodule update && \
  ./configure && \
  make && \
  make install

# Build Pushpin
ENV PUSHPIN_VERSION 1.3.1
RUN \
  git clone https://github.com/fanout/pushpin.git /pushpin && \
  cd /pushpin && \
  git checkout tags/v"$PUSHPIN_VERSION" && \
  git submodule init && git submodule update && \
  make

# Configure Pushpin
RUN \
  cd /pushpin && \
  cp examples/config/* . && \
  sed -i -e 's/push_in_http_addr=127.0.0.1/push_in_http_addr=0.0.0.0/' pushpin.conf && \
  sed -i -e 's/stats_spec=ipc:\/\/{rundir}\/pushpin-stats/stats_spec=tcp:\/\/0.0.0.0:5565/' pushpin.conf

# Cleanup
RUN \
  apt-get clean && \
  rm -fr /zurl && \
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
# - 5561: HTTP port to receive real-time messages to update in the app
# - 5565: ZMQ port for listening to stats
EXPOSE 7999
EXPOSE 5561
EXPOSE 5565
