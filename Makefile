##
## container identity
IID ?= fogfish
APP ?= erlang
VSN ?= 18.2.1

##
## image build flags
DFLAGS = \
   --rm=true \
   --build-arg SSL=1.0.2f \
   --build-arg OTP=${VSN}

##
## image run flags
IFLAGS =

##
## build container
docker: Dockerfile
	docker build ${DFLAGS} -t ${IID}/${APP}:${VSN} - < $< 

##
## 
run:
	docker run -it ${IFLAGS} ${IID}/${APP}:${VSN}

##
##
debug:
	docker run -it ${IFLAGS} ${IID}/${APP}:${VSN} bash

