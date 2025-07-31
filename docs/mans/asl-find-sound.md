# asl-find-sound

## NAME
`asl-find-sound` - Display `app_rpt`-compatible sound devices

## SYNOPSIS
usage: 
```
        `/usr/bin/asl-find-sound`
```

## DESCRIPTION
asl-find-sound - Display `app_rpt`-compatible sound devices

The `asl-find-sound` utility will find compatible sound devices, and display their relevant device identificatino, that can be used in the `devstr=` in `simpleusb.conf` or `usbradio.conf`.

Sample:

```
asl@asl:~ $ sudo asl-find-sound
1-1.5:1.0       -->     0d8c:000c C-Media USB Headphone Set
```

The resulting device string to use would then be: `devstr = 1-1.5:1.0`

## BUGS
Report bugs to https://github.com/AllStarLink/ASL3/issues

## COPYRIGHT
Copyright (C) 2025 Jason McCormick and AllStarLink under the terms of the AGPL v3.