# FROM ghcr.io/linuxserver/baseimage-alpine:edge AS librespot

# ARG LIBRESPOT_COMMIT=ba3d501b08345aadf207d09b3a0713853228ba64

# RUN apk add --no-cache alsa-lib-dev cargo curl alpine-sdk git coreutils cargo-auditable
# RUN curl "https://codeload.github.com/librespot-org/librespot/zip/${LIBRESPOT_COMMIT}" -o 'librespot.zip' && \
#     unzip -qq 'librespot.zip' -d 'librespot' && \
#     cd "librespot/librespot-${LIBRESPOT_COMMIT}" && \
#     ls && \
#     cargo fetch --locked && \
#     cargo auditable build --release --frozen --features alsa-backend && \
#     cp target/release/librespot /usr/bin/librespot

FROM ghcr.io/linuxserver/baseimage-alpine:edge

ARG LIBRESPOT_VERSION=0.7.1-r0
ARG SNAPCAST_VERSION=0.32.1-r0
ARG SNAPWEB_VERSION=0.9.1-r0

RUN apk add --no-cache bash sed
RUN apk add --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community --no-cache snapcast=${SNAPCAST_VERSION}
RUN apk add --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing --no-cache librespot=${LIBRESPOT_VERSION}
RUN apk add --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing --no-cache snapweb=${SNAPWEB_VERSION}

# COPY --from=0 /usr/bin/librespot /usr/bin/librespot

COPY root/ /

EXPOSE 1704/tcp 1705/tcp

VOLUME /data
VOLUME /config

ENV HOME="/config"
