# Configuration

These configuration details are for experts and the curious who want to dig into the guts of ASL3. For others, the ASL3 Menu is most likely all you will need to set up a fully functional Allstar node.


## /etc/asterisk/rpt.conf

<hr>

The "rpt.conf" file remains basically the same as it was in ASL2.  But, the organization has changed to make it easier to maintain, particularly for multi-node systems.  As you will see, adding a new node requires the addition of just a few lines.  For example adding three nodes to your system may need nothing more than:

<pre>
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
</pre>

This feature, available in the newer version of Asterisk, is called a "template".  The template name for a node in "rpt.conf" is called "[node-main]".  Every node tagged with "(node-main)" inherits all the template settings.  Template settings are overwritten by nodes with "(main-node)" attached.

The new ASL3 menu is fully aware of the templated configuration and handles adding, updating, and removing nodes.


## USB audio interfaces

<hr>

Setting up USB audio interfaces is much easier with ASL3.

 - The USB audio interface "tune" settings have been moved into their respective configuration files; "simpleusb.conf" and "usbradio.conf". The separate tune files (e.g. "simple-tune-usb1999.conf") no longer exist.
 - The device string is automatically found when the USB setting `devstr =` is empty.
 - rxchannel=SimpleUSB/USB1999 has been changed to rxchannel=SimpleUSB/1999. Same for rxchannel=Radio/1999 for consistency with other rxchannel= settings.
 - A new `asl-find-sound` script can be used to help identify the device strings for attached interfaces.

The ASL3 menu and Asterisk CLI USB config commands handle these changes.


## HTTP Registration

<hr>

For ASL3, we have built an new HTTP registration module. The ASL IAX module has been replaced with the current Asterisk version of IAX2 for upstream compatibility.

ASL3 menu users need not be concerned about this change. The asl3-menu makes the settings for you. For the curious and hackers out there the conf new file is `rpt_http_registrations.conf`. The settings are the same for IAX2 registration. While IAX registration still works, please do not register with both HTTP and IAX. That would result in unnecessary server load for no gain. The long term plan is to do away with IAX registration. HTTP registration also allows load balancing and other advantages not available with IAX.

ASL has used HTTP registration since the early ASL2 betas. Back in the day when there were only 2,000 or so Allstar registered nodes Rob Vella wrote a new open source registration server in Node.js which handled both IAX and HTTP registration. At that same time Adam Paul hacked IAX2 to register with HTTP and fall back to IAX as necessary. The ASL servers are still using Rob's Node.js registration server.


## allowlist and denylist
(previously referred to as whitelist and blacklist)

<hr>

Sometimes a node admin needs to allow or deny connections from specific node numbers.  ASL3 provides a way to establish either an "allowlist" or "denylist" to limit access to your ndoe(s).  New to ASL3 is the capability for nodes on the same server to have different lists.  Unlike ASL2, no modifications or scripts are required to the configuration files and there is no need to restart or reload the server.  All changes are made to the Asterisk database.  As soon as you make a change it takes effect.

Here we show you how to change and view the lists at the Asterisk CLI should you choose to do so. Of course these changes can easily be made from the ASL3 menu.

 - The "allowlist" allows inbound connects and blocks all others. Nodes on the same server are always allowed. If any nodes are on the "allowlist" then the "denylist" is ignored.

   - Add an allowed node at the Asterisk CLI> `database put allowlist/yournode/allownode "Our friend"`
   - Add another node to the "allowlist" with `database put allowlist/yournode/anothernode "Our other friend"`

 - The "denylist" prevents nodes from connecting to your node. Add a "denylist" if you only have a few nodes you want to block.
   - Add a denied node at the Asterisk CLI> `database put denylist/yournode/denynode "Not our friend"`
   - Add a another denied node at the Asterisk CLI> `database put denylist/yournode/anothernode "Not our other friend"`
 - To see what's in the database
   - Show entire db CLI> `database show`
   - Show entire "allowlist" for all your nodes CLI> `database show allowlist`
   - Show entire "allowlist" for all your one node CLI> `database show allowlist/yournode`
   - Show just the one your one allowed one node CLI> `database show allowlist/yournode/othernode`
 - To delete an entire "allowlist"
   - At the asterisk CLI> `database del allowlist`
   - To delete all allowed nodes CLI> `database del allowlist/yournode`


## Echolink

<hr>

Add more info here
