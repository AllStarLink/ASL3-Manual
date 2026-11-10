# Asterisk Templates
ASL3 now uses templates for configuration files. This can make editing Asterisk config files less tedious. So far, ASL3 is using templated configurations in the `rpt.conf`, `simpleusb.conf`, `usbradio.conf`, and `gps.conf` files.

## `/etc/asterisk/rpt.conf`

The `rpt.conf` file remains basically the same as it was in ASL2. However, the organization has changed to make it easier to maintain, particularly for multi-node systems.

The template for a node in `rpt.conf` is named `[node-main]`, it contains all the "default" settings for all nodes on your system. Every node tagged with `(node-main)` inherits all the template settings. Settings changed in the node-specific stanza will override the same settings in the `[node-main]` template.

As you will see, adding a new node requires the addition of just a few lines.  For example, adding three nodes to your system may need nothing more than:

```
[node-main](!)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Template for all your nodes ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set the defaults for your node(s) here.
; Add your nodes below the line that says
; Add you nodes below.

...

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;; Configure your nodes here ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Note: there is no need to duplicate entire settings. Only
;       place settings that are different than the template.
;
[1999](node-main)
rxchannel = SimpleUSB/1999
idrecording = |iWB6NIL
startup_macro = *32000

[1998](node-main)
;this node would use the ID in the template
rxchannel = Radio/1998
morse = morse_1998

[1997](node-main)
;This might be a hub node if "rxchannel = dahdi/pseudo" is in the template
```

In the above example, node 1997 will use all the settings configured in the `[node-main]` template. 

Node 1998 would use all the settings in the `[node-main]` template, but it would change the channel driver to `rxchannel = Radio/1998`, and that node will use a custom morse stanza, defined by `morse = morse_1998`. 

Node 1999 would use all the settings in the `[node-main]` template, but it would change the channel driver to `rxchannel = SimpleUSB/1999`, change the normal ID to `idrecording = |iWB6NIL`, and set the startup macro to `startup_macro = *32000`.

## `/etc/asterisk/simpleusb.conf` and `/etc/asterisk/usbradio.conf`

The `/etc/asterisk/simpleusb.conf` and `/etc/asterisk/usbradio.conf` files have also adopted a templated configuration. Again, the template for a node is named `[node-main]`. Every node tagged with `(node-main)` inherits all the template settings. Settings changed in the node-specific stanza will override the same settings in the `[node-main]` template.

## `/etc/asterisk/gps.conf`
The `/etc/asterisk/gps.conf` file has also adopted a templated configuration. The template for a node is named `[general]`. Every node tagged with `(general)` inherits all the template settings. Template settings are overwritten by nodes with `(general)` attached.

## ASL Menu Support
The new [`asl-menu`](../user-guide/menu.md) is fully aware of the templated configuration and handles adding, updating, and removing nodes.
