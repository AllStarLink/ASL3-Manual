# ASL3 Menu

Once you have installed ASL3 on your system you will want to configure your node.
The ASL3 menu will help you get started with many common configurations including nodes with USB audio interfaces and "hub" nodes.
The ASL3 menu will also help you maintain your system.

Your system may have been setup to automatically start the ASL3 menu as soon as you have logged in.
If not, you can access the ASL3 menu by executing the following command from the Linux shell :

```bash
asl-menu
```

Note: if you are not logged in as the "root" user you will need to use

```bash
sudo asl-menu
```

When the ASL3 menu is running you will be presented with options to configure a node, access the Asterisk CLI, backup (or restore) your ASL settings, access the Linux CLI, perform some basic diagnostics, and perform some common system actions.

## Node settings

For new installs you will want to select the ASL3 "Node Settings" menu option.
This is where you will configure the basic settings needed to get your new node on the air.
You can return to this menu later to review and/or update your node settings.

The "Node Settings" menu allows you update key node settings including :

- Node number
- Node password
- Node Callsign/ID
- Radio interface (e.g. USB sound device, HUB node)
- Duplex type (e.g. full duplex, half duplex, telemetry)
- USB Interface tuning
- Enable/disable status posting (to [http://stats.allstarlink.org](http://stats.allstarlink.org))

The "Node Settings" menu also allows you to add (or remove) additional nodes.

Note: you can also use the `node-setup` command to access this menu.

## Asterisk CLI

The Asterisk CLI provides direct access to the heart of what makes an AllStar node.
You might use the CLI for testing, troubleshooting, or for controlling your node.
You should know that many of the commands require a more in-depth knowledge of Asterisk.
The good news is that many of the commonly used commands can be executed from the "Diagnostics Menu" or with one of the web management/monitoring applications (e.g. Allmon3).

## Backup and Restore

The ASL3 "Backup and Restore" menu option provides a simple option to backup (and restore) your AllStar and Asterisk configuration.
The backup archives are stored locally on your system and optionally in the cloud.

We encourage you to "backup" your configuration, especially before and after you make changes.

Note: you can also use the `asl-backup-menu` command to access this menu.

## Diagnostics

The ASL3 "Diagnostics" menu option allows you to perform some simple/rudimentary checks of your system and node.
These include basic internet connectivity checks and reporting of your AllStar registrations.
We also provide a way to stop, start, and restart some of the AllStar and Asterisk services that run on your system.

Note: you should know that these diagnostics are not exhaustive.  With a good connection to the internet and a valid configuration all "should be" OK.
If the provided diagnostics don't flag an issue then you will need to dig deeper.
Be aware of changes you make to your system and configuration.
Be aware of software packages that you install.
Be aware of "upgrades".
If you need help, reach out to the AllStarLink Community.

## Expert Configuration

The ASL3 "Expert Configuration Menu" option will allow you to make changes to some of the AllStar and Asterisk configuration files (in the "/etc/asterisk" directory).
But, don't worry about that advanced stuff just yet.

## Bash shell

The "bash" shell provides access to the Linux command line interface, also known as the Linux CLI. This is for experts or if you have been provided with CLI instructions.
