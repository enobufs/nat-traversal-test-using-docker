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

WORKDIR /root

STOPSIGNAL SIGTERM

CMD ["./shared/start_midbox.sh"]

