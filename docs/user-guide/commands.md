# ASL3 New Commands
New and different ASL3 commands are mentioned here. Older ASL commands are still documented on the  [AllStarLink Wiki](https://wiki.allstarlink.org)

## app_rpt
 - `rpt show channels <node>`
 - `rpt show variables <node>` replaces `rpt showvars`
 - `rpt show version`

 ## New Registration System
 - `rpt show registrations` is the new http registration. `iax2 show registration` still exists but http registration should be used in its place.
 - `rpt lookup <node>` is a lookup of the IP address of <node>

Asterisk CLI comand `rpt lookup 2000` for example will show the IP
address of node 2000. Linux CLI is `host 2000.nodes.allstarlink.org`,
for example. The software now implements DNS lookup of node
information.  By default the software will now query the
AllStarLink DNS servers first to resolve node information. It will
fall back to the external rpt_extnodes file if the node cannot
be resolved by DNS.

The operation of this ASL3 feature can be controlled by changing
the following information in rpt.conf.

```
[general]
node_lookup_method = both   ;method used to lookup nodes
                    ;both = dns lookup first, followed by external file (default)
                    ;dns = dns lookup only
                    ;file = external file lookup only
```
The node lookup routines will output debug information showing the node lookups if the debug level is set to 4 or higher.


## chan_simpleusb Show Settings
`susb show settings`  is used to show the currently selected node's settings.
This replaces `susb tune`.

## chan_usbradio Show Settings
`radio show settings`  is used to show the currently selected node's settings.
This replaces `radio tune`.

## Simple and Radio Tune Menus
The utility programs `radio-tune-menu` and `simpleusb-tune-menu` have been updated with new options. The new options allow you change the operation of the respective channel driver, in realtime, without having to manually edit the `usbradio.conf` or `simpleusb.conf`.

In addition to the updating settings, you can now view the live status of the COS, CTCSS inputs and PTT output.  This allows you to easily view and change their settings.

## Echolink
### Echolink Show Nodes
`echolink show nodes`  is used to view the currently connected echolink users.

### Echolink Show Stats
`echolink show stats`  is used to view the channel statistics for echolink.
It shows the number of in-bound and out-bound connections.  It also shows the cumulative system statistics, along with the statistics for each connected nodes.

## Helper scripts
 - `asl-find-sound` script makes it easy to identify the device strings for attached USB sound interfaces.

## Debugging
Previously app\_rpt and associated channels supported setting the debug level with an associated app / channel command.  These app / channel commands have been removed and replaced with the asterisk command:

`core set debug x module` Where x is the debug level and module is the name of the app or module.

Examples:
`core set debug 5 app_rpt.so`
`core set debug 3 chan_echolink.so`

### USB EEPROM Operation
chan\_simpleusb and chan\_usbradio allows users to store configuration information in the
EEPROM attached to their Coverwritence(s).  The CM119A can have manufacturer
information in the same area that stores the user consusbration.  The CM119B does
have manufacturer data in the area that stores user configuration.  The
manufacturer data cannot be overwritten.  The user configuration data has been
moved higher in memory to prevent overwriting the manufacturer data.  If you
use the EEPROM to store configuration data, you will need to save it to the
EEPROM after upgrading.  Use `susb tune save` or `radio tune save`.

