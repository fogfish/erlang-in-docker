.PHONY: all

all:
	cd centos && make docker && make runtime && make publish
	cd alpine && make docker && make runtime && make publish

runtime:
	cd centos && make runtime && make publish
	cd alpine && make runtime && make publish
