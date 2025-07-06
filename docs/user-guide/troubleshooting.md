# Basic Troubleshooting Tips
When asking for help on [AllStarLink Community](https://community.allstarlink.org) or in a [GitHub](https://github.com/AllStarLink) Issue here are some tips on how to ask for help and how to get common troubleshooting information that is often needed to understand your specific issues.

## Connectivity Troubleshooting
Here is how to do some basic troubleshooting to see if your node is registered and reporting to the AllStarLink Network:

* Go to [https://www.allstarlink.org/nodelist](https://www.allstarlink.org/nodelist), put your node number in the Filter box and see if the system knows about your node. If it is registered, the background behind your node number should be green.

* If you have the [`rpt_extnodes`](../adv-topics/noderesolution.md#external-node-directory-file) file enabled, check to see if the timestamp on the file is current:

```
asl@wb6nil:~ $ tail /var/lib/asterisk/rpt_extnodes
657890=radio@75.183.136.24:4569/657890,75.183.136.24
658030=radio@49.199.83.84:4569/658030,49.199.83.84
658451=radio@38.92.58.92:4569/658451,38.92.58.92
658500=radio@99.48.37.185:4560/658500,99.48.37.185


;Generated 10904 records in 0.198 seconds.
;Generated at 2025-07-06 21:43:59 UTC by f0537a4b8c66
;SHA1=c91286ce0

```

* Make sure there no other devices on your LAN using the IAX port (typically configured for `4569`)

* If you are behind a NAT firewall/router, make sure you have opened port `4569/UDP`, and directed it to the correct LAN IP address of your AllStarLink node

* Make sure that the IAX port configured in your Server Settings of your [AllStarLink Portal](https://www.allstarlink.org/portal) account matches the port opened in your firewall 

* Make sure that `bindport=4569` is set in [`iax.conf`](../config/iax_conf.md#bindport-and-bindaddr), it should be unless you've changed it (perhaps if you are running [Multiple Node on the Same Network](../adv-topics/multinodesnetwork.md))

* If you are running [Multiple Node on the Same Network](../adv-topics/multinodesnetwork.md), pay particular attention to:
    * Your firewall/NAT rules in the router on your LAN
    * Your firewall rules in [Cockpit](../pi/cockpit-firewall.md), if applicable
    * Your Server Settings (IAX Port) in the AllStarLink Portal
    * Your `bindport=` setting in `iax.conf`

* Check that the `NODE = xxxxx` setting in [`extensions.conf`](../config/extensions_conf.md#globals-stanza) has the correct node number

* Check that the `[nodes]` section in [`rpt.conf`](../config/rpt_conf.md#nodes-stanza) is correct, ie. `63001 = radio@127.0.0.1:xxxx/63001,NONE`. The port, `:xxxx` is only needed if not the default port of `4569`

* If you have a friend with an AllStarLink node, have them do a lookup from the [Asterisk CLI](./menu.md#asterisk-cli) and confirm that the IP address returned is your **public** IP address, and that the IAX port is what is expected: 

```
wb6nil*CLI> rpt lookup 2001
Node: 63001     Data: radio@3.147.238.208:4569/2001,3.147.238.208
```

## AllStarLink Registration Fails When Behind a NAT Router
Some NAT routers do not honor source port preservation. Registration (by default) requires that the source port be preserved. The URL [https://register.allstarlink.org](https://register.allstarlink.org) expects the source port to be 4569 by default. With some NAT routers, source port preservation is not guaranteed. For example, the D-Link DI series is one such router which does not preserve source port numbers and there is a 100% chance that when the registration packet exits your router, it will use a different (high 60,000 range) port number.

Solution: try a different NAT router

## Breaking the Keying Loop Between Two Simplex Nodes
Back and forth keying (aka "Ping Ponging" or "Relay Racing") can occur when two simplex nodes are linked together. This is caused by COR or squelch noise glitches from certain types of radios. To fix,the COR must be ignored for a small amount of time after a simplex node releases PTT. To accommodate this, edit `usbradio.conf` and add the following statement in the `[usb]` stanza, or other port-specific stanza:

```
rxondelay=25
```

This will instruct the `usbradio` driver to ignore the COR line for a specified number of 20mSec intervals following the release of PTT.

## Cannot Receive Connections From or Make Connections to Other AllStarLink Nodes

Hint|Thing(s) to Try
----|---------------
Is Asterisk Running?|Type `asterisk -r` at the [`Linux CLI`](./menu.md#bash-shell), and see if you can access the [`Asterisk CLI`](./menu.md#asterisk-cli). If you can access the `Asterisk CLI`, then watch the console output while trying to connect and note what happens. If there is no output, proceed to the next thing to try. If there is output, note what errors or warnings you see on the console and ask a question about them on in the [AllStarLink Community](https://community.allstarlink.org). Please note that the error message: ***`WARNING[5765]: file.c:xxxx waitstream_core: Unexpected control subclass '13'`*** is an expected warning
Network issues?|Try issuing a `ping` command from the [`Linux CLI`](./menu.md#bash-shell) to something on your local network. If that works, try pinging `www.allstarlink.org`. If you get an error that `www.allstarlink.org` can't be found, check your DNS server settings in `/etc/resolv.conf` to see if they are correct. If they are incorrect, correct them, save the file, and reboot
Connectivity issues?|Check the [Connectivity Troubleshooting](#connectivity-troubleshooting) above

## Cannot Receive Incoming Connections From Other AllStarLink Nodes

Hint|Thing(s) to Try
----|---------------
Do you have the correct port forwarding settings configured in your firewall?|AllStarLink requires that UDP traffic on port `4569` be forwarded from the public (WAN) IP address to the private (LAN) IP address running your AllStarLink server. Please check the settings in your router using its instruction manual to make sure port `4569/UDP` is set up to be forwarded to the correct internal (private) IP address. If the port forwarding settings are correct in your router, please send a message to the [helpdesk@allstarlink.org](mailto:helpdesk@allstarlink.org) with your node number and router make and model, requesting help. A **small** number of NAT routers require that we force the port setting to port `4569` on the registration server. This is a manual process and requires intervention from one of the system administrators.

## VOTER/RTCM Choppy Audio
The VOTER protocol is UDP which of course means packets can be dropped causing holes in the audio. Here are a couple of things to look for if the audio is choppy.

### Network Problems
The server (via `chan_voter`) sends a keep-alive packet to the VOTER/RTCM once per second. Likewise, the VOTER/RTCM sends a keep-alive packet to `chan_voter` once per second. Timeouts will occur if excessive packets are dropped.

* Start the [`Asterisk CLI`](./menu.md#asterisk-cli) with verbosity set to `3` (`sudo asterisk -rvvv`) and watch for disconnect messages.  `-- Voter client nameOfClient disconnect (timeout)`. This means that `chan_voter` has missed 3 keep-alive packets in a row, or said another way, 3 seconds has passed since the last keep-alive was received.

* If the `VOTER/RTCM` off-line failover message is heard over the air (perhaps quickly followed by the online message), the VOTER/RTCM has missed 6 keep-alive packets in a row. In other words, 6 seconds has passed since the last keep-alive was received.

Either of these indicate a network problem that can ***not*** be compensated for with VOTER/RTCM or [`voter.conf`](../config/voter_conf.md) settings. The problem must be fixed using traditional network troubleshooting techniques, ie. `traceroute` and `ping`. Try running a `ping` with a count of 100 or more to ensure there is no packet loss.

### Buffer Size
[`Voter ping`](../voter/voter-buffers.md#voter-ping-usage) is useful for end-to-end network evaluation when ICMP ping is turned off and/or the VOTER/RTCM is behind a firewall and is not ICMP reachable. It can help with finding the correct VOTER/RTCM and [`voter.conf`](../config/voter_conf.md) buffer settings. See [Setting Voter Buffers](../voter/voter-buffers.md) and look at `oos` (out of sequence) and `packet loss`. Both should be zero. If not, adjusting the buffer size may reduce `oos` or `packet loss`.

## URI: TX Audio Clipping Using Composite (Tone and Voice Combined) on Same Output
Ensure the sum of the ***SUM*** of `txtone` and `txvoice` never exceeds 1000. If more gain is needed, split the tone and voice outputs. To split the outputs use the following configuration in `usbradio.conf`:

```
 ; voice on left channel
 txmixa=voice
 ; tone on right channel
 txmixb=tone
```

## URI: `radio tune rxnoise` Fails
Ensure you have enough audio output from the receiver. Check with a AC voltmeter or scope. You need to have at least 100mVpeak of audio for the `rxnoise` command to complete successfully.

Some radios do not produce enough high frequency noise (above 3kHz) to drive the noise detection DSP. In this case switching to simple usb is recommended.

## Tips on Asking for Help
Keep in mind that when asking for help, the pool of people likely able to help have no understanding of your personal setup, situation, skills, etc. In order to get **good help**, you need to ask a **good question**. Make sure when asking for help to the [AllStarLink Community](https://community.allstarlink.org), that you hit the following points:

#### Explain **Precisely** What is not Working Properly
Requests for help such as "ASL doesn't work" or "my Pi crashes" or "I can't do X" without any further details or information is unable to be diagnosed and assisted.

Examples of **GOOD** ways to ask a question:

* I just built a new ASL3 Pi and when I try to connect to the interface I get __this particular__ error.

* After I configured my node, I am trying to do __this particular thing__ and it doesn't work because of __this particular error__.

* I am trying to configure __this particular feature__ in `rpt.conf` and when I do, __this particular thing__ happens.

* I used to be able to do __this thing__ and after I change __this other thing__ then __this thing__ stopped working.

Basically, before submitting your question to Community, make sure your post contains the basics of "what am I trying to do", "what do I think should be happening", and "what is happening instead". If you are filing an issue on GitHub, use the Issue Templates - they ask for information for a reason.

#### Be Ready to Provide Requested Basic Troubleshooting Info
If you are going to ask for help, be ready and willing to provide the basic troubleshooting information that is requested. For example, if you're having a problem linking to another node, be ready to provide - or even better provide in advance - the basic troubleshooting information needed to help with your problem.

Items that may be requested include elements such as:

* How is your node connected to the Internet?

* What IAX2 port is configured?

* What client are you using?

* What radio type are you using?

* What is your IP address?

* Is the time correct on your system?

* Can you put a monitor on the device and tell what the screen says

* What did the log say about...?

#### AllStarLink Does Not Support Certain Other Projects/Tools
Core AllStarLink does not support certain other projects/tools such as HamVOIP, Supermon/Supermon2, SkyWarnPlus, or AllScan. Some of the developers of these tools such as SkyWarnPlus and AllScan are active and answer questions on the Community, and others are not.

If you are told, "that isn't supported but have you tried doing it in this supported way", consider giving it a try. 

#### AllStarLink v3 Contains 14+ Years of Changes
The release of AllStarLink v3 uses modern Asterisk 20 LTS. Legacy installs use Asterisk 1.4 which was end of life in 2012. Thus, there are literally 14+ years of changes of how Asterisk operates that `app_rpt` (the main engine behind ASL) had to conform to. Notably, the configuration syntax which changed gradually over time for users staying current with Asterisk, is an "all of a sudden" change in ASL3. One cannot paste old configurations into modern ASL3 and expect it to "just work".

Additionally, Asterisk no longer runs as the root user on Linux which means that its ability to do things to the system such as make OS changes is purposefully restricted. ASL3 and Asterisk are very security conscious as many of our users run ASL3 systems on the open Internet.

#### Give Questioners the Benefit of the Doubt
In general, if people are asking questions about the details of your problem, they are likely trying to help and not nitpick. In general, if many people are having the problem, it is already known and [likely documented](../basics/incompatibles.md#known-issues).

If it's not, then likely your issue is unique to your setup and providing the requested troubleshooting is needed to help you further.

### Gathering Logs
If you are asked to provide logs, there are two standard ways to provide logs, using [`Cockpit`](../pi/cockpit-basics.md) or using the `journalctl` tool from the 
Linux CLI.

#### Gathering Logs with Cockpit
In the [Cockpit interface](../pi/cockpit-basics.md), click **Services** on the left navbar. The service list will display. Wait for the full list to load and then click
on the blue link name of the service. The common services are:

* `allmon3` - Allmon3

* `asl3-update-astdb` - Maintenance of the `astdb.txt` file used by third-party apps

* `asl3-update-nodelist` - Maintenance of the "file" based lookup database, if installed

* `asterisk` - Core `Asterisk/app_rpt`

* `networking` - Information about network interfaces

* `NetworkManager` - Information about network items of all sorts

* `systemd-timesyncd` - Information about network time synchronization

After clicking on one of the links, wait until **Service logs** fills in and then view the logs. Clicking **View all logs** will show more logs.

#### Gathering Logs with CLI/SSH
Use the `journalctl -xeu` command to provide logging output. For example:

```
journalctl -xeu asterisk.service
```

Common services are:

* `allmon3.service` - Allmon3

* `asl3-update-astdb.service` - Maintenance of the `astdb.txt` file used by third-party apps

* `asl3-update-nodelist.service` - Maintenance of the "file" based lookup database, if installed

* `asterisk.service` - Core `Asterisk/app_rpt`

* `networking.service` - Information about network interfaces

* `NetworkManager.service` - Information about network items of all sorts

* `systemd-timesyncd.service` - Information about network time synchronization

### Gathering Configs
It is often needed to gather certain configuration details. Use the [Cockpit Console](../pi/cockpit-console.md) or the SSH/CLI interface. People asking for information will likely provide the filename needed in their request. However, here are some easy ways to get the data requested:

* `tail -n50 FILE` - Print the last 50 lines of `FILE`

* `tail -F FILE` - Print the output of `FILE` as it is written to (useful for watching logs
live). Press Ctrl+c to exit

* `more FILE` - Print `FILE` by pages

* `less FILE` - Less is more than more... Less is an interactive scroller and searching interface. For example typing `/SOMETHING` will search for the string "SOMETHING" forward from where you are in the file and `?SOMETHING` will search backwards. Enter CTRL+c to exit

* `grep SOMETHING FILE` - This is for basic searching within a file. For example, you can use `grep` to answer the question "what does the line with FOO in FILE say?". This command
would be `grep FOO FILE`. Note that by default, your `grep` searches are case-sensitive, use the `-i` flag for case-insensitive searches, i.e. `grep -i FOO FILE` will find all instances of "foo", "FOO", "FoO", etc. 

When possible, please copy/paste log and search text instead of attaching screenshots into systems for troubleshooting. Text is far easier to deal with (can be quoted in replies), and will make your trouble show up in search engines to help "the next person".
