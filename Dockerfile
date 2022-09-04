ARG BUILD_DATE
ARG VCS_REF
ARG QBITTORRENT_VERSION=4.4.5
ARG LIBTORRENT_VERSION=v2.0.7
ARG SHA512_QBITTORRENT_BINARY=fea9235b6e257f6c79ffd07428b5387effc9f9870abfa19f9898505d01c8e3a18effa43f326ddd6c2f7827a73c74d86cc8a9fbed80d3a7bd10af2f4ee4d06cd1
ARG QBITTORRENT_ARCH=x86_64
ARG BUSYBOX_VERSION=1.31.0-i686-uclibc

FROM debian:buster-slim as build

ARG QBITTORRENT_VERSION
ARG LIBTORRENT_VERSION
ARG SHA512_QBITTORRENT_BINARY
ARG QBITTORRENT_ARCH

ADD https://github.com/userdocs/qbittorrent-nox-static/releases/download/release-${QBITTORRENT_VERSION}_${LIBTORRENT_VERSION}/${QBITTORRENT_ARCH}-qbittorrent-nox /rootfs/usr/bin/qbittorrent-nox

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN if [ -n "$SHA512_QBITTORRENT_BINARY" ]; \
    then echo "$SHA512_QBITTORRENT_BINARY  /rootfs/usr/bin/qbittorrent-nox" | sha512sum --check;\
    fi \
    && chmod 755 /rootfs/usr/bin/qbittorrent-nox

ARG BUSYBOX_VERSION
ADD https://busybox.net/downloads/binaries/${BUSYBOX_VERSION}/busybox_WGET /rootfs/usr/bin/wget
RUN chmod 755 /rootfs/usr/bin/wget


FROM gcr.io/distroless/base:nonroot

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG QBITTORRENT_VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="qbittorrent-distroless" \
    org.label-schema.description="Distroless container for the qBittorrent program" \
    org.label-schema.url="https://guillaumedsde.gitlab.io/qbittorrent-distroless/" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.version=$QBITTORRENT_VERSION \
    org.label-schema.vcs-url="https://github.com/guillaumedsde/qbittorrent-distroless" \
    org.label-schema.vendor="guillaumedsde" \
    org.label-schema.schema-version="1.0"

COPY --from=build /rootfs /

ENV HOME=/config

VOLUME /config

WORKDIR /config

EXPOSE 8080

HEALTHCHECK  --start-period=3s --interval=5s --timeout=4s --retries=5 \
    CMD [ "/usr/bin/wget", "--quiet", "--timeout=3", "--tries=1", "--spider", "http://127.0.0.1:8080/"]

ENTRYPOINT [ "/usr/bin/qbittorrent-nox" ]

CMD [ "--profile=/config" ]