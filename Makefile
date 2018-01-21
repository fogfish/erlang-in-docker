.PHONY: all

all:
	cd centos && make docker && make runtime && make publish
	cd alpine && make docker && make runtime && make publish
