# Erlang/OTP in Docker

This project provides images of Erlang/OTP for Docker platform.


## Key features

The development and distribution of Erlang applications is achieved using [release](http://erlang.org/doc/design_principles/release_structure.html). The release contains complete application and all its dependencies, which makes it a perfect distribution package. 

Erlang **runtime environment** to package and ship Erlang releases as Docker containers. Environments provides a minimal images: **centos** `fogfish/erlang-centos-rt` about 341MB and **alpine** `fogfish/erlang-alpine-rt` about 93MB.

Erlang **toolchains** to build Erlang application within the Docker environment. These toolchains are compatible with [Erlang Workflow](https://github.com/fogfish/makefile) and they are assembled from Erlang/OTP **sources**. 

Erlang/OTP **runtime**: 

- `fogfish/erlang-alpine-rt`
- `fogfish/erlang-centos-rt`

Erlang/OTP **toolchain**

- `fogfish/erlang-alpine`
- `fogfish/erlang-centos`


Erlang/OTP **serverless**

- `fogfish/erlang-serverless`


## Getting started

The project supplies pre-built releases for Docker platforms. You can also assemble Docker images by yourself running `make` command. 

Ship your Erlang release with `Dockerfile` 

```dockerfile
FROM fogfish/erlang-alpine-rt

COPY _build/default/rel /rel

ENTRYPOINT spawn-erlang-node my-app
```

Do not forget to exclude ERTS when you are assembling release
```erlang
{include_erts,         false}.
```

As part of your application configuration `vm.args` set a node name:

```
-name ${ERL_NODE}
``` 


Build a docker images and run it using

```
docker run -it my-app
```

Bootstrap script spawns Erlang node `container_id@hostname`. You can customize the behavior

```
docker run -it -h=`hostname` my-app
docker run -it -h=`hostname` -e "NODE=app" my-app
docker run -it -e "NODE=app@localhost.localdomain" my-app
```


See [Erlang Workflow](https://github.com/fogfish/makefile) for details about usage of Erlang toolchains. It assumes that `rebar3` and `relx` tools are used for development. 


## Contributing/Bugs

Project is MIT licensed and accepts contributions via GitHub pull requests:

* Fork the repository on GitHub
* Make a contribution, follows chapter [Contributing to a Project](https://git-scm.com/book/en/v2/Distributed-Git-Contributing-to-a-Project) of Git book.
* Open Pull Request


## License

Copyright (c) 2017 Dmitry Kolesnikov

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.



