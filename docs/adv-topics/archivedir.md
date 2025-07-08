# Audio and Activity Logging
ASL3 supports a simple log and audio recorder of the activity on a node. When enabled, a series of recordings, one for each active COR on the node, is generated. The file(s) will be named with the date and time down to the second. Finer granularity is available using the `archivedatefmt=` variable. This logging can be useful in debugging, policing, or other creative things.

The archiving function is enabled by setting the [`archivedir=`](../config/rpt_conf.md#archivedir) to a non-null value.

There are additional directives in [`rpt.conf`](../config/rpt_conf.md) that control different aspects of the logging function.

rpt.conf Setting|Usage
----------------|-----
archivedir=|Set the top level recording directory
archiveformat=|Set the audio file format: wav49 (default if not specified, GSM in a .wav file), wav (SLIN in a .wav file), or gsm (straight GSM)
archivedatefmt=|Set the date format. By default, the files will use a "%Y%m%d%H%M%S" date format that maps to YYYYMMDDHHMMSS. If desired, you can specify any date format supported by the C function strftime(3) API. For more precision, you can also include the '%[n]q' format to add fractions of a second, with leading zeros
archiveaudio=|If "yes", both the simple activity log AND audio recordings are logged. If set to "no" then only the activity log will be created

## Setup
In `rpt.conf` under your node stanza place:

```
[1999]
archivedir = /var/spool/asterisk/monitor
```

The `archivedir=` and related options can be implemented in the `[node-main](!)` stanza to apply to all nodes on the server, or in the per-node stanza for recording individual nodes. See [config file templating](../adv-topics/conftmpl.md#asterisk-templates) for more information.

The directory can be of your choosing. It must exist and must have proper [permissions](../adv-topics/permissions.md) for Asterisk. ASL3 will create the node number subdirectory for you. You want to end up with a subdirectory for each node number so each node has its own archive of audio recordings.

The above `archivedir = /var/spool/asterisk/monitor/` could result in something like:

```
/var/spool/asterisk/monitor/63001
/var/spool/asterisk/monitor/1999
```

## Usage
Restart Asterisk and you're all set. ASL3 will create a recording for each COR activation and a daily log file. The recordings are by default named like `20221216115509.WAV`. 

The log file is named like `20221216.txt`, with contents that look similar to this:

```
20221216112549,TXUNKEY,MAIN
20221216112800,RXKEY,29285
20221216112800,TXKEY,MAIN
20221216112800,RXUNKEY,29285
20221216112800,TXUNKEY,MAIN
20221216112801,LINKDISC,29285
```

The log is not very in depth. But it shows connects, disconnects, and which node made a transmission. Often you will need to listen to the audio to tell exactly what happened when trying to trace some things down. But you have a time stamp to make that easier.

!!! warning "Disk Space"
    You must take care if running this long periods of time, as the audio files will consume a LOT of space. One option is to use `archivedir = /tmp/` because if it fills up, a reboot will clear the files and you'll have you node operational again. Of course, it's best to not let it get out of hand in the first place, maybe look at using `logrotate` or an external drive with lots of space.