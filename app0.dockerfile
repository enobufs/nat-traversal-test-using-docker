FROM ubuntu:16.04
LABEL maintainer="yt0916@gmail.com"

RUN \
# install base base-line
    apt-get update && apt-get install -y build-essential vim tree git curl \
    nodejs npm \
    iputils-ping net-tools bridge-utils iproute2 dnsutils \
    && ln -s /usr/bin/nodejs /usr/bin/node

COPY node-stun.ini /root/.

WORKDIR /root

RUN \
# install STUN
    git clone https://github.com/enobufs/stun.git \
    && cd stun \
    && npm link \
    && cd -

STOPSIGNAL SIGTERM

CMD ["./shared/start_app.sh"]

