We bring you another container release featuring:

* Regular and timely application updates
* Easy user mappings (PGID, PUID)
* Linuxserver.io base image with s6 overlay

# [thespad/get_iplayer](https://github.com/thespad/docker-get_iplayer)

[![GitHub Stars](https://img.shields.io/github/stars/thespad/docker-get_iplayer.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/thespad/docker-get_iplayer)
[![GitHub Release](https://img.shields.io/github/release/thespad/docker-get_iplayer.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/thespad/docker-get_iplayer/releases)
[![GitHub Package Repository](https://img.shields.io/static/v1.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=thespad&message=GitHub%20Package&logo=github)](https://github.com/thespad/docker-get_iplayer/packages)
[![Image Size](https://img.shields.io/docker/image-size/thespad/get_iplayer/latest?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=Size)](#)
[![Docker Pulls](https://img.shields.io/docker/pulls/thespad/get_iplayer.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=pulls&logo=docker)](https://hub.docker.com/r/thespad/get_iplayer)
[![Docker Stars](https://img.shields.io/docker/stars/thespad/get_iplayer.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=stars&logo=docker)](https://hub.docker.com/r/thespad/get_iplayer)
[![License](https://img.shields.io/github/license/thespad/docker-get_iplayer?color=94398d&logo=Github&logoColor=ffffff&style=for-the-badge)](#)
[![Commits](https://img.shields.io/github/commits-since/thespad/docker-get_iplayer/latest?color=94398d&include_prereleases&logo=github&style=for-the-badge)](#)

[get_iplayer](https://github.com/get-iplayer/get_iplayer/) is a BBC iPlayer/BBC Sounds Indexing Tool and PVR

## Supported Architectures

Our images support multiple architectures such as `x86-64`, `arm64` and `armhf`.

Simply pulling `ghcr.io/thespad/get_iplayer` should retrieve the correct image for your arch.

The architectures supported by this image are:

| Architecture | Tag |
| :----: | --- |
| x86-64 | latest |
| arm64 | latest |

## Application Setup

Webui is accessible at http://SERVERIP:PORT

Interact with the CLI via something like `docker exec -it get_iplayer /app/get_iplayer/get_iplayer "hey duggee"`

More info at [get_iplayer](https://github.com/get-iplayer/get_iplayer/).

## Usage

Here are some example snippets to help you get started creating a container.

### docker-compose ([recommended](https://docs.linuxserver.io/general/docker-compose))

Compatible with docker-compose v2 schemas.

```yaml
---
version: "2.1"
services:
  get_iplayer:
    image: ghcr.io/thespad/get_iplayer
    container_name: get_iplayer
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New_York
      - INCLUDERADIO= #optional
      - BASEURL= #optional
      - ENABLEIMPORT= #optional
    volumes:
      - </path/to/appdata/config>:/config
      - </path/to/appdata/downloads>:/downloads
    ports:
      - 1935:1935
    restart: unless-stopped
```

### docker cli

```shell
docker run -d \
  --name=get_iplayer \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=America/New_York \
  -e INCLUDERADIO= `#optional` \
  -e BASEURL= `#optional` \
  -e ENABLEIMPORT= `#optional` \
  -p 1935:1935 \
  -v </path/to/appdata/config>:/config \
  -v </path/to/appdata/downloads>:/downloads \
  --restart unless-stopped \
  ghcr.io/thespad/get_iplayer
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 1935` | Web GUI |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=America/New_York` | Specify a timezone to use EG America/New_York |
| `-e INCLUDERADIO=` | Set to `true` to pre-cache Radio (BBC Sounds) as well as TV shows |
| `-e BASEURL=` | Set to the full path of your proxied domain if using subfolders |
| `-e ENABLEIMPORT=` | Set to `true` to enable [SonarrAutoImport](https://github.com/Webreaper/SonarrAutoImport/). Place settings.json into the /config mount|
| `-v /config` | Contains all relevant configuration files. |
| `-v /downloads` | Storage location for all get_iplayer download files. |

## Environment variables from files (Docker secrets)

You can set any environment variable from a file by using a special prepend `FILE__`.

As an example:

```shell
-e FILE__PASSWORD=/run/secrets/mysecretpassword
```

Will set the environment variable `PASSWORD` based on the contents of the `/run/secrets/mysecretpassword` file.

## Umask for running applications

For all of our images we provide the ability to override the default umask settings for services started within the containers using the optional `-e UMASK=022` setting.
Keep in mind umask is not chmod it subtracts from permissions based on it's value it does not add. Please read up [here](https://en.wikipedia.org/wiki/Umask) before asking for support.

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```shell
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

## Support Info

* Shell access whilst the container is running: `docker exec -it get_iplayer /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f get_iplayer`

## Updating Info

Most of our images are static, versioned, and require an image update and container recreation to update the app inside. We do not recommend or support updating apps inside the container. Please consult the [Application Setup](#application-setup) section above to see if it is recommended for the image.

Below are the instructions for updating containers:

### Via Docker Compose

* Update all images: `docker-compose pull`
  * or update a single image: `docker-compose pull get_iplayer`
* Let compose update all containers as necessary: `docker-compose up -d`
  * or update a single container: `docker-compose up -d get_iplayer`
* You can also remove the old dangling images: `docker image prune`

### Via Docker Run

* Update the image: `docker pull ghcr.io/thespad/get_iplayer`
* Stop the running container: `docker stop get_iplayer`
* Delete the container: `docker rm get_iplayer`
* Recreate a new container with the same docker run parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
* You can also remove the old dangling images: `docker image prune`

### Image Update Notifications - Diun (Docker Image Update Notifier)

* We recommend [Diun](https://crazymax.dev/diun/) for update notifications. Other tools that automatically update containers unattended are not recommended or supported.

## Building locally

If you want to make local modifications to these images for development purposes or just to customize the logic:

```shell
git clone https://github.com/thespad/docker-get_iplayer.git
cd docker-get_iplayer
docker build \
  --no-cache \
  --pull \
  -t ghcr.io/thespad/get_iplayer:latest .
```

## Versions

* **28.11.21:** - Rebase to Alpine 3.15
* **17.06.21:** - Rebase to Alpine 3.14
* **24.03.21:** - Added SonarrAutoImport
* **02.03.21:** - Initial Release.
