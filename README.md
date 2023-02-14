# [🐋 qBittorrent-distroless](https://github.com/guillaumedsde/qbittorrent-distroless)

[![Docker Image Version (latest by date)](https://img.shields.io/docker/v/guillaumedsde/qbittorrent-distroless)](https://hub.docker.com/r/guillaumedsde/qbittorrent-distroless/tags)
[![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/guillaumedsde/qbittorrent-distroless)](https://hub.docker.com/r/guillaumedsde/qbittorrent-distroless)
[![Docker Pulls](https://img.shields.io/docker/pulls/guillaumedsde/qbittorrent-distroless)](https://hub.docker.com/r/guillaumedsde/qbittorrent-distroless)
[![GitHub stars](https://img.shields.io/github/stars/guillaumedsde/qbittorrent-distroless?label=Github%20stars)](https://github.com/guillaumedsde/qbittorrent-distroless)
[![GitHub watchers](https://img.shields.io/github/watchers/guillaumedsde/qbittorrent-distroless?label=Github%20Watchers)](https://github.com/guillaumedsde/qbittorrent-distroless)
[![Docker Stars](https://img.shields.io/docker/stars/guillaumedsde/qbittorrent-distroless)](https://hub.docker.com/r/guillaumedsde/qbittorrent-distroless)
[![GitHub](https://img.shields.io/github/license/guillaumedsde/qbittorrent-distroless)](https://github.com/guillaumedsde/qbittorrent-distroless/blob/master/LICENSE.md)

This repository contains the code to build a small and secure **[distroless](https://github.com/GoogleContainerTools/distroless)** **docker** image for **[qBittorrent](https://github.com/qBittorrent/qBittorrent)** running as an unprivileged user.
The final images are built and hosted on the [dockerhub](https://hub.docker.com/r/guillaumedsde/qbittorrent-distroless).
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
              guillaumedsde/qbittorrent-distroless:latest
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
    image: "guillaumedsde/qbittorrent-distroless:latest"
```

## 🖥️ Supported platforms

Currently this container supports only one (but widely used) platform:

- linux/amd64

## 🙏 Credits

A couple of projects really helped me out while developing this container:

- 💽 [qBittorrent](https://github.com/qBittorrent/qBittorrent) _the_ awesome software
- 💽 [userdocs/qbittorrent-nox-static](https://github.com/userdocs/qbittorrent-nox-static) for the great static qbittorrent build scripts
- 🥑 [Google's distroless](https://github.com/GoogleContainerTools/distroless) base docker images
- 🐋 The [Docker](https://github.com/docker) project (of course)
