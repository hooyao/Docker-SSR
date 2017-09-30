FROM ubuntu:16.04

ENV DEPENDENCIES build-essential autoconf libtool libssl-dev \
    gawk debhelper dh-systemd init-system-helpers pkg-config asciidoc xmlto apg libpcre3-dev
ENV SSR_DIR /tmp/shadowsocksr-libev
ENV SERVER_PORT 8338

ADD sources.list /etc/apt/sources.list

# Set up building environment
RUN apt-get update \
 && apt-get install -y git-core
RUN apt-get install --no-install-recommends -y $DEPENDENCIES

# Get the latest code, build and install
RUN git clone https://github.com/shadowsocksr-rm/shadowsocksr-libev.git $SSR_DIR
WORKDIR $SSR_DIR
RUN ./configure && make && make install
RUN rm -rf $SSR_DIR

# Tear down building environment and delete git repository
WORKDIR /root
RUN mkdir config

# Port in the config file won't take affect. Instead we'll use 8388.
EXPOSE $SERVER_PORT/tcp $SERVER_PORT/udp

