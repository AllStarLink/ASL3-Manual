# Configuration

These configuration details are for experts and the curious who want to dig into the guts of ASL3. For others the ASL3 Menu is most likely all you'll need to set up a fully functional Allstar node.

## RPT Conf

<hr>

rpt.conf remains basically the same as it was in ASL2. The organization has changed to make it easier to maintain particularly for multi-node systems. The new asl3-menu handle this for you.  But as you can see, adding a new node only takes adding few lines. For example adding nodes to your system may need nothing more than:

<pre>
[1999](node-main)
rxchannel = SimpleUSB/1999
idrecording = |iWB6NIL
startup_macro = *32000

[1998](node-main)
;this node would use the ID in the template
rxchannel = SimpleUSB/1998
morse = morse_1998

[1997](node-main)
;This might be a hub node if the rxchannel = dahdi/pseudo in the template
</pre>

This feature comes from a newer Asterisk feature called a template, the template name in rpt.conf is called [node-main]. Every node with (node-main) inherits all the template settings. Template settings are overwritten by nodes within (main-node) attached.


## USB

<hr>

Setting up USB is much easier with ASL3.

 - USB tune settings have been moved into their respective conf file; simpleusb.conf and usbradio.conf. The seprate tune files (ie simple-tune-usb1999.conf) no longer exist.
 - The device string is automatically found when the USB setting `devstr =` is empty.
 - A new script `asl-find-sound` shows the device strings.

The ASL3 menu handles these change as do the the Asterisk CLI USB config commands.


## Echolink

<hr>

## HTTP Registration

<hr>

For ASL3 we have built an new HTTP registration module. The ASL IAX module has been replaced with the current Asterisk version of IAX2 for upstream compatibility.

ASL3 menu users need not be concerned about this change. The asl3-menu makes the settings for you. For the curious and hackers out there the conf new file is `rpt_http_registrations.conf`. The settings are the same a IAX2 registration. While IAX registration still works, please do not register with both HTTP and IAX. That would cause unnecessary server load for no gain. The long term plan is to do away with IAX registration. HTTP allows load balancing and advantages that IAX can't.

ASL has used HTTP registration since one of the early ASL2 betas. Back in the day when there were only 2,000 or so Allstar registered nodes Rob Vella wrote a new open source registration server in nodejs which handled both IAX and HTTP registration. At that same time Adam Paul hacked IAX2 to register with HTTP and fall back to IAX as necessary. The ASL servers are still using Rob's nodejs registration server.


## Allowlist and denylist
(previously known as whitleist and blacklist)

<hr>

This allows node admins to allow or deny connections from selected node numbers. New to ASL3 is the capability for nodes on the same server have different lists. Unlike ASL2 no modifications or scripts are required to change config files and there is no need to restart or reload. All changes are made to the asterisk database. As soon as you make a change it takes effect.

Here we show you how to change and view the lists at the Asterisk CLI should you choose to do so. Of course these changes may be made from the new ASL3 menu.

 - The allowlist allows inbound connects and blocks all others. Nodes on the same server are always allowed. Node on the allowlist ignore the denylist.
   - Add an allowed node at the Asterisk CLI> `database put allowlist/yournode/allownode "Our friend"`
   - Add another node to the allowlist with `database put allowlist/yournode/anothermnode "Our other friend"`
 - The denylist prevents nodes from connecting to your node. Add a Denylist if you only have a few nodes you want to block.
   - Add a denied node at the Asterisk CLI> `database put denylist/yournode/denynode "Not our friend"`
   - Add a another denied node at the Asterisk CLI> `database put denylist/yournode/anothernode "Not our other friend"`
 - To see what's in the database
   - Show entire db CLI> `database show`
   - Show entire allowlist for all your nodes CLI> `database show allowlist`
   - Show entire allowlist for all your one node CLI> `database show allowlist/yournode`
   - Show just the one your one allowed one node CLI> `database show allowlist/yournode/othernode`
 - To delete an entire allowlist
   - At the asterisk CLI> `database del allowlist`
   - To delete all allowed nodes CLI> `database del allowlist/yournode`
