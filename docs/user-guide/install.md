# Install AllStarLink

These instructions are for installing ASL on various computer systems.

You’re going to start off by installing a new Debian OS on your PC computer, or virtual machine.  For the Raspberry Pi there is an image with the OS, Allmon3 and Cockpit.  You probably don't want to install a production system right away.  Give yourself some time to test that everything works as you'd expect.

Note: if you have installed an earlier version of ASL you need to know that ASL3 has many changes and that there's a bit of a learning curve.  If you've not already read the [Users Guide](/user-guide/) now would be a good time so you know what you're getting to.


## Raspberry Pi

<hr>

ASL can be installed on a Raspberry Pi 3, 4, or 5. You will install an image on a microSD card and go. This is the simplest install. For most nodes the menus will walk you through the setup. For the well-initiated with
loading a Rapsberry Pi image, the image may be obtained from the [ASL3 Pi Release Page](#).

Detailed step-by-step directions for imaging and getting started can be followed
at [Pi Step-by-Step](pi-detailed.md).

## Debian Linux 12

<hr>

AllStarLink v3 is supported on Debian 12 Bookworm systems, and those based
on Bookworm (e.g. Raspberry Pi OS). Both the x86_64/amd64 and arm64/aarch64
platforms are supported through apt/deb installation packages. Note that currently
the project does not support armv7l/armhf platforms because all known
use of AllStarLink is on hardware which supports the Bookworm arm64 distribution
such as Raspberry Pi 3, 4, and 5. If you have a platform that must use armv7l/armhf
32-bit packages only please file an issue at [ASL3 on GitHub](https://github.com/AllStarLink/ASL3/issues).

To install the package repositories:

```bash
wget -O/tmp/asl-apt-repos.deb12_all.deb https://repo.allstarlink.org/public/asl-apt-repos.deb12_all.deb
sudo dpkg -i /tmp/asl-apt-repos.deb12_all.deb
sudo apt update
```

Then the packages may be installed and updated directly from the AllStarLink package
repository:

```bash
sudo apt install asl3
```

This will install the complete AllStarLink v3 system including
all of the Asterisk app_rpt-enabled packages
(asl3-asterisk, asl3-asterisk-config, asl3-asterisk-doc, asl3-asterisk-modules),
the Dahdi kernel module (dahdi-dkms, dahdi-linux, dahdi-source), the needed
development tools to keep the kernel module updated, and the asl3-menu.

It's important to note that the new packaging format will allow for easy,
automated updates of kernels through the standard `apt upgrade` process.
There is no longer any reason to hold back kernel upgrades with the ASL3
packaging.

The following packages are also recommended, but not required for
installation of AllStarLink v3:

`allmon3` - The updated web interface to AllStarLink which includes strong
support for mobile devices and screens of all sizes and shapes.

`asl3-update-nodelist` - And updated node service to maintain a local
database copy of the AllStarLink node database. While, in general, the
preferred method of node lookup is DNS, some installations with
slow Internet or DNS servers that have very long cache timers may benefit
from this method of node lookup instead.

## Docker
Docker support will be coming in the near future.