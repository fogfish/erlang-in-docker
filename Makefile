.PHONY: all

##
## versions
ERL_VSN ?= 22.1
SSL_VSN ?= 1.0.2t

all:
	make -C serverless ERL_VSN=${ERL_VSN} SSL_VSN=${SSL_VSN}
