## @author     Dmitry Kolesnikov, <dmkolesnikov@gmail.com>
## @copyright  (c) 2014 Dmitry Kolesnikov. All Rights Reserved
##
## @description
##   Erlang/OTP from scratch 
FROM centos
MAINTAINER Dmitry Kolesnikov <dmkolesnikov@gmail.com>

##
##
ARG OTP_VERSION=19.0.5
ARG SSL_VERSION=1.0.2h

##
## install dependencies
RUN \
   yum -y install \
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
RUN set -e \
   && mkdir -p /tmp/openssl \
   && cd /tmp \
   && curl -fSL -o openssl.sha256   http://www.openssl.org/source/openssl-${SSL_VERSION}.tar.gz.sha256 \
   && curl -fSL -o openssl.tar.gz http://www.openssl.org/source/openssl-${SSL_VERSION}.tar.gz \
   && SHA=$(printf "%s  openssl.tar.gz" `cat openssl.sha256` | sha256sum -c -); if [ "openssl.tar.gz: OK" != "${SHA}" ]; then exit 3; fi \
   && tar -zxf openssl.tar.gz -C /tmp/openssl --strip-components=1

RUN set -e \
   && cd /tmp/openssl \
   && ./Configure \
         --prefix=/usr/local/ssl \
         --openssldir=/usr/local/ssl \
      linux-x86_64 \
      shared \
   && make -j4 \
   && make install

RUN cd /tmp; rm -Rf /tmp/openssl*

##
## download
RUN set -e \
   && mkdir -p /tmp/otp_src \
   && cd /tmp \
   && curl -fSL -o otp_src.tar.gz https://github.com/erlang/otp/archive/OTP-${OTP_VERSION}.tar.gz \
   && tar -zxf otp_src.tar.gz -C /tmp/otp_src --strip-components=1

RUN set -e \
   && cd /tmp/otp_src \
   && ./otp_build autoconf \
   && ./configure \
         --prefix=/usr/local/otp_${OTP_VERSION} \
         --enable-threads \
         --enable-smp-support \
         --enable-kernel-poll \
         --enable-hipe \
         --enable-native-libs \
         --disable-dynamic-ssl-lib \
         --with-ssl=/usr/local/ssl \
   && make clean \
   && make -j4 \
   && make install \
   && ln -s /usr/local/otp_${OTP_VERSION} /usr/local/otp

RUN cd /tmp; rm -Rf /tmp/otp_src*

ENV PATH $PATH:/usr/local/otp/bin

EXPOSE 4369
