# Debian 12 Install

These instructions are for installing ASL3 on various x86 systems. AllStarLink v3 is supported on Debian 12 Bookworm systems, and those based on Bookworm (e.g. Raspberry Pi OS). Both the x86_64/amd64 and arm64/aarch64 platforms are supported through apt/deb installation packages.

Note that currently the project does not support armv7l/armhf platforms because all known use of AllStarLink is on hardware which supports the Bookworm arm64 distribution such as Raspberry Pi 3, 4, 5, and Zero 2 W. If you have a platform that must use armv7l/armhf 32-bit packages only please file an issue at [ASL3 on GitHub](https://github.com/AllStarLink/ASL3/issues).

## OS Install
You’re going to start off by installing a new Debian 12 OS on your PC computer or virtual machine. There are instructions all over the internet that detail how to install Debian 12. Briefly you:

 - Download and boot the Debian 12 net install .iso
 - Take most of the defaults
 - Do not install a `Debian desktop environment`
 - Do install `web server` (if you plan to use Allmon3 or other web management packages)
 - Do install `SSH server`

## AllStarLink Package Repo Install
Once your Debian system is up and running, install the ASL package repositories:

```bash
cd /tmp
wget https://repo.allstarlink.org/public/asl-apt-repos.deb12_all.deb
sudo dpkg -i asl-apt-repos.deb12_all.deb
sudo apt update
```

## ASL3 Packages Install

Now the packages may be installed and updated directly from the AllStarLink package
repository:

```bash
sudo apt install asl3
```

This will install the complete ASL3 system including
all of the Asterisk app_rpt-enabled packages
(asl3-asterisk, asl3-asterisk-config, asl3-asterisk-doc, asl3-asterisk-modules),
the Dahdi kernel module (dahdi-dkms, dahdi-linux, dahdi-source), the needed
development tools to keep the kernel module updated, and the asl3-menu.

It's important to note that the new packaging format will allow for easy,
automated updates of kernels through the standard `apt upgrade` process.
There is no longer any reason to hold back kernel upgrades with the ASL3
packaging.

The following packages are also available and may be installed separately:

**Allmon3** - The updated web interface to AllStarLink which includes strong
support for mobile devices and screens of all sizes and shapes.
See the [Allmon3 page](../allmon3/index.md) for details.

**ASL3 Nodelist Updater** - An updated node service to maintain a local copy of
the AllStarLink node database (rpt_extnodes). While, in general, the
preferred method of node lookup is DNS, some installations with
slow Internet or DNS servers that have very long cache timers may benefit
from this method of node lookup instead.
Install with `sudo apt install asl3-update-nodelist`.

## Node Configuration
Next step is to configure the node settings. YouTuber Freddie Mac has a nice ASL3 RPi installation and configuration video. See the part where the asl-menu is shown [https://youtu.be/aeuj-yI8qrU](https://youtu.be/aeuj-yI8qrU). Also see [ASL3 Menu](menu.md) for details.

## Docker
Docker support will be coming in the near future.