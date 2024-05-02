# Install AllStarLink

These instructions are for installing ASL on various computer systems.

You’re going to start off by installing a new Debian OS on your Raspberry Pi, PC computer, or virtual machine.  You probably don't want to install a production system right away.  Give yourself some time to test that everything works as you'd expect.

Note: if you have installed an earlier version of ASL you need to know that ASL3 has many changes and that there's a bit of a learning curve.  You will want to read the what's new page so you know what you're getting to. 


## Raspberry Pi

<hr>

ASL can be installed on a Raspberry Pi 3, 4, or 5. You will install an image on a microSD card and go. This is the simplest install. For most nodes the menus will walk you through the setup. For the well-initiated with
loading a Rapsberry Pi image, the image may be obtained from the [ASL3 Pi Release Page](#).

Detailed step-by-step directions for imaging and getting started can be followed
at [Pi Step-by-Step](../pi-detailed).

## Debian Linux 12

<hr>

AllStarLink v3 is supported on Debian 12 Bookworm systems, and those based
on Bookworm (e.g. Raspberry Pi OS). Both the x86_64/amd64 and arm64/aarch64
platforms are supported through apt/deb installation packages. Note that currently
the project does not support armv7l/armhf platforms because all known
use of AllStarLink is on hardware which supports the Bookworm arm64 distribution
such as Rasperry Pi 3, 4, and 5. If you have a platform that must use armv7l/armhf 
32-bit packages only please file an issue at [ASL3 on GitHub](https://github.com/AllStarLink/ASL3/issues).

To install the package repositories:

```bash
wget -O/tmp/asl-apt-repos_1.0-1._all.deb https://github.com/AllStarLink/asl-apt-repos/releases/download/1.0/asl-apt-repos_1.0-1._all.deb
sudo dpkg -i /tmp/asl-apt-repos_1.0-1._all.deb
sudo apt update
```

Then the packages may be installed and updated directly from the AllStarLink package
repository:

```bash
sudo apt install asl3 asl3-menu
```

This will install the complete AllStarLink v3 system including 
all of the Asterisk app_rpt-enabled packages 
(asl3-asterisk, asl3-asterisk-config, asl3-asterisk-dev, asl3-asterisk-doc, asl3-asterisk-modules),
the Dahdi kernel module (dahdi-dkms, dahdi-linux, dahdi-source) and the needed
development tools to keep the kernel module updated. If the guided, menu-based
configuration is not required, then do not include the `asl3-menu`
package.

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

## From Source

<hr>

Source install is for developers or users who need to install AllStarLink 3
on unsupported hardware or operating systems. 

<hr>

Installing ASL from source code is primarily for developers.  Doing so will require you to download, compile, and install multiple projects.  You will also need to be very comfortable using various development tools and the Linux CLI.

The following instructions are for building ONLY Asterisk with ASL's app_rpt.

 - Source install does not include any helpers, Allmon3, asl3-menu, asl3-nodelist, etc.
 - Installs and runs Asterisk as root

#### Install phreaknet.sh script

The phreaknet script compiles and patches Asterisk and DAHDI.

```bash
cd /usr/src && wget https://docs.phreaknet.org/script/phreaknet.sh && chmod +x phreaknet.sh && ./phreaknet.sh make
```

#### Install Asterisk 20 LTS

Use -t or -b for developer mode. Both are optional.

 - The -t is for backtraces and thread debug. Thread debugging is resource intensive.
 - Use -b for backtraces only, recommended on 386 or for submitting core dumps.
 - The -s is for sip if you need it still, leave off the -s if you don’t
 - The -d is for DAHDI and is required
 - The -v is to install the latest of the major version specified, 20 in this case
 - Use -f to force a reinstall (upgrade)

```
phreaknet install -d -b -v 20
```

Asterisk should be running at this point but not app_rpt. Check the install with `asterisk -r`.

#### Clone ASL3 repo

```bash
cd /usr/src
git clone https://github.com/AllStarLink/app_rpt.git
```

#### Install ASL3

This script does a git pull of app_rpt and compiles the branch you are on.

```bash
cd app_rpt
./rpt_install.sh
```

#### Install ASL3 configs

This adds ASL3 configs to the full set of Asterisk configuration files. ASL3 modules.conf limits what actually runs.

```bash
cp /usr/src/app_rpt/configs/rpt/* /etc/asterisk
```

> reboot the system

You should now have a complete ASL3 install.

```bash
asterisk -rx "rpt localnodes"
```
You should see node 1999.

## Windows

<hr>

ASL will not install natively on Windows.

## Docker

<hr>

There is not currently a Docker install from ASL.
