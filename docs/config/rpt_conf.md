# Rpt.conf
Rpt.conf (`/etc/asterisk/rpt.conf`) is where the majority of user-facing features, such as the node's CW and voice ID, DTMF commands and timers are set. There is a lot of capability here which can be difficult to grasp. Fortunately the default [https://github.com/AllStarLink/app_rpt/blob/master/configs/rpt/rpt.conf](https://github.com/AllStarLink/app_rpt/blob/master/configs/rpt/rpt.conf) is well commented and will work fine for most node admins.

See also [config file templating](../adv-topics/conftmpl.md/#asterisk-templates).

## DTMF Commands
DTMF commands are placed in any one of **three** *named stanzas*. These stanzas control access to DTMF commands that a user can issue from various 
control points.

* The [Fuctions Stanza](#functions-stanza) - to decode DTMF from the node's local receiver.
* The [Link Functions Stanza](#link-functions-stanza) - to decode DTMF from linked nodes.
* The [Phone Functions Stanza](#phone-functions-stanza) - to decode DTMF from telephone connects.
 
A DTMF key/value pair has the following format:

`dtmfcommand=functionclass,[functionmethod],[parameters]`

Where:

* `dtmfcommand` is a DTMF digit sequence **minus** the [start character](#funcchar) (usually \*, so a `dtmfcommand` of 81 would actually be *81 when entered via radio)
* `functionclass` is a string which defines what class of command; `link`, `status`, or `COP`
* `functionmethod` defines the optional method number to use in the function class
* `parameters` are one or more optional comma separated parameters which further define a command.

### Status Commands
The `functionclass` of `status` commands provide general information about the node. 

Sample:
```
712 = status,12   ; Give Time of Day (local only)
```

<table>
<tr><td>Status</td><td>Description</td></tr>
<tr><td>1</td><td>Force ID (global)</td></tr>
<tr><td>2</td><td>Give Time of Day (global)</td></tr>
<tr><td>3</td><td>Give software Version (global)</td></tr>
<tr><td>4</td><td>Give GPS location info</td></tr>
<tr><td>5</td><td>Speak the last (dtmf) user</td></tr> 
<tr><td>11</td><td>Force ID (local only)</td></tr>
<tr><td>12</td><td>Give Time of Day (local only)</td></tr>
</table>

### Link Commands
The `functioncalss` of `link` commands affect connecting to, disconnecting from, monitoring (RX only) other nodes, and providing linking status. 

Sample:
```
3 = ilink,3   ; Connect specified link -- transceive
```

**NOTE:** The above example creates the following DTMF command: *3&lt;nodenumber&gt;, which will use `ilink,3` to connect in transceive mode to the secified node number entered as part of the DTMF command.

See the table below for the available link commands, and whether they take a node number as a (required) parameter when being entered:

<table>
<tr><td>ilink</td><td>Description</td><td>Node Number Required</td></tr>
<tr><td>1</td><td>Disconnect specified link</td><td>Y</td></tr>
<tr><td>2</td><td>Connect specified link -- monitor only</td><td>Y</td></tr>
<tr><td>3</td><td>Connect specified link -- tranceive</td><td>Y</td></tr>
<tr><td>4</td><td>Enter command mode on specified link</td><td>Y</td></tr>
<tr><td>5</td><td>System status</td><td>N</td></tr>
<tr><td>6</td><td>Disconnect all links</td><td>N</td></tr>
<tr><td>7</td><td>Last Node to Key Up</td><td>N</td></tr>
<tr><td>8</td><td>Connect specified link -- local monitor only</td><td>Y</td></tr>
<tr><td>9</td><td>Send Text Message (9,&lt;destnodeno or 0 (for all)&gt;,Message Text, etc.)</td><td>N</td></tr>
<tr><td>10</td><td>Disconnect all RANGER links (except permalinks)</td><td>N</td></tr>
<tr><td>11</td><td>Disconnect a previously permanently connected link</td><td>Y</td></tr>
<tr><td>12</td><td>Permanently connect specified link -- monitor only</td><td>Y</td></tr>
<tr><td>13</td><td>Permanently connect specified link -- tranceive</td><td>Y</td></tr>
<tr><td>15</td><td>Full system status (all nodes)</td><td>N</td></tr>
<tr><td>16</td><td>Reconnect links disconnected with "disconnect all links"</td><td>N</td></tr>
<tr><td>17</td><td>MDC test (for diag purposes)</td><td>N</td></tr>
<tr><td>18</td><td>Permanently Connect specified link -- local monitor only</td><td>Y</td></tr>
</table>

**Permanent** links are links that `app_rpt` will try and keep connected (automatic redial) if there are network disruptions. Use `ilink,13` for situations like maintaining a connection from a node to a hub.

### COP Commands
The `functionclass` of `cop` (Control OPerator) commands are privileged commands. Node admins may provide some of these to their user community based on personal preference. 

Sample:
```
99 = cop,7   ; enable timeout timer
```

Some COP commands can take multiple parameters. For example this COP 48 would send #3#607 on command.

`900 = cop,48,#,3,#,6,0,7` 

<table>
<tr><td>COP</td><td>Description</td></tr>
<tr><td>1</td><td>System warm boot</td></tr>
<tr><td>2</td><td>System enable</td></tr>
<tr><td>3</td><td>System disable</td></tr>
<tr><td>4</td><td>Test Tone On/Off</td></tr>
<tr><td>5</td><td>Dump System Variables on Console (debug)</td></tr>
<tr><td>6</td><td>PTT (phone mode only)</td></tr>
<tr><td>7</td><td>Time out timer enable</td></tr>
<tr><td>8</td><td>Time out timer disable</td></tr>
<tr><td>9</td><td>Autopatch enable</td></tr>
<tr><td>10</td><td>Autopatch disable</td></tr>
<tr><td>11</td><td>Link enable</td></tr>
<tr><td>12</td><td>Link disable</td></tr>
<tr><td>13</td><td>Query System State</td></tr>
<tr><td>14</td><td>Change System State</td></tr>
<tr><td>15</td><td>Scheduler Enable</td></tr>
<tr><td>16</td><td>Scheduler Disable</td></tr>
<tr><td>17</td><td>User functions (time, id, etc) enable</td></tr>
<tr><td>18</td><td>User functions (time, id, etc) disable</td></tr>
<tr><td>19</td><td>Select alternate hang timer</td></tr>
<tr><td>20</td><td>Select standard hang timer</td></tr>
<tr><td>21</td><td>Enable Parrot Mode</td></tr>
<tr><td>22</td><td>Disable Parrot Mode</td></tr>
<tr><td>23</td><td>Birdbath (Current Parrot Cleanup/Flush)</td></tr>
<tr><td>24</td><td>Flush all telemetry</td></tr>
<tr><td>25</td><td>Query last node un-keyed</td></tr>
<tr><td>26</td><td>Query all nodes keyed/unkeyed</td></tr>
<tr><td>27</td><td>Reset DAQ minimum on a pin</td></tr>
<tr><td>28</td><td>Reset DAQ maximum on a pin</td></tr>
<tr><td>30</td><td>Recall Memory Setting in Attached Xcvr</td></tr>
<tr><td>31</td><td>Channel Selector for Parallel Programmed Xcvr</td></tr>
<tr><td>32</td><td>Touchtone pad test: command + Digit string + # to playback all digits pressed</td></tr>
<tr><td>33</td><td>Local Telemetry Output Enable</td></tr>
<tr><td>34</td><td>Local Telemetry Output Disable</td></tr>
<tr><td>35</td><td>Local Telemetry Output on Demand</td></tr>
<tr><td>36</td><td>Foreign Link Local Output Path Enable</td></tr>
<tr><td>37</td><td>Foreign Link Local Output Path Disable</td></tr>
<tr><td>38</td><td>Foreign Link Local Output Path Follows Local Telemetry</td></tr>
<tr><td>39</td><td>Foreign Link Local Output Path on Demand</td></tr>
<tr><td>42</td><td>Echolink announce node # only</td></tr>
<tr><td>43</td><td>Echolink announce node Callsign only</td></tr>
<tr><td>44</td><td>Echolink announce node # and Callsign</td></tr>
<tr><td>45</td><td>Link Activity timer enable</td></tr>
<tr><td>46</td><td>Link Activity timer disable</td></tr>
<tr><td>47</td><td>Reset "Link Config Changed" Flag</td></tr>
<tr><td>48</td><td>Send Page Tone (Tone specs separated by parenthesis)</td></tr>
<tr><td>49</td><td>Disable incoming connections (control state noice)</td></tr>
<tr><td>50</td><td>Enable incoming connections (control state noicd)</td></tr>
<tr><td>51</td><td>Enable sleep mode</td></tr>
<tr><td>52</td><td>Disable sleep mode</td></tr>
<tr><td>53</td><td>Wake up from sleep</td></tr>
<tr><td>54</td><td>Go to sleep</td></tr>
<tr><td>55</td><td>Parrot Once if parrot mode is disabled</td></tr>
<tr><td>56</td><td>Rx CTCSS Enable</td></tr>
<tr><td>57</td><td>Rx CTCSS Disable</td></tr>
<tr><td>58</td><td>Tx CTCSS On Input only Enable</td></tr>
<tr><td>59</td><td>Tx CTCSS On Input only Disable</td></tr>
<tr><td>60</td><td>Send MDC-1200 Burst (cop,60,type,UnitID[,DestID,SubCode])
Type is 'I' for PttID, 'E' for Emergency, and 'C' for Call 
(SelCall or Alert), or 'SX' for STS (status), where X is 0-F.
DestID and subcode are only specified for  the 'C' type message.
UnitID is the local systems UnitID. DestID is the MDC1200 ID of
the radio being called, and the subcodes are as follows: 
Subcode '8205' is Voice Selective Call for Spectra ('Call')
Subcode '8015' is Voice Selective Call for Maxtrac ('SC') or
Astro-Saber('Call')
Subcode '810D' is Call Alert (like Maxtrac 'CA')</td></tr>
<tr><td>61</td><td>Send Message to USB to control GPIO pins (cop,61,GPIO1=0[,GPIO4=1]...)</td></tr>
<tr><td>62</td><td>Send Message to USB to control GPIO pins, quietly (cop,62,GPIO1=0[,GPIO4=1]...)</td></tr>
<tr><td>63</td><td>Send pre-configred APRSTT notification (cop,63,CALL[,OVERLAYCHR])</td></tr>
<tr><td>64</td><td>Send pre-configred APRSTT notification, quietly (cop,64,CALL[,OVERLAYCHR])</td></tr> 
<tr><td>65</td><td>Send POCSAG page (equipped channel types only)</td></tr>
</table>

## General Stanza
ASL3 introduces a new stanza in `rpt.conf`, the `[general]` stanza.

Presently, this stanza just contains a `key=value` for how node lookups are handled:

```
[general]
node_lookup_method = both           ;method used to lookup nodes
                                    ;both = dns lookup first, followed by external file (default)
                                    ;dns = dns lookup only
                                    ;file = external file lookup only
```

See [New Commands](../adv-topics/commands.md#app_rpt-commands) for how this new node lookup method is handled.

## Node Number Stanza
The node number stanza is a critical stanza in `rpt.conf`. 

```
[1999]    ; Replace with your assigned or private node number
```

The node number stanza is set to the **assigned node number** *or* a **private node number** (if a private node is being configured). It will normally be configured by [asl-menu](../user-guide/menu.md).

The node number stanza contains all the configurable options for that specific node using a `key=value` pair syntax. The following configurable options are available to use:

### accountcode=
This option is optional, it sets the `ACCOUNTCODE` variable to be passed back to other Asterisk applications, namely for call detail records (CDR).

Sample:
```
accountcode=RADIO   ; set the accountcode variable to RADIO
```

### althangtime=
This controls the length of the repeater hang time when the alternate hang timer is selected with a control operator function. It is specified in milliseconds. 

Sample:
```
althangtime=4000   ; 4 seconds
```

### aprstt=
This option enables aprstt. Set the `aprstt=` option to a matching context in `/etc/asterisk/gps.conf` to enable. You also need to have the `app_gps.so` module loaded in `/etc/asterisk/modules.conf`.

Sample:
```
aprstt = general             ;  Point to the [general] context in gps.conf
```

See the comments in `gps.conf` for more details on configuring.

### archivedir=
The `archivedir=` option is used to enable a simple log and audio recorder of the activity on a node. When enabled, a series of recordings, one for each active COR on the node, is generated. The file(s) will be named with the date and time down to the 1/100th of a second. This logging can be useful in debugging, policing, or other creative things.

Sample:
```
archivedir = /var/spool/asterisk/monitor ; top-level recording directory
```

The [`archivedir=`](#archivedir) and [`archiveformat=`](#archiveformat) options can be implemented in the `[node-main](!)` stanza to apply to all nodes on the server, or in the per-node stanza for recording individual nodes. See [config file templating](../adv-topics/conftmpl.md/#asterisk-templates) for more information.

**NOTE:** Enabling this function can adversly impact the CPU utilization on the device, and consume large amounts of the available storage. You would be wise to implement a script or look at a utility such as `logrotate` to periodically flush old recordings and logs.

### archiveformat=
The `archiveformat` option specifies the format of the audio recordings in [`archivedir=`](#archivedir). By default, the format will be "wav49" (GSM in a .WAV file). Other options you may consider include "wav" (SLIN in a .wav file) and "gsm" (GSM in straight gsm format).

Sample:
```
archiveformat = wav49                    ; audio format (default = wav49)
```

### beaconing=
When set to 1 will send the repeater ID at the idtime interval regardless of whether there was repeater activity or not. This feature appears to be required in the UK, but is probably illegal in the US.

Sample:
```
beaconing=1   ;Set to 1 to beacon. Defaults to 0
```

### callerid=
This setting allows the autopatch on the node to be identified with a specific caller ID. The default setting is as follows

```
callerid="Repeater" <0000000000>
```

**Note**: The value in quotes is the name of the autopatch caller, and the numbers in angle brackets are the originating telephone number to use.

### connpgm= and discpgm=
Runs user defined scripts. Example from [https://www.qsl.net/k0kn/swissarmy_debian](https://www.qsl.net/k0kn/swissarmy_debian)

`connpgm` executes a program you specify on connect. It passes 2 command line arguments to your program:

1. node number in this stanza (us)
2. node number being connected to us (them)

`discpgm` executes a program you specify on disconnect. It passes 2 command line arguments to your program:

1. node number in this stanza (us)
2. node number being connected to us (them)                         

Sample:
```
# Place these lines in rpt.conf for each node:
#     connpgm=/home/kyle/swissarmy 1
#     discpgm=/home/kyle/swissarmy 0
```

### context=
This setting directs the autopatch for the node to use a specific context in `extensions.conf` for outgoing autopatch calls. The default is to specify a context name of radio.

```
context=radio
```

### controlstates=
The `controlstates` option allows you to override the stanza name used for the `controlstates` stanza in `rpt.conf`. Control states are an optional feature which allows groups of control operator commands to be executed all at once. To use control states, define an entry in your node stanzas to point to a dedicated control states stanza like this:

```
controlstates = controlstates   ; points to control state stanza

[controlstates]
0 = rptena,lnkena,apena,totena,ufena,noicd  ; Normal operation                                  
1 = rptena,lnkena,apdis,totdis,ufena,noice  ; Net and news operation                                             
2 = rptena,lnkdis,apdis,totena,ufdis,noice  ; Repeater only operation
```

The default is to have `controlstates=` point to a stanza called `controlstates`. However, you can have it point to another named stanza, see [Settings to Name Other Stanzas](./config-structure.md#settings-to-name-other-stanzas) for more information.

The [Control States Stanza](#control-states-stanza) describes these mnemonics in detail.

### duplex=
This setting sets the duplex mode for desired radio operation. Duplex mode 2 is the default if nonthing specified.

<table>
<tr><td>Duplex</td><td>Mode Description</td></tr> 
<tr><td>0</td><td>Half duplex with no telemetry tones or hang time. Special Case: Full duplex if linktolink is set to yes. This mode is preferred when interfacing with an external multiport repeater controller. Comment out idrecording and idtalkover to suppress IDs.</td></tr> 
<tr><td>1</td><td>Half duplex with telemetry tones and hang time. Does not repeat audio. This mode is preferred when interfacing a simplex node.</td></tr> 
<tr><td>2</td><td>Full Duplex with telemetry tones and hang time. This mode is preferred when interfacing a repeater.</td></tr>  
<tr><td>3</td><td>Full Duplex with telemetry tones and hang time, but no repeated audio.</td></tr> 
<tr><td>4</td><td>Full Duplex with telemetry tones and hang time. Repeated audio only when the autopatch is down.</td></tr> 
</table>

Sample:
```
duplex = 0     ; 0 = Half duplex with no telemetry tones or hang time.
```

### eannmode= 
This setting sets the Echolink node announcement type, when a node connects:

* 1 = Say only node number (default)
* 2 = Say phonetic call sign only on echolink connects
* 3 = Say phonetic call sign and node number on echolink connects

### echolinkdefault=
This setting sets the Echolink telemetry option:

* 0 = telemetry output off
* 1 = telemetry output on
* 2 = timed telemetry output on command execution and for a short time thereafter
* 3 = follow local telemetry mode

### echolinkdynamic=
This setting enables/disables the Echolink telemetry COP command.

* 0 = disallow users to change current echolink telemetry setting with a COP command
* 1 = Allow users to change the setting with a COP command

### endchar=
This setting allows the end character used by some control functions to be changed. By default this is a #. The `endchar` value must not be the same as the [`funcchar`](#funcchar) default (*) or its overridden value.

### erxgain=
This setting adjusts the Echolink receive gain in +/- dbV. It is used to balance Echolink recieve audio levels on an `app_rpt` node. 

```
erxgain = -3
```

See the Echolink How-to for more information.

### etxgain=
This setting adjusts the Echolink transmit gain in +/- dbV. It is used to balance Echolink transmit audio on an `app_rpt` node. 

```
etxgain = 3
```

See the Echolink How-to for more information.

### events=
The `events` option allows you to override the stanza name used for the `events` stanza in `rpt.conf`. As of app_rpt version 0.259, 10/9/2010, there exists a method by which a user can specify actions to be taken when certain events occur, such as transitions in receive and transmit keying, presence and modes of links, and external inputs, such as GPIO pins on the URI (or similar USB devices).

Bear in mind, this now also includes the ability to set the condition of external devices, such as output pins on a URI (or similar USB devices), or a Parallel Printer Port.

To use events, define an entry in your node stanzas to point to a dedicated events stanza like this:

```
events = events   ; points to the events stanza

[events]
;;;;; Events Management ;;;;;
status,2 = c|f|RPT_NUMLINKS      ; Say time of day when all links disconnect.
```

The default is to have `events=` point to a stanza called `events`. However, you can have it point to another named stanza, see [Settings to Name Other Stanzas](./config-structure.md#settings-to-name-other-stanzas) for more information.

See [Event Management](https://wiki.allstarlink.org/wiki/Event_Management) for a more detailed look on how to configure events.

### extnodefile=
**This option is deprecated in ASL3 and has been replaced by** `node_lookup_method=`. See [Node Resolutuion](../adv-topics/noderesolution.md) for information on how to configure node lookups. 

The `extnodefile` option allows you to set the name of the external node lookup file. The default value is '/var/lib/asterisk/rpt_extnodes'. This file is used to look up node information when linking to other nodes.  It is also used to validate nodes that are connecting to your node.

```
extnodefile=/var/lib/asterisk/rpt_extnodes
```

The default file is automatically updated using the node update script or the `asl-node-diff` script.

The `extnodefile` key/value supports multiple file names. In some cases, you may want the default file along with a static locally maintained node file.  Multiple file names can be entered by separating them with a comma. A maximum of 100 external files can be specified.

```
extnodefile=/var/lib/asterisk/rpt_extnodes,/var/lib/asterisk/myrpt_extnodes
```

If a custom `extnodefile` is used, it must have the section header `[extnodes]` or a custom header as described in [extnodes](#extnodes).

**This option does not appear in the default `rpt.conf`.**

### extnodes=
The `extnodes` option allows you to set the section name used for `[extnodes]` in the `rpt_extnodes` file.  The default value is `extnodes`. This translates to `[extnodes]` section header. 

```
extnodes=myextnodes
```

In this example, you would need to configure the section `[myextnodes]` in your custom `rpt_extnodes` file.  `app_rpt` will no longer look for an `[extnodes]` section header for this node, it will look for `[myextnodes]` instead.

See the [extnodefile](#extnodefile) for more information on how the `extnodes` section is used.

**This option does not appear in the default `rpt.conf`.**

### funcchar=
This setting can be used to change the default function starting character of * to something else. Please note that the new value chosen must not be the same as the default (#) or overridden value for [`endchar=`](#endchar).

### functions=
The `functions` option allows you to override the stanza name used for the `functions` stanza in `rpt.conf`. Functions are used to decode DTMF commands when accessing the node from its receiver. To use functions, define an entry in your node stanzas to point to a dedicated function stanza like this:

Sample:
```
functions = functions   ; pointer to functions stanza
```
The default is to have `functions=` point to a stanza called `functions`, and have a common set of commands for all nodes. However, you can have it point to another named stanza, see [Settings to Name Other Stanzas](./config-structure.md#settings-to-name-other-stanzas) for more information.

See the [Functions Stanza](#functions-stanza) for more detail on defining functions.

### hangtime=
This option controls the length of the repeater (squelch tail) hang time. It is specified in milliseconds. 

Sample:
```
hangtime = 1000   ;Set hang time for 1 second
```

The default is 5000(ms), or 5sec.

### holdofftelem=
This option forces all telemetry to be held off until a local user on the receiver or a remote user over a link unkeys. There is one exception to this behavior, and that is when an ID needs to be sent and there is activity coming from a linked node.

Sample:
```
holdofftelem = 0   ;Set to 1 to hold off. Default is 0
```

### idrecording=
The identifier message is stored in the node stanza using the `idrecording` key. It can be changed to a different call sign by changing the value to something different. The value can be either a morse code identification string (when prefixed with `|i`), or the name of a sound file containing a voice identification message. When using a sound file, the default path for the sound file is `/var/lib/asterisk/sounds`. Example usages are as follows:

Sample:
```
idrecording = |iwa6zft/r   ; Morse Code ID
```
or
```
idrecording = /var/lib/asterisk/sounds/myid   ; Voice ID
```

**Note:** ID recording files must have extension gsm, ulaw, pcm, or wav. The extension is **left off** when it is defined as the example shows above. File extensions are used by Asterisk to determine how to decode the file. All ID recording files should be sampled at 8KHz. See Recording Audio Files for more information (link pending).

### idtalkover=
The ID talkover message is stored in the node stanza using the `idtalkover` setting. The purpose of `idtalkover` is to specify an *alternate* ID to use when the ID must be sent **over the top** of a user transmission. This can be a shorter voice ID or an ID in morse code. The value can be either a morse code identification string (when prefixed with `|i`), or the name of a sound file containing a voice identification message. When using a sound file, the default path for the sound file is `/var/lib/asterisk/sounds`. Example usages are as follows:

Sample:
```
idtalkover = |iwa6zft/r   ; Morse Code ID
```
or
```
idtalkover = /var/lib/asterisk/sounds/myid   ; Voice ID
```

**Note:** ID recording files must have extension gsm,ulaw,pcm, or wav. The extension is left off when it is defined as the example shows above. File extensions are used by Asterisk to determine how to decode the file. All ID recording files should be sampled at 8KHz. See Recording Audio Files for more information (link pending).

### idtime=
This option sets the ID interval time, in mS. It is optional.

Sample:
```
idtime = 540000                     ; id interval time (in ms) (optional)
```

The default is 5 minutes (300000mS).

### inxlat=
The `inxlat` (input translate) option allows complete remapping of the [`funcchar`](#funcchar) and [`endchar`](#endchar) digits to different digits or digit sequences.

`inxlat` acts on the digits received by the radio receiver on the node.

Format: `inxlat = funchars,endchars,passchars[,dialtone]`

where:

* `funcchars` is the digit or digit sequence to replace `funcchar`
* `endchars` is the digit or digit sequence to replace `endchar`
* `passchars` are the digits to pass through (can be used to block certain digits)
* `dialtone` set to `y` to optionally play dialtone on a function.

Sample:
```
inxlat = #456,#457,0123456789ABCD ; string xlat from radio port to sys
```

In the above example, on inbound DTMF, translate #456 as `funchar` (normally *), #457 as `endchar` (normally #), and pass all other digits listed in `passchars` normally.

### link_functions=
The `link_functions` option allows you to override the stanza name used for the `link_functions` stanza in `rpt.conf`. The `link_functions=` setting directs the node to use a particular function stanza for functions dialed by users accessing the node **via a link from another node**. 

Sample:
```
link_functions = functions ; pointer to the function stanza
```

The default is to have `link_functions=` point to a stanza called `functions`, and have a common set of commands for all nodes. However, you can have it point to another named stanza, see [Settings to Name Other Stanzas](./config-structure.md#settings-to-name-other-stanzas) for more information.

See the [Functions Stanza](#functions-stanza) for more detail on defining functions.

### lnkactenable=
Set this option to enable the link activity timer. This applies to standard nodes only. 

Sample:
```
lnkactenable = 0                   ; Set to 1 to enable the link activity timer.
```

The default is `0` (disabled).

### lnkacttime=
Set the optional link activity timer (`lnkactenable` must be enabled for this to have any effect). The value is in seconds.

Sample:
```
lnkacttime = 1800                  ; Link activity timer time in seconds.
```

### lnkactmacro=
Play the defined macro when the link activity timer expires.

Sample:
```
lnkactmacro = *52                  ; Function to execute when link activity timer expires.
```

### lnkacttimerwarn=
Set this to the voice file to play when the link activity timer has 30 seconds remaining.

Sample:
```
lnkacttimerwarn = 30seconds        ; Message to play when the link activity timer has 30 seconds left.
```

### linkmongain=
Link monitor gain adjusts the audio level of monitored nodes when a signal from another node or the local receiver is received. If `linkmongain` is set to a negative number the monitored audio will decrease by the set amount in dB. If `linkmongain` set to a positive number monitored audio will increase by the set amount in dB. The value of `linkmongain` is in dB. The default value is 0dB.

Sample:
```
linkmongain = -20   ; reduce link volume 20dB
```

### linktolink=
When operating in [duplex mode 0](#duplex), this forces the radio interface to operate in full duplex mode, but keeps all the other "duplex mode 0" semantics. 

This is used when a radio interface is connected to a multiport analog repeater controller. The `linktolink=` option can take two values: `yes`/`1` or `no`/`0`.

Sample:
```
linktolink = no   ; set to yes to enable. Default is no.
```

### linkunkeyct=
The `linkunkeyct` option selects the courtesy tone to send when a connected remote node unkeys. The default is no courtesy tone when a remote node unkeys.

Sample:
```
linkunkeyct = ct8  ; use courtesy tone 8
```

### macro=
The `macro` option allows you to override the stanza name used for the `macro` stanza in `rpt.conf`. The macro stanza directs the node to use a particular stanza for macros dialed by users accessing the node. Macros are DTMF shortcuts, and are a special type of function. 

Sample:
```
macro=macro   ; use stanza named macro

[macro]
1 = *32000*32001     ; connect to nodes 2000 and 2001
```

The default is to have `macro=` point to a stanza called `macro`, and have a common set of commands for all nodes. However, you can have it point to another named stanza, see [Settings to Name Other Stanzas](./config-structure.md#settings-to-name-other-stanzas) for more information.

See the [Macro Stanza](#macro-stanza) for more detail on defining macros.

**This option does not appear in the default `rpt.conf`.**

### morse=
The `morse` option allows you to override the stanza name used for the `morse` stanza in `rpt.conf`. The morse stanza directs the node to use a particular stanza for morse code parameters for the node. Morse code parameters can be defined on a per-node basis.  

Sample:
```
morse=morse   ; use stanza named morse

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

The default location is `/var/lib/asterisk/sounds/rpt/nodenames`.

Sample:
```
nodenames = /var/lib/asterisk/sounds/rpt/nodenames.callsign  ; Point to alternate nodename sound directory
```

When a node connects/disconnects, Asterisk will look in this directory for a filename that matches the calling node number. If it finds such a file, it will play it as the connect/disconnect message.

### nodes=
The `nodes` option allows you to override the section name used for the '[nodes]' stanza in `rpt.conf`. The default value is `nodes`. The `[nodes]` stanza operates like a "hosts" file in an OS, and is the first place `app_rpt` looks to resolve how to reach a particular node.

```
nodes=mynodes
```

In this example, you would need to configure the section `[mynodes]` in `rpt.conf`.  `app_rpt` will no longer look for a `[nodes]` section header for this node, it will look for `[mynodes]` instead.

See the [Nodes Stanza](#nodes-stanza) for more information on how the nodes section is used.

**This option does not appear in the default `rpt.conf`, and as such, app_rpt uses the default stanza of `[nodes]`**

### nolocallinkct=
Set this option to send `unlinkedct` instead, if another local node is connected to this node (hosted on the same PC).

Sample:
```
nolocallinkct = 0     ; default is 0, set to 1 to enable 
```

### nounkeyct=
The `nounkeyct` option completely disables the courtesy tone. This is useful for eliminating TX tail time in applications using simplex uplinks to repeaters on the repeater pair itself.  This practice is **strongly** discouraged. The `nounkeyct=` option can take two values: `yes`/`1` or `no`/`0`.

Sample:
```
nounkeyct = no  ; Set to yes to disable :(. Default is no.
```

### outstreamcmd=
This option is used to configure the utilities to run on th system to support streaming the node's audio to a streaming server.

Sample:
```
outstreamcmd = /bin/sh,-c,/usr/bin/lame --preset cbr 16 -r -m m -s 8 --bitwidth 16 - - | /usr/bin/ezstream -qvc /etc/ezstream.xml
```
or
```
outstreamcmd = /usr/local/bin/nptee,broadcastify,otherstreamserver     ; Use the available nptee utility to stream to multiple servers at once
```

See [Streaming a Node to Broadcastify](../adv-topics/broadcastify.md) for further information and details on how to configure audio streaming of the node.

### outxlat=
The `outxlat` (output translate) option allows complete remapping of the [`funcchar`](#funcchar) and [`endchar`](#endchar) digits to different digits or digit sequences.

`outxlat` acts on the digits sent by the node to a link.

Format: `outxlat = funchars,endchars,passchars`

where:

* `funcchars` is the digit or digit sequence to replace `funcchar`
* `endchars` is the digit or digit sequence to replace `endchar`
* `passchars` are the digits to pass through (can be used to block certain digits).

Sample:
```
outxlat = *7,*0,0123456789ABCD ; string xlat from sys to radio port
```

In the above example, on outbound DTMF, *7 generates a `funchar` (normally *), *0 generates an `endchar` (normally #), and pass all other digits listed in `passchars` normally.

**NOTE:** This option is not well documented in the code, your mileage may vary.

### parrotmode=
The "parrot" repeats everything it hears. Use this option to create an "echo reflector node", where everything you transmit to the node will be played back when you unkey.

Sample:
```
parrotmode = 0                      ; 0 = Parrot Off (default = 0)
```
Parrot mode can operate in a number of different methods:

* 0 = Parrot Off (default = 0)
* 1 = Parrot On Command (see [`cop,21 and cop,22`](#cop-commands))
* 2 = Parrot Always
* 3 = Parrot Once by Command ([`cop,21`](#cop-commands) enables it for one shot before automatically turning off)

### parrottime=
This option sets the amount of time in mS to delay before playing back the audio buffer.

Sample:
```
parrottime = 1000                   ; Wait 1s (1000mS) before playback
```

### phone_functions=
The `phone_functions` option allows you to override the stanza name used for the `phone_functions` stanza in `rpt.conf`. Phone functions are a specific group of commands that are available when the node is accessed via phone.

Sample:
```
phone_functions = functions   ; name phone_functions to functions
```

The default is to have `phone_functions=` point to a stanza called `functions`, and have a common set of commands for all nodes. However, you can have it point to another named stanza, see [Settings to Name Other Stanzas](./config-structure.md#settings-to-name-other-stanzas) for more information.

See [Phone Functions Stanza](#phone-functions-stanza) for more information on the functions that can be configured.

### phonelinkdefault=
This option sets whether telemetry is sent down phone links.

```
phonelinkdefault = 1 
```

The available options are:

* 0 = telemetry output off
* 1 = telemetry output on 
* 2 = timed telemetry output on command execution and for a short time thereafter 
* 3 = follow local telemetry mode
* Default is 1

### phonelinkdynamic=
This option sets whether telemetry down phone links can be enabled/disabled by users using a COP command.

```
phonelinkdynamic = 1
```

The available options are:

* 0 = disallow users to change phone telemetry setting with a COP command
* 1 = Allow users to change the setting with a COP command
* Default is 1

### politeid=
The `politeid` setting specifies the number of milliseconds prior to the end of the ID cycle where the controller will attempt to play the ID in the tail when a user unkeys. If the controller does not get a chance to send the ID in the tail, the ID will be played over the top of the next user transmission. Optional, default 30000mS.

Sample:
```
politeid = 30000   ; 30 seconds
```

### propagate_dtmf=
This option takes either `yes`/`1` or `no`/`0`. When set to `yes`, DTMF **will** be regenerated from out-of-band signalling or from from the receiver DTMF decoder whenever a function start character is NOT detected, and command decoding has not begun. When set to `no`, no tones will be regenerated. The default for this setting is `no`.

This setting is meant to be used in conjunction with `linktolink`, `inxlat`, and `outxlat` when interfacing a radio port to a multiport analog repeater controller on an RF-linked system.

Sample:
```
propagate_dtmf = no
```
**Note:** There is a separate setting `propagate_phonedtmf` for use by dial-in (phone and dphone) users.

### remotect=
The `remotect` setting allows the selection of the remote linked courtesy tone so that the users can tell there is a [Remote Base](../adv-topics/remotebase.md#remote-base-nodes) connected locally.

Sample:
```
remotect = ct3   ; use courtesy tone 3
```

### remote_inact_timeout=
This option specifies the amount of time without keying from the link, before the link is determined to be inactive. Set to `0` to disable timeout.

Sample:
```
remote_inact_timeout = 0   ; do not time out
```

This is a [Remote Base](../adv-topics/remotebase.md#remote-base-nodes) option. See that section of the manual for more information.

### remote_timeout=
This option specifies the session time out for the remote base. Set to `0` to disable. This option does not appear to be implemented in code.

Sample:
```
remote_timeout = 0   ; do not timeout
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

```
rxbursttime= 250
```

**This option does not appear in the default `rpt.conf`.**

### rxchannel=
The `rxchannel` option selects the type of radio interface used by the node. There must be **one** (and only one) `rxchannel` per node definition stanza. The selections for `rxchannel` are: 

<table>
<tr><td>Value</td><td>Description</td></tr> 
<tr><td>dahdi/pseudo</td><td>No radio, used for hubs</td></tr> 
<tr><td>SimpleUSB/1999</td><td>SimpleUSB Channel Driver (limited DSP), specify associated node number found in simpleusb.conf</td></tr>  
<tr><td>Radio/1999</td><td>Usbradio Channel Driver (full DSP), specify associated node number found in usbradio.conf</td></tr>  
<tr><td>voter/1990</td><td>VOTER (RTCM) Channel Driver, specify associated node number found in voter.conf</td></tr>  
<tr><td>Pi/1</td><td>Raspberry Pi PiTA</td></tr>  
<tr><td>Dahdi/1</td><td>PCI Quad card, specify channel number</td></tr>  
<tr><td>Beagle/1</td><td>BeagleBoard</td></tr>   
<tr><td>USRP/127.0.0.1:34001:32001</td><td>GNU Radio interface USRP</td></tr> 
</table>

Sample:
```
rxchannel = dahdi/pseudo     ; No radio (hub)
```

**NOTE:** This is selecting what is known as (in Asterisk terminology) the *channel driver*.

**NOTE:** Be sure that any channel driver you use also has it's corresponding module being loaded in `/etc/asterisk/modules.conf`.

### rxnotch=
In order to use this option, `app_rpt` must have been compiled with the `notch` option. This option will notch a particular center frequency (in Hz) for a specified bandwidth (in Hz).

Sample:
```
rxnotch=1065,40                    ; Notch 1065Hz for +/-20Hz
```

**NOTE:** IF this option is available, it requires a great deal of CPU to perform and would probably be detrimental to use on the small boards. It isn't recommended for use.

### scheduler=
The `scheduler` option allows you to override the stanza name used for the `schedule` stanza in `rpt.conf`. The scheduler is used to execute commands at a particular time.

Sample:
```
scheduler = schedule   ; name scheduler to 'schedule'

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

### startup_macro=
The `startup_macro` is executed once on system startup. Each node can have **one** startup macro defined in its node stanza.

Sample:
```
startup_macro = *31000 *31001 *31002   ; Connect to nodes 1000, 1001 and 1002 at startup
```

One string of one or multiple commands, executed in order. 

**NOTE:** This string of commands does NOT terminate with a # like a normal macro. You can call any number of regular macros with it.

### startup_macro_delay=
This option causes the system to wait a specified number of seconds upon startup, before executing the [`startup_marco`](#startup_macro).

Sample:
```
startup_macro_delay = 5                    ; wait 5s before running the startup_macro
```

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
;statpost_url = http://stats.allstarlink.org/uhandler ; Status updates
```

The `statspost_url=` option can be implemented in the `[node-main](!)` stanza to apply to all nodes on the server, or in the per-node stanza for limiting statistics posting to an individual nodes. See [config file templating](../adv-topics/conftmpl.md/#asterisk-templates) for more information.

### tailmessagelist=
The `tailmessagelist` setting allows a comma-separated list of audio files to be specified for the tail message function. The tail messages will rotate from one to the next until the end of the list is reached, at which point the first message in the list will be selected. If no absolute path name is specified, the directory `var/lib/asterisk/sounds` will be searched for the sound file. The file extension should be omitted.

Sample:
```
tailmessagelist = welcome,clubmeeting,wx   ; rotate 3 tail messages
```

Tail messages can be "squashed" if a user keys up over them.

**Note:** ID recording files must have extension gsm,ulaw,pcm, or wav. The extension is left off when it is defined as the example shows above. File extensions are used by Asterisk to determine how to decode the file. All ID recording files should be sampled at 8KHz. See Recording Audio Files for more information.

### tailmessagetime=
This option sets the amount of time in milliseconds between tail messages. Tail Messages are played when a user unkeys on the node input at the point where the hang timer expires, and after the courtesy tone is sent.

Sample:
```
tailmessagetime = 900000   ; 15 minutes between tail messages
```

The maximum value is 200000000mS, 55.5555hours.

### tailsquashedtime=
If a tail message is "squashed" by a user keying up over the top of it, a separate time value can be loaded to make the tail message be retried at a shorter time interval than the standard `tailmessagetime=` setting. The `tailsquashedtime=` setting takes a value in milliseconds.

Sample:
```
tailsquashedtime = 300000   ; 5 minutes
```

### telemetry=
The `telemetry` option allows you to override the stanza name used for the `telemetry` stanza in `rpt.conf`. Telemetry definitions define courtesy tone parameters, and tones sent when certain actions take place on the node.

Sample:
```
telemetry = telemetry   ; name telemetry to 'telemetry'

[telemetry]
...
```
The default is to have `telemetry=` point to a stanza called `telemetry`, and have a common set of commands for all nodes. However, you can have it point to another named stanza, see [Settings to Name Other Stanzas](./config-structure.md#settings-to-name-other-stanzas) for more information.

See the [Telemetry Stanza](#telemetry-stanza) for more information on the options that can be configured.

### telemdefault=
This option sets whether telemetry is turned on or off by default.

```
telemdefault = 1 
```

The available options are:

* 0 = telemetry output off
* 1 = telemetry output on (default)
* 2 = timed telemetry output on command execution and for a short time thereafter
* Default is 1

### telemduckdb=
This option allows adjustment of the telemetry level in dB when a local or voice transmission is in progress. Specify the level to lower the telemetry level in negative dB.

Sample:
```
telemduckdb = -15                   ; Reduce telemetry by -15dB
```

### telemdynamic=
This option sets whether telemetry can be enabled/disabled by users using a COP command.

```
telemdynamic = 1
```

The available options are:

* 0 = disallow users to change the local telemetry setting with a COP command
* 1 = Allow users to change the setting with a COP command
* Default is 1

### telemnomdb=
This option is used to fine tune the telemetry level, relative to standard node audio. The level is in dB. 

Sample:
```
telemnomdb = -3                     ; Decrease nominal telemetry by -3dB
```

### tonemacro=
The `tonemacro` option allows you to override the stanza name used for the `tonemacro` stanza in `rpt.conf`. The tone macro stanza directs the node to use a particular stanza for PL tone tiggered macros from users accessing the node. Macros are DTMF shortcuts, and are a special type of function. 

Sample:
```
tonemacro = tonemacro   ; use stanza named tonemacro

[tonemacro]
100.0 = *81#     ; play the time if a 100.0Hz PL tone is received
```

The default is to have `tonemacro=` point to a stanza called `tonemacro`, and have a common set of commands for all nodes. However, you can have it point to another named stanza, see [Settings to Name Other Stanzas](./config-structure.md#settings-to-name-other-stanzas) for more information.

See the [Tonemacro Stanza](#tonemacro-stanza) for more detail on defining tone macros.

**This option does not appear in the default `rpt.conf`.**

### totime=
This setting defines the time out timer interval for the node. The value is in milliseconds. If the node transmitter remains keyed beyond the `totime` timer length, the transmitter will be unkeyed until the receiver activity resets. 

Sample:
```
totime = 180000   ; Repeater timeout 3 minutes 
```
The default value is 180000(mS), or 3 minutes. 

**NOTE:** This setting can cause issues when linked to active hub nodes that may have long transmissions. If the local node transmitter appears to "drop out" when connected to nodes/hubs with long winded operators or broadcasts, review this setting, and increase as necessary.

Related: [COP Commands 7 and 8](#cop-commands) and [`controlstates`](#controlstates), and [Control States Stanza](#control-states-stanza).

### unlinkedct=
The `unlinkedct` setting selects the courtesy tone to be used when the system has no remote nodes connected and is operating as a standalone repeater.

Sample:
```
unlinkedct = ct2   ; use courtesy tone 2
```

### wait-times=
The `wait-times` option allows you to override the stanza name used for the `wait-times` stanza in `rpt.conf`. Wait times are a specific group of timers for the node.

Sample:
```
wait-times = wait-times   ; name wait-times to wait-times
```

The default is to have `wait-times=` point to a stanza called `wait-times`, and have a common set of commands for all nodes. However, you can have it point to another named stanza, see [Settings to Name Other Stanzas](./config-structure.md#settings-to-name-other-stanzas) for more information.

See [Wait Times Stanza](#wait-times-stanza) for more information on the timers that can be configured.

## Control States Stanza
There are several predefined nmemonics (keywords) used in the `[controlstates]` stanza to enable and disable the various features of the controller. These nmemonics correspond to the control operator command (COP) to be executed and most of these are the same groups of letters announced on air when a single control operator command is executed on the controller.

<table>
<tr><td>Nmemonic</td><td>Description</td><td>COP Method</td></tr>
<tr><td>rptena</td><td>Repeater Enable</td><td>2</td></tr>
<tr><td>rptdis</td><td>Repeater Disable</td><td>3</td></tr>
<tr><td>totena</td><td>Timeout Timer Enable</td><td>7</td></tr>
<tr><td>totdis</td><td>Timeout Timer Disable</td><td>8</td></tr>
<tr><td>apena</td><td>Autopatch Enable</td><td>9</td></tr>
<tr><td>apdis</td><td>Autopatch Disable</td><td>10</td></tr>
<tr><td>lnkena</td><td>Link Enable</td><td>11</td></tr>
<tr><td>lnkdis</td><td>Link Disable</td><td>12</td></tr>
<tr><td>skena</td><td>Scheduler Enable</td><td>15</td></tr>
<tr><td>skdis</td><td>Scheduler Disable</td><td>16</td></tr>
<tr><td>ufena</td><td>User Functions Enable</td><td>17</td></tr>
<tr><td>ufdis</td><td>User Functions Disable</td><td>18</td></tr>
<tr><td>atena</td><td>Alternate Hangtime Enable</td><td>19</td></tr>
<tr><td>atdis</td><td>Alternate Hangtime Disable</td><td>20</td></tr>
<tr><td>noice</td><td>No Incoming Connections Enable</td><td>49</td></tr>
<tr><td>noicd</td><td>No Incoming Connections Disable</td><td>50</td></tr>
<tr><td>slpen</td><td>Sleep Mode Enable</td><td>51</td></tr>
<tr><td>slpds</td><td>Sleep Mode Disable</td><td>52</td></tr>
</table>

## Functions Stanza
The `[functions]` stanza is a named stanza pointed to by the [`functions=`](#functions) option. Functions within this stanza are used to decode DTMF commands when accessing the node from its **receiver**. This stanza is typically named `[functions]`. The name can be overridden, on a per-node basis, see [Settings to Name Other Stanzas](./config-structure.md#settings-to-name-other-stanzas) for more information.  

Sample:
```
functions = functions   ; name the functions stanza functions

[functions]
...
```

See [DTMF Commands](#dtmf-commands) for the list of functions available.

### Function Classes
Function classes are names for categories of functions. There are several function classes defined. They are described in the table below:

<table>
<tr><td>Class</td><td>Description</td></tr>
<tr><td>cop</td><td>Control operator commands</td></tr>
<tr><td>ilink</td><td>Internet linking commands</td></tr>
<tr><td>status</td><td>User status commands</td></tr>
<tr><td>autopatchup</td><td>Autopatch up commands</td></tr>
<tr><td>autopatchdn</td><td>Autopatch down commands</td></tr>
<tr><td>remote</td><td>Remote base commands</td></tr>
<tr><td>macro</td><td>Command macros</td></tr>
</table>

Most of the above command classes require a [`function method`](#function-methods) and possibly one or more additional [`function option`](#function-options) parameters. Function methods are discussed next.

### Function Methods
Function methods are numbers which identify a specific function to execute within a `function class`. Function methods may be optional and in some cases should be omitted (such as with the autopatchup method). A complete and up-to-date description of all `function methods` can be found in the [`app_rpt.c`](https://github.com/AllStarLink/app_rpt/blob/master/apps/app_rpt.c)  source file. Some `function methods` are shown below as an example below:

* 1  - Force ID (global)
* 2  - Give Time of Day (global)
* 3  - Give software Version (global)
* 11 - Force ID (local only)
* 12 - Give Time of Day (local only)

### Function Options
Some `function methods` can take `function options`. These are specified after the `function method`, separated with commas. Not all commands require or take `function options`. An example of a method which can accept `function options` is the `autopatchup` method.

### Putting it all Together
A small excerpt from the function stanza of `rpt.conf` is shown below.

```
 [functions]
 1=ilink,1                                               ; Specific link disconnect
 6=autopatchup,noct=1,farenddisconnect=1,dialtime=2000   ; Autopatch up
```

The above example contains DTMF functions with all of the parameters discussed on previously.

In the above example:

* *1 followed by a node number disconnects a specific link, recall that * is the default [`funchar`](#funcchar). The `function class` is `ilink` and the `function method` is `1`
* *6 followed by a phone number brings up the autopatch with the `function options` specified. Note that there is no `function method` defined, but there are `function options` present.

## Link Functions Stanza
The `[my_link_functions]` stanza, if defined (see below), is a named stanza pointed to by the [`link_functions`](#link_functions) option. Functions within this stanza are used decode DTMF commands when accessing the node **via a link from another node**. 

The traditional usage is to point the `link_functions=` option to the same stanza as named by [`functions=`](#functions), thereby having functions from a linked node and from the local node be the same.

Sample:
```
functions = functions        ; name the functions stanza functions
link_functions = functions   ; use the same stanza 

[functions]
...
```

If a different set of either limited or more capable functions is desired:
```
functions = functions                ; name the functions stanza functions
link_functions = my_link_functions   ; use a different stanza

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
macro=macro   ; use stanza named macros

[macro]
1 = *32000*32001     ; connect to nodes 2000 and 2001
```

See [Full Macro Use And Format](https://wiki.allstarlink.org/index.php?title=Macro_use_and_format) for more information on macros.

## Morse Stanza
The `[morse]` stanza is a named stanza pointed to by the [`morse=](#morse) option.

Sample:
```
[morse]
speed = 20            ; Approximate speed in WPM
frequency = 900       ; Morse Telemetry Frequency in Hz
amplitude = 4096      ; Morse Telemetry Amplitude (relative level)
idfrequency = 746     ; Morse ID Frequency in Hz
idamplitude = 768     ; Morse ID Amplitude (relative level)
```
Note that `frequency` and `amplitude` would set the parameters for telemetry messages, whereas `idfrequency` and `idamplitude` would set the parameters specifically for identification (and they do not need to be the same).

## Nodes Stanza
The `[nodes]` stanza is a list of nodes, their IP addresses, port and "NONE" or "NO" for non-remote base (normal) nodes. The nodes stanza is used to identify which node is mapped to which Internet call and to determine the destination to send the call to. 

If you are using automatic update for AllStarLink (public) nodes, no Allstar link nodes should be defined here. Only place a definition for your local nodes (on your local LAN behind the same NAT router), private (off of AllStarLink) nodes, and remote base nodes here.

Sample:
```
[nodes]
1000 = radio@127.0.0.1/1000,NONE               ; Private hub on this server 
1001 = radio@host.domain.com/1001,NONE         ; Private node on another server
2501 = radio@127.0.0.1/2501,NONE               ; Public node on this server
2502 = radio@127.0.0.1/2502,NONE               ; Another public node on this server
2503 = radio@192.168.1.20:4570/2503,NONE       ; Public node behind the same NAT router
1998 = radio@127.0.0.1/1999,Y                  ; Remote base node on this server
```

For remote base nodes, replace the "NONE" with "Y" or "YES". Once designated as a remote base, that node will only allow **one connection** (link) for use, command, and control.

The `[nodes]` stanza performs a function similar to an OS hosts file. When looking up node information, `app_rpt` looks in the `[nodes]` stanza first then searches (what could be called the Allstar DNS) the `/var/lib/asterisk/rpt_extnodes` file.

## Phone Functions Stanza
The `[my_phone_functions]` stanza is a named stanza pointed to by the [`phone_functions=`](#phone-functions-stanza) option. Functions within this stanza are used decode DTMF commands when **accessing the node from a telephone**. 

The traditional usage is to point `phone_functions=` to the same stanza as named by [`functions=`](#functions), thereby having functions from a phone and from the local node be the same. 

Sample:
```
functions = functions         ; name the functions stanza functions
phone_functions = functions   ; use the same stanza 

[functions]
...
```

If a different set of either limited or more capable functions is desired:

```
functions = functions                  ; name the functions stanza functions
phone_functions = my_phone_functions   ; use a different stanza

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

See [https://wiki.allstarlink.org/wiki/Scheduler_(ASL_System)](https://wiki.allstarlink.org/wiki/Scheduler_(ASL_System)) for more details.

## Telemetry Stanza
This stanza is named by the [`telemetry=`] option. Telemetry entries can be shared across all nodes on the `Asterisk/app_rpt` server, or defined for each node. They can be a tone sequence, morse string, or a file as follows:

* |t - Tone escape sequence:
  * Tone sequences consist of 1 or more 4-tuple entries (freq1, freq2, duration, amplitude). Single frequencies are created by setting freq1 or freq2 to zero.
* |m - Morse escape sequence:
  * Sends Morse code at the **telemetry amplitude and telemetry frequency** as defined in the `[morse]` section. Follow with an alphanumeric string.
* |i - Morse ID escape sequence:
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
ct9=/path/to/sound/filewithoutextion;

;remotetx=|t(1633,0,50,3000)(0,0,80,0)(1209,0,50,3000);
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

## Tonemacro Stanza
The `[tonemacro]` stanza is a named stanza pointed to by the [`tonemacro=`](#tonemacro) option. Tonemacros are macros that are executed upon receipt of a specific PL tone.

Sample:
```
tonemacro = tonemacro;     user stanza named tonemacro

[tonemacro]

100.0=*671
```

Format: `PL Tone = macro to execute`.

See [Full Tonemacro Use and Format] (https://wiki.allstarlink.org/wiki/Tonemacro_use_and_format) for more information on tone macros.

## Wait Times Stanza
This stanza is named by the [`wait-times=`](#wait-times) option. The wait time stanza is used to set delay time between various node actions and their response. Values are in milliseconds.

Sample:
```
wait-times = wait-times   ; name the stanza wait-times

[wait-times]                                                                                                 
telemwait = 600                    ; Time to wait before sending most
idwait = 600                       ; Time to wait before starting ID
unkeywait = 800                    ; Time to wait after unkey before sending CT's and link telemetry
calltermwait = 2000                ; Time to wait before announcing "call terminated"
```
