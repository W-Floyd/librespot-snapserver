FROM ghcr.io/linuxserver/baseimage-alpine:edge

ARG LIBRESPOT_VERSION=0.6.0-r0
ARG SNAPCAST_VERSION=0.31.0-r0
ARG SNAPWEB_VERSION=0.7.0-r0

RUN apk add --no-cache bash sed
RUN apk add --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community --no-cache snapcast=${SNAPCAST_VERSION}
RUN apk add --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing --no-cache librespot=${LIBRESPOT_VERSION}
RUN apk add --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing --no-cache snapweb

COPY root/ /

EXPOSE 1704/tcp 1705/tcp

VOLUME /data
VOLUME /config

ENV HOME="/config"