IMGNAME_WAN=enobufs/wan
IMGNAME_MBX=enobufs/midbox
IMGNAME_APP=enobufs/app0

.PHONY: build shell run start exec rm clean

build:
	docker build -t $(IMGNAME_WAN) -f docker/wan.dockerfile .
	docker build -t $(IMGNAME_MBX) -f docker/midbox.dockerfile .
	docker build -t $(IMGNAME_APP) -f app0.dockerfile .
	rm -f midbox.tar
	rm -f app0.tar
	docker save enobufs/midbox --output midbox.tar
	docker save enobufs/app0 --output app0.tar

shell:
	docker run -it --rm --privileged --name my_wan -v "$(PWD):/root/shared" $(IMGNAME_WAN):latest /bin/bash

run:
	docker run -t --rm --privileged --name my_wan -v "$(PWD):/root/shared" $(IMGNAME_WAN):latest

start:
	docker start -ia my_wan

exec:
	docker exec -it my_wan /bin/bash

rm:
	docker rm my_wan my_mb0 my_app0

clean:
	rm -f *.tar
	rm -f *.log
