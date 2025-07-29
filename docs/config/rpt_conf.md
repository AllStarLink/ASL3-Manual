# rpt.conf
rpt.conf (`/etc/asterisk/rpt.conf`) is where the majority of user-facing features, such as the node's CW and voice ID, DTMF commands and timers are set. There is a lot of capability here which can be difficult to grasp. Fortunately the default `rpt.conf` is well commented and will work fine for most node admins.

See also [config file templating](../adv-topics/conftmpl.md/#asterisk-templates).

## DTMF Commands
DTMF commands are placed in any one of **three** *named stanzas*. These stanzas control access to DTMF commands that a user can issue from various 
control points.

* The [Fuctions](#functions-stanza) Stanza - to decode DTMF from the node's local receiver.
* The [Link Functions](#link-functions-stanza) Stanza - to decode DTMF from linked nodes.
* The [Phone Functions](#phone-functions-stanza) Stanza - to decode DTMF from telephone connects.
 
A DTMF `key=value` pair has the following format:

`dtmfcommand=functionclass,[functionmethod],[parameters]`

Where:

* `dtmfcommand` is a DTMF digit sequence **minus** the [start character](#funcchar) (usually `*`, so a `dtmfcommand` of `81` would actually be `*81` when entered via radio)
* `functionclass` is a string which defines the class of command; `link`, `status`, or `COP`
* `functionmethod` defines the optional method number to use in the function class
* `parameters` are one or more optional comma separated parameters that further define a command.

### Status Commands
Commands using the `status` function class are used to provide general information about the local node.

Sample:

```
712 = status,12   ; Give Time of Day (local only)
```

Status|Description
------|-----------
1|Force ID (global)
2|Give Time of Day (global)
3|Give software Version (global)
4|Give GPS location info
5|Speak the last (dtmf) user 
11|Force ID (local only)
12|Give Time of Day (local only)

### Link Commands
Commands using the `link` function class affect connecting to, disconnecting from, monitoring (RX only) other nodes, and providing linking status. 

Sample:

```
3 = ilink,3   ; Connect specified link -- transceive
```

The above example creates the following DTMF command: `*3<nodenumber>`, which will use `ilink,3` to connect in transceive mode to the specified node number entered as part of the DTMF command.

See the table below for the available link commands, and whether they take a node number as a (required) parameter when being entered:

ilink|Description|Node Number Required
-----|-----------|--------------------
1|Disconnect specified link|Yes
2|Connect specified link -- monitor only|Yes
3|Connect specified link -- tranceive|Yes
4|Enter command mode on specified link|Yes
5|System status|No
6|Disconnect all links|No
7|Last Node to Key Up|No
8|Connect specified link -- local monitor only|Yes
9|Send Text Message (9,&lt;destnodeno or 0 (for all)\>,Message Text, etc.)|No
10|Disconnect all RANGER links (except permalinks)|No
11|Disconnect a previously permanently connected link|Yes
12|Permanently connect specified link -- monitor only|Yes
13|Permanently connect specified link -- tranceive|Yes
15|Full system status (all nodes)|No
16|Reconnect links disconnected with "disconnect all links"|No
17|MDC test (for diag purposes)|No
18|Permanently Connect specified link -- local monitor only|Yes

The commands to permanently connect a link will have `app_rpt` try to maintain those connections across network disruptions.

### COP Commands
Commands using the `cop` (Control OPerator) function class are privileged commands. Node admins may provide some of these to their user community based on personal preference. 

Sample:

```
99 = cop,7   ; enable timeout timer
```

Some COP commands can take multiple parameters. For example this COP 48 would send `#3#607` on command:

Sample:

```
900 = cop,48,#,3,#,6,0,7 
```

COP|Description
---|-----------
1|System warm boot
2|System enable
3|System disable
4|Test Tone On/Off
5|Dump System Variables on Console (debug)
6|PTT (phone mode only)
7|Time out timer enable
8|Time out timer disable
9|Autopatch enable
10|Autopatch disable
11|Link enable
12|Link disable
13|Query System State
14|Change System State
15|Scheduler Enable
16|Scheduler Disable
17|User functions (time, id, etc) enable
18|User functions (time, id, etc) disable
19|Select alternate hang timer
20|Select standard hang timer
21|Enable Parrot Mode
22|Disable Parrot Mode
23|Birdbath (Current Parrot Cleanup/Flush)
24|Flush all telemetry
25|Query last node un-keyed
26|Query all nodes keyed/unkeyed
27|Reset DAQ minimum on a pin (See [DAQ Subsystem](../adv-topics/daq.md))
28|Reset DAQ maximum on a pin (See [DAQ Subsystem](../adv-topics/daq.md))
30|Recall Memory Setting in Attached Xcvr
31|Channel Selector for Parallel Programmed Xcvr
32|Touchtone pad test: command + Digit string + # to playback all digits pressed
33|Local Telemetry Output Enable (See [Telemetry Messages](../adv-topics/telemetry.md))
34|Local Telemetry Output Disable (See [Telemetry Messages](../adv-topics/telemetry.md))
35|Local Telemetry Output on Demand (See [Telemetry Messages](../adv-topics/telemetry.md))
36|Foreign Link Local Output Path Enable (See [Telemetry Messages](../adv-topics/telemetry.md))
37|Foreign Link Local Output Path Disable (See [Telemetry Messages](../adv-topics/telemetry.md))
38|Foreign Link Local Output Path Follows Local Telemetry (See [Telemetry Messages](../adv-topics/telemetry.md))
39|Foreign Link Local Output Path on Demand (See [Telemetry Messages](../adv-topics/telemetry.md))
42|Echolink announce node number only (See [Telemetry Messages](../adv-topics/telemetry.md))
43|Echolink announce node callsign only (See [Telemetry Messages](../adv-topics/telemetry.md))
44|Echolink announce node number and callsign (See [Telemetry Messages](../adv-topics/telemetry.md))
45|Link Activity timer enable (See [Link Activity Timer](../adv-topics/linkacttimer.md))
46|Link Activity timer disable (See [Link Activity Timer](../adv-topics/linkacttimer.md))
47|Reset "Link Config Changed" Flag (See [Link Activity Timer](../adv-topics/linkacttimer.md))
48|Send Tone Sequence (See [Tone Signalling](../adv-topics/tonesignalling.md))
49|Disable incoming connections (control state noice)
50|Enable incoming connections (control state noicd)
51|Enable sleep mode
52|Disable sleep mode
53|Wake up from sleep
54|Go to sleep
55|Parrot Once if parrot mode is disabled
56|Rx CTCSS Enable
57|Rx CTCSS Disable
58|Tx CTCSS On Input only Enable
59|Tx CTCSS On Input only Disable
60|Send MDC-1200 Burst (See [MDC-1200](../adv-topics/mdc1200.md))
61|Control GPIO/PP pins (See [Manipulating GPIO](../adv-topics/gpio.md)) 
62|Control GPIO/PP pins, quietly (See [Manipulating GPIO](../adv-topics/gpio.md))
63|Send pre-configred APRSTT notification (cop,63,CALL[,OVERLAYCHR])
64|Send pre-configred APRSTT notification, quietly (cop,64,CALL[,OVERLAYCHR]) 
65|Send POCSAG page (equipped channel types only)

## General Stanza
ASL3 introduces a new stanza in `rpt.conf`, the `[general]` stanza.

Presently, this stanza just contains `key=value` pairs that specify how node lookups are handled:

```
[general]
node_lookup_method = both           ; method used to lookup nodes
                                    ; both = dns lookup first, followed by external file (default)
                                    ; dns = dns lookup only
                                    ; file = external file lookup only

; The domain name used for DNS lookups when the node lookup method is "dns" or
; "both".  The default domain is "nodes.allstarlink.org" and does not need to
; be defined here.  Only set "dns_node_domain" if a) You really know what you're
; doing and b) you need to use an alternate DNS domain for node resolution.
;dns_node_domain = nodes.allstarlink.org

; When using DNS, "app_rpt" must know the length of the longest node number.
; The current maximum is 6 digits and does not need to be defined here. The
; "max_dns_node_length" variable can be used to limit queries to shorter (or
; longer) node numbers.
;max_dns_node_length = 6
```

See [Node Resolution](../adv-topics/noderesolution.md) for how this new node lookup method is handled.

## Node Number Stanza
The node number stanza is a critical stanza in `rpt.conf`. 

```
[1999]                              ; Replace with your assigned or private node number
```

The node number stanza is set to the **assigned node number** *or* a **private node number** (if a private node is being configured). It will normally be configured by [`asl-menu`](../user-guide/index.md).

The node number stanza contains all the configurable options for that specific node using a `key=value` pair syntax. The following configurable options are available to use:

### accountcode=
This option is optional, it sets the `ACCOUNTCODE` variable to be passed back to other Asterisk applications, namely for call detail records (CDR).

Sample:

```
accountcode=RADIO                   ; set the accountcode variable to RADIO
```

### althangtime=
This setting controls the length of the repeater hang time when the alternate hang timer is selected with a control operator function. It is specified in milliseconds. 

Sample:

```
althangtime=4000                    ; 4 seconds
```

### aprstt=
This option enables APRStt. Set the `aprstt=` option to a matching context in `/etc/asterisk/gps.conf` to enable. You also need to have the `app_gps.so` module loaded in `/etc/asterisk/modules.conf`.

Sample:

```
aprstt = general                    ;  Point to the [general] context in gps.conf
```

See the comments in `gps.conf` for more details on configuring.

### archivedir=
This option is used to enable a simple log and audio recorder of the activity on a node. When enabled, a series of recordings, one for each active COR on the node, is generated. The file(s) will be named with the date and time down to the second (this may change to provide more granularity in the future). This logging can be useful in debugging, policing, or other creative things.

Sample:

```
archivedir = /var/spool/asterisk/monitor ; top-level recording directory
```

The [`archivedir=`](#archivedir) and related options can be implemented in the `[node-main](!)` stanza to apply to all nodes on the server, or in the per-node stanza for recording individual nodes. See [config file templating](../adv-topics/conftmpl.md/#asterisk-templates) for more information.

!!! warning "Disk and CPU Usage"
  Enabling this function can adversely impact the CPU utilization on the device, and consume large amounts of the available storage. You would be wise to implement a script or look at a utility such as `logrotate` to periodically flush old recordings and logs.

See the [Audio and Activity Logging](../adv-topics/archivedir.md) page for additional details on this feature.

### archiveformat=
This option specifies the format of the audio recordings in [`archivedir=`](#archivedir). By default, the format will be "wav49" (GSM in a .WAV file). Other options you may consider include "wav" (SLIN in a .wav file) and "gsm" (GSM in straight gsm format).

Sample:

```
archiveformat = wav49               ; audio format (default = wav49)
```

See the [Audio and Activity Logging](../adv-topics/archivedir.md) page for additional details on this feature.

### archivedatefmt=
This option specifies the filename format used for the audio recordings in [`archivedir=`](#archivedir).  By default, the files will use a "%Y%m%d%H%M%S" date format that maps to YYYYMMDDHHMMSS.  If desired, you can specify any date format supported by the C function strftime(3) API.  For more precision, you can also include the `%[n]q` format to add fractions of a second, with leading zeros.

Sample:

```
archivedatefmt = %Y%m%d%H%M%S%2q    ; date/time (time to 1/100th secs)
```

See the [Audio and Activity Logging](../adv-topics/archivedir.md) page for additional details on this feature.

### archiveaudio=
This option specifies whether the both the simple activity log AND audio recordings are included in [`archivedir=`](#archivedir). If set to `no` then only the activity log will be created (the audio recordings will not be saved).

Sample:

```
archiveaudio = yes                  ; enable/disable audio recordings (default = yes)
```

See the [Audio and Activity Logging](../adv-topics/archivedir.md) page for additional details on this feature.

### beaconing=
This option, when set to `1` will send the repeater ID at the [`idtime`](#idtime) interval, regardless of whether there was repeater activity or not. This feature appears to be required in the UK, but is probably illegal in the US.

Sample:

```
beaconing=1                         ; set to 1 to beacon. Defaults to 0
```

See [European Repeater Operation](../adv-topics/eurorptr.md) for more information on the application of this option.

### callerid=
This option allows the autopatch on the node to be identified with a specific caller ID. The default setting is as follows

```
callerid="Repeater" <0000000000>
```

The value in quotes is the CallerID Name of the autopatch caller, and the numbers in angle brackets are the originating telephone number (CallerID Number) to use.

### connpgm= and discpgm=
These options run user defined scripts.

`connpgm` executes a program or script you specify when a node connects.

`discpgm` executes a program or script you specify when a node disconnects.

`app_rpt` passes two variables to your program or script when it is executed. They are added at the very end of the command string that is executed, `<node number in this stanza>` (us) and `<node number being connected to us>` (them). You do not NEED to use them, but they are available for your use.

Sample:

```
connpgm = /etc/asterisk/custom/conlog.sh
discpgm = /etc/asterisk/custom/dislog.sh

```

See the [Connect and Disconnect Scripts](../adv-topics/condiscpgm.md) page for further details and options.

### context=
This setting directs the autopatch for the node to use a specific context in `extensions.conf` for outgoing autopatch calls. The default is to specify a context name of radio.

```
context=radio
```

### controlstates=
This setting allows you to override the stanza name used for the [`[Control States]`](#control-states-stanza) in `rpt.conf`. Control states are an optional feature which allows groups of control operator commands to be executed all at once. To use control states, define an entry in your node stanzas to point to a dedicated control states stanza like this:

```
controlstates = controlstates       ; points to control state stanza
```

The default is to have `controlstates=` point to a stanza called `controlstates`. However, you can have it point to another named stanza, see [Settings to Name Other Stanzas](./config-structure.md#settings-to-name-other-stanzas) for more information.

The [Control States Stanza](#control-states-stanza) describes all the associated mnemonics and usage in detail.

### dtmfkey=
This setting allows you to change the access control for the local node to require a DTMF key sequence to "key-up" the node on every transmission. Similar to requiring CTCSS, users needs to send a DTMF sequence for the receiver to validate the transmission.

Sample:

```
dtmfkey = 0                         ; set to 1 to require DTMF access. Default is 0 (normal access)
```

If set to `1`, there needs to be an associated [`[dtmfkeys]`](#dtmfkeys) stanza to set the valid DTMF sequence(s).

**This option does not appear in the default `rpt.conf`.**

### dtmfkeys=
The `dtmfkeys` option allows you to override the stanza name used for the `dtmfkeys` stanza in `rpt.conf`. This stanza is used to define the DTMF sequence that is required on every transmission to "key-up" the node. Each key/value pair consists of the DTMF sequence and the associated user callsign. The callsign is used for logging purposes.To use dtmfkeys, define an entry in your node stanza to point to a dedicated dtmfkeys stanza like this:

Sample:

```
dtmfkeys = dtmfkeys                 ; pointer to dtmfkeys stanza
```

The default is to have `dtmfkeys=` point to a stanza called `dtmfkeys`, and have a common set of commands for all nodes. However, you can have it point to another named stanza, see [Settings to Name Other Stanzas](./config-structure.md#settings-to-name-other-stanzas) for more information.

See the [DTMFKeys Stanza](#dtmfkeys-stanza) for more detail on defining dtmfkeys.

To use this option, [`dtmfkey=1`](#dtmfkey) needs to be set. 

**This option does not appear in the default `rpt.conf`.**

### duplex=
This setting sets the duplex mode for desired radio operation. Duplex mode 2 is the default if nonthing specified.

Duplex|Mode Description
------|----------------
0|Half duplex with no telemetry tones or hang time. Special Case: Full duplex if linktolink is set to yes. This mode is preferred when interfacing with an external multiport repeater controller. Comment out idrecording and idtalkover to suppress IDs. 
1|Half duplex with telemetry tones and hang time. Does not repeat audio. This mode is preferred when interfacing a simplex node. 
2|Full Duplex with telemetry tones and hang time. This mode is preferred when interfacing a repeater.  
3|Full Duplex with telemetry tones and hang time, but no repeated audio. 
4|Full Duplex with telemetry tones and hang time. Repeated audio only when the autopatch is down. 

Sample:

```
duplex = 0                          ; 0 = Half duplex with no telemetry tones or hang time.
```

### eannmode= 
This option sets the Echolink node announcement type, when a node connects:

* 0 = Do not announce EchoLink nodes at all
* 1 = Say only node number (default)
* 2 = Say phonetic call sign only on Echolink connects
* 3 = Say phonetic call sign and node number on Echolink connects

See the [Telemetry Messages](../adv-topics/telemetry.md) page for more information on telemetry.

### echolinkdefault=
This option sets the Echolink telemetry option:

* 0 = telemetry output off
* 1 = telemetry output on
* 2 = timed telemetry output (after command execution and for two minutes thereafter)
* 3 = follow local telemetry mode (default)

See the [Telemetry Messages](../adv-topics/telemetry.md) page for more information on telemetry.

### echolinkdynamic=
This option sets whether EchoLink telemetry can be enabled/disabled by users using a [COP](#cop-commands) command.

* 0 = disallow users to change current Echolink telemetry setting with a COP command
* 1 = allow users to change the setting with a COP command

See the [Telemetry Messages](../adv-topics/telemetry.md) page for more information on telemetry.

### elke=
This option, if set, defines this node as an ["Elke Link"](../adv-topics/elkelink.md), and sets the time before the node goes to "sleep".

Sample:

```
elke = 744                          ; set the Elke timer for 15 minutes (FFF 744 = 15 minutes)
```

The timer value is in [furlong/firkin/fortnight (FFF) system](https://en.wikipedia.org/wiki/FFF_system) units... a bit of Jim Dixon humor.

See the [Elke Link](../adv-topics/elkelink.md) page for more details.

### endchar=
This setting allows the end character used by some control functions to be changed. By default this is a `#`. The `endchar` value must not be the same as the [`funcchar`](#funcchar) default (`*`) or its overridden value.

### erxgain=
This option adjusts the Echolink receive gain in +/- dbV. It is used to balance Echolink recieve audio levels on an `app_rpt` node. 

Sample:

```
erxgain = -3
```

See the Echolink How-to for more information.

### etxgain=
This option adjusts the Echolink transmit gain in +/- dbV. It is used to balance Echolink transmit audio on an `app_rpt` node. 

Sample:

```
etxgain = 3
```

See the Echolink How-to for more information.

### events=
This option allows you to override the name used for the `[events]` stanza in `rpt.conf`. You can create events to specify that actions be taken when certain events occur such as transitions in receive and transmit keying, the presence and modes of links, and external inputs such as GPIO pins on the URI (or similar USB devices).

To use events, define an entry in your node stanzas to point to a dedicated events stanza like this:

```
events = events                     ; points to the events stanza

[events]
;;;;; Events Management ;;;;;
status,2 = c|f|RPT_NUMLINKS      ; Say time of day when all links disconnect.
```

The default is to have `events=` point to a stanza called `events`. However, you can have it point to another named stanza, see [Settings to Name Other Stanzas](./config-structure.md#settings-to-name-other-stanzas) for more information.

See [Event Management Subsystem](../adv-topics/eventmgmt.md)) for a more detailed look on how to configure events.

### extnodefile=
This option allows you to set the name of the external node lookup file. The default value is `/var/lib/asterisk/rpt_extnodes`. This file is used to look up node information when linking to other nodes.  It is also used to validate nodes that are connecting to your node.

Sample:

```
extnodefile=/var/lib/asterisk/rpt_extnodes
```

The default file is automatically updated using the node update script or the [`asl3-update-nodelist`](../adv-topics/noderesolution.md#external-node-directory-file) service.

The `extnodefile=` option supports multiple file names. In some cases, you may want the default file, along with a static locally maintained node file.  Multiple file names can be entered by separating them with a comma. A maximum of 100 external files can be specified.

Sample:

```
extnodefile=/var/lib/asterisk/rpt_extnodes,/var/lib/asterisk/myrpt_extnodes
```

If a custom `extnodefile=` is used, it must have the section header `[extnodes]` or a custom header as described in [extnodes](#extnodes).

Also see [Node Resolutuion](../adv-topics/noderesolution.md) for information on how to configure node lookups. 

**This option does not appear in the default `rpt.conf`.**

### extnodes=
This option allows you to set the section name used for `[extnodes]` in the `rpt_extnodes` file.  The default value is `extnodes`. This translates to `[extnodes]` section header. 

Sample:

```
extnodes=myextnodes
```

In this example, you would need to configure the section `[myextnodes]` in your custom `rpt_extnodes` file. `app_rpt` will no longer look for an `[extnodes]` section header for this node, it will look for `[myextnodes]` instead.

See the [extnodefile](#extnodefile) for more information on how the `extnodes` section is used.

**This option does not appear in the default `rpt.conf`.**

### funcchar=
This setting can be used to change the default function starting character of `*` to something else. Please note that the new value chosen must not be the same as the default (`#`) or overridden value for [`endchar=`](#endchar).

### functions=
The `functions` option allows you to override the stanza name used for the `functions` stanza in `rpt.conf`. Functions are used to decode DTMF commands when accessing the node from its receiver. To use functions, define an entry in your node stanzas to point to a dedicated function stanza like this:

Sample:

```
functions = functions               ; pointer to functions stanza
```
The default is to have `functions=` point to a stanza called `functions`, and have a common set of commands for all nodes. However, you can have it point to another named stanza, see [Settings to Name Other Stanzas](./config-structure.md#settings-to-name-other-stanzas) for more information.

See the [Functions Stanza](#functions-stanza) for more detail on defining functions.

### guilinkdefault=
This option sets how telemetry is handled for IAXRpt, SIP phone display, and VoIP clients.

Sample:

```
guilinkdefault = 1 
```

The available options are:

* 0 = telemetry output off
* 1 = telemetry output on (default)
* 2 = timed telemetry output (after command execution and for two minutes thereafter) 
* 3 = follow local telemetry mode

See the [Telemetry Messages](../adv-topics/telemetry.md) page for more information on telemetry.

### guilinkdynamic=
This option sets whether telemetry for IAXRpt, SIP phone display, and VoIP clients can be enabled/disabled by users using a [COP](#cop-commands) command.

Sample:

```
guilinkdynamic = 1
```

The available options are:

* 0 = disallow users to change gui telemetry setting with a COP command
* 1 = Allow users to change the setting with a COP command

See the [Telemetry Messages](../adv-topics/telemetry.md) page for more information on telemetry.

### hangtime=
This option controls the length of the repeater (squelch tail) hang time. It is specified in milliseconds. 

Sample:

```
hangtime = 1000                     ; set hang time for 1 second
```

The default is 5000(ms), or 5sec.

### holdofftelem=
This option forces all telemetry to be held off until a local user on the receiver or a remote user over a link unkeys. There is one exception to this behavior, and that is when an ID needs to be sent and there is activity coming from a linked node.

Sample:

```
holdofftelem = 0                    ; set to 1 to hold off. Default is 0
```

### idrecording=
The identifier message is stored in the node stanza using the `idrecording=` setting. It can be changed to a different call sign by changing the value to something different. The value can be either a morse code identification string (when prefixed with `|i`), or the name of a sound file containing a voice identification message. When using a sound file, the default path for the sound file is `/usr/share/asterisk/sounds/en`. Example usages are as follows:

Sample:

```
idrecording = |iWB6NIL              ; morse code ID
```

or

```
idrecording = myid                  ; voice ID, plays /usr/local/share/asterisk/sounds/myid.ulaw (or other valid extension)
```

!!! note "File Extensions"
    ID recording files must have extension gsm, ulaw, pcm, or wav. The extension is **left off** when it is defined as the example shows above. File extensions are used by Asterisk to determine how to decode the file. All ID recording files should be sampled at 8KHz mono. 

See [Sound Files](../adv-topics/soundfiles.md) for more information.

### idtalkover=
The ID talkover message is stored in the node stanza using the `idtalkover=` setting. The purpose of `idtalkover` is to specify an *alternate* ID to use when the ID must be sent **over the top** of a user transmission. This can be a shorter voice ID or an ID in morse code. The value can be either a morse code identification string (when prefixed with `|i`), or the name of a sound file containing a voice identification message. When using a sound file, the default path for the sound file is `/usr/share/asterisk/sounds/en`. Example usages are as follows:

Sample:

```
idtalkover = |iwa6zft/r             ; morse code ID
```

or

```
idrecording = shortid               ; voice ID, plays /usr/local/share/asterisk/sounds/shortid.ulaw (or other valid extension)
```

!!! note "File Extensions"
    ID recording files must have extension gsm, ulaw, pcm, or wav. The extension is **left off** when it is defined as the example shows above. File extensions are used by Asterisk to determine how to decode the file. All ID recording files should be sampled at 8KHz mono.

See [Sound Files](../adv-topics/soundfiles.md) for more information.

### idtime=
This option sets the ID interval time, in mS. It is optional.

Sample:

```
idtime = 540000                     ; id interval time (in ms) (optional)
```

The default is 5 minutes (300000mS).

### inxlat=
The input translate option allows complete remapping of the [`funcchar`](#funcchar) and [`endchar`](#endchar) digits to different digits or digit sequences.

`inxlat` acts on the digits received by the radio receiver on the node.

Format: `inxlat = funcchars,endchars,passchars[,dialtone]`

where:

* `funcchars` is the digit or digit sequence to replace `funcchar`
* `endchars` is the digit or digit sequence to replace `endchar`
* `passchars` are the digits to pass through (can be used to block certain digits)
* `dialtone` set to `y` to optionally play dialtone on a function.

Sample:

```
inxlat = #456,#457,0123456789ABCD   ; string xlat from radio port to sys
```

In the above example, on inbound DTMF, translate `#456` as `funcchar` (normally `*`), `#457` as `endchar` (normally `#`), and pass all other digits listed in `passchars` normally.

### link_functions=
This option allows you to override the stanza name used for the `link_functions` stanza in `rpt.conf`. The `link_functions=` setting directs the node to use a particular function stanza for functions dialed by users accessing the node **via a link from another node**. 

Sample:

```
link_functions = functions          ; pointer to the function stanza
```

The default is to have `link_functions=` point to a stanza called `functions`, and have a common set of commands for all nodes. However, you can have it point to another named stanza, see [Settings to Name Other Stanzas](./config-structure.md#settings-to-name-other-stanzas) for more information.

See the [Functions Stanza](#functions-stanza) for more detail on defining functions.

### lnkactenable=
Set this option to enable the link activity timer. 


Sample:
```
lnkactenable = 0                    ; set to 1 to enable the link activity timer.
```

See the [Link Activity Timer](../adv-topics/linkacttimer.md) page for more details.

The default is `0` (disabled).

See the [Link Activity Timer](../adv-topics/linkacttimer.md) page for more information.

### lnkacttime=
Set the optional link activity timer (`lnkactenable` must be enabled for this to have any effect). The value is in seconds.

Sample:

```
lnkacttime = 1800                   ; link activity timer time in seconds.
```

See the [Link Activity Timer](../adv-topics/linkacttimer.md) page for more details.

### lnkactmacro=
Play the defined macro when the link activity timer expires.
Sample:

```
lnkactmacro = *52                   ; function to execute when link activity timer expires.
```

See the [Link Activity Timer](../adv-topics/linkacttimer.md) page for more details.

### lnkacttimerwarn=
Set this to the voice file to play when the link activity timer has 30 seconds remaining.
Sample:

```
lnkacttimerwarn = rpt/timeout-warning ; message to play when the link activity timer has 30 seconds left.
```

See the [Link Activity Timer](../adv-topics/linkacttimer.md) page for more details.

### linkmongain=
This option adjusts the audio level of monitored nodes when a signal from another node or the local receiver is received. If `linkmongain` is set to a negative number the monitored audio will decrease by the set amount in dB. If `linkmongain` set to a positive number monitored audio will increase by the set amount in dB. The value of `linkmongain` is in dB. The default value is 0dB.

Sample:

```
linkmongain = -20                   ; reduce link volume 20dB
```

### linktolink=
When operating in [duplex mode 0](#duplex), this forces the radio interface to operate in full duplex mode, but keeps all the other "duplex mode 0" semantics. 

This is used when a radio interface is connected to a multiport analog repeater controller. The `linktolink=` option can take two values: `yes`/`1` or `no`/`0`.

Sample:

```
linktolink = no                     ; set to yes to enable. Default is no.
```

### linkunkeyct=
This option selects the courtesy tone to send when a connected remote node unkeys. The default is no courtesy tone when a remote node unkeys.

Sample:

```
linkunkeyct = ct8                   ; use courtesy tone 8
```

See the [Courtesy Tones](../adv-topics/courtesytones.md) page for more information on defining telemetry tones.

### litzchar=
This option sets the DTMF character used to initiate the Long Tone Zero (LiTZ) feature. LiTZ is an optional feature that users can initiate to indicate they require immediate assistance. When the LiTZ DTMF character is sent for longer than the LiTZ time, the LiTZ command will be triggered. This could dial 911 on the autopatch, play a message, connect to another node, etc.

Sample:

```
litzchar = 0                        ; 0 is the default DTMF access character for the LiTZ feature
```

### litzcmd=
This option defines the command to run when the LiTZ feature is initiated. Leave blank to disable LiTZ (default).

Sample:

```
litzcmd = *6911                     ; dial 911 on the autopatch when LiTZ is activated
```

### litztime=
This option defines how long `litzchar` needs to be sent for, to be considered valid. If `litzchar` is received for this minimum period, `litzcmd` will be executed when the user unkeys. The default is 3000mS (3 seconds).

Sample:

```
litztime = 3000                     ; default 3000mS (3 seconds)
```

### macro=
This option allows you to override the stanza name used for the `[macro]` stanza in `rpt.conf`. The macro stanza directs the node to use a particular stanza for macros dialed by users accessing the node. Macros are DTMF shortcuts, and are a special type of function. 

Sample:

```
macro=macro                         ; use stanza named macro

[macro]
1 = *32000 *32001#                  ; connect to nodes 2000 and 2001
```

The default is to have `macro=` point to a stanza called `macro`, and have a common set of commands for all nodes. However, you can have it point to another named stanza, see [Settings to Name Other Stanzas](./config-structure.md#settings-to-name-other-stanzas) for more information.

See the [Macro Stanza](#macro-stanza) for more detail on defining macros.

### mdclog=
This option is used to enable a simple log for all local MDC-1200 Signalling received by the node. When set, each incoming MDC-1200 burst that is decoded will be logged into the log file with a timestamp.

```
mdclog = /tmp/mdclog                ; log MDC-1200 received data to /tmp/mdclog
```

The directory you use needs to be writable by Asterisk. See the [Permissions](../adv-topics/permissions.md) page for more information.

See the [MDC-1200 Signalling](../adv-topics/mdc1200.md) page for more information on MDC-1200 support.

**This option does not appear in the default `rpt.conf`.**

### mdcmacro=
This option allows you to override the stanza name used for the `[mdcmacro]` stanza in `rpt.conf`. The mdcmacro stanza directs the node to use a particular stanza for mdcmacros when [MDC-1200 signalling](../adv-topics/mdc1200.md) is received by the node. 

Sample:

```

mdcmacro=mdcmacro                   ; use stanza named mdcmacro

[mdcmacro]
I1701=*81#                          ; announce the time with unit 1701 IDs
```

The default is to have `mdcmacro=` point to a stanza called `mdcmacro`, and have a common set of commands for all nodes. However, you can have it point to another named stanza, see [Settings to Name Other Stanzas](./config-structure.md#settings-to-name-other-stanzas) for more information.

See the [MDC Macro Stanza](#mdc-macro-stanza) for more detail on defining mdcmacros.

See the [MDC-1200 Signalling](../adv-topics/mdc1200.md) page for more information on MDC-1200 support.

**This option does not appear in the default `rpt.conf`.**

### morse=
This option allows you to override the stanza name used for the `morse` stanza in `rpt.conf`. The morse stanza directs the node to use a particular stanza for morse code parameters for the node. Morse code parameters can be defined on a per-node basis.  

Sample:

```
morse=morse                         ; use stanza named morse

[morse]
speed = 20                          ; Approximate speed in WPM
frequency = 400                     ; Morse Telemetry Frequency
amplitude = 4096                    ; Morse Telemetry Amplitude
idfrequency = 400                   ; Morse ID Frequency
idamplitude = 1024                  ; Morse ID Amplitude

```

The default is to have `morse=` point to a stanza called `morse`, and have a common set of commands for all nodes. However, you can have it point to another named stanza, see [Settings to Name Other Stanzas](./config-structure.md#settings-to-name-other-stanzas) for more information.

See the [Morse Stanza](#morse-stanza) for more detail on defining morse parameters.

### nodenames=
This option lets you override the default location to look for custom nodename files to play back when a node connects/disconnects.

The default location is a relative path of `rpt/nodenames`. The absolute path will typically then be `/usr/share/asterisk/sounds/en/rpt/nodenames`. 

Sample:

```
nodenames = /var/lib/asterisk/sounds/custom/nodenames  ; point to alternate nodename sound directory
```

When a node connects/disconnects, Asterisk will look in this directory for a filename that matches the calling node number (ie. 63001.gsm). If it finds such a file, it will play it as the connect/disconnect message.

See the [Sound Files](../adv-topics/soundfiles.md) page for more information on sound file locations.

### nodes=
This option allows you to override the section name used for the '[nodes]' stanza in `rpt.conf`. The default value is `nodes`. The `[nodes]` stanza operates like a "hosts" file in an OS, and is the first place `app_rpt` looks to resolve how to reach a particular node.

Sample:

```
nodes=mynodes
```

In this example, you would need to configure the section `[mynodes]` in `rpt.conf`. `app_rpt` will no longer look for a `[nodes]` section header for this node, it will look for `[mynodes]` instead.

See the [Nodes Stanza](#nodes-stanza) for more information on how the nodes section is used.

**This option does not appear in the default `rpt.conf`, and as such, app_rpt uses the default stanza of `[nodes]`**

### nolocallinkct=
Set this option to send `unlinkedct` instead, if another local node is connected to this node (hosted on the same PC).

Sample:

```
nolocallinkct = 0                   ; default is 0, set to 1 to enable 
```

### nounkeyct=
This option completely disables the courtesy tone. This is useful for eliminating TX tail time in applications using simplex uplinks to repeaters on the repeater pair itself.  This practice is **strongly** discouraged. The `nounkeyct=` option can take two values: `yes`/`1` or `no`/`0`.

Sample:

```
nounkeyct = no                      ; set to yes to disable :(. Default is no.
```

### outstreamcmd=
This option is used to configure the utilities to run on the system to support streaming the node's audio to a streaming server.

Sample:

```
outstreamcmd = /bin/sh,-c,/usr/bin/lame --preset cbr 16 -r -m m -s 8 --bitwidth 16 - - | /usr/bin/ezstream -qvc /etc/ezstream.xml
```

See [Streaming a Node to Broadcastify](../adv-topics/broadcastify.md) for further information and details on how to configure audio streaming of the node.

### outxlat=
The output translate option allows complete remapping of the [`funcchar`](#funcchar) and [`endchar`](#endchar) digits to different digits or digit sequences.

`outxlat` acts on the digits sent by the node to a link.

Format: `outxlat = funcchars,endchars,passchars`

where:

* `funcchars` is the digit or digit sequence to replace `funcchar`
* `endchars` is the digit or digit sequence to replace `endchar`
* `passchars` are the digits to pass through (can be used to block certain digits).

Sample:

```
outxlat = *7,*0,0123456789ABCD      ; string xlat from sys to radio port
```

In the above example, on outbound DTMF, `*7` generates a `funcchar` (normally `*`), `*0` generates an `endchar` (normally `#`), and pass all other digits listed in `passchars` normally.

!!! warning "Documentation Missing" 
    This option is not well documented in the code, your mileage may vary.

### parrot=
The "parrot" repeats everything it hears. Use this option to create an "echo reflector node", where everything you transmit to the node will be played back when you unkey.

Sample:

```
parrot = 0                          ; 0 = Parrot mode off or enabled with COP commands (default = 0)
```

The available options are:

* 0 = Parrot mode off or enabled with COP commands (default = 0)
* 1 = Parrot mode always on

See [Parrot Mode](../adv-topics/parrotmode.md) for more information on what this mode does, and how it works.

### parrottime=
This option sets the amount of time in mS to delay before playing back the audio buffer.

Sample:

```
parrottime = 1000                   ; Wait 1s (1000mS) before playback
```

This timer is related to [Parrot Mode](../adv-topics/parrotmode.md).

### phone_functions=
This option allows you to override the stanza name used for the `phone_functions` stanza in `rpt.conf`. Phone functions are a specific group of commands that are available when the node is accessed via phone.

Sample:

```
phone_functions = functions         ; name phone_functions to functions
```

The default is to have `phone_functions=` point to a stanza called `functions`, and have a common set of commands for all nodes. However, you can have it point to another named stanza, see [Settings to Name Other Stanzas](./config-structure.md#settings-to-name-other-stanzas) for more information.

See [Phone Functions Stanza](#phone-functions-stanza) for more information on the functions that can be configured.

### phonelinkdefault=
This option sets how telemetry is handled for the [autopatch](../adv-topics/autopatch.md) and [Phone Portal](../user-guide/phoneportal.md) connections.

Sample:

```
phonelinkdefault = 1 
```

The available options are:

* 0 = telemetry output off
* 1 = telemetry output on (default)
* 2 = timed telemetry output (after command execution and for two minutes thereafter) 
* 3 = follow local telemetry mode

See the [Telemetry Messages](../adv-topics/telemetry.md) page for more information on telemetry.

### phonelinkdynamic=
This option sets whether telemetry for [autopatch](../adv-topics/autopatch.md) and [Phone Portal](../user-guide/phoneportal.md) connections can be enabled/disabled by users using a [COP](#cop-commands) command.

Sample:

```
phonelinkdynamic = 1
```

The available options are:

* 0 = disallow users to change phone telemetry setting with a COP command
* 1 = Allow users to change the setting with a COP command

!!! warning "Uses `guilinkdynamic`"
    See [`app_rpt` Issue #717](https://github.com/AllStarLink/app_rpt/issues/717).

See the [Telemetry Messages](../adv-topics/telemetry.md) page for more information on telemetry.

### politeid=
This option specifies the number of milliseconds prior to the end of the ID cycle where the controller will attempt to play the ID in the tail when a user unkeys. If the controller does not get a chance to send the ID in the tail, the ID will be played over the top of the next user transmission. Optional, default is 30000mS.

Sample:

```
politeid = 30000                    ; 30 seconds
```

### propagate_dtmf=
This option takes either `yes`/`1` or `no`/`0`. When set to `yes`, DTMF **will** be regenerated from out-of-band signalling or from from the receiver DTMF decoder whenever a function start character is NOT detected, and command decoding has not begun. When set to `no`, no tones will be regenerated. The default for this setting is `no`.

This setting is meant to be used in conjunction with [`linktolink`](#linktolink), [`inxlat`](#inxlat), and [`outxlat`](#outxlat) when interfacing a radio port to a multiport analog repeater controller on an RF-linked system.

Sample:

```
propagate_dtmf = no
```

!!! note "Alternate Setting for Phone Users"
    There is a separate setting `propagate_phonedtmf` for use by dial-in (phone and dphone) users.

### remotect=
This option allows the selection of the remote linked courtesy tone so that the users can tell there is a [Remote Base](../adv-topics/remotebase.md#remote-base-nodes) connected locally.

Sample:

```
remotect = ct3                      ; use courtesy tone 3
```

See the [Courtesy Tones](../adv-topics/courtesytones.md) page for more information on defining telemetry tones.

### remote_inact_timeout=
This option specifies the amount of time without keying from the link, before the link is determined to be inactive. Set to `0` to disable timeout.

Sample:

```
remote_inact_timeout = 0            ; do not time out
```

This is a [Remote Base](../adv-topics/remotebase.md#remote-base-nodes) option. See that section of the manual for more information.

### remote_timeout=
This option specifies the session time out for the remote base. Set to `0` to disable. This option does not appear to be implemented in code.

Sample:

```
remote_timeout = 0                  ; do not timeout
```

Default is 3600 (seconds?).

This is a [Remote Base](../adv-topics/remotebase.md#remote-base-nodes) option. See that section of the manual for more information.

### remote_timeout_warning=
This option does not appear to be implemented in code.

Default is 180 (seconds?).

This is a [Remote Base](../adv-topics/remotebase.md#remote-base-nodes) option. See that section of the manual for more information.

### remote_timeout_warning_freq=
This option does not appear to be implemented in code.

Default is 30 (seconds?).

This is a [Remote Base](../adv-topics/remotebase.md#remote-base-nodes) option. See that section of the manual for more information.

### rxburstfreq=
This option determines the frequency of tone that the node receiver listens for, to enable access (RX Toneburst Access, common in Europe). If RX Toneburst operation is desired, specify the frequency in Hertz of the desired tone burst. Setting to `0` (or not specifying) indicates no tone burst operation.

Sample:

```
rxburstfreq = 1000
```
**This option does not appear in the default `rpt.conf`.**

### rxburstthreshold=
Fot RX Toneburst mode, this option specifies the minimum signal to noise ratio in dB that qualifies a valid tone.

Sample:

```
rxburstthreshold= 16
```

Defaults to 16 (dB).

**This option does not appear in the default `rpt.conf`.**

### rxbursttime=
For RX Toneburst operation, specifies minimum amount of time that tone needs to be valid for recognition (in milliseconds). Defaults to 250.

Sample:

```
rxbursttime= 250
```

**This option does not appear in the default `rpt.conf`.**

### rxchannel=
This setting selects the type of radio interface used by the node. There must be **one** (and only one) `rxchannel` per node definition stanza. The selections for `rxchannel` are: 

Value|Description
-----|-----------
dahdi/pseudo|No radio, used for hubs 
SimpleUSB/1999|SimpleUSB Channel Driver (limited DSP), specify associated node number found in simpleusb.conf  
Radio/1999|Usbradio Channel Driver (full DSP), specify associated node number found in usbradio.conf  
voter/1990|VOTER (RTCM) Channel Driver, specify associated node number found in voter.conf    
USRP/127.0.0.1:34001:32001|GNU Radio interface USRP 
tlb/tlb0|TheLinkBox Channel Driver, pointing to the specified (tlb0) channel context in tlb.conf

Sample:

```
rxchannel = dahdi/pseudo            ; no radio (hub)
```

!!! note "Channel Driver"
    This is selecting what is known (in Asterisk terminology) as the *channel driver*.

!!! warning "Load Module"
    Be sure that any channel driver you use also has it's corresponding module being loaded in `/etc/asterisk/modules.conf`.

### rxnotch=
In order to use this option, `app_rpt` must have been compiled with the `notch` option. This option will notch a particular center frequency (in Hz) for a specified bandwidth (in Hz).

Sample:

```
rxnotch=1065,40                    ; notch 1065Hz for +/-20Hz
```

!!! warning "High CPU Utilization"
    IF this option is available, it requires a great deal of CPU to perform and would probably be detrimental to use on the small boards. It isn't recommended for use.

### scheduler=
This option allows you to override the stanza name used for the `schedule` stanza in `rpt.conf`. The scheduler is used to execute commands at a particular time.

Sample:

```
scheduler = schedule                ; name scheduler to 'schedule'

[schedule]
...
```

The default is to have `scheduler=` point to a stanza called `schedule`, and have a common set of commands for all nodes. However, you can have it point to another named stanza, see [Settings to Name Other Stanzas](./config-structure.md#settings-to-name-other-stanzas) for more information.

See the [Schedule Stanza](#schedule-stanza) for more information on the scheduler.

### sleeptime=
This option sets the inactivity period in *seconds* of no signal on the node's receiver before the system goes to sleep. 

Sample:

```
sleeptime = 300   ; go to sleep after 5 mins of no activity
```

See [Sleep Mode](../adv-topics/sleepmode.md) for more information on what this timer does, and how it works.

### startup_macro=
The `startup_macro` is executed once on system startup. Each node can have **one** startup macro defined in its node stanza.

Sample:

```
startup_macro = *31000 *31001 *31002 ; connect to nodes 1000, 1001 and 1002 at startup
```

One string of one or multiple commands, executed in order. 

!!! note "No Termination Character"
    This string of commands does NOT terminate with a `#` like a normal macro. You can call any number of regular macros with it.

### statpost_program=
This option sets the commands to run on the server to process usage statistics of the node. **This option is generally no longer required, but is included for documentation purposes.**

Sample:

```
;statpost_program=/usr/bin/wget,-q,--timeout=15,--tries=1,--output-document=/dev/null
```

### statpost_url=
Uncomment this option to enable status and statistics reporting of your node to [https://stats.allstarlink.org](https://stats.allstarlink.org)

Sample:

```
;statpost_url = http://stats.allstarlink.org/uhandler ; status updates
```

The `statspost_url=` option can be implemented in the `[node-main](!)` stanza to apply to all nodes on the server, or in the per-node stanza for limiting statistics posting to an individual nodes. See [config file templating](../adv-topics/conftmpl.md/#asterisk-templates) for more information.

### tailmessagelist=
This option allows a comma-separated list of audio files to be specified for the tail message function. The tail messages will *rotate* from one to the next until the end of the list is reached, at which point the first message in the list will be selected. If no absolute path name is specified, the directory `/usr/share/asterisk/sounds/en` will be searched for the sound file. The file extension should be omitted.

Sample:

```
tailmessagelist = welcome,clubmeeting,wx ; rotate 3 tail messages
```

Tail messages can be "squashed" if a user keys up over them.

!!! note "File Extensions"
    ID recording files must have extension gsm,ulaw,pcm, or wav. The extension is left off when it is defined as the example shows above. File extensions are used by Asterisk to determine how to decode the file. All ID recording files should be sampled at 8KHz mono.

See the [Sound Files](../adv-topics/soundfiles.md) page for more information.

### tailmessagetime=
This option sets the amount of time in milliseconds between tail messages. Tail Messages are played when a user unkeys on the node input at the point where the hang timer expires, and after the courtesy tone is sent.

Sample:

```
tailmessagetime = 900000            ; 15 minutes between tail messages
```

The maximum value is 200000000mS (55.5555 hours).

### tailsquashedtime=
If a tail message is "squashed" by a user keying up over the top of it, a separate time value can be loaded to make the tail message be retried at a shorter time interval than the standard `tailmessagetime=` option. The `tailsquashedtime=` option takes a value in milliseconds.

Sample:

```
tailsquashedtime = 300000           ; 5 minutes
```

### telemetry=
This option allows you to override the stanza name used for the `telemetry` stanza in `rpt.conf`. Telemetry definitions define courtesy tone parameters, and tones sent when certain actions take place on the node.

Sample:

```
telemetry = telemetry               ; name telemetry to 'telemetry'

[telemetry]
...
```

The default is to have `telemetry=` point to a stanza called `telemetry`, and have a common set of commands for all nodes. However, you can have it point to another named stanza, see [Settings to Name Other Stanzas](./config-structure.md#settings-to-name-other-stanzas) for more information.

See the [Telemetry Stanza](#telemetry-stanza) for more information on the options that can be configured.

### telemdefault=
This option sets whether telemetry is turned on or off by default.

Sample:

```
telemdefault = 1 
```

The available options are:

* 0 = telemetry output off
* 1 = telemetry output on (default)
* 2 = timed telemetry output (after command execution and for two minutes thereafter)

See the [Telemetry Messages](../adv-topics/telemetry.md) page for more information on telemetry.

### telemduckdb=
This option allows adjustment of the telemetry level in dB when a local or voice transmission is in progress. Specify the level to lower the telemetry level in negative dB.

Sample:

```
telemduckdb = -15                   ; Reduce telemetry by -15dB
```

### telemdynamic=
This option sets whether telemetry can be enabled/disabled by users using a [COP](#cop-commands) command.

Sample:

```
telemdynamic = 1
```

The available options are:

* 0 = disallow users to change the local telemetry setting with a COP command
* 1 = Allow users to change the setting with a COP command (default)

See the [Telemetry Messages](../adv-topics/telemetry.md) page for more information on telemetry.

### telemnomdb=
This option is used to fine tune the telemetry level, relative to standard node audio. The level is in dB. 

Sample:

```
telemnomdb = -3                     ; decrease nominal telemetry by -3dB
```

### tlbdefault=
This option sets the TheLinkBox telemetry option:

* 0 = telemetry output off
* 1 = telemetry output on
* 2 = timed telemetry output on command execution and for a short time thereafter
* 3 = follow local telemetry mode (default)

See the [Telemetry Messages](../adv-topics/telemetry.md) page for more information on telemetry.

### tlbdynamic=
This option sets whether TheLinkBox telemetry can be enabled/disabled by users using a [COP](#cop-commands) command.

* 0 = disallow users to change current Echolink telemetry setting with a COP command
* 1 = allow users to change the setting with a COP command

See the [Telemetry Messages](../adv-topics/telemetry.md) page for more information on telemetry.

### tonemacro=
This option allows you to override the stanza name used for the `tonemacro` stanza in `rpt.conf`. The tone macro stanza directs the node to use a particular stanza for CTCSS tone tiggered macros from users accessing the node. Macros are DTMF shortcuts, and are a special type of function. 

Sample:

```
tonemacro = tonemacro               ; use stanza named tonemacro

[tonemacro]
100.0 = *81#                        ; play the time if a 100.0Hz CTCSS tone is received
```

The default is to have `tonemacro=` point to a stanza called `tonemacro`, and have a common set of commands for all nodes. However, you can have it point to another named stanza, see [Settings to Name Other Stanzas](./config-structure.md#settings-to-name-other-stanzas) for more information.

See the [Tonemacro Stanza](#tonemacro-stanza) for more detail on defining tone macros.

See the [Tone Macros](../adv-topics/tonemacros.md) page on how to utilize tone macros.

**This option does not appear in the default `rpt.conf`.**

### totime=
This option defines the time out timer interval for the node. The value is in milliseconds. If the node transmitter remains keyed beyond the `totime` timer length, the transmitter will be unkeyed until the receiver activity resets. 

Sample:

```
totime = 180000                     ; repeater timeout 3 minutes 
```
The default value is 180000(mS), or 3 minutes. 

!!! warning "Active Hub Advisory" 
    This setting can cause issues when linked to active hub nodes that may have long transmissions. If the local node transmitter appears to "drop out" when connected to nodes/hubs with long winded operators or broadcasts, review this setting, and increase as necessary.

Related: [COP Commands 7 and 8](#cop-commands) and [`controlstates`](#controlstates), and [Control States Stanza](#control-states-stanza).

### unlinkedct=
This option selects the courtesy tone to be used when the system has no remote nodes connected and is operating as a standalone repeater.

Sample:

```
unlinkedct = ct2                    ; use courtesy tone 2
```

See the [Courtesy Tones](../adv-topics/courtesytones.md) page for more information on defining telemetry tones.

### votermargin=
This option is used with the [Simple Voter](../adv-topics/simplevoter.md) feature to set the RSSI difference threshold to switch to another remote receiver.

Sample:

```
votermargin = 10                      ; 10=default sets signal margin to vote a new winner
```

### votermode=
This option is used with the [Simple Voter](../adv-topics/simplevoter.md) feature to set what type of voting to do.

Sample:

```
votermode = 2                         ; 0 = no voting (default), 1 = voter one-shot, 2 = voter continuous
```

### votertype=
This option is used with the [Simple Voter](../adv-topics/simplevoter.md) feature to set what type of site this node is.

Sample:

```
votertype = 1                         ; 0 = no voting (default), 1 = voter repeater, 2 = voter receiver
```

The main/transmitter site would typically be a normal node, and have this option set to `1`. Remote receiver sites would have this option set to `2`.

### wait-times=
This option allows you to override the stanza name used for the `wait-times` stanza in `rpt.conf`. Wait times are a specific group of timers for the node.

Sample:

```
wait-times = wait-times             ; name wait-times to wait-times
```

The default is to have `wait-times=` point to a stanza called `wait-times`, and have a common set of commands for all nodes. However, you can have it point to another named stanza, see [Settings to Name Other Stanzas](./config-structure.md#settings-to-name-other-stanzas) for more information.

See [Wait Times Stanza](#wait-times-stanza) for more information on the timers that can be configured.

## Control States Stanza
There are several predefined mnemonics (keywords) used in the `[controlstates]` stanza to enable and disable the various features of the controller. These mnemonics correspond to the control operator command (COP) to be executed and most of these are the same groups of letters announced on air when a single control operator command is executed on the controller.

Mnemonic|Description|COP Method
--------|-----------|----------
rptena|Repeater Enable|2
rptdis|Repeater Disable|3
totena|Timeout Timer Enable|7
totdis|Timeout Timer Disable|8
apena|Autopatch Enable|9
apdis|Autopatch Disable|10
lnkena|Link Enable|11
lnkdis|Link Disable|12
skena|Scheduler Enable|15
skdis|Scheduler Disable|16
ufena|User Functions Enable|17
ufdis|User Functions Disable|18
atena|Alternate Hangtime Enable|19
atdis|Alternate Hangtime Disable|20
noice|No Incoming Connections Enable|49
noicd|No Incoming Connections Disable|50
slpen|Sleep Mode Enable|51
slpds|Sleep Mode Disable|52

The above mneonics can be grouped together in the `[controlstates]` stanza, to define different modes of operation for the node.

Sample:

```
[controlstates]
0 = rptena,lnkena,apena,totena,ufena,noicd  ; Normal operation                                  
1 = rptena,lnkena,apdis,totdis,ufena,noice  ; Net and news operation                                             
2 = rptena,lnkdis,apdis,totena,ufdis,noice  ; Repeater only operation
```

Therefore, instead of issuing all the individual COP commands to change the repeater state, you can use `cop,14` to set the control state:

From the Asterisk CLI (changing to control state 1):

```
asl*CLI> rpt cmd <nodenumber> cop 14 1
```

In a script:

```
asterisk -rx "rpt cmd <nodenumber> cop 14 1"
```

Or in a macro:

```
[macro]
2 = cop,13                          ; macro 2 to query current control state
3 = cop,14,1                        ; macro 3 to change to control state 1
```

You can also use `cop,13` to query the current control state that is selected:

From the Asterisk CLI:

```
asl*CLI> rpt cmd <nodenumber> cop 13
```

In a script:

```
asterisk -rx "rpt cmd <nodenumber> cop 13"
```

When you execute any of the above commands, Asterisk will play "SS" and then the control state number over the air.


## DTMFKeys Stanza
The `[dtmfkeys]` stanza is a named stanza pointed to by the [`dtmfkeys=`](#dtmfkeys) option. The key/value pairs in this stanza define the DTMF sequence(s) and associated callsign(s) that are required to "key-up" the node. This stanza is typically named `[dtmfkeys]`. The name can be overridden, on a per-node basis, see [Settings to Name Other Stanzas](./config-structure.md#settings-to-name-other-stanzas) for more information.

Sample:

```
1234=WB6NIL
4567=W1AW
```

In order to use the data in this stanza, [`dtmfkey=1`](#dtmfkey) must also be set.

The above example will require either of the DTMF sequences `1234` or `4567` to be sent for **every** transmission, in order to "key-up" the node. Depending on which sequence is sent, the associated callsign will be logged by Asterisk.

## Functions Stanza
The `[functions]` stanza is a named stanza pointed to by the [`functions=`](#functions) option. Functions within this stanza are used to decode DTMF commands when accessing the node from its **receiver**. This stanza is typically named `[functions]`. The name can be overridden, on a per-node basis, see [Settings to Name Other Stanzas](./config-structure.md#settings-to-name-other-stanzas) for more information.  

Sample:

```
functions = functions               ; name the functions stanza functions

[functions]
...
```

See [DTMF Commands](#dtmf-commands) for the list of functions available.

### Function Classes
Function classes are names for categories of functions. There are several function classes defined. They are described in the table below:

Class|Description
-----|-----------
cop|Control operator commands
ilink|Internet linking commands
status|User status commands
autopatchup|Autopatch up commands
autopatchdn|Autopatch down commands
remote|Remote base commands
macro|Command macros

Most of the above command classes require a [`function method`](#function-methods) and possibly one or more additional [`function option`](#function-options) parameters. Function methods are discussed next.

### Function Methods
Function methods are numbers which identify a specific function to execute within a `function class`. Function methods may be optional and in some cases should be omitted (such as with the autopatchup method). A complete and up-to-date description of all `function methods` can be found in the [`app_rpt.c`](https://github.com/AllStarLink/app_rpt/blob/master/apps/app_rpt.c)  source file. Some `function methods` are shown below as an example below:


Method|Description
------|-----------
1|Force ID (global)
2|Give Time of Day (global)
3|Give software Version (global)
4|Give GPS location info
5|Speak the last (dtmf) user 
11|Force ID (local only)
12|Give Time of Day (local only)

### Function Options
Some `function methods` can take `function options`. These are specified after the `function method`, separated with commas. Not all commands require or take `function options`. An example of a method which can accept `function options` is the `autopatchup` method.

### Putting it all Together
A small excerpt from the function stanza of `rpt.conf` is shown below.

```
 [functions]
 1=ilink,1                                             ; specific link disconnect
 6=autopatchup,noct=1,farenddisconnect=1,dialtime=2000 ; autopatch up
```

The above example contains DTMF functions with all of the parameters discussed on previously.

In the above example:

* `*1` followed by a node number disconnects a specific link, recall that `*` is the default [`funcchar`](#funcchar). The `function class` is `ilink` and the `function method` is `1`
* `*6` followed by a phone number brings up the autopatch with the `function options` specified. Note that there is no `function method` defined, but there are `function options` present.

## Link Functions Stanza
The `[my_link_functions]` stanza, if defined (see below), is a named stanza pointed to by the [`link_functions`](#link_functions) option. Functions within this stanza are used decode DTMF commands when accessing the node **via a link from another node**. 

The traditional usage is to point the `link_functions=` option to the same stanza as named by [`functions=`](#functions), thereby having functions from a linked node and from the local node be the same.

Sample:

```
functions = functions               ; name the functions stanza functions
link_functions = functions          ; use the same stanza 

[functions]
...
```

If a different set of either limited or more capable functions is desired:

```
functions = functions               ; name the functions stanza functions
link_functions = my_link_functions  ; use a different stanza

[functions]
...

[my_link_functions]
...
```

See [DTMF Commands](#dtmf-commands) for the list of functions available.

## Macro Stanza
The `[macro]` stanza is a named stanza pointed to by the [`macro=`](#macro) option. Macros are DTMF shortcuts. 

Sample:

```
macro=macro                         ; use stanza named macros

[macro]
1 = *32000*32001                    ; connect to nodes 2000 and 2001
```

See the [Macro](../adv-topics/macros.md) page for more information on macros.

## MDC Macro Stanza
The `[mdcmacro]` stanza is a named stanza pointed to by the [`mdcmacro=`](#mdcmacro) option. Mdcmacros are actions to carry out when [MDC-1200 signalling](../adv-topics/mdc1200.md) is received. 

Sample:

```
mdcmacro=mdcmacro                   ; use stanza named mdcmacro

[mdcmacro]
I1701=*81#                          ; announce the time with unit 1701 IDs
```

See the [MDC-1200 Signalling](../adv-topics/mdc1200.md) page for more information.

## Morse Stanza
The `[morse]` stanza is a named stanza pointed to by the [`morse=](#morse) option.

Sample:

```
[morse]
speed = 20                          ; approximate speed in WPM
frequency = 900                     ; morse Telemetry Frequency in Hz
amplitude = 4096                    ; morse Telemetry Amplitude (relative level)
idfrequency = 746                   ; morse ID Frequency in Hz
idamplitude = 768                   ; morse ID Amplitude (relative level)
```
Note that `frequency` and `amplitude` would set the parameters for telemetry messages, whereas `idfrequency` and `idamplitude` would set the parameters specifically for identification (and they do not need to be the same).

## Nodes Stanza
The `[nodes]` stanza is a list of nodes, their IP addresses, port and `NONE` or `NO` for non-remote base (normal) nodes. The nodes stanza is used to identify which node is mapped to which Internet call and to determine the destination to send the call to. 

If you are using automatic update for AllStarLink (public) nodes, no AllStarLink nodes should be defined here. Only place a definition for your local nodes (on your local LAN behind the same NAT router), private (off of AllStarLink) nodes, and remote base nodes here.

Sample:

```
[nodes]
1000 = radio@127.0.0.1/1000,NONE               ; private hub on this server 
1001 = radio@host.domain.com/1001,NONE         ; private node on another server
2501 = radio@127.0.0.1/2501,NONE               ; public node on this server
2502 = radio@127.0.0.1/2502,NONE               ; another public node on this server
2503 = radio@192.168.1.20:4570/2503,NONE       ; public node behind the same NAT router
1998 = radio@127.0.0.1/1999,Y                  ; remote base node on this server
```

For remote base nodes, replace the `NONE` with `Y` or `YES`. Once designated as a remote base, that node will only allow **one connection** (link) for use, command, and control.

The `[nodes]` stanza performs a function similar to an OS hosts file. When looking up node information, `app_rpt` looks in the `[nodes]` stanza first then searches (what could be called the Allstar DNS) the `/var/lib/asterisk/rpt_extnodes` file.

## Phone Functions Stanza
The `[my_phone_functions]` stanza is a named stanza pointed to by the [`phone_functions=`](#phone-functions-stanza) option. Functions within this stanza are used decode DTMF commands when **accessing the node from a telephone**. 

The traditional usage is to point `phone_functions=` to the same stanza as named by [`functions=`](#functions), thereby having functions from a phone and from the local node be the same. 

Sample:

```
functions = functions               ; name the functions stanza functions
phone_functions = functions         ; use the same stanza 

[functions]
...
```

If a different set of either limited or more capable functions is desired:

```
functions = functions                ; name the functions stanza functions
phone_functions = my_phone_functions ; use a different stanza

[functions]
...

[my_phone_functions]
...
```

See [DTMF Commands](#dtmf-commands) for the list of functions available.

## Schedule Stanza
This stanza is named by the [`scheduler=`](#scheduler) option. The scheduler can execute **macros** at certain times. For example for a net on Tuesday nights at 8 PM.

Sample:

```
scheduler=schedule   ; name the stanza 'schedule'

[schedule]                                                                      
;dtmf_function =  m h dom mon dow  ; ala cron, star is implied                                                  
2 = 00 00 * * *   ; at midnight every day, execute macro 2.
```

See the [Scheduled Events](../adv-topics/scheduler.md) page for more details.

## Telemetry Stanza
This stanza is named by the [`telemetry=`] option. Telemetry entries can be shared across all nodes on the `Asterisk/app_rpt` server, or defined for each node. They can be a tone sequence, morse string, or a file as follows:

* `|t` - Tone escape sequence:
    * Tone sequences consist of 1 or more 4-tuple entries (freq1, freq2, duration, amplitude). Single frequencies are created by setting freq1 or freq2 to zero.
* `|m` - Morse escape sequence:
    * Sends Morse code at the **telemetry amplitude and telemetry frequency** as defined in the `[morse]` section. Follow with an alphanumeric string.
* `|i` - Morse ID escape sequence:
    * Sends Morse code at the **ID amplitude and ID frequency** as defined in the `[morse]` section. Follow with an alphanumeric string.
* Path to sound file:
    * Specify the path to a sound file on the server. Do not include file extension.

Sample:

```
[telemetry]
ct1=|t(350,0,100,2048)(500,0,100,2048)(660,0,100,2048)
ct2=|t(660,880,150,2048)  
ct3=|t(440,0,150,4096) 
ct4=|t(550,0,150,2048)
ct4=|t(2475,0,250,768)
ct5=|t(660,0,150,2048)
ct6=|t(880,0,150,2048)
ct7=|t(660,440,150,2048)
ct8=|t(700,1100,150,2048)
ct9=filename-without-extension

;remotetx=|t(1633,0,50,3000)(0,0,80,0)(1209,0,50,3000)
remotetx=|t(880,0,150,2048) 
remotemon=|t(1209,0,50,2048) 
cmdmode=|t(900,903,200,2048)
functcomplete=|t(1000,0,100,2048)(0,0,100,0)(1000,0,100,2048)
patchup=rpt/callproceeding
patchdown=rpt/callterminated

What the numbers mean,
 (000,000,010,000)
   |   |   |   |-------amplitude
   |   |   |-------------duration
   |   |-------------------Tone 2
   |-------------------------Tone 1
```
See the [Courtesy Tones](../adv-topics/courtesytones.md) page for more information on defining telemetry tones.

See the [Sound Files](../adv-topics/soundfiles.md) page for more information on sound file locations.

## Tonemacro Stanza
The `[tonemacro]` stanza is a named stanza pointed to by the [`tonemacro=`](#tonemacro) option. Tonemacros are macros that are executed upon receipt of a specific CTCSS tone.

Sample:

```
tonemacro = tonemacro               ; user stanza named tonemacro

[tonemacro]

100.0 = *671
```

Format: `CTCSS Tone = macro to execute`.

See the [Tone Macros](../adv-topics/tonemacros.md) page on how to utilize tone macros.

## Wait Times Stanza
This stanza is named by the [`wait-times=`](#wait-times) option. The wait time stanza is used to set delay time between various node actions and their response. Values are in milliseconds.

Sample:

```
wait-times = wait-times             ; name the stanza wait-times

[wait-times]                                                                                                 
telemwait = 600                     ; time to wait before sending most
idwait = 600                        ; time to wait before starting ID
unkeywait = 800                     ; time to wait after unkey before sending CT's and link telemetry
calltermwait = 2000                 ; time to wait before announcing "call terminated"
```
