## @author     Dmitry Kolesnikov, <dmkolesnikov@gmail.com>
## @copyright  (c) 2014 Dmitry Kolesnikov. All Rights Reserved
##
## @description
##   Erlang/OTP from scratch 
FROM centos:7
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
## install ncurses, it is required to enable remsh with erlang nodes
RUN set -e \
   && mkdir -p /tmp/ncurses \
   && cd /tmp \
   && curl -fSL -o ncurses.tar.gz https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.0.tar.gz \
   && tar -zxf ncurses.tar.gz -C /tmp/ncurses --strip-components=1 \
   && cd /tmp/ncurses \
   && CC="musl-gcc" ./configure \
      --prefix=/usr/local/ncurses \
      --with-shared \
   && make -j4 \
   && make install \
   && rm -Rf /tmp/ncurses*


##
## install open ssl
ARG SSL_VERSION

RUN set -e \
   && mkdir -p /tmp/openssl \
   && cd /tmp \
   && curl -fSL -o openssl.sha256 http://www.openssl.org/source/openssl-${SSL_VERSION}.tar.gz.sha256 \
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
   && export CC="musl-gcc" \
   && export CPPFLAGS='-I/usr/local/ncurses/include' \
   && export LDFLAGS='-L/usr/local/ncurses/lib' \
   && export export LD_LIBRARY_PATH=/usr/local/ncurses/lib \
   && ./configure \
         --prefix=/usr/local/otp \
         --enable-threads \
         --enable-smp-support \
         --enable-kernel-poll \
         --disable-dynamic-ssl-lib \
         --with-ssl=/usr/local/ssl \
         --with-termcap \
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
         --disable-hipe \
         `test "${WITH_NATIVE}" = "true" && echo "--enable-native-libs"` \
   && make -j4 \
   && make install \
   && ln -s /usr/local/otp_${OTP_VERSION} /usr/local/otp \
   && rm -Rf /tmp/otp_src*

ENV PATH $PATH:/usr/local/otp/bin

##
## required to run Erlang release 
# RUN set -e \
#    && yum -y install \
#       which

FROM alpine

RUN set -e \
   && apk --no-cache update \
   && apk --no-cache add curl ncurses \
   && ln -s /usr/lib/libncursesw.so.6 /usr/lib/libncurses.so.6

COPY --from=0 /usr/local/otp /usr/local/otp
ENV PATH $PATH:/usr/local/otp/bin

ADD spawn-erlang-node /usr/bin/spawn-erlang-node
