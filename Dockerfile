FROM ubuntu:16.04
ADD sources.list /etc/apt/sources.list
RUN apt-get update && apt-get install -y unzip
WORKDIR /root
ADD master.zip ./ssr-libev.zip
RUN unzip -d ssr-libev ssr-libev.zip && rm ssr-libev.zip
WORKDIR /root/ssr-libev/shadowsocksr
RUN apt-get install -y --no-install-recommends build-essential autoconf libtool libssl-dev libpcre3-dev asciidoc
RUN ./configure && make
RUN make install