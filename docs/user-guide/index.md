# User's Guide

This is the ASL3 User's Guide. You're reading this so you've noticed it's new. Did you notice the next and previous menu items? We hope you find those a orderly way to learn about ASL3.

No doubt you want to get on with installation. First, here are a few important details:

 - At the risk of being redundant ASL3 now runs on Asterisk 20... we're so proud.
 - There is no update or migration path from ASL2 to ASL3
 - Many of the ASL3 configuration files are different
 - The SimpleUSB and USBRadio tune settings have been moved into their respective (.conf) configuration files.  We no longer have separate per-node tune setting files.
 - EchoLink chat has been enabled
 - EchoLink now honors the app\_rpt timeout timer.  A text message is sent to the client when they time out.
 - EchoLink longer allows clients to double.  A text message is sent to the client when they are doubling.

# ASL3 Menu

The new ASL3 menu will walk you through setting up a basic USB or hub node quickly. Switching between menu and configuration edits is non-destructive.

# ASL3 Commands

New ASL3 go here

# Editing configs

The first thing to know about editing configuration files is that for the most part you don't have to. When editing configurations or using the Asterisk CLI consider:

 - Registration is now set in `rpt_http_registration.conf`, not in `iax.conf`. IAX registration still works but is discouraged. Do not register both HTTP and IAX. The new Asterisk CLI command is `rpt show registrations`.
 - A template is now used in `rpt.conf`. Editing is much easier but it's different than ASL2. Node settings are much simpler with only a few lines needed to be added/updated for each node. The ASL3 menu handles the new templated configuration.
 - The USB configuration files now contain the tune settings. There is no tune file for each node as in ASL2. The tune menus and Asterisk CLI write to the new tune setting locations.
 - There no need to edit or use a script to update the per node access lists, formerly known as the blacklist and whitelist.

 Most of this new stuff is explained with more detail in the ASL3 Configuration page.

# Where to Get Help and Report Bugs

The AllStarLink Community is the primary support for all versions of ASL including ASL3. Please do not use the help desk for ASL technical help. To report bugs use the ASL3 GitHub repo. 
