FROM ubuntu:16.04

ENV DEPENDENCIES gettext build-essential autoconf libtool libssl-dev libpcre3-dev libc-ares-dev\
                 asciidoc xmlto zlib1g-dev libev-dev libudns-dev libsodium-dev \
                 ca-certificates automake libmbedtls-dev
ENV SS_DIR /tmp/shadowsocks-libev
ENV OBSF_DIR /tmp/simple-obfs
ENV SERVER_PORT 8338

ADD sources.list /etc/apt/sources.list

# Set up building environment
# Set up building environment
RUN apt-get update \
 && apt-get install -y git-core
RUN apt-get install --no-install-recommends -y $DEPENDENCIES

# Get the latest code, build and install
RUN git clone https://github.com/shadowsocks/shadowsocks-libev.git $SS_DIR
WORKDIR $SS_DIR
RUN git submodule update --init --recursive \
 && ./autogen.sh \
 && ./configure \
 && make \
 && make install
RUN rm -rf $SS_DIR

RUN git clone https://github.com/shadowsocks/simple-obfs.git $OBSF_DIR
WORKDIR $OBSF_DIR
RUN git submodule update --init --recursive \
 && ./autogen.sh \
 && ./configure \
 && make \
 && make install
RUN rm -rf $OBSF_DIR

# Tear down building environment and delete git repository
WORKDIR /root
RUN mkdir config

# Port in the config file won't take affect. Instead we'll use 8388.
EXPOSE $SERVER_PORT/tcp $SERVER_PORT/udp

