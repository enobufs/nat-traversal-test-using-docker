#!/bin/bash

service docker start
sleep 3

ip link delete docker0

# create docker network, vnet0
docker network create \
    --driver bridge \
    --gateway 192.168.0.1 \
    --ip-range 192.168.0.0/24 \
    --subnet 192.168.0.0/24 \
    -o "com.docker.network.bridge.name"="vnet0" \
    -o "com.docker.network.bridge.enable_icc"="false" \
    -o "com.docker.network.bridge.host_binding_ipv4"="172.19.0.2" \
    vnet0

ifconfig &> ./shared/ifconfig.mb0

docker load -q -i shared/app0.tar

docker run -t --rm --name my_app0 -v $(pwd)/shared:/root/shared --network vnet0 enobufs/app0
