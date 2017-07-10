## @author     Dmitry Kolesnikov, <dmkolesnikov@gmail.com>
## @copyright  (c) 2014 Dmitry Kolesnikov. All Rights Reserved
##
## Generate a custom Dockerfile to build Docker images for
## various versions of Erlang/OTP.

##
## container identity
IID ?= fogfish
APP ?= erlang
ERL_VSN ?= 20.0
SSL_VSN ?=  1.0.2l

WITH_NATIVE ?= false

##
## image build flags
DFLAGS = \
   --rm=true \
   --build-arg OTP_VERSION=${ERL_VSN} \
   --build-arg SSL_VERSION=${SSL_VSN} \
	--build-arg WITH_NATIVE=${WITH_NATIVE}

##
## image run flags
IFLAGS =

##
## build container
docker: Dockerfile
	docker build ${DFLAGS} -t ${IID}/${APP}:${ERL_VSN} - < $< 

##
## 
run:
	docker run -it ${IFLAGS} ${IID}/${APP}:${ERL_VSN} erl

##
##
debug:
	docker run -it ${IFLAGS} ${IID}/${APP}:${ERL_VSN} bash
