ARG BUILD_DATE
ARG VCS_REF
ARG QBITTORRENT_VERSION=4.5.0
ARG LIBTORRENT_VERSION=v2.0.8
ARG SHA512_QBITTORRENT_BINARY=879ba8a674fdd70edc822967fbc4989647797d84d14da76ade3a3e3443563bc0a88ca789203ddce847901ca3f7eeb0641c1b240cae53acf9a33b0e10d21558cb
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