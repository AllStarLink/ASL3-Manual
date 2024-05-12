# Updating ASL3
All of the software components that make up AllStarLink 3 are
provided by software packages (Debian .deb files) from an
centralized Apt repository. This makes upgrades quick and
painless for users.

## Standard Debian Upgrades
Whether AllStarLink 3 is installed on a standard Debian 12
installation or one is using the Pi appliance image,
updates follow the standard Debian format:

```bash
sudo apt update
sudo apt upgrade -y
sudo reboot
```

This will update all AllStarLink 3 software as well as
the underlying operating system. AllStarLink 3 will never
release any update that is a "breaking change" through
the apt system that doesn't have either an automated upgrade
process or a well-documented manual step-by-step process.

Sometimes an update may ask what to do with a configuration
file. It is generally say to answer such questions with
`N` meaning "keep your currently-installed version. Such a question
will look like:
```bash
Configuration file '/etc/asterisk/rpt.conf'
 ==> Modified (by you or by a script) since installation.
 ==> Package distributor has shipped an updated version.
   What would you like to do about it ?  Your options are:
    Y or I  : install the package maintainer's version
    N or O  : keep your currently-installed version
      D     : show the differences between the versions
      Z     : start a shell to examine the situation
 The default action is to keep your current version.
*** rpt.conf (Y/I/N/O/D/Z) [default=N] ? N
```

AllStarLink will clearly announce when there is a change that may break
existing configurations.

## Note on DAHDI
In the past, managing the DAHDI kernel module necessary
for app_rpt has been problematic during kernel upgrades.
Previously, it had been recommended never to upgrade
the kernel. This advice is no longer valid and should not
be followed for security and practicality reasons.

AllStarLink v3 automatically manages and rebuild the
DAHDI kernel modules during software updates using
the DKMS system. After an upgrade, rebooting into a new version
of the Linux kernel will "Just Work".