#!/bin/bash

ifconfig &> ./shared/ifconfig.app0

node-stun-client -s 172.17.0.2 &>./shared/stun-client.log
