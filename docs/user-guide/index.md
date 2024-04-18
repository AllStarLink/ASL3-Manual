# User's Guide

This is the ASL3 User's Guide.

You're reading this so you've noticed it's new. Did you notice the "Next" and "Previous" menu items? We hope you find those provide an orderly way to learn about ASL3.

## What's New in ASL3?
<hr>

We have no doubt you want to get on with installation.  For those who have used ASL2 (or other/earlier versions of ASL) you to be aware of a few important details :

- At the risk of repeating ourselves, ASL3 now runs on Asterisk 20!  We are no longer stuck in the past.  We're so proud!!!

- There is no update or migration path from ASL2 to ASL3

- Many of the ASL3 configuration files are different
	- The configuration files now support templates
	- We now favor node registration using HTTP
	- The SimpleUSB and USBRadio tune settings have been moved into their respective (.conf) configuration files.  We no longer have separate per-node tune setting files.

- EchoLink changes
	- EchoLink chat has been enabled
	- EchoLink now honors the app\_rpt timeout timer.  A text message is sent to the client when they time out.
	- EchoLink longer allows clients to double.  A text message is sent to the client when they are doubling.

## ASL3 Menu Changes

The ASL3 menu has been updated.
We are trying to provide a way for you to configure you node and to minimize the need to edit any configuration files.

At the same time, we have removed most of the "OS" configuration options found in earlier implementations.
Historically, ASL has been installed on many OS variants and the commands that work on one version do not always work on others.
For our supported OS's, we will try to provide documentation for some of the commonly requested actions (e.g. changing the hostname, timezone) but we know we won't cover all topics.
Fortunately, there is a lot of information available online for your system.

Please let us know about any changes you have made to your configuration that would benefit others.

## ASL3 Configuration File Changes
<hr>

The first thing to know about editing configuration files is that we hope that the menus can be used to make the changes.  But, if you need to edit the configurations or use the Asterisk CLI you should consider:

- A template is now used in `rpt.conf`.  Editing is much easier but it's different than ASL2. Node settings are much simpler with only a few lines needed to be added/updated for each node. The ASL3 menu handles the new templated configuration.

- ASL registration is now set in `rpt_http_registration.conf`, not in `iax.conf`. IAX registration still works but is discouraged. Please do not configure your node for both HTTP and IAX registration. The new Asterisk CLI command is `rpt show registrations`.

- The USB configuration files now contain the tune settings. There is no tune file for each node as in ASL2. The tune menus and Asterisk CLI write to the new tune setting locations.

- There no need to edit or use a script to update the per node access lists, formerly known as the blacklist and whitelist.

Most of this new stuff is explained with more detail in the ASL3 Configuration page.

# Where to Get Help and Report Bugs
<hr>

The AllStarLink Community is the primary support for all versions of ASL including ASL3. Please do not use the help desk for ASL technical help. To report bugs use the ASL3 GitHub repo. 
