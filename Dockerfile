# FROM ghcr.io/linuxserver/baseimage-alpine:edge AS librespot

# ARG LIBRESPOT_REPO=librespot-org/librespot
# ARG LIBRESPOT_COMMIT=d36f9f1907e8cc9d68a93f8ebc6b627b1bf7267d

# RUN apk add --no-cache alsa-lib-dev cargo curl alpine-sdk git coreutils cargo-auditable openssl-dev
# RUN curl "https://codeload.github.com/${LIBRESPOT_REPO}/zip/${LIBRESPOT_COMMIT}" -o 'librespot.zip' && \
#     unzip -qq 'librespot.zip' -d 'librespot' && \
#     cd "librespot/librespot-${LIBRESPOT_COMMIT}" && \
#     ls && \
#     cargo fetch --locked && \
#     cargo auditable build --release --frozen --features alsa-backend && \
#     cp target/release/librespot /usr/bin/librespot

FROM ghcr.io/linuxserver/baseimage-alpine:edge AS snapweb

ARG SNAPWEB_REPO=W-Floyd/snapweb
ARG SNAPWEB_COMMIT=16f48328ab2ec19a9323f186175dc657a3395e8c
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
ARG SNAPCAST_VERSION=0.34.0-r0
ARG SNAPWEB_VERSION=0.9.2-r0

RUN apk add --no-cache bash sed
RUN apk add --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing --no-cache librespot=${LIBRESPOT_VERSION}
RUN apk add --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community --no-cache snapcast=${SNAPCAST_VERSION}
# RUN apk add --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing --no-cache snapweb=${SNAPWEB_VERSION}


# COPY --from=0 /usr/bin/librespot /usr/bin/librespot

# Change to --from=1 if using custom librespot also
COPY --from=0 /usr/share/snapweb /usr/share/snapweb

COPY root/ /

EXPOSE 1704/tcp 1705/tcp

VOLUME /data
VOLUME /config

ENV HOME="/config"
