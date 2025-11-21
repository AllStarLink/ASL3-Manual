# Debian Appliance

!!! info "Debian 13 Only"
    An ASL Appliance can only be added to Debian 13 installations.

AllStarLink distributes a set of packages that turn a Debian OS installation
into an "appliance" for almost-turnkey operation of an ASL node. The following
features are available with the appliance packages.


| Feature | ASL3-Appliance | ASL3-Appliance-Pi | ASL3-Appliance-PC |
|-|-|-|-|
| ASL Appliance Site | :material-check-bold: | :material-check-bold: | :material-check-bold: |
| Webserver Management | :material-check-bold: | :material-check-bold: | :material-check-bold: |
| Allmon3 Auto-Configuration | :material-check-bold: | :material-check-bold: | :material-check-bold: |
| Cockpit | :material-check-bold: | :material-check-bold: | :material-check-bold: |
| Firewalld | :material-check-bold: | :material-check-bold: | :material-check-bold: |
| mDNS Broadcasts (`.local` DNS names) | | :material-check-bold: | :material-check-bold: |
| Swapfile Management | | :material-check-bold: | :material-check-bold: |
| Pi `/dev/serial0` Management | | :material-check-bold: | |
| WiFi Config Preload | | :material-check-bold: | |
| Logs and Tempfiles are ephemeral to<br>reduce writes to media<br>when used on an ASL3 Appliance Pi image| | :material-check-bold: | |

If you install the following package, you’ll have everything you need to use the “appliance” configuration.

Any Debian 13 installation can turned into an appliance. The following
will work for any platform, including virtual machines and VPS installs.
```bash
sudo apt install asl3-appliance
```

Systems that are hardware based (that _are not_ Raspberry Pi platforms) where certain additional features
may be desired, notably mDNS and swap management can
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
