## @author     Dmitry Kolesnikov, <dmkolesnikov@gmail.com>
## @copyright  (c) 2014 Dmitry Kolesnikov. All Rights Reserved
##
## @description
##   Erlang/OTP from scratch 
FROM centos
MAINTAINER Dmitry Kolesnikov <dmkolesnikov@gmail.com>

##
## build essential tools
RUN set -e \
   && yum -y install \
      autoconf \
      gcc \
      gcc-c++ \
      git \
      make \
      tar

##
## http://www.musl-libc.org/download.html
RUN set -e \
   && cd /tmp \
   && git clone git://git.musl-libc.org/musl \
   && cd /tmp/musl \
   && ./configure --prefix=/usr \
   && make \
   && make install \
   && rm -Rf /tmp/musl

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
   && CC="musl-gcc" ./Configure \
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
   && CC="musl-gcc" ./configure \
         --prefix=/usr/local/otp \
         --enable-threads \
         --enable-smp-support \
         --enable-kernel-poll \
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
         --enable-hipe \
         `test "${WITH_NATIVE}" = "true" && echo "--enable-native-libs"` \
   && make -j4 \
   && make install \
   && ln -s /usr/local/otp_${OTP_VERSION} /usr/local/otp \
   && rm -Rf /tmp/otp_src*

ENV PATH $PATH:/usr/local/otp/bin

##
## required to run Erlang release 
RUN set -e \
   && yum -y install \
      which
