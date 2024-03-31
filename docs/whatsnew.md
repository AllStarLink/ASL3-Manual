# What's New

**New Features and improvements**

 - ASL3 runs on Asterisk 20 and Debian 12.
 - HTTP AllStarLink registration
 - DNS IP address resolution with fallback to file
 - Memory leaks addressed
 - All modules reload or refresh
 - Improved uptime
 - USB tune settings improvements
 - ASL menu improvements
 - EchoLink improvements
    - Chat has been enabled
    - Honors the app\_rpt timeout timer.  A text message is sent to the client when they time out.
    - No longer allows clients to double.  A text message is sent to the client when they are doubling.
 - Per node access lists
 - Compile directives for more architectures
 - rpt.conf template
 - Asterisk runs as non-root
    - RTCM configs: We are recommending the use of port 1667 to avoid OS hacks for ports below 1024.
    - USB configs require a udev rule: `cat /etc/udev/rules.d.90-asl3.rules` SUBSYSTEM=="usb", ATTRS{idVendor}=="0d8c", GROUP="plugdev", TAG+="uaccess"

# What's different

At the risk of being redundant ASL3 now runs on Asterisk 20... we're so proud.

 - There is no update or migration path from ASL2 to ASL3
 - Many ASL3 conf files are different.

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


# ASL3 Menu

The new ASL3 menu will walk you through setting up a basic USB or hub node quickly. Switching between menu and config edits is non-destructive.

# Editing configs

When editing configs or using the Asterisk CLI consider:

 - Registration is now set in `rpt_http_registration.conf` not in `iax.conf`. IAX registration still works but is discouraged. Don't register both http and IAX. The new CLI command is`rpt show registrations`.
 - A template is now used in `rpt.conf`. Editing is much easier but it's different than ASL2. Node settings are much simpler requiring only a few added lines per node. The ASL3 menu handles the templated config.
 - The USB configuration files now contain the tune settings. There is no tune file for each node as in ASL2. The tune menus and Asterisk CLI write to the new tune setting locations.
 - There no need to edit or use a script to update the blacklist and whitelist.

 Most of this new stuff is explained with more detail in the ASL3 Configuration page.

