# Debian Appliance

AllStarLink distributes a set of packages that turn a Debian OS installation
into an "appliance" for almost-turnkey operation of an ASL node. The following
features are available with the appliance packages.

!!! info "Debian 13 Only"
    An ASL Appliance can only be added to Debian 13 installations.

## Appliance Options :

The following appliance options are available :

| Feature | ASL3-Appliance | ASL3-Appliance-Pi | ASL3-Appliance-PC |
|---------|----------------|-------------------|-------------------|
| ASL Appliance Web Page | :material-check-bold: | :material-check-bold: | :material-check-bold: |
| Web Server Management | :material-check-bold: | :material-check-bold: | :material-check-bold: |
| Allmon3 Auto-Configuration | :material-check-bold: | :material-check-bold: | :material-check-bold: |
| Cockpit | :material-check-bold: | :material-check-bold: | :material-check-bold: |
| Firewall Configuration | :material-check-bold: | :material-check-bold: | :material-check-bold: |
| mDNS Broadcasts (`.local` DNS names) | | :material-check-bold: | :material-check-bold: |
| Swapfile Management | | :material-check-bold: | :material-check-bold: |
| Pi `/dev/serial0` Management | | :material-check-bold: | |
| Wi-Fi Configuration Preloaded | | :material-check-bold: | |
| Logs and temp files are ephemeral to reduce writes to<br>media when used on an ASL3 Appliance Pi image | | :material-check-bold: | |

## Appliance Installation :

Any Debian 13 installation can be turned into an appliance. The following
will work for any platform, including virtual machines and VPS installs.

```bash
sudo apt install asl3-appliance
```

Systems that are hardware based (that _are not_ Raspberry Pi platforms) where certain
additional features may be desired, notably mDNS and swap management can
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
