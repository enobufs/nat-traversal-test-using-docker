FROM ubuntu:16.04
LABEL maintainer="yt0916@gmail.com"

RUN \
# install base base-line
    apt-get update && apt-get install -y build-essential vim tree git curl \
    nodejs npm \
    iputils-ping net-tools bridge-utils iproute2 dnsutils \
    && ln -s /usr/bin/nodejs /usr/bin/node

RUN \
# install docker
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" \
    && apt-get update && apt-get install -y docker-ce

COPY node-stun.ini /root/.

WORKDIR /root

RUN \
# install STUN
    git clone https://github.com/enobufs/stun.git \
    && cd stun \
    && npm link \
    && cd -

STOPSIGNAL SIGTERM

CMD ["./shared/start_wan.sh"]

# ip addr add 172.17.0.3/16 dev eth0:0
# docker build -t node --network vnet .
# docker run -it --name node01 --network vnet node:latest /bin/bash

# docker build -t node .
# docker run -it --name node01 node:latest /bin/bash

# docker network create -d nat --subnet=192.168.0.0/24 NatNetwork1


