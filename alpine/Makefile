## @author     Dmitry Kolesnikov, <dmkolesnikov@gmail.com>
## @copyright  (c) 2014 Dmitry Kolesnikov. All Rights Reserved
##
## Generate a custom Dockerfile to build Docker images for
## various versions of Erlang/OTP.
.PHONY: docker runtime run debug

##
## versions
ERL_VSN ?= 20.2
SSL_VSN ?= 1.0.2n

##
## container identity
ORG    ?= fogfish
APP    ?= erlang-alpine

DOCKER  = ${ORG}/${APP}
RUNTIME = ${ORG}/${APP}-rt

##
## configuration flags
WITH_NATIVE_LIB ?= false
DFLAGS = \
   --rm=true \
   --build-arg OTP_VERSION=${ERL_VSN} \
   --build-arg SSL_VERSION=${SSL_VSN} \
	--build-arg WITH_NATIVE=${WITH_NATIVE_LIB}

##
## 
docker: Dockerfile
	@echo "==> build ${DOCKER}"
	@docker build ${DFLAGS} -t ${DOCKER}:${ERL_VSN} - < $<
	@docker tag ${DOCKER}:${ERL_VSN} ${DOCKER}:latest

##
##
runtime: otp Dockerfile.runtime
	@echo "==> build ${RUNTIME}"
	@docker build -t ${RUNTIME} -f Dockerfile.runtime .
	@docker tag ${RUNTIME}:${ERL_VSN} ${RUNTIME}:latest
	@rm -Rf otp

otp:
	@echo "==> extracting erlang ${ERL_VSN}" ;\
	I=`docker create ${DOCKER}:${ERL_VSN}` ;\
	docker cp $$I:/usr/local/$@ $@ ;\
	docker rm -f $$I

##
## 
run:
	docker run -it ${IFLAGS} ${DOCKER} erl

##
##
debug:
	docker run -it ${IFLAGS} ${DOCKER} bash

##
##
publish:
	@docker push ${DOCKER}:${ERL_VSN}
	@docker push ${DOCKER}:latest
	@docker push ${RUNTIME}:${ERL_VSN}
	@docker push ${RUNTIME}:latest


