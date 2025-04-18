# Debian 12 Install
These instructions are for installing ASL3 on general purpose operating systems manually. For installation on Raspberry Pis, consider using the [AllStarLink 3 Pi Appliance](pi-detailed.md)

!!! note "Architecture Support"
    Currently, the project does not support armv7l/armhf platforms because all known uses of AllStarLink is on hardware which supports the Bookworm arm64 distribution such as Raspberry Pi 3, 4, 5, and Zero 2 W. If you have a platform that can use armv7l/armhf 32-bit packages only please file an issue at [ASL3 on GitHub](https://github.com/AllStarLink/ASL3/issues).

!!! note "Previous Issues with Cloud Kernels"
    As of DAHDI Linux 3.4.0-5, as released from AllStarLink, no longer has conflicts with the Debian "cloud" kernels and is fully supported.

## System Requirements
The following are the system requirements for an ASL3 system:

| | Minimum Required | Recommended
|------|-----------|-------------|
| **CPU/Platform** | 1 CPU, 64-bit, x86_64 (amd64) or ArmV8 (arm64) | 2 - 4 CPUs depending on the number of hardware devices connected to the system |
| **Memory** | 512M | 2 G |
| **Storage** | 8G (for OS + software) | - |

!!! note "UEFI / SecureBoot"
    For x86_64/amd64 platforms, it is recommended to disable SecureBoot if you do not need that feature. While it is a good security feature, given that AllStarLink v3 requires building a kernel module, it adds likely-undesired complexity for most ASL users. If you need or want to use UEFI/SecureBoot see [the advanced topic document](../adv-topics/uefi-secureboot.md).
  
## Debian 12 OS Install
You’re going to start off by installing a new Debian 12 OS on your PC computer or virtual machine. There are instructions all over the internet that detail how to install Debian 12. Briefly you:

 * Download and boot the Debian 12 netinstall.iso
 * Take most of the defaults
 * Do not install a `Debian desktop environment`
 * Do install `web server` (if you plan to use Allmon3 or other web management packages)
 * Do install `SSH server`

**NOTE:** When setting up users and passwords you may be prompted to set the password for the `root` account. If you DO NOT provide a password then the root account will be disabled, and the system's initial user account (that will requested on the next screen) will be given the power to become `root` using the `sudo` command.  If you DO provide a password then the `sudo` command will NOT be installed on your system. Our recommendation is to NOT set the `root` password and rely on using the `sudo` command only when needed.

## AllStarLink Package Repo Install
Once your Debian system is up and running, install the ASL package repositories:

```
cd /tmp
wget https://repo.allstarlink.org/public/asl-apt-repos.deb12_all.deb
sudo dpkg -i asl-apt-repos.deb12_all.deb
sudo apt update
```

## ASL3 Packages Install
Now the packages may be installed and updated directly from the AllStarLink package repository:

```
sudo apt install asl3
```

This will install the complete ASL3 system including all of the Asterisk `app_rpt`-enabled packages (`asl3-asterisk`, `asl3-asterisk-config`, `asl3-asterisk-doc`, `asl3-asterisk-modules`), the Dahdi kernel module (`dahdi-dkms`, `dahdi-linux`, `dahdi-source`), the needed development tools to keep the kernel module updated, and the `asl3-menu`.

It's important to note that the new packaging format will allow for easy, automated updates of kernels through the standard `apt upgrade` process. There is no longer any reason to hold back kernel upgrades with the ASL3 packaging.

The following packages are also available and may be installed separately:

**Allmon3** - The updated web interface to AllStarLink which includes strong support for mobile devices and screens of all sizes and shapes. See the [Allmon3](../allmon3/basics.md) page for details.

**ASL3 Nodelist Updater** - An updated node service to maintain a local copy of the AllStarLink node database (`rpt_extnodes`). While, in general, the preferred method of node lookup is DNS, some installations with slow Internet or DNS servers that have very long cache timers may benefit from this method of node lookup instead.

Install with `sudo apt install asl3-update-nodelist`.

## Node Configuration
The next step is to configure the node settings. It is recommended to use the `asl-menu` command to manage the configuration for common use cases. See [ASL3 Menu](menu.md) for details. YouTuber Freddie Mac has a nice [ASL3 RPi installation and configuration video](https://youtu.be/aeuj-yI8qrU). See the part where the `asl-menu` is shown. 

Proceed from here with the **Node Settings** option in order to configure your node number and choose/configure your audio interface. 

## Debian 12 Appliance

!!! danger "Do This at Your Own Risk"
    A Debian 12 Appliance, similar to the Raspberry Pi Appliance, is still under development. In the meantime, you can get "close" to the same user experience by installing and configuring some additional packages. This is not generally recommended for most users at this time.

If you install the following packages, you’ll have everything you need to use the “appliance” configuration:

```
sudo apt install asl3 asl3-update-nodelist asl3-menu allmon3
```

You will still need to do certain things like configure [Allmon3](../allmon3/basics.md) by hand.

If you want to turn your configuration you described into the full appliance, you can try installing `asl3-pi-appliance` which will “take over” your system. 

This hasn't been rigorously tested against a non-Pi installation, but it should *mostly* work (if not completely work) - but YMMV. A non-PI “image” is in the works, but it’s not ready yet.

If you don’t want to take the risk of that, but still want all the web experience, you can install:

```
sudo apt install cockpit cockpit-networkmanager cockpit-packagekit \
  cockpit-sosreport cockpit-storaged cockpit-system cockpit-ws \
  python3-serial firewalld
```

Which should give you an unbranded, uncustomized `Cockpit` environment.

Again, doing the above is **experimental and not generally recommended**, but you are welcome to give it a try, and perhaps provide feedback on issues and changes to help push the development of a Debian 12 Appliance image along!

## Docker
Docker support will be coming in the near future.