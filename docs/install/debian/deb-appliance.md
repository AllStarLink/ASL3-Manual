# Debian Appliance

!!! info "Debian 13 Only"
    An ASL Appliance can only be added to Debian 13 installations.

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

Systems that are based on the Raspberry Pi platform are strongly encouraged to start with
the ASL3 Appliance (Raspberry Pi) image that includes the asl3-appliance-pi package.
Those who need to create their own Pi images (something ASL does not support), can use:
```bash
sudo apt install asl3-appliance-pi
```

Use one of the above in the [Debian Appliance](install.md) directions
in place of the _ASL3 Package Install_ step.
