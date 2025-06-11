# Accessing ASL3 Menu
Your system may have been setup to automatically start the ASL3 menu as soon as you have logged in. If not, you can access the ASL3 menu by executing the following command from the Linux shell :

```
asl-menu
```

!!! note "May Require sudo"
    If you are not logged in as the "root" user you will need to use:

    ```
    sudo asl-menu
    ```

When the ASL3 menu is running you will be presented with options to configure a node, access the Asterisk CLI, backup (or restore) your ASL settings, access the Linux CLI, perform some basic diagnostics, and perform some common system actions.

## Node Settings
For new installs, you will want to select the ASL3 `Node Settings` menu option. This is where you will configure the basic settings needed to get your new node on the air. You can return to this menu later to review and/or update your node settings.

The `Node Settings` menu allows you update key node settings including :

* Node number
* Node password
* Node Callsign/ID
* Radio interface (e.g. USB sound device, HUB node)
* Duplex type (e.g. full duplex, half duplex, telemetry)
* USB Interface tuning
* Enable/disable status posting (to [http://stats.allstarlink.org](http://stats.allstarlink.org))

The `Node Settings` menu also allows you to add (or remove) additional nodes.

!!! note "Direct CLI Access"
    You can also use the `node-setup` command to access this menu directly from the Linux CLI.

## Asterisk CLI
The Asterisk Command Line Interface (CLI) provides direct access to the heart of what makes an AllStar node.

You might use the CLI for testing, troubleshooting, or for controlling your node. You should know that many of the commands require a more in-depth knowledge of Asterisk. The good news is that many of the commonly used commands can be executed from the `Diagnostics Menu`, or with one of the web management/monitoring applications (e.g. [Allmon3](../allmon3/index.md)).

The Asterisk CLI can be accessed directly via `asl-menu`, from the [`Cockpit` terminal](../pi/cockpit-console.md), or directly off the Linux command line using `asterisk -rvvv` or `sudo asterisk -rvvv`, depending on your configuration.

### Asterisk CLI Verbosity and Debug

#### Verbosity Level
"Verbosity" refers to how "chatty" the Asterisk CLI is. The larger the verbosity level, the more detailed the messages on the console will be. A good verbosity level is typically `3`. It provides a reasonable level of detail as Asterisk is operating.

The verbosity level is set by the number of `v`'s when the command to connect to the CLI is invoked. As shown above, `asterisk -rvvv` would connect to the console with a verbosity level of `3`, due to the `vvv`.

The `asl-menu` option to `Enter the Asterisk CLI` invokes the CLI with a verbosity level of `3`.

You can see the current verbosity level once you are in the Asterisk CLI by using the `core show settings` command.

You can change the current verbosity level once you are in the Asterisk CLI by using the `core set verbose <level>` command.

The Asterisk CLI should be invoked with at least a verbosity level of `1`, otherwise you will see very few messages.

#### Debug Level

"Debug" messages are additional logging messages that developers specifically add to modules, to aid in troubleshooting. Debug messages are distinct from normal (verbosity) messages, and must be enabled separately. 

You can see the current debug level once you are in the Asterisk CLI by using the `core show settings` command. It will default to level `0`, unless specifically changed.

You can change the current debug level once you are in the Asterisk CLI by using the `core set debug <level>` command. Optionally, the debug level can be configured and set for a specific module, by passing the module name in the command. For example, `core set debug 4 app_rpt` would set the debug level to `4` specifically for the `app_rpt` module, instead of the whole system. This could make things easier to read, as all the modules wouldn't be spitting out debug messages, only the `app_rpt` module.

## Backup and Restore
The ASL3 `Backup and Restore` menu option provides a simple option to backup (and restore) your AllStar and Asterisk configuration.

The backup archives are stored locally on your system and optionally in the cloud.

We encourage you to "backup" your configuration, especially before and after you make changes.

**NOTE:** you can also use the `asl-backup-menu` command directly from the Linux CLI to access this menu.

## Diagnostics
The ASL3 `Diagnostics` menu option allows you to perform some simple/rudimentary checks of your system and node.

These diagnostics include basic internet connectivity checks and reporting of your AllStar registrations. We also provide a way to stop, start, and restart some of the AllStar and Asterisk services that run on your system.

**NOTE:** You should know that these diagnostics are not exhaustive. With a good connection to the internet and a valid configuration all "should be" OK.

If the provided diagnostics don't flag an issue then you will need to dig deeper.

* Be aware of changes you make to your system and configuration.
* Be aware of software packages that you install.
* Be aware of "upgrades".

If you need help, reach out to the [AllStarLink Community](https://community.allstarlink.org/).

## Expert Configuration
The ASL3 `Expert Configuration Menu` option will allow you to make changes to some of the AllStar and Asterisk configuration files (in the `/etc/asterisk` directory). But, don't worry about that advanced stuff just yet.

## Bash Shell
The `bash` shell provides access to the Linux command line interface, also known as the Linux CLI. This is for experts or if you have been provided with CLI instructions.
