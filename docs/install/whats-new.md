# New Things in ASL3

AllStarLink v3 builds on the historical lineage of earlier major versions of the software but has introduced many changes and improvements.

## New Commands

ASL3 is overall very similar to older versions (ASL2). However, due to the upgrade to Asterisk 20+, there are things that have changed. In addition, some new commands are now available.

New and different commands to interact with ASL3 are documented here.

All these commands are available when using the Asterisk Command Line Interface (CLI), also known as the Asterisk Console. This can be accessed through the [`Cockpit`](../pi/cockpit-get-started.md) Terminal, from [`asl-menu`](../user-guide/menu.md), or directly from the Linux terminal with `asterisk -rvvv` or `sudo asterisk -rvvv`, depending on your system configuration.

### `app_rpt` commands

These commands interact with the `app_rpt` application itself:

* `rpt show version` shows the current version of the `app_rpt` module specifically

* `rpt show registrations` shows HTTP registrations. For nodes configured with the old IAX registration system the equivalent command would be `iax2 show registry`.

* `rpt lookup <node>` can be used to lookup the IP address and IAX port of a node. Depending on how your node has been configured (in `rpt.conf`) the lookup will use the AllStarLink DNS servers to resolve the node information or the external `rpt_extnodes` file.

* `rpt show channels <node>` shows the channel driver information associated with the node

* `rpt show variables <node>` (replaces `rpt showvars`) shows the current value of all the `app_rpt` variables for the node

For example, `rpt lookup 2000` will show the IP of node 2000. If you have the `bind9-host` package installed on your system, the equivalent Linux CLI command to query the IP would be `host 2000.nodes.allstarlink.org`.

The node lookup routines will output debug information showing the node lookups, if the [`debug`](../user-guide/menu.md#asterisk-cli-verbosity-and-debug) level is set to `4` or higher.

The operation of this ASL3 feature can be controlled by changing the following information in `rpt.conf`:

```ini
[general]
node_lookup_method = both   ;method used to lookup nodes
                            ;both = dns lookup first, followed by external file (default)
                            ;dns = dns lookup only
                            ;file = external file lookup only
```

### chan_simpleusb commands

The `susb show settings` command is used to interact with the `SimpleUSB` channel driver, and will show the current node's settings. This replaces `susb tune`. The module must be loaded for this command to work.

### chan_usbradio commands

The `radio show settings` command is used to interact with the `USBRadio` channel driver, and will show the current node's settings. This replaces `radio tune`. The module must be loaded for this command to work.

### SimpleUSB and USBRadio Tune Menus

The `simpleusb-tune-menu` and `radio-tune-menu` utility programs have been updated with new options. These commands are accessed from the Linux CLI (not the Asterisk CLI). The new options allow you change the operation of the respective channel driver, in realtime, without having to manually edit the `simpleusb.conf` or `usbradio.conf` files.

In addition to the updating settings, you can now view the live status of the COS, CTCSS inputs and PTT output. This allows you to easily view and change their settings.

### chan_echolink commands

The Echolink channel driver (module) must be loaded for these commands to work. These commands interact directly with the `chan_echolink` channel driver:

`echolink show nodes`  is used to view the currently connected Echolink users.

`echolink show stats`  is used to view the channel statistics for Echolink. It shows the number of in-bound and out-bound connections. It also shows the cumulative system statistics, along with the statistics for each connected nodes.

### app_gps commands

The `app_gps` module must be loaded for this command to work. This command interacts directly with the `app_gps` application:

`gps show status` is used to view the status of the GPS device. It will show if the GPS is locked on the satellites and the current position. It also shows the default location configured.

The `app_gps` module is used with APRStt and for reporting the position of (mobile) nodes to APRS-IS, in conjunction with an attached GPS.

## Verbosity and Debug Levels

Previously, `app_rpt`, associated applications, and channel drivers supported setting the debug level with a unique command for those modules. These unique commands have been removed in ASL3, and replaced with the stock Asterisk `debug` commands.

See how to set [verbosity and debug levels](../user-guide/menu.md#asterisk-cli-verbosity-and-debug) in the CLI for more information.

Examples:

```ast
core set debug 5 app_rpt
core set debug 3 chan_simpleusb
```

## Helper Scripts

There are some new helper utilities that have been introduced with ASL3. See the
[ASL Commands and Tools](../user-guide/asl-cmds-tools.md) page for further details.

## USB EEPROM Operation

Both `chan_simpleusb` and `chan_usbradio` allow users to store configuration information in the EEPROM attached to their interface (if equipped).

The CM119A can have manufacturer information in the same area that stores the user configuration.

The CM119B does not have manufacturer data in the area that stores user configuration. The manufacturer data cannot be overwritten.

The user configuration data has been moved higher in memory to prevent overwriting manufacturer data.

If you use the EEPROM to store configuration data, you will need to save it to the EEPROM after upgrading to ASL3. Use the `susb tune save` or `radio tune save` Asterisk CLI commands, as applicable to your installation.

## Menu Changes

The ASL3 menu utility ([`asl-menu`](../user-guide/menu.md)) has been updated. Our goal is to provide an easy way for you to configure your node and to minimize the need to edit any configuration files.

At the same time, we have removed most of the "OS" configuration options found in earlier implementations. Historically, ASL has been installed on many OS variants and the OS commands that work on one version do not always work on others. For that reason there are no OS related commands in the ASL3 menu.

See [Menu](../user-guide/menu.md) for details.

## Configuration Changes

The first thing to know about ASL3 configuration is that [`asl-menu`](../user-guide/menu.md) can be used to make and view common changes. Here are the highlights. You may want to read about [Advanced Topics](../adv-topics/index.md) and [New Commands](../install/whats-new.md#new-commands) details later.

* You may edit the `.conf` files without concern of switching between editing and using the menu. The tune menus are removing leading white space from comments (we're hoping to fix this).
* An Asterisk [template](../adv-topics/conftmpl.md) is now used within `rpt.conf`, `simpleusb.conf`, and `usbradio.conf`. Editing is much easier, but it's different than with other versions of AllStar. Node settings are much simpler with only a few lines needed to be added/updated for each node. The ASL3 menu handles the new templated configuration.
* [AllStar registration](../adv-topics/httpreg.md) is now set in `rpt_http_registration.conf`, not in `iax.conf`. [IAX registration](../adv-topics/iaxreg.md) still works but is discouraged. Please do not configure your node for both HTTP and IAX registration. The new Asterisk CLI command to show the registration status of your nodes is `rpt show registrations`.  This command can be performed from the ASL3 menu.
* The USB configuration files now contain the tune settings. There is no tune file for each node as in ASL2. The tune menus and the Asterisk CLI write to the new tune setting locations.
* There is no need to edit or use a script to update the access list, formerly known as the blacklist and whitelist. The settings are different because the access list is now per node rather than for all nodes as in other AllStar versions. It's also much easier to use the ASL3 menu to build the access lists.

## A&P Measurement

Adoption and Performance measurements are to help ASL understand growth and technical aspects of ASL3. No sensitive or private information is collected. For details see [GitHub/AllStarLink/ASL3-Usage](https://github.com/AllStarLink/ASL3-Usage). Reports are available at [repo.allstarlink.org/reports/](https://repo.allstarlink.org/reports/).
