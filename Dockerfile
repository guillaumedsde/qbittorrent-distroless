ARG QBITTORRENT_VERSION=5.0.3
ARG LIBTORRENT_VERSION=2.0.10

FROM docker.io/alpine:3.21 AS builder

ARG QBITTORRENT_VERSION
ARG LIBTORRENT_VERSION

WORKDIR /binaries

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN ARCH="$(uname -m | sed 's/armv7l/armv7/')" \
    && wget -q "https://github.com/userdocs/qbittorrent-nox-static/releases/download/release-${QBITTORRENT_VERSION}_v${LIBTORRENT_VERSION}/${ARCH}-qbittorrent-nox" -O qbittorrent-nox \
    && chmod 755 ./qbittorrent-nox

COPY --chmod=755 --from=busybox:1.37.0-musl /bin/wget wget

FROM gcr.io/distroless/static-debian12:nonroot

COPY --from=builder /binaries /usr/bin

ENV HOME=/config

VOLUME /config

WORKDIR /config

EXPOSE 8080

HEALTHCHECK  --start-period=7s --interval=5s --timeout=4s --retries=5 \
    CMD [ "/usr/bin/wget", "--quiet", "--timeout=3", "--tries=1", "--spider", "http://127.0.0.1:8080/"]

ENTRYPOINT [ "/usr/bin/qbittorrent-nox" ]

CMD [ "--profile=/config" ]