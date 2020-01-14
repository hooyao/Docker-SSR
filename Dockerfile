FROM alpine:3.11

ARG SERVER_PORT=1080
ARG CODE_URL=https://github.com/hooyao/shadowsocksr-libev/archive/master.zip

#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add --no-cache --virtual .build-deps \
                                asciidoc \
                                autoconf \
                                build-base \
                                zlib-dev \
                                curl \
                                libtool \
                                linux-headers \
                                openssl-dev \
                                pcre-dev \
                                tar \
                                xmlto && \
    curl ${CODE_URL} -L --output /tmp/ssr.zip && \
    cd /tmp && \
    unzip ssr.zip -d /tmp -q -o && \
    cd /tmp/shadowsocksr-libev-master && \
    ./configure --prefix=/usr --disable-documentation && \
    make install && \
    runDeps="$( \
        scanelf --needed --nobanner /usr/bin/ss-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" && \
    apk add --no-cache --virtual .run-deps $runDeps && \
    apk del .build-deps && \
    rm -f /var/cache/apk/* && \
    rm -rf /tmp/*

RUN mkdir -p /root/config/ 

EXPOSE $SERVER_PORT/tcp $SERVER_PORT/udp            

