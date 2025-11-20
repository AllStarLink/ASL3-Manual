# Debian Appliance

!!! info "Debian 13 Only"
    An ASL Appliance can be added to a *Debian 13 installations only*.

If you install the following packages, you’ll have everything you need to use the “appliance” configuration.

Any Debian 13 installation can turned into an appliance. The following
will work for any platform, including virtual machines and VPS installs.
```bash
sudo apt install asl3-appliance
```

Systems that are hardware based (that _are not_ Raspberry Pi platforms) where certain additional features
may be desired, notably mDNS and low-write disk environments can
use the "PC" flavor of the appliance:

```bash
sudo apt install asl3-appliance-pc
```

Systems that are Raspberry-pi platforms where certain additional features may be desired, notably mDNS and specific Pi hardware
features can use:

```bash
sudo apt install asl3-appliance-pi
```

However it is **strongly** suggested to start any Pi build with
the ASL Appliance image. The asl3-appliance-pi package is **not**
supported on other Pi OS installs.

Use one of the above in the [Debian Appliance](install.md) directions
in place of the _ASL3 Package Install_ step.
