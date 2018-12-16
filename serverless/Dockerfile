## @author     Dmitry Kolesnikov, <dmkolesnikov@gmail.com>
## @copyright  (c) 2014 Dmitry Kolesnikov. All Rights Reserved
##
## @description
##   Erlang/OTP from scratch 
FROM amazonlinux
MAINTAINER Dmitry Kolesnikov <dmkolesnikov@gmail.com>

##
## build essential tools
RUN set -e \
   && yum -y install \
      autoconf \
      gcc \
      gcc-c++ \
      git \
      glibc-devel \
      make \
      ncurses-devel \
      tar

##
## install open ssl
ARG SSL_VERSION

RUN set -e \
   && mkdir -p /tmp/openssl \
   && cd /tmp \
   && curl -fSL -o openssl.sha256   http://www.openssl.org/source/openssl-${SSL_VERSION}.tar.gz.sha256 \
   && curl -fSL -o openssl.tar.gz http://www.openssl.org/source/openssl-${SSL_VERSION}.tar.gz \
   && SHA=$(printf "%s  openssl.tar.gz" `cat openssl.sha256` | sha256sum -c -); if [ "openssl.tar.gz: OK" != "${SHA}" ]; then exit 3; fi \
   && tar -zxf openssl.tar.gz -C /tmp/openssl --strip-components=1 \
   && cd /tmp/openssl \
   && ./Configure \
         --prefix=/usr/local/ssl \
         --openssldir=/usr/local/ssl \
      linux-x86_64 \
      shared \
   && make -j4 \
   && make install \
   && rm -Rf /tmp/openssl*

##
## download
ARG OTP_VERSION
ARG WITH_NATIVE

RUN set -e \
   && mkdir -p /tmp/otp_src \
   && cd /tmp \
   && curl -fSL -o otp_src.tar.gz https://github.com/erlang/otp/archive/OTP-${OTP_VERSION}.tar.gz \
   && tar -zxf otp_src.tar.gz -C /tmp/otp_src --strip-components=1 \
   && cd /tmp/otp_src \
   && ./otp_build autoconf \
   && ./configure \
         --prefix=/var/task/serverless \
         --enable-threads \
         --enable-smp-support \
         --enable-kernel-poll \
         --enable-hipe \
         --disable-dynamic-ssl-lib \
         --with-ssl=/usr/local/ssl \
         --without-termcap \
         --without-javac \
         --without-wx \
         --without-debugger \
         --without-observer \
         --without-jinterface \
         --without-cosEvent\
         --without-cosEventDomain \
         --without-cosFileTransfer \
         --without-cosNotification \
         --without-cosProperty \
         --without-cosTime \
         --without-cosTransactions \
         --without-et \
         --without-gs \
         --without-ic \
         --without-megaco \
         --without-orber \
         --without-percept \
         --without-typer \
         --without-edoc \
         --without-common_test \
         --without-eunit \
         --without-reltool \
         --without-mnesia \
         --without-erl_docgen \
         --without-dialyzer \
         --without-diameter \
         --without-eldap \
         `test "${WITH_NATIVE}" = "true" && echo "--enable-hipe --enable-native-libs"` \
   && make -j4 \
   && make install \
   && rm -Rf /tmp/otp_src* \
   && for I in /var/task/serverless/lib/erlang/erts* /var/task/serverless/lib/erlang/lib/* ;\
      do \
         rm -rf ${I}/src; \
         rm -rf ${I}/doc; \
         rm -rf ${I}/man; \
         rm -rf ${I}/examples; \
         rm -rf ${I}/emacs; \
         rm -rf ${I}/c_src; \
      done \
   && rm -rf /var/task/serverless/lib/erlang/erts-*/lib/ \
   && rm /var/task/serverless/bin/dialyzer \
   && rm /var/task/serverless/lib/erlang/bin/dialyzer \
   && rm /var/task/serverless/lib/erlang/erts-*/bin/dialyzer \
   && rm /var/task/serverless/bin/erlc \
   && rm /var/task/serverless/lib/erlang/bin/erlc \
   && rm /var/task/serverless/lib/erlang/erts-*/bin/erlc \
   && rm /var/task/serverless/lib/erlang/erts-*/bin/typer \
   && rm /var/task/serverless/lib/erlang/erts-*/bin/ct_run

COPY bootstrap /var/task/bootstrap
COPY function /function

ENV PATH $PATH:/var/task/bin

##
## required to run Erlang release 
RUN set -e \
   && yum -y install \
      zip

