# Echolink Configuration
In addition to connecting to the AllStarLink network, ASL3 also has the capability to register as a node on the [EchoLink](https://echolink.org) network. Review the information on their page to find out how to get started with creating a node on their network.

## Connecting to EchoLink
From an `Asterisk/app_rpt` node, EchoLink connections look just like AllStarLink connections, except the EchoLink node numbers have been prefixed with a `3` and padded out to 7 digits with leading zeroes. For instance, if you want to connect to EchoLink node `1234` on your AllStarLink system you would dial `*3` followed by `3001234`. If you have a 6 digit EchoLink node number link `123456`, you would dial `*3` followed by `3123456`. As you can see, we have reserved AllStarLink node numbers with a leading 3 for the EchoLink number space.

For users originating from an EchoLink node using EchoLink supplied software, nothing changes for them, they just dial the 4 or 6 digit EchoLink node number assigned to your AllStarLink system and they get connected!

## Configuring AllStarLink for EchoLink
There are some steps required in order to configure your AllStarLink node to connect to the EchoLink network. Please ensure you have followed all the steps below.

### Enable the EchoLink Channel Driver
By default, the EchoLink channel driver, `chan_echolink` is not loaded in Asterisk. You will need to edit `/etc/asterisk/modules.conf` and change the `noload` to `load` for `chan_echolink.so`:

```
noload  = chan_echolink.so          ; Echolink Channel Driver disabled
```

becomes:

```
load  = chan_echolink.so            ; Echolink Channel Driver enabled
```

Once you have enabled the module, you will need to restart Asterisk with `sudo systemctl restart asterisk`. You may want to do this after you finish editing the rest of the configuration files, to avoid un-necessary errors while your configuration is incomplete.

### Router and Firewall Configuration
If you are behind a NAT router, please make sure the ports for EchoLink are correctly forwarded to your AllStarLink node. The required ports are:

```
5198/UDP                            ; rtp audio port
5199/UDP                            ; rtcp (control) data port
5200/TCP                            ; directory server port
```

Additionally, if you are running a firewall on your node, be sure to allow those same ports. If you are using the [ASL3 Appliance](../install/pi-appliance/index.md), you will need to add these ports to the [Cockpit Firewall](../pi/cockpit-firewall.md). 

Current documentation on what ports need to be forwarded can be found at [https://echolink.org/firewall-friendly.htm](https://echolink.org/firewall-friendly.htm).

### Configure echolink.conf
To activate the EchoLink channel driver, all that's required is a properly formatted configuration file. A base configuration file has been included with ASL3, and is located at `/etc/asterisk/echolink.conf`.

The important settings to configure are as follows:

```
[el0]
call = INVALID						; Change this!
pwd = INVALID						; Change this!
name = YOUR NAME					; Change this!
qth = INVALID						; Change this!
email = INVALID						; Change this!
node = 000000                       ; Change this!
; Data for EchoLink Status Page
lat = 0.0							; Latitude in decimal degrees
lon = 0.0							; Longitude in decimal degrees
freq = 0.0                          ; not mandatory Frequency in MHz
tone = 0.0                          ; not mandatory CTCSS Tone (0 for none)
power = 0							; 0=0W, 1=1W, 2=4W, 3=9W, 4=16W, 5=25W, 6=36W, 7=49W, 8=64W, 9=81W (Power in Watts)
height = 0							; 0=10 1=20 2=40 3=80 4=160 5=320 6=640 7=1280 8=2560 9=5120 (AMSL in Feet)
gain = 0							; Gain in db (0-9)
dir = 0								; 0=omni 1=45deg 2=90deg 3=135deg 4=180deg 5=225deg 6=270deg 7=315deg 8=360deg (Direction)

astnode = 1999						; Change this!
```

Use the relevant settings from EchoLink, and your station configuration to configure the options above. The `astnode=` setting is your AllStarLink node number that is configured on this server (that is where EchoLink connections will be bridged to).

There are other settings in `echolink.conf` that you can adjust as necessary. See the [`echolink.conf`](../config/echolink_conf.md) page for more information.

### Completing Setup
Once you have configured your [`echolink.conf`](../config/echolink_conf.md), don't forget to restart Asterisk with `sudo systemctl restart Asterisk` to effect the changes. Within a few minutes, the node should show up on [https://echolink.org/logins.jsp](https://echolink.org/logins.jsp).

## Aditional rpt.conf Configuration Options
There are additional configuration options in [`rpt.conf`](../config/rpt_conf.md) that customize how your EchoLink node interacts with your AllStarLink node. These options are:

* [`eannmode=`](../config/rpt_conf.md#eannmode)
* [`echolinkdefault=`](../config/rpt_conf.md#echolinkdefault)
* [`echolinkdynamic=`](../config/rpt_conf.md#echolinkdynamic)
* [`erxgain=`](../config/rpt_conf.md#erxgain)
* [`etxgain=`](../config/rpt_conf.md#etxgain)

See those options for more information on what they adjust.

## Connectivity Issues
When debugging EchoLink connectivity issues with your AllStarLink node, remember the following:

* Never run the EchoLink application from your mobile device (cell phone/tablet/etc.) using the ***same network*** as your AllStarLink node. This will lead to problems with one or the other not being able to connect to/register/use the EchoLink servers or other EchoLink nodes. This also applies to running the Windows application on the ***same network*** as your AllStarLink node.

* If using the EchoLink application on your mobile device (cell phone/tablet/etc.), make sure that the EchoLink application is **not set to run/is not running in the background**. Having the application running in the background can cause problems with your AllStarLink node not being able to connect to/register/use the EchoLink servers or other EchoLink nodes.

!!! note "Same Network"
    Same network refers to the the public IP address that both your AllStarLink node **AND** the device running the EchoLink application are using, even if they are on different subnets internally. The public IP is what the EchoLink server/network sees and uses when communicating with your node/device.

## Caveats
The `chan_echolink` driver currently:

* Does not process chat text
* Only recognizes a few remote text commands
* Does not have a busy, deaf or mute feature
* Does not have a banned or private station list. Access controls are rudimentary and on a per station basis
* Does not have an admin list, only local 127.0.0.1 access
* Does not have a customizable welcome text message
* Does not support login or connect timeouts
* Does not have a max TX time limit
* Does not support activity reporting
* Does not have event notifications
* Does not have any stats
* Does not have any callsign prefix restrictions
* Does not have any loop detection
* Allows "doubles" (newer version of the software are preventing this. Work in progress)

## Debugging
The `chan_echolink` channel driver supports debugging output. With debugging turned on, `chan_echolink` will output various messages to the terminal related to connecting to nodes, etc.

See the [Debug Level](../user-guide/menu.md#debug-level) page for information on how to turn on debugging for the `chan_echolink` driver.

## Remote Commands
The following remote text commands can be sent to the `chan_echolink` driver running on your AllStarLink node using `netcat`:

Command|Function
-------|--------
`o.conip <IPaddress>`|Request a connect
`o.dconip <IPaddress>`|Request a disconnect
`o.rec`|Turn on/off recording

!!! warning "No Documentation"
    These commands are supported in the code, but their actual usage is unknown. If you have specific examples showing how these commands are used, please [file an issue](https://github.com/AllStarLink/ASL3-Manual/issues) to help document it.