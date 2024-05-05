# ASL3 User's Guide

This is the AllStarLink version 3 User's Guide. No doubt you're you've noticed this is not a Wiki. The [ASL Wiki](https://wiki.allstarlink.org) still exists while this manual covers ASL3 specifics. Did you see the "Next" and "Previous" menu items? Those will page to the next section of this document. We think you'll find those provide an orderly way to learn about ASL3.

## What's New?

Ready to get on with installation? We thought so, but first consider that ASL3 is very new. You'll probably want to install on removable media or on a non-production system. For those who have used ASL2 or other versions of AllStar you should be aware of a few important details:

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

## Menu Changes

The ASL3 menu has been updated. Our goal is to provide an easy way for you to configure your node and to minimize the need to edit any configuration files.

At the same time, we have removed most of the "OS" configuration options found in earlier implementations. Historically, ASL has been installed on many OS variants and the OS commands that work on one version do not always work on others. For that reason there are no OS related commands in the ASL3 menu.

See [Menu](menu.md) for details.

## Configuration Changes

The first thing to know about ASL3 configuration is that the menu can be used to make and view common changes. Here are the highlights. See [configuration](config.md) and [commands](commands.md) for details.

- You may edit the conf files without concern of switching between editing and using the menu. The tune menus do remove leading white space from comments.
- An Asterisk template is now used within `rpt.conf`.  Editing is much easier but it's different than with other versions of AllStar. Node settings are much simpler with only a few lines needed to be added/updated for each node. The ASL3 menu handles the new templated configuration.
- AllStar registration is now set in `rpt_http_registration.conf`, not in `iax.conf`. IAX registration still works but is discouraged. Please do not configure your node for both HTTP and IAX registration. The new Asterisk CLI command is `rpt show registrations` and cam be performed from the ASL3 menu.
- The USB configuration files now contain the tune settings. There is no tune file for each node as in ASL2. The tune menus and the Asterisk CLI write to the new tune setting locations.
- There is no need to edit or use a script to update the access list, formerly known as the blacklist and whitelist. The settings are different because the access list is now per node rather than for all nodes as in other AllStar versions. It's also much easier to use the ASL3 menu to build the access lists.

## Help and Report Bugs

The [AllStarLink Community](https://community.allstarlink.org/) is the primary support for all versions of ASL including ASL3. Please do not use the help desk for ASL technical help.

Report bugs to [AllStarLink GitHub](https://github.com/AllStarLink). There are numerous ASL3 repos. If you're not sure which repo for reporting bugs, feel free to use Community.