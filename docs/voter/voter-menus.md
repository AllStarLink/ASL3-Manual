# VOTER/RTCM Hardware Menu System
Both the VOTER and the RTCM run the same (similar) firmware. The menus are consistent between them both.

This page *should* be consistent with the current options available in the current firmware.

**BE AWARE** there are some settings that take effect *immediately*, and others that require you to save settings to EEPROM (99) and reboot (r) for them to take effect. If you are not getting the expected results, this may be the cause. Try a `99` and `r` to see if that fixes your situation.

## Console Access
Serial Console access is provided by an RS-232 serial port at 57600 baud, 8 bits, No parity, 1 Stop Bit. It is also made available remotely (off-board) via TELNET. When TELNET-ing the default user is `admin` and the password is `radios`. 

```
VOTER System Serial # 1234 Remote Console Access

Login: admin
Password: radios

Logged in successfully, now joining console session...
```

When done with the console session, please use the `q` command to disconnect. The local serial port and the TELNET (remote) user share the same (and only) console session.

## Main Menu

```
Select the following values to View/Modify:

1  - Serial # (1694) (which is MAC ADDR 00:04:A3:00:04:D2)
2  - VOTER Server Address (FQDN) (n0call.dyndns.net)
3  - VOTER Server Port (1667),  4  - Local Port (Override) (0)
5  - Client Password (madcow1),  6  - Host Password (BLAH)
7  - Tx Buffer Length (640)
8  - GPS Data Protocol (0=NMEA, 1=TSIP) (1)
81 - GPS Type (0=Normal TSIP, 1=Trimble Thunderbolt) (0)
82 - GPS Time Offset (seconds to add for correction) (0)
9  - GPS Serial Polarity (0=Non-Inverted, 1=Inverted) (0)
10 - GPS PPS Polarity (0=Non-Inverted, 1=Inverted, 2=NONE) (1)
11 - GPS Baud Rate (9600)
12 - External CTCSS (0=Ignore, 1=Non-Inverted, 2=Inverted) (0)
13 - COR Type (0=Normal, 1=IGNORE COR, 2=No Receiver) (0)
14 - Debug Level (16)
15  - Alt. VOTER Server Address (FQDN) ()
16  - Alt. VOTER Server Port (Override) (0)
17  - DSP/BEW Mode NOT SUPPORTED
18 - "Duplex Mode 3" (0=DISABLED, 1-255 Hang Time) (1/10 secs) (0)
19 - Simulcast Launch Delay (0) (approx 200 ns, 5 = 1us, > 0 to ENA SC)
97 - RX Level,  98 - Status,  99 - Save Values to EEPROM
i - IP Parameters menu, o - Offline Mode Parameters menu, s - Squelch menu
q - Disconnect Remote Console Session, r - reboot system, d - diagnostics

Enter Selection (1-19,81-82,97-99,i,o,s,r,q,d) :
```


### Main Menu Options

* `1 - Serial #`, is an unsigned 16 bit number (0-65535) which defines the last 2 bytes of the MAC address of the ethernet interface. **Be sure that the MAC address of the device is unique on the LAN to which it is connected** (if you have more than one VOTER on the LAN, they **must** each have a different serial number/MAC address)
* `2 - VOTER Server Address (FQDN)` is the fully-qualified domain name (FQDN) DNS address, **or** the IP, of the VOTER (AllStarLink) server you want to connect to. If you use the FQDN here, you **must** set at least one DNS server on the IP Parameters menu
* `3 - VOTER Server Port` is the UDP port that the VOTER Server is listening on. Remember to add a forwarding rule in your firewall, if you are connecting from outside your LAN (ie. over the Internet). ASL2 used port 667, ASL3 uses 1667 by default
* `4 - Local Port (Override)` normally should be `0`. This allows the specification of a UDP port number for the device to use locally (incoming traffic). If specified as `0`, it uses the same port as the `Voter Server Port`. **Not tested**. Presumably, this should allow *incoming* traffic **to** the VOTER to be on a different port than the standard `VOTER Server Port`, but it is unclear how the server would be configured to do that
* `5  - Client Password` is the `password` option in [`voter.conf`](../config/voter_conf.md) that is associated with the `DISPLAY_NAME` for this VOTER. When this VOTER connects to the host, and the host matches the `Client Password` to a configured `DISPLAY_NAME`, that device will be connected to `chan_voter`.
* `6  - Host Password` is the password of the Asterisk host, and must match the `password` setting in the `[General]` context in [`voter.conf`](../config/voter_conf.md)
* `7  - Tx Buffer Length` sets the transmit buffer length in **samples** (8000 samples per second, so 8 samples = 1 millisecond), plus overhead, of the Transmit Delay buffer. This should be set to the maximum expected network latency plus a little padding (800 samples is a good amount of padding, so setting the parameter to 3000 is probably a good place to start until you do buffer tuning) between the host and all the clients on the **transmit** side. It must be set long enough to allow for worst-case delay and jitter in the Internet path between the client and the host. Minimum setting is 800, maximum setting is 6400
* `8  - GPS Data Protocol` determines whether your GPS speaks NMEA, or Trimble TSIP. The VOTER is looking for NMEA $GPGGA, $GPGSV, and $GPRMC sentences
* `81 - GPS Type` is normally set to `0`, if you are using a Trimble GPS **other than** a Thunderbolt. Option `1` selects specific firmware hacks to accommodate Thunderbolt quirks
* `82 - GPS Time Offset (seconds to add for correction)` if you have some oddball situation where you need to add a fixed number of seconds to GPS time, this is where you would specify that. **You should not normally need this option** 
* `9  - GPS Serial Polarity` depending on if your GPS is TTL or RS-232, you will need to adjust this setting accordingly to get lock. `GPS Lock` in the `98 - Status` menu should be a **1** when this is correct and the GPS is locked
* `10 - GPS PPS Polarity` depending on if your GPS PPS signal is TTL or RS-232, you will need to adjust this setting accordingly. Option `2` is used if you are using "General-purpose" mode, and not using a GPS. Check the `PPS BAD or Wrong Polarity` on the `98 - Status` menu. If it is a **1**, try toggling this setting, because the VOTER can't lock to PPS
* `11 - GPS Baud Rate` is set according to your GPS. Typically this would be `4800` for most NMEA GPS, and `9600` for most TSIP applications
* `12 - External CTCSS` is set depending on if you are feeding an external CTCSS logic signal from your repeater in to the VOTER. If you are using carrier squelch, leave this as `0`. If your receiver is decoding CTCSS, and you are feeding a logic signal in to the radio connector, set the proper polarity for your application. The VOTER is normally expecting the External CTCSS to be pulled to ground
* `13 - COR Type` is normally set to `0` (it **must** be set to `0` for voting/simulcast applications). COR is determined in software (Squelch Calibration procedure). If you have External CTCSS configured, this would be the equivalent of **AND** squelch when set to `0`, needing CTCSS **AND** COR to qualify the receiver. If set to `1`, then you **must** be feeding an External COR/CTCSS signal in to the External CTCSS input (and have that option correctly optioned) to qualify the receiver COR; in this application you can feed processed audio (non-discriminator) to the audio input, this would be used with "General-purpose" mode. Option `2` applications are un-tested/not known
* `14 - Debug Level` sets various debug settings in the firmware
* `15  - Alt. VOTER Server Address` is the alternate VOTER Server Address, when a redundant host system is configured. Not normally used
* `16  - Alt. VOTER Server Port (Override)` is the UDP port of the redundant host, if it is different than the standard port configured in setting 3. Not normally used
* `17  - DSP/BEW Mode` will show `NOT SUPPORTED` for firmware built without DSP/BEW mode. Will allow DSP/BEW to be optionally enabled in firmware built with this option (-BEW firmware files)
* `18 - "Duplex Mode 3"` setting to anything other than `0` enables this function. `Duplex Mode 3` in `app_rpt` allows for "in-cabinet repeat" (where the **radio hardware** provides repeat audio) and `app_rpt` adds the hang time, courtesy tones, linking - all the things `apt_rpt` does, except repeat audio. Therefore no repeat audio delay. Cool, eh? This duplex mode has been in the `app_rpt` for a while. The problem has been how to implement it in the VOTER environment. `Duplex Mode 3` support in the VOTER provides in-cabinet repeat functionality. Repeat audio loops through the VOTER, and has almost zero delay because it does not have to traverse the network. The delay is not quite zero but it's plenty short enough to eliminate all of the above mentioned annoyances. Of course, `Duplex Mode 3` support can't be used with voting or simulcast. You also lose DTMF muting, time out timer, and repeater disable functions because the repeat path is not through `app_rpt`
* `19 - Simulcast Launch Delay` set to anything other than `0` to enable. Adds a "launch delay" to transmit audio in simulcast applications. A setting of `1` is approximately 200nS, 5 = 1uS
* `97 - RX Level` enters the RX Level tuning display  
* `98 - Status` displays the current status of various parameters  
* `99 - Save Values to EEPROM` saves all current changes to EEPROM
* `i - IP Parameters menu` enters the IP configuration menu
* `o - Offline Mode Parameters menu` enters the `Offline Mode` configuration menu, used to "soft-fail" to a basic repeater if the connection to the host is lost 
* `s - Squelch menu` enters the squelch tuning menu
* `q - Disconnect Remote Console Session` quits the current TELNET connection, and releases the console back to serial 
* `r - reboot system` should be pretty obvious... 
* `d - diagnostics` enters the diagnostics menu

### 97 RX Level Display

```
RX VOICE DISPLAY:
                                  v -- 3KHz        v -- 5KHz
|>           
```

This displays the Receive Audio Level in "real-time" when setting the Receive Level.

Modulate the receiver with a 1kHz at 3kHz deviation signal, and set the Receive Level potentiometer until the bar graph displays:

```
RX VOICE DISPLAY:
                                  v -- 3KHz        v -- 5KHz
|=================================>           
```

Press any key to exit this display.

### 98 Status Display

```
S/W Version: 3.00 3/24/2021
System Uptime: 850819.2 Secs
IP Address: 192.168.1.124
Netmask: 255.255.255.0
Gateway: 192.168.1.254
Primary DNS: 192.168.1.254
Secondary DNS: 0.0.0.0
DHCP: 0
VOTER Server IP: 192.168.1.100
VOTER Server UDP Port: 667
OUR UDP Port: 667
GPS Lock: 0
PPS BAD or Wrong Polarity: 0
Connected: 0
COR: 0
EXT CTCSS IN: 1
PTT: 0
RSSI: 3
Current Samples / Sec.: 8000
Current Peak Audio Level: 49776
Squelch Noise Gain Value: 13, Diode Cal. Value: 57, SQL Level 400, Hysteresis 24
Current Time: Sun  Jan 30, 2022  03:11:40.860
Last Ntwk Rx Pkt System time: <System Time Not Set>, diff: -1462339168 msec
Last Ntwk Rx Pkt Timestamp time: <System Time Not Set>, diff: 0 msec
Last Ntwk Rx Pkt index: 0, inbounds: 0

Press The Any Key (Enter) To Continue
```

#### Status Display Values 

* `S/W Version` displays the current firmware version and build date
* `System Uptime` shows how long this device has been running, in seconds
* `IP Address` is the current static IP, or the IP address received using DHCP
* `Netmask` is the current configured netmask, or the netmask received using DHCP
* `Gateway` is the current configured gateway, or the gateway received using DHCP
* `Primary DNS` is the current configured primary DNS server, or the DNS server received using DHCP
* `Secondary DNS` is the current configured primary DNS server, or the DNS server received using DHCP
* `DHCP` reports `1` if DHCP is enabled, or `0` if using static IP configuration
* `VOTER Server IP` is the IP address that the `VOTER Server Address` resolves to
* `VOTER Server UDP Port` is the current `VOTER Server UDP` port
* `OUR UDP Port` is the current incoming UDP port. This would change if `Local Port (Override)` is set
* `GPS Lock` reports `1` if the GPS is locked and time is good. Reports `0` if the GPS is unlocked (or GPS polarity is incorrect and the VOTER can't decode any GPS data)
* `PPS BAD or Wrong Polarity` reports `1` if the PPS signal is **bad** (check polarity). Reports `0` if the PPS signal is **good**
* `Connected` reports `1` if the VOTER is has established a connection to it's host. Reports `0` if there is currently no host connection
* `COR` reports `1` if the squelch is currently open. Reports `0` if the squelch is closed
* `EXT CTCSS IN` reports the status of the `External CTCSS` pin. It is normally pulled up, so will report `1`. It will report `0` if it is grounded. Logic would depend on your application
* `PTT'` reports `1` if the transmitter is presently keyed. Reports `0` if the transmitter is un-keyed
* `RSSI` reports the currently sampled/decoded RSSI level when the receiver is active
* `Current Samples / Sec.` displays the current encoding rate (will always be `8000` or `8001`)
* `Current Peak Audio Level` reports the current audio level (ADC level)
* `Squelch Noise Gain Value` displays the EEPROM setting written during the "Squelch Calibration" procedure. The optimal (valid) range is `8-127`. Below `8`, and there is **too much** signal, and Squelch Calibration will fail with a level too high. Above `127` and Squelch Calibration will fail with a level too low  
* `Diode Cal. Value` displays the EEPROM setting written during the "Diode Calibration" procedure
* `SQL Level` displays the current squelch level (relative value from `0-1023`). If configured for `squelch pot`, this is the value set by the squelch potentiometer. If set for `software squelch`, this is the value programmed in to the EEPROM. See the [Squelch Parameters Menu](#s-squelch-parameters-menu) for more details
* `Hysteresis` displays the current squelch hysteresis setting (configured on the [Squelch Parameters Menu](#s-squelch-parameters-menu))
* `Current Time` if the GPS is **locked**, the current time will be displayed
* `Last Ntwk Rx Pkt System time` and `diff` *is only applicable in sites where transmit is enabled.* This displays the timestamp of the last transmit audio packet received from the network (from the host), and the **diff**erence between when that packet was received, and the current time (how long ago did we last transmit an audio packet?). On a satellite receiver site this will display `<System Time Not Set>` and a wild number for the **diff**erence
* `Last Ntwk Rx Pkt Timestamp time` and `diff` *is only applicable in sites where transmit is enabled.* This displays the timestamp of the last transmit audio packet received from the network (from the host), and the **diff**erence between when the time stamp of that packet and the VOTER's time. On a satellite receiver site this will display `<System Time Not Set>, diff: 0 msec`
* `Last Ntwk Rx Pkt index` and `inbounds` *is only applicable in sites where transmit is enabled.* This displays the index of the transmitted audio packet in the transmit buffer that was last transmitted, and a flag if the packet was inbounds (should be `1`). On a satellite receiver site, both will be `0`.

### 99 Save Values to EEPROM 
Saves current settings to non-volatile EEPROM. 

## i IP Parameters Menu 

```
IP Parameters Menu

Select the following values to View/Modify:

1  - (Static) IP Address (192.168.1.124)
2  - (Static) Netmask (255.255.255.0)
3  - (Static) Gateway (192.168.1.254)
4  - (Static) Primary DNS Server (192.168.1.254)
5  - (Static) Secondary DNS Server (0.0.0.0)
6  - DHCP Enable (0)
7  - Telnet Port (23)
8  - Telnet Username (admin)
9  - Telnet Password (radios)
10 - DynDNS Enable (0)
11 - DynDNS Username (wb6nil)
12 - DynDNS Password (radios42)
13 - DynDNS Host (voter-test.dyndns.org)
14 - BootLoader IP Address (192.168.1.11) (OK)
15 - Ethernet Duplex (0=Half, 1=Full) (1)
99 - Save Values to EEPROM
x  - Exit IP Parameters Menu (back to main menu)
q  - Disconnect Remote Console Session, r - reboot system

Enter Selection (1-14,99,c,x,q,r) :
```

### IP Parameters Options

* `1  - (Static) IP Address` if you are setting a static IP, configure it here. Does not apply for DHCP
* `2  - (Static) Netmask` if you are configuring a static IP, you will need to specify the netmask. Does not apply for DHCP
* `3  - (Static) Gateway` if you are configuring a static IP, you will need to specify the default gateway. Does not apply for DHCP
* `4  - (Static) Primary DNS Server` if you are configuring a static IP, you will need to specify the primary DNS server. Does not apply for DHCP
* `5  - (Static) Secondary DNS Server` if you are configuring a static IP, you can (optionally) specify a secondary DNS server. Does not apply for DHCP
* `6  - DHCP Enable` is set to `0` to use the static IP settings (above), or set to `1` to use DHCP to configure the IP settings
* `7  - Telnet Port` is normally the standard TCP port `23`, however, you can change it, if desired
* `8  - Telnet Username` is the username required for TELNET access (serial console doesn't require a username or password)
* `9  - Telnet Password` is the password required for TELNET access (serial console doesn't require a username or password)
* `10 - DynDNS Enable` the VOTER supports the DynDNS service (and only DynDNS). Whether this feature still works is unknown, as that part of the code has not been actively maintained. Set to `1` to enable or set to `0` to disable. This will (in theory) update your DynDNS account with the Hostname (specified below) so that you could configure remote access to the VOTER using a known hostname on a dynamic IP internet service. **The AllStarLink host does not care what the hostname is of the VOTER** as it is not required for communication. The VOTER establishes the outbound connection to the host, and communication then flows back and forth over that session
* `11 - DynDNS Username` is the username of your DynDNS account 
* `12 - DynDNS Password` is the password of your DynDNS account
* `13 - DynDNS Host` is the hostname in your DynDNS account that you want to update when this VOTER gets a new IP address from DHCP
* `14 - BootLoader IP Address` configures the bootloader IP address used for loading new firmware. Initially, the default bootloader on a new VOTER (with only bootloader code installed) will be `192.168.1.11`. Once you get this firmware running on it, you can override the bootloader IP address here to something more appropriate (if desired)
* `15 - Ethernet Duplex` selects `Half (0)` or `Full (1)` duplex. Remember, the Ethernet is only 10mb/s. Pay attention to your switch configuration, if you need to manually set it to 10mb/s. The VOTER will not auto-negotiate full or half duplex. The ENC28J60 does not support duplex auto-negotiation, and it will be detected as a half-duplex device. To use full duplex you **MUST** configure both ends manually, otherwise, you are likely to get a lot of errors (which will often manifest as choppy audio or missing syllables)
* `99 - Save Values to EEPROM` will save all the settings to non-volatile EEPROM
* `x  - Exit IP Parameters Menu (back to main menu)` will, obviously, exit this menu and return back to the Main Menu
* `q  - Disconnect Remote Console Session` quits the current TELNET connection, and releases the console back to serial
* `r - reboot system` should be pretty obvious...

## o OffLine Mode Parameters Menu 
OffLine Mode is (optionally) enabled when the connection to the host is lost. It is only applicable at a site with a receiver **and** transmitter (on the same VOTER). It allows a repeater to maintain basic functions (repeats audio and identifies) if the internet connection to the host is lost, or Asterisk crashes.

When the connection to the host is lost, it will send the `CW "Offline"` ID string. It will then periodically (`ID Period Time`) send the ID string out the transmitter on an ongoing basis.

When the connection to the host is restored, it will send the `CW "Online"` string.

On satellite receiver sites (no co-located transmitter), leave the mode set to `0 (NONE)`.
 
```
OffLine Mode Parameters Menu

Select the following values to View/Modify:

1  - Offline Mode (0=NONE, 1=Simplex, 2=Simplex w/Trigger, 3=Repeater) (3)
2  - CW Speed (400) (1/8000 secs)
3  - Pre-CW Delay (4000) (1/8000 secs)
4  - Post-CW Delay (4000) (1/8000 secs)
5  - CW "Offline" (ID) String (N0CALL/R)
6  - CW "Online" String (OK)
7  - "Offline" (CW ID) Period Time (18000) (1/10 secs)
8  - Offline Repeat Hang Time (15) (1/10 secs)
9  - Offline CTCSS Tone (136.5) Hz
10 - Offline CTCSS Level (0-32767) (1500)
11 - Offline De-Emphasis Override (0=NORMAL, 1=OVERRIDE) (1)
99 - Save Values to EEPROM
x  - Exit OffLine Mode Parameter Menu (back to main menu)
q  - Disconnect Remote Console Session, r - reboot system

Enter Selection (1-9,99,c,x,q,r) :
```

### Offline Mode Parameters Options

* `1  - Offline Mode` set to `0` to disable (or for receiver sites). Set to `1` to send the `CW Offline String` when host connection is lost, and then periodically thereafter. Set to `2` to send the `CW Offline String` when host connection is lost, and then be quiet until there is a receiver event to trigger sending the `CW Offline String` again. Set to `3` for full-duplex repeat (dumb repeater with ID)
* `2  - CW Speed` sets the CW speed, *in multiples of 125uS*
* `3  - Pre-CW Delay` sets the delay before sending CW, *in multiples of 125uS* (4000 = 500mS)
* `4  - Post-CW Delay` sets the hangt ime of the transmitter, after sending CW, *in multiples of 125uS* (4000 = 500mS)
* `5  - CW "Offline" (ID) String` is the CW string to send when the host connection is lost, and also the repeater ID to periodically send
* `6  - CW "Online" String` is the CW string to send when the host connection is restored. You wouldn't typically want this to be the repeater ID, as you would want to know when the connection is restored by it being something different
* `7  - "Offline" (CW ID) Period Time` is the timer for sending the CW ID when in OffLine mode, *in multiples of 0.1sec* (18000 = 1800sec = 30min)
* `8  - Offline Repeat Hang Time` is the hang timer for the transmitter when in OffLine mode, *in multiples of 0.1sec* (15 = 1.5sec)
* `9  - Offline CTCSS Tone` configures the (optional) CTCSS tone to use on the **transmitter**. See the [Transmit Level Calibration](./voter-hardware.md#transmit-level-calibration) procedure
* `10 - Offline CTCSS Level` configures the output level of the CTCSS tone to the transmitter. Valid range is 0-32767. See the [Transmit Level Calibration](./voter-hardware.md#transmit-level-calibration) procedure
* `11 - Offline De-Emphasis Override` allows manual selection of whether the de-emphasis is used in OffLine mode. It is dependent on how you have audio to your **transmitter** connected. In `normal (0)` mode, receive audio **will** be de-emphasized, as the VOTER is expecting the **transmit** audio to be connected to the microphone input. In `override (1)` mode, receive audio will **not** be de-emphasized, as the VOTER is expecting that the **transmit** audio is connected directly to the modulator (with no pre-emphasis); as such, the receiver audio would already be pre-emphasized (from the user's radio), and just needs to be sent to the transmitter (avoiding "double pre-emphasis"). If you are going to generate CTCSS in the VOTER (or via [`voter.conf`](../config/voter_conf.md)), you will need to connect your transmit audio directly to the modulator... so for OffLine mode, you're probably going to want to set this to `override (1)`.
* `99 - Save Values to EEPROM` will save all the settings to non-volatile EEPROM
* `x  - Exit IP Parameters Menu (back to main menu)` will, obviously, exit this menu and return back to the Main Menu
* `q  - Disconnect Remote Console Session` quits the current TELNET connection, and releases the console back to serial
* `r - reboot system` should be pretty obvious...

## s Squelch Parameters Menu
In firmware version >3.00, this menu was added to allow for remote squelch and hysteresis adjustments.

Normal squelch uses a potentiometer to set a voltage on a dsPIC ADC pin. The reference voltage used for the potentiometer is slightly temperature compensated. The calculated RSSI is compared with the Squelch ADC value. When the calculated RSSI rises above the squelch threshold, squelch is opened. 

This menu lets you use the squelch potentiometer (hardware) for squelch adjustment, or it lets you specify the squelch setting directly (software squelch). For initial configuration, you normally would want to use the hardware potentiometer for setting the squelch. This will give you the ballpark value for your receiver when you look at the [# 98 Status Display](#98-status-display). Once you have that baseline established, you can then switch to using software squelch (and program the initial value determined with your hardware pot). That then allows you to remotely adjust the squelch on the receiver from the comfort of your sofa... so you don't have to drive to the repeater site every time you want to tweak it.

There is hysteresis around the squelch setting, set by the Hysteresis value (obviously). A smaller value is a "tighter" squelch, a larger value is a "looser" squelch. 

```
Squelch Parameters Menu

Select the following values to View/Modify:

1  - Squelch Pot (0=Hardware, 1=Software) (1)
2  - Squelch Setting (1-1023) (675)
3  - Hysteresis (1-100) (10)
99 - Save Values to EEPROM
x  - Exit Squelch Parameter Menu (back to main menu)
q  - Disconnect Remote Console Session, r - reboot system

Enter Selection (1-3,99,x,q,r) :
```

### Squelch Parameters Options

* `1  - Squelch Pot` set to `0` to use the hardware potentiometer. Set to `1` to use the software squelch setting below
* `2  - Squelch Setting` set to the desired squelch level setting. Valid range is `1-1023`. Set this to the initial value found on the [# 98 Status Display](#98-status-display) when using the hardware potentiometer. **Set this level before switching to software squelch**
* `3  - Hysteresis` set to the desired squelch "tightness". Valid range is `1-100`. A smaller number is a "tighter" squelch. A larger number is a "looser" squelch. The default in previous firmware versions is `24`. **Ensure this level is set, otherwise it defaults to `2` and your squelch will be very choppy (tight)** 
* `99 - Save Values to EEPROM` will save all the settings to non-volatile EEPROM
* `x  - Exit IP Parameters Menu (back to main menu)` will, obviously, exit this menu and return back to the Main Menu
* `q  - Disconnect Remote Console Session` quits the current TELNET connection, and releases the console back to serial

## d Diagnostics Menu

!!! warning "Service Interruption" 
    Entering the diagnostic menu will kill a connection to the host (it interrupts the PPS). Not recommended for running on a production system.

!!! note "May be Discontinued"
    This menu/function may be removed in future firmware, as it's use is limited and code space is at a premium.

```
Select the following Diagnostic functions:

1  - Set Initial Tone Level (and assert PTT)
2  - Display Value of DIP Switches
3  - Flash LED's in sequence
4  - Run entire diag suite
x -  Exit Diagnostic Menu (back to main menu)
q - Disconnect Remote Console Session, r - reboot system

Enter Selection (1-4,x,q,r) :
```

### Diagnostic Menu Options

* `1  - Set Initial Tone Level (and assert PTT)` connect the oscilloscope to the lead on the radio connector (see the Diagnostic Cable below), and follow the instructions
* `2  - Display Value of DIP Switches` will show the current value of all the DIP switches (RTCM) or Jumpers (VOTER)
* `3  - Flash LED's in sequence` will flash all the LEDs
* `4  - Run entire diag suite` will run all the diagnostics. Follow the on screen instructions
* `x  - Exit IP Parameters Menu (back to main menu)` will, obviously, exit this menu and return back to the Main Menu
* `q  - Disconnect Remote Console Session` quits the current TELNET connection, and releases the console back to serial


### Diagnostic Cable Connector Pinout
In order to run the diagnostic suite, you will need to build the following test cables/connectors. Note that these instructions are for the RTCM, the connections will be different for the VOTER.

```
DB9(f) 9 Pin D-Shell Connector (Radio Connector):
1 - VIN (+12V or so)
2 (TX Audio Out) - connects to - 3 (RX Audio In) and also is output to 'scope for tone measurement
4 (External CTCSS In) - connects to - 7 (/PTT Out)
5 - Gnd
```

```
15 Pin D-Shell Connector (GPS/Console Connector):
2 - to Console DB9(f) Pin 2
3 - to Console DB9(f) Pin 3
5 - to Console DB9(f) Pin 5
6 (GPS RX) - connects to - 14 (GPS TX)
```

Console is a 9 Pin D-shell connector that connects to serial console device.

## Hidden Menus
There may be up to two hidden menus available in the firmware.

### 96 ENC Registers
If the firmware is compiled with `DUMPENCREGS` enabled, then a Menu `96` would be available that would dump the registers from the Ethernet chip. Normally, this option is not compiled in to the standard releases, you would have to compile a custom firmware image and enable the `DUMPENCREGS` flag to build that option.

### 111 Special Configs
Menu `111` allows access to some special configurations that Jim included for special applications. Normally, these options should all be `0`.

```
Elkes (11780): 0, Glasers (1103): 0, Sawyer (1170): 0

Press The Any Key (Enter) To Continue
```

#### Elkes Mode
See the [Elke Link page](https://wiki.allstarlink.org/wiki/Elke_Link) for more information.

#### Glasers Mode
Unknown. It sets a "Glaser Timer" value, no idea what it does.

#### Sawyer Mode
Developed for Tim Sawyer use on a Yaesu VXR5000 repeater. It modifies the hardware CTCSS Filter behavior when on/off line.

If the hardware CTCSS Filter is ON, and Option `1170=1`, and Offline Mode is enabled, then loss of the Host Connection (which reverts to Offline mode) causes the CTCSS Filter to turn OFF. Re-establishing the Host Connection turns the CTCSS Filter back ON.

Normally (Option `1170=0`), the CTCSS Filter always stays in its configured state (`ON` or `OFF`), as set with options in [`voter.conf`](../config/voter_conf.md).
