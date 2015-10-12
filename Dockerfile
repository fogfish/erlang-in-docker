## @author     Dmitry Kolesnikov, <dmkolesnikov@gmail.com>
## @copyright  (c) 2014 Dmitry Kolesnikov. All Rights Reserved
##
## @description
##   Erlang/OTP from scratch 
FROM centos
MAINTAINER Dmitry Kolesnikov <dmkolesnikov@gmail.com>

##
##
ENV VSN 17.4
ENV SSL 1.0.2d

##
## install dependencies
RUN \
   yum -y install \
      tar \
      gcc \
      gcc-c++ \
      git \
      glibc-devel \
      make \
      ncurses-devel \
      autoconf

##
## install open ssl
RUN cd /tmp && \
   curl -L -O http://www.openssl.org/source/openssl-${SSL}.tar.gz
RUN cd /tmp && \
   tar -zxvf openssl-${SSL}.tar.gz

RUN cd /tmp/openssl-${SSL} && \
   ./Configure \
      --prefix=/usr/local/ssl \
      --openssldir=/usr/local/ssl \
      linux-x86_64 \
      shared
      
RUN cd /tmp/openssl-${SSL} && \
   make && \
   make install

RUN rm -Rf /tmp/openssl-${SSL}*


##
## download
RUN cd /tmp && \
   curl -O http://www.erlang.org/download/otp_src_${VSN}.tar.gz
RUN cd /tmp && \
   tar -zxvf otp_src_${VSN}.tar.gz

##
## configure
RUN cd /tmp/otp_src_${VSN} && \
   ./configure \
      --prefix=/usr/local/otp_${VSN} \
      --enable-threads \
      --enable-smp-support \
      --enable-kernel-poll \
      --enable-hipe \
      --enable-native-libs \
      --disable-dynamic-ssl-lib \
      --with-ssl=/usr/local/ssl \
      CFLAGS="-DOPENSSL_NO_EC=1"

##
## build
RUN cd /tmp/otp_src_${VSN} && \
   make && \
   make install && \
   ln -s /usr/local/otp_${VSN} /usr/local/otp

RUN rm -Rf /tmp/otp_src_${VSN}*

ENV PATH $PATH:/usr/local/otp/bin

EXPOSE 4369

