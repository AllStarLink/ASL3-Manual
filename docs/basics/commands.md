# New Commands
ASL3 is overall very similar to older versions (ASL2). However, due to the upgrade to Asterisk 20 (and newer), there are things that have changed. In addition, some new commands are now available.

New and different commands to interact with ASL3 are documented here. Older ASL2 commands are still documented on the [AllStarLink Wiki](https://wiki.allstarlink.org), and may still be applicable (with some modifications) to ASL3. The Wiki documentation will remain as a reference, until all the documentation can be updated for ASL3, and added to this manual. 

All these commands are available when using the Asterisk Command Line Interface (CLI), also known as the Asterisk Console. This can be accessed through the [`Cockpit`](../pi/cockpit-get-started.md) Terminal, from [`asl-menu`](../user-guide/index.md), or directly from the Linux terminal with `asterisk -rvvv` or `sudo asterisk -rvvv`, depending on your system configuration. 

## `app_rpt` commands
These commands interact with the `app_rpt` application itself:

* `rpt show channels <node>` shows the channel driver information associated with the node

* `rpt show variables <node>` (replaces `rpt showvars`) shows the current value of all the `app_rpt` variables for the node

* `rpt show version` shows the current version of the `app_rpt` module specifically

* `rpt show registrations` is the new command to show HTTP registrations. ASL3 uses a new HTTP registration system. The old IAX registration system and `iax2 show registry` command still exist, but HTTP registration should be used in its place.

* `rpt lookup <node>` can be used to lookup the IP address of a node. In addition to the new registration system, ASL3 now implements a DNS lookup of node information.	By default, ASL3 will first query the AllStarLink DNS servers to resolve node information. It will fall back to the external `rpt_extnodes` file, if the node cannot be resolved by DNS.

For example, `rpt lookup 2000` will show the IP of node 2000. If you have the `bind9-host` package installed on your system, the equivalent Linux CLI command to query the IP would be `host 2000.nodes.allstarlink.org`.

The node lookup routines will output debug information showing the node lookups, if the [`debug`](../user-guide/menu.md#asterisk-cli-verbosity-and-debug) level is set to `4` or higher.

The operation of this ASL3 feature can be controlled by changing the following information in `rpt.conf`:

```
[general]
node_lookup_method = both   ;method used to lookup nodes
                            ;both = dns lookup first, followed by external file (default)
                            ;dns = dns lookup only
                            ;file = external file lookup only
```

## chan_simpleusb commands
The command `susb show settings` is used to interact with the `SimpleUSB` channel driver, and will show the current node's settings. This replaces `susb tune`. The module must be loaded for this command to work.

## chan_usbradio commands
The command `radio show settings` is used to interact with the `USBRadio` channel driver, and will show the current node's settings. This replaces `radio tune`. The module must be loaded for this command to work.

## SimpleUSB and USBRadio Tune Menus
The `simpleusb-tune-menu` and `radio-tune-menu` utility programs have been updated with new options. These are accessed from the Linux CLI (not the Asterisk CLI). The new options allow you change the operation of the respective channel driver, in realtime, without having to manually edit the `simpleusb.conf` or `usbradio.conf` files.

In addition to the updating settings, you can now view the live status of the COS, CTCSS inputs and PTT output. This allows you to easily view and change their settings.

## chan_echolink commands
The Echolink channel driver (module) must be loaded for these commands to work. These commands interact directly with the `chan_echolink` channel driver: 

`echolink show nodes`  is used to view the currently connected Echolink users.

`echolink show stats`  is used to view the channel statistics for Echolink. It shows the number of in-bound and out-bound connections. It also shows the cumulative system statistics, along with the statistics for each connected nodes.

## app_gps commands
The `app_gps` module must be loaded for this command to work. This command interacts directly with the `app_gps` application: 

`gps show status` is used to view the status of the GPS device. It will show if the GPS is locked on the satellites and the current position. It also shows the default location configured.

The `app_gps` module is used with APRStt and for reporting the position of (mobile) nodes to APRS-IS, in conjunction with an attached GPS.

## Verbosity and Debug Levels
Previously, `app_rpt`, associated applications, and channel drivers supported setting the debug level with a unique command for those modules. These unique commands have been removed in ASL3, and replaced with the stock Asterisk `debug` commands.

See how to set [verbosity and debug levels](../user-guide/menu.md#asterisk-cli-verbosity-and-debug) in the CLI for more information.

Examples:

```
core set debug 5 app_rpt
core set debug 3 chan_simpleusb
```

## Helper Scripts
There are some new helper utilities that have been introduced with ASL3. See the [ASL Commands and Tools](../user-guide/asl-cmds-tools.md) page for further details.

## USB EEPROM Operation
Both `chan_simpleusb` and `chan_usbradio` allow users to store configuration information in the EEPROM attached to their interface (if equipped). 

The CM119A can have manufacturer information in the same area that stores the user configuration. 

The CM119B does not have manufacturer data in the area that stores user configuration. The manufacturer data cannot be overwritten. 

The user configuration data has been moved higher in memory to prevent overwriting manufacturer data. 

If you use the EEPROM to store configuration data, you will need to save it to the EEPROM after upgrading to ASL3. Use the `susb tune save` or `radio tune save` Asterisk CLI commands, as applicable to your installation.

