ARG BUILD_DATE
ARG VCS_REF
ARG QBITTORRENT_VERSION=4.3.4.1
ARG QBITTORRENT_RELEASE=r1
ARG QBITTORRENT_ARCH=amd64

FROM alpine:3.13 as build

ARG QBITTORRENT_VERSION
ARG QBITTORRENT_RELEASE
ARG QBITTORRENT_ARCH

ADD https://github.com/guillaumedsde/qbittorrent-nox-static/releases/download/$QBITTORRENT_VERSION-$QBITTORRENT_RELEASE/qbittorrent-nox-v$QBITTORRENT_VERSION-static-$QBITTORRENT_ARCH /rootfs/usr/bin/qbittorrent-nox

RUN chmod 755 /rootfs/usr/bin/qbittorrent-nox

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

ENTRYPOINT [ "/usr/bin/qbittorrent-nox" ]