# ASL3 New Commands

New and different ASL3 commands are mentioned here. Older ASL commands are still documented on the  [AllStarLink Wiki](https://wiki.allstarlink.org)


## app_rpt
 - `rpt show channels <node>`
 - `rpt show registrations` is the new http registration. `iax2 show registration` still exists but http registration should be used in its place.
 - `rpt show variables <node>` replaces `rpt showvars`
 - `rpt show version`

## USB
 - `susb show settings` replaces `susb tune`
 - `radio show settings` replaces `radio tune`


## Simple and Radio Tune Menus
The utility programs `radio-tune-menu` and `simpleusb-tune-menu` have been updated with new options. The new options allow you change the operation of the respective channel driver, in realtime, without having to manually edit the `usbradio.conf` or `simpleusb.conf`.

In addition to the updating settings, you can now view the live status of the COS, CTCSS inputs and PTT output.  This allows you to easily view and change their settings.

## Echolink
 - `echolink show nodes`
 - `echolink show stats`


## Helper scripts
 - `asl-find-sound` script makes it easy to identify the device strings for attached USB sound interfaces.

## Debugging

Previously app\_rpt and associated channels supported setting the debug level with an associated app / channel command.  These app / channel commands have been removed and replaced with the asterisk command:

`core set debug x module` Where x is the debug level and module is the name of the app or module.

Examples:
`core set debug 5 app_rpt.so`
`core set debug 3 chan_echolink.so`



