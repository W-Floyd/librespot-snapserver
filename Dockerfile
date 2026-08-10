FROM ghcr.io/linuxserver/baseimage-alpine:edge AS librespot

ARG LIBRESPOT_REPO=librespot-org/librespot
ARG LIBRESPOT_COMMIT=9c7d75615fc093bdcbdb29adbce3fed38c531852

RUN apk add --no-cache alsa-lib-dev cargo curl alpine-sdk git coreutils cargo-auditable openssl-dev
RUN curl "https://codeload.github.com/${LIBRESPOT_REPO}/zip/${LIBRESPOT_COMMIT}" -o 'librespot.zip' && \
    unzip -qq 'librespot.zip' -d 'librespot' && \
    cd "librespot/librespot-${LIBRESPOT_COMMIT}" && \
    ls && \
    cargo fetch --locked && \
    cargo auditable build --release --frozen --features alsa-backend && \
    cp target/release/librespot /usr/bin/librespot

FROM ghcr.io/linuxserver/baseimage-alpine:edge AS snapweb

ARG SNAPWEB_REPO=W-Floyd/snapweb
ARG SNAPWEB_COMMIT=55c3896d10f2e060e49535c75ee24d87db1166eb
RUN apk add --no-cache npm vips-dev
RUN curl "https://codeload.github.com/${SNAPWEB_REPO}/zip/${SNAPWEB_COMMIT}" -o 'snapweb.zip' && \
    unzip -qq 'snapweb.zip' -d 'snapweb' && \
    cd "snapweb/snapweb-${SNAPWEB_COMMIT}" && \
    ls && \
    npm install && \
    npm run build && \
    mkdir /usr/share/snapweb && \
    cp -r ./dist/* /usr/share/snapweb


FROM ghcr.io/linuxserver/baseimage-alpine:edge

ARG LIBRESPOT_VERSION=0.8.0-r0
ARG SNAPCAST_VERSION=0.35.0-r1
ARG SNAPWEB_VERSION=0.9.2-r1

RUN apk add --no-cache bash sed
# RUN apk add --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing --no-cache librespot=${LIBRESPOT_VERSION}
RUN apk add --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community --no-cache snapcast=${SNAPCAST_VERSION}
# RUN apk add --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing --no-cache snapweb=${SNAPWEB_VERSION}


COPY --from=0 /usr/bin/librespot /usr/bin/librespot

# Change to --from=0 if not using custom librespot also
COPY --from=1 /usr/share/snapweb /usr/share/snapweb

COPY root/ /

EXPOSE 1704/tcp 1705/tcp

VOLUME /data
VOLUME /config

ENV HOME="/config"
