# Debian Appliance

!!! info "Debian 13 Only"
    An ASL Appliance can be created with a **Debian 13** installations only.

If you install the following packages, you’ll have everything you need to use the “appliance” configuration.

Any Debian 13 installation can turned into an appliance. The following
will work for any platform, including virtual machines and VPS installs.
```bash
sudo apt install asl3 asl3-menu allmon3 asl3-appliance
```

Systems that are hardware based where certain additional features
may be desired, notably mDNS and low-write disk environments can
use the "PC" flavor of the appliance:

```bash
sudo apt install asl3 asl3-menu allmon3 asl3-appliance-pc
```

Use one of the above in the [Debian Appliance](install.md) directions
in place of the _ASL3 Package Install_ step.
