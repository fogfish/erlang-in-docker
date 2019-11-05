## @author     Dmitry Kolesnikov, <dmkolesnikov@gmail.com>
## @copyright  (c) 2014 Dmitry Kolesnikov. All Rights Reserved
##
## Generate a custom Dockerfile to build Docker images for
## various versions of Erlang/OTP.
.PHONY: docker layer run debug

##
## versions
ERL_VSN ?=
SSL_VSN ?=

##
## container identity
ORG    ?= fogfish
APP    ?= erlang-serverless

DOCKER  = ${ORG}/${APP}

##
## configuration flags
WITH_NATIVE_LIB ?= false
WITH_PREFIX=/opt
DFLAGS = \
  --rm=true \
  --build-arg OTP_VERSION=${ERL_VSN} \
  --build-arg SSL_VERSION=${SSL_VSN} \
	--build-arg WITH_NATIVE=${WITH_NATIVE_LIB} \
	--build-arg WITH_PREFIX=${WITH_PREFIX}

##
## layer builder
define BUILDER
FROM ${DOCKER}:${ERL_VSN}
RUN cd ${WITH_PREFIX} && zip ${APP}-${ERL_VSN}.zip -r * > /dev/null
endef
export BUILDER

all: docker layer

##
## 
docker: Dockerfile
	@echo "==> build ${DOCKER}"
	@docker build ${DFLAGS} -t ${DOCKER}:${ERL_VSN} .
	@docker tag ${DOCKER}:${ERL_VSN} ${DOCKER}:latest

##
##
layer: ${APP}-${ERL_VSN}.zip
	aws lambda publish-layer-version \
		--layer-name ${APP} \
		--description "${APP} ${ERL_VSN} (ssl ${SSL_VSN})" \
		--zip-file fileb://./$^

${APP}-${ERL_VSN}.zip:
	echo "$$BUILDER" > Dockerfile.layer ;\
	docker build --file=Dockerfile.layer --force-rm=true --tag=build/${APP}:latest . ;\
	I=`docker create build/${APP}:latest` ;\
	docker cp $$I:${WITH_PREFIX}/$@ $@ ;\
	docker rm -f $$I ;\
	docker rmi build/${APP}:latest ;\
	rm Dockerfile.layer ;\
	test -f $@ && echo "==> tarball: $@"

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
