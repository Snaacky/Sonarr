# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.23

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SONARR_VERSION
ARG TARGETARCH
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thespad"

# set environment variables
ENV XDG_CONFIG_HOME="/config/xdg" \
  SONARR_CHANNEL="v4-stable" \
  SONARR_BRANCH="main" \
  COMPlus_EnableDiagnostics=0 \
  TMPDIR=/run/sonarr-temp

RUN \
  echo "**** install packages ****" && \
  apk add --no-cache \
    icu-libs \
    sqlite-libs \
    xmlstarlet && \
  mkdir -p /app/sonarr/bin && \
  echo -e "UpdateMethod=docker\nBranch=${SONARR_BRANCH}\nPackageVersion=${VERSION:-LocalBuild}\nPackageAuthor=[linuxserver.io](https://linuxserver.io)" > /app/sonarr/package_info && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** install sonarr ****"

COPY _artifacts/linux-musl-x64/net6.0/Sonarr/ /tmp/sonarr-x64/
COPY _artifacts/linux-musl-arm64/net6.0/Sonarr/ /tmp/sonarr-arm64/

RUN case "${TARGETARCH}" in \
      amd64) cp -r /tmp/sonarr-x64/. /app/sonarr/bin ;; \
      arm64) cp -r /tmp/sonarr-arm64/. /app/sonarr/bin ;; \
      *) echo "Unsupported TARGETARCH: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    rm -rf \
      /app/sonarr/bin/Sonarr.Update \
      /tmp/sonarr-x64 \
      /tmp/sonarr-arm64 \
      /tmp/*

# add local files
COPY root/ /

# set executable bit
RUN chmod +x \
    /app/sonarr/bin/Sonarr \
    /app/sonarr/bin/ffprobe \
    /etc/s6-overlay/s6-rc.d/init-sonarr-config/run \
    /etc/s6-overlay/s6-rc.d/init-sonarr-config/up \
    /etc/s6-overlay/s6-rc.d/svc-sonarr/run \
    /etc/s6-overlay/s6-rc.d/svc-sonarr/data/check

# ports and volumes
EXPOSE 8989

VOLUME /config
