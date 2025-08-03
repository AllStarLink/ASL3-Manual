# asl-play-arn

## NAME
`asl-play-arn` - Play Amateur Radio Newsline

## SYNOPSIS
Usage: 

```
/usr/bin/asl-play-arn [-h] --node <node> [ --when <when> ] [ --debug ]
```

Required arguments:

`--node <node>`: AllStarLink (local) node number to play audio on

Optional arguments:

`-h`, `--help`: show this help message and exit

`--when <when>`: when to play in 24 hour format `HHMM`. Not specifying `--when` will result in the audio playing immediately

`--debug`: enable debug-level logging in `syslog`

## DESCRIPTION
Basic use is either immediately from the command line:

```
allstar-play-arn --node 1999
```

Depending on the processing speed of the device and Internet connectivity, the start of playback may take a significant time. If the desire is for precision on the start time, use the `--when` command and execute `allstar-play-arn` a few minutes before the desired start time.

The script is silent except on errors like all good Unix utilities. Some useful troubleshooting may be done with the `--debug` option if an error is not revealing.

## Sceheduling the Playback
The best way to schedule the playback is as follows as the root user.

1. `cp /usr/share/asl3/asl-play-arn.* /etc/systemd/system`

2. Edit the `OnCalendar=` entry of `/etc/systemd/system/asl-play-arn.timer` for the timing of the playback desired

3. Edit the value for "NODE" in `/etc/systemd/system/asl-play-arn.service` for the node to execute the playback upon

4. Enable the timer unit:

  ```
  sudo systemctl daemon-reload
  sudo systemctl enable asl-play-arn.timer
  ```

## `Asterisk/app_rpt` Configuration
Usually the timeout timer in `app_rpt` will be too short to accommodate the playing of the full news file. The following commands can be added to [`rpt.conf`](../config/rpt_conf.md) to enable and disable the TOT:

```
907=cop,7    ; Time out timer enable
908=cop,8    ; Time out timer disable
```

These appear as commented-out options in the stock [`rpt.conf`](../config/rpt_conf.md).

## BUGS
Report bugs to https://github.com/AllStarLink/ASL3/issues

## COPYRIGHT
Copyright (C) 2025 Jason McCormick and AllStarLink under the terms of the AGPL v3.