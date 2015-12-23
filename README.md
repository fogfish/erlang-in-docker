# Docker - Erlang/OTP 

The images contains Erlang/OTP suitable to execute and develop applications. It facilitates assembly of standalone Erlang software services deployable to hosts on network, such high-level package is called a release in OTP. It address two major requirements:

1. The production deployment of Erlang application performed on hosts running vanilla Linux distribution. The major assumption -- Erlang/OTP runtime is not installed on target host. The application needs to package and deliver Erlang runtime along with its code. 

1. The application development and operation is performed on various environment; the development environment is built on Mac OS; the production system uses Linux distributions. The developer shall have ability to assemble of production image without access to dedicated build machines .

