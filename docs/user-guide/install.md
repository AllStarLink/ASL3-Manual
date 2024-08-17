# Debian 12 Install

These instructions are for installing ASL3 on general purpose operating systems manually. For
installation on Raspberry Pis, consider using the [AllStarLink 3 Pi Appliance](pi-detailed.md)

!!! note "Architecture Support"
    Currently, the project does not support armv7l/armhf platforms because all known uses of AllStarLink is on hardware which supports the Bookworm arm64 distribution such as Raspberry Pi 3, 4, 5, and Zero 2 W. If you have a platform that can use armv7l/armhf 32-bit packages only please file an issue at [ASL3 on GitHub](https://github.com/AllStarLink/ASL3/issues).

!!! warning "Asterisk/app_rpt on VMs/Cloud"
    Asterisk/app_rpt works fine on virtual machines in a cloud environment (often terms "VPS"). However
    Asterisk/app_rpt requires certain kernel modules to function properly and these are provided
    by ASL3 in the dkms-dahdi package. There are, however, two situations where Asterisk/app_rpt
    will not work:

    1. When the VPS provider is using a customized Debian using the "cloud" kernel. If the
    output of `uname -r` refers to the kernel as something similar to 
    "6.1.0-12-cloud-x86_64" then you **cannot** use that OS for ASL because it lacks the
    capabilities build the needed kernel modules. You must install a standard Debian 12
    image which is probably a "custom install" for your provider. Ask your VPS provider
    for support.

    2. When the virtual machine is using an emulated Linux kernel. Microsoft Windows 
    Subsystem for Linux (WSL2) is a good example of this situation. The kernel is
    custom and not related to the operating system distribution. Asterisk/app_rpt
    cannot work in this type of setup.

## System Requirements
The following are the system requirements for an ASL3 system:

| | Minimum Required | Recommended
|------|-----------|-------------|
| **CPU/Platform** | 1 CPU, 64-bit, x86_64 (amd64) or ArmV8 (arm64) | 2 - 4 CPUs depending on the number of hardware devices connected to the system |
| **Memory** | 512M | 2 G |
| **Storage** | 8G (for OS + software) | - |

!!! note "UEFI / SecureBoot"
    For x86_64/amd64 platforms, it is recommended to disable UEFI and SecureBoot
    if you do not need those features and your platform supports a "legacy BIOS" mode.
    While they are a good security feature, given that
    AllStarLink v3 requires building a kernel module, it adds likely-undesired complexity
    for most ASL users. If you need or want to use UEFI/SecureBoot see
    [the advanced topic document](../adv-topics/uefi-secureboot.md).
  
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
Next step is to configure the node settings. It is recommended to use the
`asl-menu` command to manage the configuration for common use cases. See
[ASL3 Menu](menu.md) for details. YouTuber Freddie Mac has a nice
[ASL3 RPi installation and configuration video](https://youtu.be/aeuj-yI8qrU). See
the part where the asl-menu is shown. 

## Docker
Docker support will be coming in the near future.