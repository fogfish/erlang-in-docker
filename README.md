# Erlang/OTP in Docker

This project provides images of Erlang/OTP for Docker platform:

--- | --- 
`fogfish/erlang-centos` | [![Docker Pulls](https://img.shields.io/docker/pulls/fogfish/erlang-centos.svg)](https://github.com/docker-file/erlang) 
`fogfish/erlang-centos-rt` | [![Docker Pulls](https://img.shields.io/docker/pulls/fogfish/erlang-centos-rt.svg)](https://github.com/docker-file/erlang) 
`fogfish/erlang-alpine` | [![Docker Pulls](https://img.shields.io/docker/pulls/fogfish/erlang-alpine.svg)](https://github.com/docker-file/erlang) 
`fogfish/erlang-alpine-rt` | [![Docker Pulls](https://img.shields.io/docker/pulls/fogfish/erlang-alpine-rt.svg)](https://github.com/docker-file/erlang) 



## Key features

* Build from **source code**
* Support **centos** and **alpine** images
* **Build** toolchain for Erlang application
* Minimal **runtime** image 


## Getting started

These docker images are designed to host **application release** 

> When you have written one or more applications, you might want to create a complete system with these applications and a subset of the Erlang/OTP applications. This is called a **release**.

The **release** contains complete system including VM binaries, which makes it a perfect distribution package -- a single file to copy into target environment. 

The project implements a few Docker images to build and package Erlang application. These images are compatible with [Erlang Workflow](https://github.com/fogfish/makefile)
* `fogfish/erlang-centos`
* `fogfish/erlang-alpine`


These images are suitable to build Erlang **release**, which is the distribution package, it includes only those application that are required for operation. Please read [this tutorial about releases](http://learnyousomeerlang.com/release-is-the-word) and [that one too](http://alancastro.org/2010/05/01/erlang-application-management-with-rebar.html).   

As an example a following script builds Erlang release and packages Erlang application into tarball. 

```
FROM fogfish/erlang-centos
ARG VERSION=1.0
COPY . app
RUN cd app && make VSN=${VERSION} && make release VSN=${VERSION}
```

As the result it produces `app-x.y.z+arch.plat.bundle`. Copy and execute this file on the target host (no needs to use any of Erlang images). 

```
FROM centos

COPY app-x.y.z+arch.plat.bundle /tmp/app.bundle
```


The project implements a few Docker runtime images to execute Erlang application in-place
* `fogfish/erlang-centos-rt`
* `fogfish/erlang-alpine-rt`

