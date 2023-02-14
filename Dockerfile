ARG BUILD_DATE
ARG VCS_REF
ARG QBITTORRENT_VERSION=4.5.1
ARG LIBTORRENT_VERSION=v2.0.8
ARG BASE_IMAGE=gcr.io/distroless/static-debian11:nonroot

FROM alpine:3.17.2 as builder

ARG QBITTORRENT_VERSION
ARG LIBTORRENT_VERSION
ARG BUSYBOX_VERSION

WORKDIR /binaries

RUN wget "https://github.com/userdocs/qbittorrent-nox-static/releases/download/release-${QBITTORRENT_VERSION}_${LIBTORRENT_VERSION}/$(uname -m)-qbittorrent-nox" -O qbittorrent-nox \
    && chmod 755 ./qbittorrent-nox

COPY --chmod=755 --from=busybox:1.36.0-musl /bin/wget wget

FROM $BASE_IMAGE

ARG QBITTORRENT_VERSION
ARG BASE_IMAGE

# Build-time metadata as defined at https://github.com/opencontainers/image-spec/blob/819aa940cae7c067a8bf89b1745d3255ddaaba1d/annotations.md
ARG BUILD_DATE
ARG VCS_REF

LABEL org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.title="qbittorrent-distroless" \
    org.opencontainers.image.description="Distroless container for the qBittorrent program" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.base.name=$BASE_IMAGE \
    org.opencontainers.image.version=$QBITTORRENT_VERSION \
    org.opencontainers.image.source="https://github.com/guillaumedsde/qbittorrent-distroless" \
    org.opencontainers.image.authors="guillaumedsde" \
    org.opencontainers.image.vendor="guillaumedsde"

COPY --from=builder /binaries /usr/bin

ENV HOME=/config

VOLUME /config

WORKDIR /config

EXPOSE 8080

HEALTHCHECK  --start-period=3s --interval=5s --timeout=4s --retries=5 \
    CMD [ "/usr/bin/wget", "--quiet", "--timeout=3", "--tries=1", "--spider", "http://127.0.0.1:8080/"]

ENTRYPOINT [ "/usr/bin/qbittorrent-nox" ]

CMD [ "--profile=/config" ]