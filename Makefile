USR ?= sys
APP ?= erlang
VSN ?= latest

FLAGS = 

all:
	docker build -t ${USR}/${APP}:${VSN} .

run:
	docker run -it ${FLAGS} ${USR}/${APP}:${VSN}

deb:
	docker run -it ${FLAGS} ${USR}/${APP}:${VSN} bash

