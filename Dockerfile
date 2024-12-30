# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.21

# set version label
ARG BUILD_DATE
ARG VERSION
ARG APP_VERSION
LABEL build_version="Version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thespad"
LABEL org.opencontainers.image.source="https://github.com/thespad/docker-get_iplayer"
LABEL org.opencontainers.image.url="https://github.com/thespad/docker-get_iplayer"
LABEL org.opencontainers.image.description="A BBC iPlayer/BBC Sounds Indexing Tool and PVR"
LABEL org.opencontainers.image.authors="thespad"

ENV GETIPLAYER_PROFILE=/config/.get_iplayer \
  PATH="${PATH:+${PATH}:}/app/get_iplayer"

RUN \
  apk add --update --no-cache --virtual=build-dependencies \
    build-base \
    cmake \
    git \
    glib-dev \
    zlib-dev && \
  apk add --update --no-cache \
    ffmpeg \
    perl-cgi \
    perl-mojolicious \
    perl-lwp-protocol-https \
    perl-xml-libxml \
    perl-libwww \
    icu-libs \
    krb5-libs \
    libgcc \
    libintl \
    libssl3 \
    libstdc++ \
    zlib && \
  git clone -b get_iplayer https://github.com/get-iplayer/atomicparsley.git /tmp/atomic && \
  cd /tmp/atomic && \
  cmake . && \
  cmake --build . --config Release && \
  cmake --install . --prefix /usr && \
  cd /usr/bin && \
  ln -s AtomicParsley atomicparsley && \
  echo "**** install get_iplayer ****" && \
  mkdir -p /app/get_iplayer && \
  if [ -z ${APP_VERSION+x} ]; then \
    APP_VERSION=$(curl -sX GET "https://api.github.com/repos/get-iplayer/get_iplayer/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -s -o \
    /tmp/get_iplayer.tar.gz -L \
    "https://github.com/get-iplayer/get_iplayer/archive/${APP_VERSION}.tar.gz" && \
  tar xf \
    /tmp/get_iplayer.tar.gz -C \
    /app/get_iplayer/ --strip-components=1 && \
  chmod 755 /app/get_iplayer/get_iplayer /app/get_iplayer/get_iplayer.cgi && \
  mkdir /downloads && \
  echo "**** install dotnet runtime ****" && \
  mkdir -p /app/sonarrautoimport && \
  curl -s -o \
    /tmp/dotnet-install.sh -L \
    "https://dot.net/v1/dotnet-install.sh" && \
  chmod +x /tmp/dotnet-install.sh && \
  /tmp/dotnet-install.sh --channel 6.0 --runtime dotnet --os linux-musl --install-dir /usr/share/dotnet && \
  printf "Version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  apk del --purge \
    build-dependencies && \
  rm -rf \
    /root/.cache \
    /tmp/*

ENV TMPDIR=/run/get_iplayer-temp \
  MOJO_TMPDIR=/run/get_iplayer-temp

COPY root/ /

COPY util/ /app/sonarrautoimport/

EXPOSE 1935

VOLUME /config
