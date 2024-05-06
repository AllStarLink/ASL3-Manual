# Asterisk Templates 

The app_rpt configuration file now optionally makes use of asterisk templates.  This is a new concept for app_rpt users.

You will see the following in rpt.conf:

```
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Template for all your nodes ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set the defaults for your node(s) here. Add your nodes
; below the line that says Add you nodes here.
[node-main](!)
```

`[node-main](!)` is the template for all of your nodes associated with this install.  These are base settings that can be used for every node.  You can think of them as the defaults.

Further down in rpt.conf, you will find this section:
```
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;; Add your nodes here ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; No need to duplicate entire settings. Only place settings different than template.

;;;;;;;;;;;;;;;;;;; Your node settings here ;;;;;;;;;;;;;;;;;;;

[1999](node-main)
rxchannel = Radio/usb_1999       ; USBRadio (DSP)
;startup_macro = *8132000
```

`[1999](node-main)` defines your node.  `[1999]` should be changed to your node number.  `(node-main)` tells asterisk to use the template stanza `[node-main](!)` as the default settings.

Entries that are added below `[1999](node-main)` override or add to the default settings.  You will notice that `rxchannel = Radio/usb_1999` was added here to override the default found in the template.  The same goes for startup_macro. If uncommented, it overrides the default in the template.

### Rpt.conf Edits
The rpt.conf file is documented with comments to help you make changes.  Please review the comments in the file as you make edits to setup your node.

After you have completed these changes, enter the command:

```
systemctl restart asterisk
```
The node should now come alive and register with the AllStarLink servers.

If you are using usbradio or simpleusb, you will have to edit usbradio.conf or simpleusb.conf and change the `[usb_??????]` section to match your node number.

Since asl-menu is not available in the Alpha release, you will have to use one of the following commands to tune the radio adapter.

`/usr/lib/asterisk/radio-tune-menu`
Or
`/usr/lib/asterisk/simpleusb-tune-menu`
