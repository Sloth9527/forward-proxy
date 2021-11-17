FROM ubuntu:16.04

USER root

WORKDIR /opt/nginx

ENV NGINX_VERSION=1.21.0

COPY ngx_http_proxy_connect_module /opt/ngx_http_proxy_connect_module

RUN apt-get update  && \
    apt-get -y upgrade && \
    apt-get autoremove && \
    apt-get autoclean && \
    apt-get install --no-install-recommends --no-install-suggests -y \
    wget \
    patch \
    build-essential \
    libtool \
    make


RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar -xzvf nginx-${NGINX_VERSION}.tar.gz && \
    cd nginx-${NGINX_VERSION}/ && \
    patch -p1 < /opt/ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_1018.patch && \
    ./configure --add-module=/opt/ngx_http_proxy_connect_module && \
    make && make install && \
    nginx -v


