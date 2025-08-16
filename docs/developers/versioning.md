# Versioning
ASL3 is a collection of many packages and each package (and the RPi image) have their own version numbers. For this reason it’s a bit hard to have one single version number to reference. One of those packages is the `asl3` package (ie. v3.8.0) from the [GitHub](https://github.com/AllStarLink/ASL3) ASL3 repo.

Another collection of packages, those starting with `asl3-asterisk`, have a much longer version string that include both Asterisk (ie. v22.4.1) and `app_rpt` (ie. v3.5.4). More information on the versioning of these packages can be found on the [Building ASL3-Asterisk](./package-builds.md#package-version-format) page.

The `asl-menu` title line shows the version number of `app_rpt`, ie. `3.5.4`.

!!! note "asl-show-version"
    You can use the `asl-show-version` command to see all of the ASL3 packages you have installed.


Here is an example output from `asl-show-version`:

```
********** AllStarLink [ASL] Version Info **********

OS            : Debian GNU/Linux 12 (bookworm)
OS Kernel     : 6.12.20+rpt-rpi-v8

Asterisk      : 22.4.1+asl3-3.5.4-1.deb12
ASL [app_rpt] : 3.5.4

Installed ASL packages :

  Package                         Version
  ==============================  ==============================
  allmon3                         1.5.1-1.deb12
  asl3                            3.8-1.deb12
  asl3-asterisk                   2:22.4.1+asl3-3.5.4-1.deb12
  asl3-asterisk-config            2:22.4.1+asl3-3.5.4-1.deb12
  asl3-asterisk-modules           2:22.4.1+asl3-3.5.4-1.deb12
  asl3-menu                       1.14-1.deb12
  asl3-pi-appliance               1.10.0-1.deb12
  asl3-tts                        1.0.1-1.deb12
  asl3-update-nodelist            1.5.1-1.deb12
  cockpit                         287.1-0+deb12u3
  cockpit-bridge                  287.1-0+deb12u3
  cockpit-networkmanager          287.1-0+deb12u3
  cockpit-packagekit              287.1-0+deb12u3
  cockpit-sosreport               287.1-0+deb12u3
  cockpit-storaged                287.1-0+deb12u3
  cockpit-system                  287.1-0+deb12u3
  cockpit-wifimanager             1.1.1-1.deb12
  cockpit-ws                      287.1-0+deb12u3
  dahdi                           1:3.1.0-2
  dahdi-dkms                      1:3.4.0-6+asl.deb12
  dahdi-linux                     1:3.4.0-6+asl.deb12
```

AllStarLink tries to follow the general guidelines of the [Semantic Versioning](https://semver.org/) major.minor.patch format.

