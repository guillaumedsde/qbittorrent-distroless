ARG BUILD_DATE
ARG VCS_REF
ARG QBITTORRENT_VERSION=4.3.8
ARG LIBTORRENT_VERSION=v2.0.4
ARG SHA512_QBITTORRENT_BINARY=3b5915e5212535b822404a0c57845590c22b5f6bf9b4ac003a86bbe8762965e9a81b404d62c8b91c16bf8389d04986fb48d874d9059ad13f9be398fad70aad6b
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
    then echo "$SHA512_QBITTORRENT_BINARY /rootfs/usr/bin/qbittorrent-nox" | sha512sum --check;\
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

HEALTHCHECK  --start-period=1s --interval=5s --timeout=4s --retries=5 \
    CMD [ "/usr/bin/wget", "--quiet", "--timeout=3", "--tries=1", "--spider", "http://127.0.0.1:8080/"]

ENTRYPOINT [ "/usr/bin/qbittorrent-nox" ]