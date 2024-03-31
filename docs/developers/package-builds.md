# test

Because Asterisk runs a non-root consider:

 - RTCM configs: We are recommending the use of port 1667 to avoid OS hacks for ports below 1024.
 - USB configs require a udev rule: `cat /etc/udev/rules.d.90-asl3.rules` SUBSYSTEM=="usb", ATTRS{idVendor}=="0d8c", GROUP="plugdev", TAG+="uaccess"

# Version Taxonomy
ASL3 has adopted a new version format for individual packages related to
Asterisk and the app_rpt-associated code. That format is:

```
{ASTERISK_VERSION}+asl3-{APP_RPT_VERSION}-{PKG_RELEASE}
```

The string `ASTERISK_VERSION` is the base version of Asterisk (e.g. 20.7.0).
The string `APP_RPT_VERSION` is the version of apt_rpt and associated code, starting
from 1 at the epoch of beginning packaging building.
The string `PKG_RELEASE` is a Debian package-related package version. This will appear
in the output of the `asterisk -rv` command and otherwise as necessary.

