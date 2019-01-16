# Demo: NAT traversal test using Docker

## Overview

Testing applications in a NATted (things behind Network Address Translators)
environment is hard because it usually requires a manual operations with
specifically set up many pieces of hardware such as separate host PCs,
routers and switches.

This demonstrates how we could easily set up such natted environment, emulated
using Docker, which is accomplished within a single host machine, suitable for
CI testing.


## Configuration (proposed)

The solution uses `Docker-in-Docker` technique to enable isolated virtual
subnets behind a NAT (based on iptables Docker uses) as shown below:


```
  +---------------------------------------------------------------------------+
  |Container(WAN)    +-------------------------------------------------------+|
  |                  |Container(MIDBOX)  +----------------------------------+||
  |                  |       (NAT)       |Container(APP)                    |||
  |                  |                   |          +----------------+      |||
  |eth0           mb0|eth0          vnet0|eth0     +----------------+|      |||
  o---------+--------o--[IP Masquerade]--o         |  Applicaiton   ||      |||
  |         |        |       (NAT)       |         |                |+      |||
  |         |        |                   |         +----------------+       |||
  |         |        |                   +----------------------------------+||
  |         |        +-------------------------------------------------------+|
  |         |        +-------------------------------------------------------+|
  |         |        |                   +----------------------------------+||
  |         |        |                   |          +----------------+      |||
  |         |     mb1|eth0          vnet0|eth0     +----------------+|      |||
  |         +--------o--[IP Masquerade]--o         |  Applicaiton   ||      |||
  |                  |                   |         |                |+      |||
  |                  |                   |         +----------------+       |||
  |                  |                   +----------------------------------+||
  |                  +-------------------------------------------------------+|
  +---------------------------------------------------------------------------+
```

## Running Demo
The demo runs a RFC 3489 STUN discovery testing which would ascertain types of NAT.
STUN server will be running on "WAN" container, and STUN client will be running on
"APP" container.


First, build three images: wan, midbox and vnet.
```
make build
```

Then, run..
```
make run
```

On successful completion, you should see logs like below:
```
$ cat stun-client.log
NB-Rtx0: len=20 retrans=1 elapsed=0 to=172.17.0.2:3478
CHANGED: addr=172.17.0.3:3479
MAPPED0: addr=172.19.0.2:55990
MAPPED1: addr=172.19.0.2:55990
MAPPED2: addr=172.19.0.2:55990
MAPPED3: addr=172.19.0.2:55990
EF-Rtx0: retrans=1 elapsed=0
EF-Rtx1: retrans=1 elapsed=0
EF-Rtx0: retrans=2 elapsed=0
EF-Rtx1: retrans=2 elapsed=0
EF-Rtx0: retrans=3 elapsed=0
EF-Rtx1: retrans=3 elapsed=0
EF-Rtx0: retrans=4 elapsed=0
EF-Rtx1: retrans=4 elapsed=0
EF-Rtx0: retrans=5 elapsed=0
EF-Rtx1: retrans=5 elapsed=0
EF-Rtx0: retrans=6 elapsed=0
EF-Rtx1: retrans=6 elapsed=0
EF-Rtx0: retrans=7 elapsed=0
EF-Rtx1: retrans=7 elapsed=0
EF-Rtx0: retrans=8 elapsed=0
EF-Rtx1: retrans=8 elapsed=0
Complete(0): Natted NB=I EF=APD (Port-restricted cone) mapped=172.19.0.2:55990 rtt=0
All sockets closed.
```

As you can see, Docker's (iptables') IP masquerade exhibits "Port-restricted cone" behavior.

Now, you can replace those docker files with your own application!


## Caveat / Consideration / TODO
* Running docker daemon inside a container is generally not recommended. :pray:
* Explore if this can be achieved using docker-compose.
* Build&run takes some time. Consider using smaller base images.
* The diagram above is not too accurate. (e.g. "Application" is a container). Fixed later.
