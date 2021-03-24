FROM ghcr.io/linuxserver/baseimage-alpine:3.13
LABEL maintainer="Adam Beardwood"
ENV GETIPLAYER_PROFILE=/config/.get_iplayer 

RUN apk add --update --no-cache ffmpeg perl-cgi perl-mojolicious perl-lwp-protocol-https perl-xml-libxml perl-libwww jq curl && \
apk add --update --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ atomicparsley

RUN \
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
 mkdir /downloads

COPY root/ /

COPY util/SonarrAutoImport.arm64 /usr/local/bin/SonarrAutoImport

EXPOSE 1935
VOLUME /config