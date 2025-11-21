# Docker Installation
These instructions are for installing ASL3 within a Docker container. The
utility of this is low because of the host-container kernel dependencies.
Use of a [normal installation](install.md) is recommended.

!!! warning "Host / Container Kernel Compatibility"
    As app_rpt.so requires the DAHDI kernel modules, the container must be
    hosted on a Debian 12 or Debian 13 system. The container must be able to compile the
    kernel module (using DKMS) for the exact kernel version provided to
    the container from the Host OS. Currently, the container must be
    recomposed after a reboot into a new kernel.

!!! note "Advanced Concept"
    Use of Asterisk/app_rpt within a Docker container is not a trivial
    undertaking. The Docker structure is provided due to requests from the
    community but it is not the recommended way to install and use
    AllStarLink as it requires more configuration, not less, than
    a traditional installation.

!!! note "Limited Support"
    Installation of Asterisk/app_rpt in a container is not a primary
    platform for AllStarLink v3. Updates, fixes, and support will
    occur on as "as available" basis. Users of the container are
    requested to help the project.

## Git Repository
Create the directory `/docker` (or use whatever is preferred), `cd` to it,
and check out the Git repository containing the Docker configuration.
All commands on the rest of this page assume they are being run from
the directory containing the root of the Git repository.

For this manual page, the path used is `/docker/ASL3-Docker`.

The Git repository is located at [https://github.com/AllstarLink/asl3-docker](https://github.com/AllstarLink/asl3-docker). The following general steps can be used:

```bash
mkdir /docker
cd /docker
git clone https://github.com/AllStarLink/ASL3-Docker.git
cd ASL3-Docker
```

If the repository has already been checked out, but simply needs the latest
information, do `git pull origin main` from the `/docker/ASL3-Docker` directory.
For example:

```bash
cd /docker/ASL3-Docker
git pull origin main
```

## System Requirements
The AllStarLink3 container will require about 2G of space available
to `/var/lib/docker`.

## Container Composition
Construct the docker container with:

```bash
docker compose up -d --build --force-recreate
```

The script `asl3-init.sh` is used during the composition process to build the
system. Alterations for composing should be added here when possible
instead of the `Dockerfile` or `docker-compose.yml`. Do not delete
the `fake-systemctl` - that is needed to simulate systemd configurations for
successful package installation.

## Container Configuration
Configuration of Asterisk/ASL3 within the container is best done using
the `asl-menu` program. This is invoked with:

```bash
docker exec -it allstarlink3 asl-menu
```

!!! warning "Restarting Asterisk for Config Changes"
    Due to the workings of containers, the "Restart Asterisk" functions
    of asl-menu do not work. Changes make to the configuration
    requires a container restart - `docker restart allstarlink3`.
    It is possible to use the Asterisk command `rpt restart` to reload
    app_rpt but that is not always reliable.

## Interacting with Asterisk
Interacting with asterisk in the container is done using `asterisk-cli.sh`:

```bash
docker exec -it allstarlink3 /asl3/asterisk-cli.sh
```

## Viewing Asterisk Logs
Logs are viewed with `docker logs allstarlink3`.

## Stopping and Starting the Container
After the `docker compose` command, the container will be running
with the initial configuration of Asterisk and app_rpt. The following
commands may be used to manage the container:

* `docker stop allstarlink3` - Stops the container
* `docker start allstarlink3` - Starts the container
* `docker restart allstarlink3` - Restart the container (effectively a stop/start)

The container will start on boot of the Host OS unless otherwise configured.

## Container Rebuild After Host Kernel Upgrade
As stated above, the container must be managed in lock-step with the underlying
kernel of the host operating system. After the kernel of the host has been
upgraded, the container must be upgraded as well. The easiest way to do this
is simply top stop and recompose the container:

```bash
docker stop allstarlink3
docker compose up -d --build --force-recreate
```

Upon start after the recomposition, DAHDI will be installed and working
for the upgraded kernel.