FROM ghcr.io/linuxserver/baseimage-alpine:3.14
LABEL maintainer="Adam Beardwood"
ENV GETIPLAYER_PROFILE=/config/.get_iplayer 

RUN \
  apk add --update --no-cache ffmpeg perl-cgi perl-mojolicious perl-lwp-protocol-https perl-xml-libxml perl-libwww jq curl icu-libs krb5-libs libgcc libintl libssl1.1 libstdc++ zlib && \
  apk add --update --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ atomicparsley && \
  echo "**** install get_iplayer ****" && \
  mkdir -p /app/get_iplayer && \
  if [ -z ${GET_IPLAYER_RELEASE+x} ]; then \
    GET_IPLAYER_RELEASE=$(curl -sX GET "https://api.github.com/repos/get-iplayer/get_iplayer/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -s -o \
    /tmp/get_iplayer.tar.gz -L \
    "https://github.com/get-iplayer/get_iplayer/archive/${GET_IPLAYER_RELEASE}.tar.gz" && \
  tar xf \
    /tmp/get_iplayer.tar.gz -C \
    /app/get_iplayer/ --strip-components=1 && \
  chmod 755 /app/get_iplayer/get_iplayer /app/get_iplayer/get_iplayer.cgi && \
  rm /tmp/get_iplayer.tar.gz && \
  mkdir /downloads && \
  echo "**** install dotnet runtime ****" && \
  mkdir -p /app/sonarrautoimport && \
  curl -s -o \
    /tmp/dotnet-install.sh -L \
    "https://dot.net/v1/dotnet-install.sh" && \
  chmod +x /tmp/dotnet-install.sh && \
  /tmp/dotnet-install.sh -c 5.0 --runtime dotnet --os linux-musl --install-dir /usr/share/dotnet && \
  rm /tmp/dotnet-install.sh

COPY root/ /

COPY util/ /app/sonarrautoimport/

EXPOSE 1935
VOLUME /config