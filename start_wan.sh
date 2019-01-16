#!/bin/bash

service docker start
sleep 3

ip link delete docker0

# add secondary IP address for STUN server
ip addr add 172.17.0.3/16 dev eth0:0

# create docker network, vnet0
docker network create \
    --driver bridge \
    --gateway 172.19.0.1 \
    --ip-range 172.19.0.0/24 \
    --subnet 172.19.0.0/24 \
    -o "com.docker.network.bridge.name"="mb0" \
    -o "com.docker.network.bridge.enable_ip_masquerade"="true" \
    -o "com.docker.network.bridge.enable_icc"="false" \
    -o "com.docker.network.bridge.host_binding_ipv4"="0.0.0.0" \
    -o "com.docker.network.driver.mtu"="1500" \
    mb0

ifconfig &> ./shared/ifconfig.wan

node-stun-server &>./shared/stun-server.log &

docker load -q -i shared/midbox.tar

docker run -t --rm --privileged --name my_mb0 -v $(pwd)/shared:/root/shared --network mb0 enobufs/midbox

