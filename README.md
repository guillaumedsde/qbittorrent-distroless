# [🐋 qBittorrent-distroless](https://github.com/guillaumedsde/qbittorrent-distroless)

[![GitHub stars](https://img.shields.io/github/stars/guillaumedsde/qbittorrent-distroless?label=Github%20stars)](https://github.com/guillaumedsde/qbittorrent-distroless)
[![GitHub watchers](https://img.shields.io/github/watchers/guillaumedsde/qbittorrent-distroless?label=Github%20Watchers)](https://github.com/guillaumedsde/qbittorrent-distroless)
[![GitHub](https://img.shields.io/github/license/guillaumedsde/qbittorrent-distroless)](https://github.com/guillaumedsde/qbittorrent-distroless/blob/master/LICENSE.md)

This repository contains the code to build a small and secure **[distroless](https://github.com/GoogleContainerTools/distroless)** **docker** image for **[qBittorrent](https://github.com/qBittorrent/qBittorrent)** running as an unprivileged user.
The final images are built and hosted on the [GHCR](https://github.com/guillaumedsde/qbittorrent-distroless/pkgs/container/qbittorrent-distroless).

## ✔️ Features summary

- 🥑 [distroless](https://github.com/GoogleContainerTools/distroless) minimal image
- 🤏 As few Docker layers as possible
- 🛡️ only basic runtime dependencies
- 🛡️ Runs as unprivileged user with minimal permissions

## 🏁 How to Run

### `docker run`

```bash
# create config directory
$ mkdir config
# set ownership on the config directory
$ chown `id -u`:`id -g` config
# run the container
$ docker run  --volume `pwd`/config:/config \
              --tmpfs /tmp \
              --read-only \
              --user `id -u`:`id -g` \
              --publish 8080:8080 \
              ghcr.io/guillaumedsde/qbittorrent-distroless:latest
```

### `docker-compose.yml`

```yaml
version: "3.3"
services:
  qbittorrent-distroless:
    read_only: true
    volumes:
      - "`pwd`/config:/config"
    tmpfs:
      - /tmp
    user: 1000:1000
    ports:
      - 8080:8080
    image: "ghcr.io/guillaumedsde/qbittorrent-distroless:latest"
```

## 🖥️ Supported platforms

This docker image is built for the following platforms:

- linux/amd64
- linux/arm/v7
- linux/arm64

## 🙏 Credits

A couple of projects really helped me out while developing this container:

- 💽 [qBittorrent](https://github.com/qBittorrent/qBittorrent) _the_ awesome software
- 💽 [userdocs/qbittorrent-nox-static](https://github.com/userdocs/qbittorrent-nox-static) for the great static qbittorrent build scripts
- 🥑 [Google's distroless](https://github.com/GoogleContainerTools/distroless) base docker images
- 🐋 The [Docker](https://github.com/docker) project (of course)
