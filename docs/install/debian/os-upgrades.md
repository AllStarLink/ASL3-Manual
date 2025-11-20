# Debian OS Upgrades

!!! warning "An in-place upgrade is only recommended for experienced users."

Debian does support in-place upgrades of the operating system and, in general,
all core AllStarLink packages will properly upgrade between supported
versions. Third-party applications and scripts may not work properly or at all
without additional upgrades for those.

!!! tip "Official Upgrade Instructions"
    The official Debian upgrade from Debian 12 to 13 can be found
    in the [Debian 13 Release Notes](https://www.debian.org/releases/trixie/release-notes/upgrading.en.html).

1. Login to Debian and become root with `sudo -s`. All commands
following this are run as root.

2. Ensure that all of the latest Bookworm packages are installed:
    ```bash
    apt update
    apt upgrade -y
    apt dist-upgrade -y
    ```

    It is not necessary to reboot into a new kernel if installed.

3. Change the `apt` configuration to pull packages from the
Trixie release:

    ```bash
    perl -pi -e 's/bookworm/trixie/g' \
        /etc/apt/sources.list \
        /etc/apt/sources.list.d/*
    ```

4. Perform an update of the Debian package information:

    ```bash
    apt update
    ```

    If the last few lines complain about the following:
    ```
    N: Skipping acquire of configured file 'main/binary-armhf/Packages' as repository 'https://repo.allstarlink.org/public trixie InRelease' doesn't support architecture 'armhf'
    N: Skipping acquire of configured file 'beta/binary-armhf/Packages' as repository 'https://repo.allstarlink.org/public trixie InRelease' doesn't support architecture 'armhf'
    N: Skipping acquire of configured file 'devel/binary-armhf/Packages' as repository 'https://repo.allstarlink.org/public trixie InRelease' doesn't support architecture 'armhf'
    ```

    Then remove the "armhf" architecture legacy configuration
    with:
    ```bash
    dpkg --remove-architecture armhf
    apt update
    ```

5. Begin the upgrade-process first stage install:
    ```bash
    apt upgrade -y
    ```

    If you are prompted about restarting services
    it is safe to choose "Yes".

    DO NOT reboot after this step.

6. Begin the upgrade-process second stage install:
    ```bash
    apt dist-upgrade -y
    ```

7. Reboot the system with the `reboot` command.

8. Login to Debian and become root with `sudo -s`.

9. Remove obsolete packages related to Debian 12:
    ```bash
    apt autoremove -y
    ```

10. Remove all legacy package data or other information
that is no longer needed:

    ```bash
    apt purge -y $(dpkg -l | grep -E '^rc' | awk '{print $2}')
    ```

11. Run `asl-check-install` and look for any installation
problems.

12. Test out your Asterisk/app_rpt system and any other
applications.