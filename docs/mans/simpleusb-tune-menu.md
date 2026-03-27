# simpleusb-tune-menu

## NAME
`simpleusb-tune-menu` - Configure SimpleUSB Radio interface device from menu

## SYNOPSIS
Usage: 

```
/usr/sbin/simpleusb-tune-menu [-n node#]
```

Optional arguments:

`-n node#`: tune interface associated with node#

## DESCRIPTION
simpleusb-tune-menu - Configure a SimpleUSB Radio interface device using an interactive menu

With no options, executing `sudo simpleusb-tune-menu` will open a menu driven utility for configuring the default SimpleUSB interface.

You will be able to adjust outgoing (TX) audio and check incoming (RX) audio levels, and view the COS, CTCSS, and PTT signaling in real-time. <mark>Echo mode</mark> and <mark>Flash</mark> can be used to verify correct interface functioning.

!!! tip "SA818 Programming"
    For a personal hotspot interface (typically a USB dongle combining SA818 (RF) module and CM108 (audio) chipset), it is suggested to configure the RF settings first (see [`sa818-menu`](./sa818-menu.md)).

!!! note "CTCSS Configuration"
    Many USB interfaces do not provide COS and CTCSS hardware signals (e.g. personal hotspot interfaces). For these interfaces you need to change the <mark>CTCSS From</mark> setting to 'no'. If this setting is not correct, you will find you are unable to ***kerchunk*** your node.

## BUGS
Report bugs to https://github.com/AllStarLink/ASL3/issues

## COPYRIGHT
Copyright (C) 2026 AllStarLink Inc. under the terms of the AGPL v3.
