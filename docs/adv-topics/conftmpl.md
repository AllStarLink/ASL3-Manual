# Asterisk Templates

Asterisk now has a template configuration option. This can make editing Asterisk conf flies less tedious. So far, ASL3 is using templated configurations in the "rpt.conf", "simpleusb.conf", and "usbradio.conf" files.

## /etc/asterisk/rpt.conf

The "rpt.conf" file remains basically the same as it was in ASL2.  But, the organization has changed to make it easier to maintain, particularly for multi-node systems.

The template for a node in rpt.conf is named "[node-main]".  Every node tagged with "(node-main)" inherits all the template settings.  Template settings are overwritten by nodes with "(main-node)" attached.

As you will see, adding a new node requires the addition of just a few lines.  For example adding three nodes to your system may need nothing more than:

```text
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

## /etc/asterisk/simpleusb.conf, /etc/asterisk/usbradio.conf

The "/etc/asterisk/simpleusb.conf" and "/etc/asterisk/usbradio.conf" files have also adopted a templated configuration.  Again, the template for a node is named "[node-main]".  Every node tagged with "(node-main)" inherits all the template settings.  Template settings are overwritten by nodes with "(main-node)" attached.

## ASL menu support

The new ASL3 menu is fully aware of the templated configuration and handles adding, updating, and removing nodes.
