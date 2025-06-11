# ASL3 Appliance (Raspberry Pi)
The ASL3 "Appliance" is based around the Raspberry Pi platform. It is envisioned as a compact standalone platform that can be used to quickly deploy a node.

The Pi would be the [Server](../../basics/gettingstarted.md#what-is-a-server) on which you would deploy your [Node(s)](../../basics/gettingstarted.md#what-is-a-node).

The ASL3 Appliance (Raspberry Pi) image includes the following to make a complete AllStarLink system:

* Debian 12 operating system
* Asterisk 20 LTS + `app_rpt`
* `asl-*` commands
* ASL3 Menu ([`asl-menu`](../../user-guide/index.md))
* Allmon3
* Web-based administration (`Cockpit`)
* A nice landing page

## ASL3 Appliance Requirements
The following are the system requirements for the ASL3 Appliance

| | Required | Recommended
|------|-----------|-------------|
| **Hardware** | Arm v8 64-bit CPU <br> Raspberry Pi 3, 4, 5, Zero 2 W, 400 | Raspberry Pi 4B or 5B |
| **Memory** | Minimum 512M | 4G |
| **Storage** | Minimum 4G or larger | 8GB Class 10 |s

The ASL3 Appliance been tested on Raspberry Pi 3, 4, 5, and Zero 2W.