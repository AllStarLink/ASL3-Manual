# User's Guide

This is the ASL3 User's Guide. You're reading this so you've noticed it's new. Did you notice the next and previous menu items? We hope you find those a orderly way to learn about ASL3.

No doubt you want to get on with installation. First, here are a few important details.

 - At the risk of being redundant ASL3 now runs on Asterisk 20... we're so proud.
 - There is no update or migration path from ASL2 to ASL3
 - Many ASL3 conf files are different
 - EchoLink chat has been enabled
 - EchoLink honors the app\_rpt timeout timer.  A text message is sent to the client when they time out.
 - EchoLink longer allows clients to double.  A text message is sent to the client when they are doubling.
 - USBradio and simpleUSB tune settings have been moved into there respective conf file. No longer septate per node tune setting files.



# ASL3 Menu

The new ASL3 menu will walk you through setting up a basic USB or hub node quickly. Switching between menu and config edits is non-destructive.

# ASL3 Commands

New ASL3 go here

# Editing configs

The first thing to know about editing conf files is that for the most part you don't have to. When editing configs or using the Asterisk CLI consider:

 - Registration is now set in `rpt_http_registration.conf` not in `iax.conf`. IAX registration still works but is discouraged. Don't register both http and IAX. The new CLI command is`rpt show registrations`.
 - A template is now used in `rpt.conf`. Editing is much easier but it's different than ASL2. Node settings are much simpler requiring only a few added lines per node. The ASL3 menu handles the templated config.
 - The USB configuration files now contain the tune settings. There is no tune file for each node as in ASL2. The tune menus and Asterisk CLI write to the new tune setting locations.
 - There no need to edit or use a script to update the per node access lists, formerly known as the blacklist and whitelist.

 Most of this new stuff is explained with more detail in the ASL3 Configuration page.

