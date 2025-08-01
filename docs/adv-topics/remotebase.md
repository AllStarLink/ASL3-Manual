# Remote Base Nodes
The primary purpose of a remote base node is to make outgoing RF connections using a frequency agile radio to allow access to frequencies which are not part of your Internet connected radio system.

Remote base nodes are configured differently than a standard node. A completely different set of internal functions in `Asterisk/app_rpt` is used when operating a node as a remote base. Usually, the only reason to set up a node as a remote base is when you wish to change the operating parameters of the the attached radio remotely, or if you only want the radio to be used by a single user at a time.

If you want a *public* node number for a remote base, it must specifically be requested in the [AllStarLink Portal](https://allstarlink.org/portal). You must be sure to answer yes to `Is node a remote base station?`, and then optionally `If remote base, is it frequency agile?` questions. Alternatively, you can configure a private node.

## Security Issues
Unfettered access to remote bases can be a **security issue**. If the remote base has no login protection it could be used by unscrupulous individuals to violate amateur radio rules and regulations. We **strongly** advise that all remote bases be protected by requiring a login code (see [Remote Base Authentication](#remote-base-authentication) below). 

## Behavior of Standard Nodes Versus Remote Base Nodes
Behavior|Standard Node|Remote Base Node
--------|-------------|----------------
Command Decoding|Remote or Local. DTMF can be optionally decoded on the receive audio input|Remote only. No DTMF will be decoded on the receive audio input
Duplexing|Configurable: duplex or half-duplex|Half-duplex only
|Frequency and Mode Agility|Fixed frequency operation, and channelized operation only using arguments passed in to app_rpt from extensions.conf|Frequency and Mode agile. Support for several radio types using asynchronous serial, CAT, and synchronous serial
Multiple connections|Multiple nodes can connect. Operates as a conference bridge|Only one node can connect at a time
Login Protection|No|Optional

## What's Required
In order to configure a remote base you will need the following:

### Node Number
Either request a public node number or choose a private node number.

### Radio Interface (Audio)
A free port on a radio interface such a URI adapter must be made available for use by the remote base. This is needed for the audio transport and keying.

### Radio Interface Cable (Control)
A radio interface cable must be constructed or purchased to interface the radio to the node for control. Depending on the radio, this could be a USB to serial cable for CAT commands, or similar. 

### Supported Radios
See the [`remote=`](#remote) setting below for a list of supported or partially supported radios.

## Remote Base Operation
The following is an example of how you would use a remote base:

* Send node \*3&lt;node> to connect to the remote base node
* Use [`[functions_remote]`](#functions) commands to operate the remote base
* * Send \*4&lt;node>\*000# to set the remote base to memory channel 00
* * Send \*4&lt;node>\*1146\*940\*1# to set the VFO to 146.940-
* Send \*1&lt;node> to disconnect from the remote base node

## Remote Base Node Definition
A remote base needs to be defined as such in the `[nodes]` context. Specifically, the node definition would need to have the last option changed from "NONE" to "Y".

Sample:

```
1998 = radio@127.0.0.1/1998,Y                  ; Remote base node on this server
```

## Remote Base Node Number Stanza
The node number stanza is a critical stanza in `rpt.conf`. It is the same concept as for a "normal node". 

```
[1998]    ; Replace with your assigned or private node number
```

The node number stanza is set to the **assigned node number** *or* a **private node number** (if a private node is being configured). The [asl-menu](../user-guide/index.md) utility, via the **Node Setup** menu, should normally be used to create node stanzas for both public and private nodes.

The node number stanza contains all the configurable options for that specific node using a `key=value` pair syntax. The following configurable options are available to use:

### authlevel=
The `authlevel=` option is used to enable or disable login requirements for a remote base.

* authlevel = 0 Disables all access control (not recommended, unsecured)
* authlevel = 1 Enables access control, and waits for key up before prompting for the access code
* authlevel = 2 Enables access control, and prompts for the access code at the time of connection

Sample:

```
authlevel = 0   ; allow everyone 
```

See [Remote Base Authentication](#remote-base-authentication) and [Remote Base TX Limits](#remote-base-txlimits-stanza) for additional details.

### civaddr=
ICOM radios use the ICOM Communications Interface V (CI-V) for remote control. The `civaddr=` is used to set the CI-V address. The value is a 2 digit hexadecimal number. If this option is not specified, then the CI-V address will be set to the default of 88.

Sample:

```
civaddr = 88  ; set CIV to 88
```

### dusbabek=
This option is a "Jim Special", and documentation around it is sparse. It accepts parameters of `yes` or `no`, and MAY be required for the radio you are interfacing to. Try it, you may or may not need it.

Specifically, it may be required for the Syntor-X (using `remote=xcat`).

### functions=
The `functions=` option is a pointer to a remote base function stanza. It operates the same as the normal [`functions=`](../config/rpt_conf.md#functions) option. You will likely want to define a functions stanza that is unique for your remote base, so that you can tailor what functions are available to use. 

Sample:

```
functions = functions-remote   ; name the functions stanza 'functions-remote'

[functions-remote]
0=remote,1                              ; Retrieve Memory
1=remote,2                              ; Set freq.
2=remote,3                              ; Set tx PL tone
3=remote,4                              ; Set rx PL tone
40=remote,100                           ; Rx PL off
41=remote,101                           ; Rx PL on
42=remote,102                           ; Tx PL off
43=remote,103                           ; Tx PL on
44=remote,104                           ; Low Power
45=remote,105                           ; Medium Power
46=remote,106                           ; High Power
51=remote,5                             ; Long status query
52=remote,140                           ; Short status query
61=remote,61                            ; Set mode to FM
62=remote,62                            ; Set mode to USB
63=remote,63                            ; Set mode to LSB
64=remote,64                            ; Set mode to AM
67=remote,210                           ; Send a *
69=remote,211                           ; Send a #
711=remote,107                          ; Bump down ­20Hz
714=remote,108                          ; Bump ­down 100Hz
717=remote,109                          ; Bump ­down 500Hz
713=remote,110                          ; Bump up 20Hz
716=remote,111                          ; Bump up 100Hz
719=remote,112                          ; Bump up 500Hz
721=remote,113                          ; Scan -­ slow
724=remote,114                          ; Scan ­- quick
727=remote,115                          ; Scan ­- fast
723=remote,116                          ; Scan + slow
726=remote,117                          ; Scan + quick
729=remote,118                          ; Scan + fast
79=remote,119                           ; Tune 
91=remote,99,CALLSIGN,[LICENSETAG]      ; Remote base login.
                                        ; Define a different dtmf sequence for each user which is 
                                        ; authorized to use the remote base to control access to it.
                                        ; For example: 
9139583=remote,99,WB6NIL,G              ; would grant access 
                                        ; to the remote base and announce WB6NIL as being logged in.
                                        ; For example:
9148351=remote,99,WA6ZFT,E              ; would grant access 
                                        ; to the remote base and announce WA6ZFT as being logged in.
                                        ; When the remote base is disconnected from the originating 
                                        ; node, the user will be logged out. The LICENSETAG parameter 
                                        ; can be optionally specified to enforce TX band limits.
98=cop,6                                ; Remote base telephone key
```

In the above example the digits to the left of the = are the DTMF code to dial (don't forget to prefix with [`[funcchar]`](../config/rpt_conf.md#funcchar), usually *).

!!! note "Command Mode"
    When sending DTMF commands to a remote base, you need to send them in "command mode", usually \*4 (ilink,4). So, if your remote base was defined as node 1998 and you are already connected to the node, you would set the remote base to high power by sending \*41998\*46.

See [Remote Base Commands](#remote-base-commands) for functions that are specifically available for remote base nodes.

### ioaddr=
The `ioaddr=` option sets a parallel port control I/O address. It is specified as a hexadecimal number with a 0x prefix. The parallel port is used when the Doug Hall RBI-1 interface is employed.

Sample:

```
ioaddr = 0x378   ; set RBI-1 /Parallel Port I/O address on LPT1
```

### ioport=
The `ioport=` option sets the serial port for the control interface to the remote base radio. On Linux Systems, these are typically path names to special files in the `/dev` directory.

Sample:

```
ioport = /dev/ttyS1   ; Linux com1
```

or

```
ioport = /dev/ttyUSB0 ; USB to serial adapter
```

### iospeed=
The `iospeed=` option sets the serial port baud rate for the control interface to the remote base radio.

Sample:

```
iospeed = 4800         ; Use 4800 baud
```

Valid `iospeed` values are:

* 2400
* 4800
* 9600 (default if `iospeed` is not specified)
* 19200
* 38400
* 57600

### mars=
The `mars=` option is only used with the IC-706MKIIG remote. When set to `1`, it enables access to additional bands via remote, as shown below.

Sample:

```
mars = 0        ; set to 1 to enable MARS bands
```

MARS bands available:

Band|Frequency Range|Allowed Mode
----|---------------|------------
LMR UHF|450-470MHz|FM
LMR VHF|148-174MHz|FM
VHF-AM|108-144MHz|AM
AM BCB|550-1750kHz|AM
HF SWL|1750kHz-30MHz|AM

### phone_functions=
The `phone_functions=` is a pointer to a remote base phone function stanza. It operates the same as the normal [`phone_functions=`](../config/rpt_conf.md#phone_functions) option. You will likely want to define a phone functions stanza that is unique for your remote base, so that you can tailor what functions are available to use. 

Sample:

```
phone_functions = functions-remote

[functions-remote]
...
```

### remote=
The `remote=` option sets the type of radio. It **must** be defined, as it ensures that the node will be defined as a remote base node and not a standard node, and determines the protocol for communicating with the radio over the `ioport`.

Sample:

```
remote = xcat   ; set xcat interface
```

Vendor|Model|remote= Value|Notes
------|-----|-------------|-----
N/A|Dumb|y|Use for any single channel remote base radios, with no remote tuning capability
N/A|Parallel Port|pp16|Parallel port programmable 16 channels? Perhaps parallel port BCD bit-banging, such for Motorola radios that can be driven from their accessory port? Interface information not available
Doug Hall|Remote Base Interface|rbi|Requires Parallel Port Address https://wiki.allstarlink.org/wiki/Remote_Base:_Doug_Hall_RBI-1
ICOM|IC-706MKIIG|ic706|**IC-706MKIIG only**. Must specify serial port using `ioport=`. Must specify CIV address using `civaddr=`. Also note `mars=` option. Earlier versions return data format is different and will lock up the software
Kenwood|Various|kenwood|Should work for many/most Kenwood radios, unless otherwise specified
Kenwood|TM-D700|tmd700|
Kenwood|TS-440|kenwood|Some functions may not work
Kenwood|TS-450|kenwood|Some functions may not work
Kenwood|TS-950|kenwood|Some functions may not work
Kenwood|TM-271|tm271|Must specify serial port using `ioport=`
Kenwood|TMG-707|kenwood|Must specify serial port using `ioport=`
Motorola|Syntor Xcat|xcat|Must specify serial port using `ioport=`. Must specify CIV address using `civaddr=`
Ritron Patriot|RTX-150|rtx150|Interface information not available
Ritron Partiot|RTX-450|rtx450|
Yaesu|FT-100|ft100|Must specify serial port using `ioport=`. Default `iospeed=` is set to 4800
Yaesu|FT-897GXII|ft100|See FT-100. Some commands may not work.
Yaesu|FT-857|ft897|Must specify serial port using `ioport=`. Default `iospeed=` is set to 4800
Yaesu|FT-897|ft897|Must specify serial port using `ioport=`. Default `iospeed=` is set to 4800
Yaesu|FT-890|ft100|See FT-100. Some commands may not work
Yaesu|FT-900|ft100|See FT-100. Some commands may not work
Yaesu|FT-950|ft950|Must specify serial port using `ioport=`. Default `iospeed=` is set to 38400

Many Yaesu models should work for the most part with one of the above, back to 747/757 vintage for frequency and mode anyway. The FT-817 has completely different commands, so it won't work.

### remote\_inact\_timeout=
This option specifies the amount of time without keying from the link, before the link is determined to be inactive. Set to `0` to disable timeout.

Sample:

```
remote_inact_timeout = 0   ; do not time out
```

### remote_timeout=
This option specifies the session time out for the remote base. Set to `0` to disable. This option does not appear to be implemented in code.

Sample:

```
remote_timeout = 0   ; do not timeout
```

Default is 3600 (seconds?).

### remote\_timeout\_warning=
This option does not appear to be implemented in code.

Default is 180 (seconds?).

### remote\_timeout\_warning\_freq=
This option does not appear to be implemented in code.

Default is 30 (seconds?).

### rxchannel=
This option contains the type of channel driver which is being used for the audio and control (COR/PTT) interface to the remote base.

Sample:

```
rxchannel = SimpleUSB/1998
```

See the [`rxchannel=`](../config/rpt_conf.md#rxchannel) option for available channel drivers.

### split2m=
This option defines the offset in kHz to use for 2m [memory chanels](#remote-base-memory-stanza). The default if not defined is 600 (kHz).

### split70cm=
This option defines the offset in kHz to use to 70cm [memory channels](#remote-base-memory-stanza). The default if not defined is 5000 (kHz), aka 5MHz.

## Remote Base Commands
Remote base commands (`functionclass` of `remote`) provide DTMF functions for remote base control. The `remote` commands are only applicable to remote base node configurations.

remote|Description|Parameter(s) Accepted
------|-----------|---------------------
1|Retrieve Memory|00 to 99
2|Set VFO Frequency|MMM\*kkk\*o# where MMM is frequency in MHz, kkk is kHz portion of the frequency, o is offset (1=minus, 2=simplex, 3=positive)
3|Set TX PL Tone|XXX\*X ie 067\*0 to set 67.0Hz
4|Set RX PL Tone|XXX\*X ie 067\*0 to set 67.0Hz
5|Link Status Query (long)|
6|Set Operating Mode|m, where m is 1 (FM), 2 (USB), 3, (LSB), or 4 (AM)
99|Remote Base login|CALLSIGN,LICENSETAG
100|RX PL Off|Default
101|RX PL On|
102|TX PL Off|Default
103|TX PL On|
104|Low Power|
105|Medium Power|
106|High Power|
107|Bump -20Hz|
108|Bump -100Hz|
109|Bump -500Hz|
110|Bump +20Hz|
111|Bump +100Hz|
112|Bump +500Hz|
113|Scan - Slow|
114|Scan - Quick|
115|Scan - Fast|
116|Scan + Slow|
117|Scan + Quick|
118|Scan + Fast|
119|Tune (brief AM transmission for automatic tuners)|
140|Link Status Query (brief)|
210|Send a *|
211|Send a #|

Not all commands above are supported by all radios. For example, radios which don't support SSB, would not be able to be placed in LSB or USB mode.

See the [Remote Base Functions](#functions) on how to define the DTMF commands for remote base functions.

## Remote Base Authentication
When [`authlevel=`](#authlevel) is greater than zero, the [`remote,99`](#remote-base-commands) command is used to define a different DTMF sequence (password) for each user authorized to use the remote base. The remote base will announce the callsign as access is granted.

If using an `authlevel` greater than zero, be sure to define users in your `[functions]` stanza to authenticate against.

The format of the function is: `DTMF_Password = remote,99,CALLSIGN,LICENSETAG`.

The `LICENSETAG` is the corresponding entry in the [`[txlmiits]`](#remote-base-txlimits-stanza) stanza. The `LICENSETAG` is used for enforce TX frequency limits.

Sample:

```
[1998]           ; node number for the remote base
; authlevel = 0  ; Anyone can use it
; authlevel = 1  ; Requires log in, Waits for Tx key to ask for it
authlevel = 2  ; Requires log in, asks for it automously

[remote-functions]
8xx=remote,99,OK,E ; where xx is the password
```

Sample:

```
9139583 = remote,99,WB6NIL,G   ; grant access to Jim (general)
9148351 = remote,99,WA6ZFT,E   ; grant access to Steve (extra)
```

In the above example, DTMF "*9139583" would log in to the remote base as WB6NIL, with the TX Limits of the "G" class as defined in the [`[txlimits]`](#remote-base-txlimits-stanza) staza.

When the remote base is disconnected from the originating node, the
user will be logged out. 

## Remote Base Memory Stanza
Up to 100 (00 to 99) preset memory channels can be defined, to be recalled by the `remote,1` function command.

If the `init` memory channel is optionally specified, the remote base will attempt to tune to this channel when a user connects.

Remote base memories are in the format of:

Remote base memory syntax: `CC=RRR.RRR,PPP.P,AAAAA` or `CC=RRR.RRR,PPP.P,OFFSET,AAAAA`

* C = Memory (Channel) number
* R = RX Frequency (must be defined down to kHz)
* P = PL Frequency
* A = One or more Attributes

Attributes are specified as a *non-delimited* string. The available Attributes are: 

* a = AM, b = LSB, f = FM, u = USB
* l = Low Power, m = Medium Power, h = High Power
* - = Minus TX Offset, s = Simplex, + = Plus TX Offset
* t = TX PL on, r = RX PL on

To use a non-standard offset on the memory channel, it can be defined (in kHz), be sure to also specify either `-` or `+`, as necessary.

Sample:

```
[memory]
init = 146.520,000.0,fm ; set to this channel on start
00 = 146.580,100.0,m
01 = 147.030,103.5,m+t
02 = 147.240,103.5,m+t
03 = 147.765,79.7,m-t
04 = 146.460,100.0,m
05 = 146.550,100.0,m
06 = 147.540,000.0,fs
07 = 147.540,123.0,shrt
08 = 147.435,103.5,1035,h-t ; This would be for W6NUT in Los Angeles with input of 146.400, and a PL of 103.5Hz.
```

**NOTE:** Not all attributes may be supported by all radios.

## Remote Base Txlimits Stanza
The `[txlimits]` stanza defines TX privileges to be assigned to a particular license class (`LICENSETAG`).

The `LICENSETAG` is used when configuring the [`authentication`](#remote-base-authentication) parameters for remote base users.

```
[txlimits]
; In the example below, voice privileges are assigned for US ham
; licensees for 40 meters through 10 meters.
; Each line contains a LICENSETAG defined in a user login command,
; then a set of band limit ranges. Up to 40 ranges per entry may be defined.
;
T = 28.300-28.500
G = 7.175-7.300,14.225-14.300,18.110-18.168,21.275-21.450,24.930-24.990,28.300-29.700
A = 7.125-7.300,14.175-14.300,18.110-18.168,21.225-21.450,24.930-24.990,28.300-29.700
E = 7.125-7.300,14.150-14.300,18.110-18.168,21.200-21.450,24.930-24.990,28.300-29.700
```

## Sample Remote Configuration
```
[1998]
; Rx audio/signaling channel                                                                                   
rxchannel = Radio/usb

; Serial port for control
ioport = /dev/ttyS1

; Radio Type                
remote = ft897 

; Function list from link                                          
functions = functions-remote  

; Function list from phone         
phone_functions = functions-remote

; Authorization level                                         
authlevel = 0      
```

## Doug Hall (RBI-1) Remote Base
**The Doug Hall RBI-1 is long obsolete, but is documented here for reference.**

The Doug Hall Electronics Model RBI-1 is frequency agile, multi port, remote base. It is possible to interface the RBI-1 to AllStar, but only on a PC.

### RBI-1 Connections
The RBI-1 uses the first three pins of the parallel port and can not be changed. There is no other interface method built into the `app_rpt` software. If you have been using the pins for anything else, you will need to migrate them to higher pins than the first three. See Parallel Port GPIO.

Parallel port pinout is as follows:
```
PP1 = data
PP2 = clock
PP3 = reset
```

No buffering is required. Attach directly to the RBI-1's DB9 interface on the correct parallel port pins.

### RBI-1 rpt.conf Settings
In `rpt.conf` you will need to set lines in the node's stanza:

```
[1998]                              ; your node number 
iobase=0x378                        ; (for lpt1)
remote=rbi                          ; Doug Hall RBI-1
functions=funtions-remote1998       ; Function list from link (a list of agile working commands) - use your node number
memory=memory1998                   ; 'system stored' radio presets, not required - use your node number

[funtions-remote1998]               ;for RBI-1   use your node number

0=remote,1                          ; Retrieve Radio Stored Memory Channel
1=remote,2                          ; Set freq. VFO MMMMM*KKK*O   (Mhz digits, Khz digits, Offset)
2=remote,3                          ; Set tx PL tone PL Tone HHH*D*
3=remote,4                          ; Set rx PL tone         HHH*D*

40=remote,100                       ; Rx PL off
41=remote,101                       ; Rx PL on
42=remote,102                       ; Tx PL off
43=remote,103                       ; Tx PL on
44=remote,104                       ; Low Power
45=remote,105                       ; Medium Power
46=remote,106                       ; High Power

51=remote,5                         ; Long status query
52=remote,140                       ; Short status query
67=remote,210                       ; Send a *
69=remote,211                       ; Send a #


; Not Required but noted:

[memory1998]                        ;Stored presets for radio, 
                                    ;Format: (recall# xx) = (Freq 6 digits and decimal) (TX PL Tone )  ( CTCSS Tone )  (offset + - S ) ( power l m h )
init=224.660,100.0,-l               ;initial freq/mode on start-up/boot - choose something safe in case of error. Not required. Can be remarked out.
00=224.560,100.0,-l
01=224.460,114.8,-l
02=224.580,131.8,-l
03=223.980,100.0,-l
04=146.940,114.8,-lt
10=442.175,162.2,+l
11=444.475,114.8,+l
12=444.150,100.0,+l
;13=446.500,100.0,sl
```
