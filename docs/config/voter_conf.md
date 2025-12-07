# voter.conf
The `voter.conf` file is generally going to be located with the rest of the Asterisk configuration files, in `/etc/asterisk`.

This file sets up the `chan_voter` channel driver to interface with `app_rpt`.

Remember, in `rpt.conf`, you will need a directive to use the `chan_voter` channel driver:

```
rxchannel = Voter/1999
```

The `1999` should match the corresponding instance stanza defined in `voter.conf` that holds all the definitions for your clients.

The VOTER/RTCM may be used in any of 3 modes:

* non-voting client mode
* voting mode
* voting and simulcast mode

There **must** be a `[general]` stanza that contains directives that are common to all the `chan_voter` instances. Some directives may be allowed in the `[general]` stanza and/or be defined on a per-client basis with the client definition directive.

In addition, there must be at least one **instance** stanza defined. An instance is a group of clients that are all related to each other. In a typical voting repeater scenario, the instance would typically be the node number, and all the clients would be the transmitter client and all the voting receiver clients associated with that repeater.

It *is* a valid configuration to only have one client defined in an instance. You might have this if you are just using the VOTER/RTCM as a RoIP adapter to connect a remotely located repeater back to a host over Ethernet.

Each client directive has a number of optional **attributes** associated with it that may, or may not, be required depending on your system configuration.

You *may* have more than one client defined as a transmitter, as in the case of a simulcast system. Any client with a transmitter attribute defined will be sent transmit audio packets associated to that instance.

There are also configuration directives that apply to an entire instance (and all the defined clients within it).

## `voter.conf` File Structure
The `voter.conf` file is structured as shown below (as in all other Asterisk configuration files, lines preceded with a semi-colon ";" are treated as a comment):

```
[general]
;bindaddr = 10.10.10.1		; specify a particular IP address to bind to (not generally used, defaults to bind to all interfaces)
port = 1667			        ; specifies the UDP port to use for incoming connections (formerly 667 is ASL2)
buflen = 480			    ; specifies the receive buffer length in milliseconds.
				            ; This parameter should be set to the maximum expected network latency,
				            ; plus a little padding (100 milliseconds of padding is a good amount).
							; The default is 480 milliseconds, if nothing is specified, 
							; the minimum is 40 milliseconds for voting clients, or 160 milliseconds for mix mode clients.
				            ; Buffer length may be specified on a per-stanza and per-client basis, see below.

password = secret_password	; password common to all clients (Main Menu Item 6 - Host Password, on RTCM/VOTER)
utos = y			        ; Turn on IP TOS for Ubiquiti (ToS is enable by default on the RTCM/VOTER) from the host TO the clients

;sanity = 0			        ; disable sanity checking of clients (debug use only) defaults to 1 if not specifically set to 0
;puckit = 1			        ; KLUDGE to try and fix random Garmin LVC-18 pucks that may or may not be 1 second off (defaults to 0 if not specified)

[1999]				        ; define the 1999 instance stanza
Main = secret,transmit,master	; master,transmit,adpcm,nulaw,nodeemp,noplfilter,buflen=value,gpsid[=value],prio=value
				            ; 
				            ; master - this client is the Master Timing source (the RTCM client that is on the same LAN as the Asterisk server.)
				            ; There can only be 1 Master Timing source per ENTIRE Asterisk server.
				            ; 
				            ; secret - password unique to this client
				            ; transmit - this client is intended to have transmit audio sent to it and will have a transmitter connected to it.
				            ; adpcm - this client is to be sent audio in 8000 samples/sec, 4-bit, IMA ADPCM format, rather than default G.711 Mulaw (aka ulaw).
				            ; nulaw - this client is to be sent audio in 4000 samples/second Mulaw (Nulaw, as we call it), rather than the standard 8000 samples/second.
				            ; nodeemp - this client is not to perform de-emphasis of the receiver audio  (This is only to be used with non-voting clients). Switches 
				            ; the hardware de-emphasis filter OUT on the client
				            ; noplfilter - this client is to not to perform hardware pl filtering of the audio. Switches the hardware PL filter OUT on the client.
				            ; buflen=value - receive buffer length override for this client only.
				            ; gpsid[=value] - This specifies a gps identity to associate with the specified client (as referred in the /etc/asterisk/gps.conf file).
				            ; prio=value - define a specific priority for this client when voting. Lower numbers are higher priority. Default is 0 if nothing specified.

plfilter = y			    ; use DSP IIR 6 pole High pass filter, 300 Hz corner with 0.5 db ripple (note clients filter PL by default already)
txctcss = 100.0			    ; Transmit CTCSS frequency
txctcsslevel = 62		    ; Transmit CTCSS level (default of 62 if txctcss is supplied, but txctcsslevel is not set)
txtoctype = phase		    ; Transmit tone control type: none,phase,notone
				            ; none - CTCSS tone encoding with no hang time (default)
				            ; phase - encode CTCSS and reverse phase (AKA "reverse burst") before un-keying TX
				            ; notone - encode CTCSS and stop sending tone before un-keying TX (AKA "chicken burst")

;gtxgain = 3.0			    ; adjust the audio gain to all transmitters (in db voltage gain)
;hostdeemp = 1			    ; force the use of the DSP FIR Integrator providing de-emphasis at 8000 samples/sec. Used with Duplex Mode 3 setting in RTCM/VOTER

thresholds = 255,110=5		;
; linger=6			        ; linger default is 6 if no other value specified
; streams = 67.215.233.178:1667 ; location to send voter data stream for this instance (used only with votemond Java program, which is deprecated)

; isprimary = y			    ; used in redundant server applications only. must be set on the primary server only
; primary = 10.20.20.1:667,mypaswd	; used in redundant server applications only. must be ONLY set on the secondary server to point to the primary

[1998]				        ; define another voting instance on this server (for another node). Three simulcast transmitters and four receivers.
				            ; NOTE: there is NO "master" in this instance, since we already have a master timing source on this server defined above 

NORTH = password_1,transmit	; transmit/receive site
SOUTH = Password_2,transmit	; transmit/receive site
EAST = password_3,nodeemp	; receive-only site, bypass de-emphasis filter in RTCM
WEST = Password_4,transmit,noplfilter	; transmit/receive site, bypass CTCSS filter in RTCM

[1997]						; special application using mix-mode (aka general purpose) nodes in a "mixminus" configuration
Site01 = secret1,transmit,nodeemp,noplfilter
Site02 = secret2,transmit,nodeemp,noplfilter
Site03 = secret3,transmit,nodeemp,noplfilter
Site04 = secret4,transmit,nodeemp,noplfilter
Site05 = secret5,transmit,nodeemp,noplfilter
buflen = 250
mixminus = y
plfilter = n
```

Of course, the above denotes all the possible options that you can define in `voter.conf`. A typical "bare minimum" to get on the air would be more along the lines of:

```
[general]
port = 1667			        ; specifies the UDP port to use for incoming connections
buflen = 480			    ; specifies the receive buffer length in milliseconds.
				            ; This parameter should be set to the maximum expected network latency,
				            ; plus a little padding (100 milliseconds of padding is a good amount).
				            ; The default is 480 milliseconds, if nothing is specified, 
							; the minimum is 40 milliseconds for voting clients, or 160 milliseconds for mix mode clients.
				            ; Buffer length may be specified on a per-stanza and per-client basis, see below.

password = secret_password	; password common to all clients (Main Menu Item 6 - Host Password, on RTCM/VOTER)
utos = y			        ; Turn on IP TOS for Ubiquiti (ToS is enable by default on the RTCM/VOTER) from the host TO the clients


[1999]				        ; define the 1999 instance stanza

Main = secret,transmit,master	; master - this client is the Master Timing source (the RTCM client that is on the same LAN as the Asterisk server.)
				            ; There can only be 1 Master Timing source per ENTIRE Asterisk server.
				            ; secret - password unique to this client
				            ; transmit - this client is intended to have transmit audio sent to it and will have a transmitter connected to it.

Remote = secret2		    ; satellite receiver site only 
```

## `[general]` Stanza
The `[general]` stanza defines all the configuration directives that apply to `chan_voter`, and all instances in the `voter.conf` file.

```
[general]
;bindaddr = 10.10.10.1		; specify a particular IP address to bind to (not generally used, defaults to bind to all interfaces)
port = 1667			        ; specifies the UDP port to use for incoming connections
buflen = 480			    ; specifies the receive buffer length in milliseconds.
				            ; This parameter should be set to the maximum expected network latency,
				            ; plus a little padding (100 milliseconds of padding is a good amount).
							; The default is 480 milliseconds, if nothing is specified, 
							; the minimum is 40 milliseconds for voting clients, or 160 milliseconds for mix mode clients.
				            ; Buffer length may be specified on a per-stanza and per-client basis, see below.

password = secret_password	; password common to all clients (Main Menu Item 6 - Host Password, on RTCM/VOTER)
utos = y			        ; Turn on IP TOS for Ubiquiti (ToS is enable by default on the RTCM/VOTER) from the host TO the clients

;sanity = 0			        ; disable sanity checking of clients (debug use only) defaults to 1 if not specifically set to 0
;puckit = 1			        ; KLUDGE to try and fix random Garmin LVC-18 pucks that may or may not be 1 second off (defaults to 0 if not specified or set to 1)
```

### bindaddr
Typically, `bindaddr` is not specified (it defaults to "INADDR_ANY"). It is supported, however, should you need to bind your VOTER clients to a specific IP interface on the server.

### buflen
Each client has a pair of circular buffers, one for mulaw audio data, and one for RSSI value. The default allocated buffer length for all clients is determined by the `buflen` parameter in the `[general]` stanza. It is specified in `voter.conf` in milliseconds, but is represented in the channel driver as a number of samples (actual buffer length =
buflen * 8).

The `buflen` defined in the `[general]` stanza is used for all clients, **unless** there is an alternate `buflen` directive under an instance (which then applies to all clients defined under that instance).

`buflen` is selected so that there is enough time (delay) for any straggling packets to arrive before it is time to present the data to the Asterisk channel.

The default in `voter.conf` is set to `480` (milliseconds), which is overly generous for most applications, and should be tuned in accordance with the [Buffer Tuning](../voter/voter-buffers.md) procedure.

If the `buflen` parameter is omitted, the channel driver will set it to `480` by default. 

The minimum `buflen` for voting clients is `40`.

The minimum `buflen` for mix mode (aka general purpose) clients is `160`.

The `buflen` parameter only has 40ms granularity. It can only effectively be set in increments of `40`, ie. `40, 80, 120, 160, etc.`. Intermediate values will get rounded down to the closest 40ms increment (ie `150` would round down to `120` internally).

!!! warning "Out of Bounds"
	Setting `buflen` lower than `160` for mix mode clients will prevent them from connecting to the channel driver, and will result in "out of bounds" warnings on the Asterisk console. This minimum will be enforced in a future channel driver update.

### port
The `port` directive specifies the listening UDP port that `chan_voter` is listening on for incoming connections from clients. When clients power on, they attempt to contact the `VOTER Server Address` at the `VOTER Server Port`, defined in their on-board configuration settings. See the Menu Structure and Definitions page for further explanation of those configuration settings. This is the **incoming** port you may need to let through your firewall.

!!! note "Default Port Change"
	In ASL2, the default port used was `667/UDP`, and is now `1667/UDP`. See [VOTER/RTCM Default Port](../basics/incompatibles.md#voterrtcm-default-port) for more details on this change.

If running the AllStarLink Pi Appliance (or another system with a firewall), inbound to port `1667/UDP` must be permitted. For directions on how to do this with the Pi Appliance see [Managing the Firewall](../pi/cockpit-firewall.md). **Don't forget to also allow this port through any firewall that may part of your internet connection.**

### password
The password directive specifies the matching `Host Password` that needs to be configured in the VOTER client. This is the password for the server as a whole for all the clients to authenticate with.

### utos
Short for "Ubiquity Type of Service". When set, it will mark outbound packets (from the host to the client) with the ToS header flag of `0xC0`. This is ToS precedence Level 6 or "Internetwork Control".

It is used in traffic shaping. If your network is that congested that you need to shape traffic... you might have bigger issues. However, it doesn't hurt to flag the traffic when transiting the Internet to remote sites.

!!! note "Default `utos` Change"
	As of VOTER/RTCM firmware >v2.00, the clients will automatically mark their outbound traffic (to the host) with the same flag. That can now be **disabled** by setting the appropriate `Debug Option`. Older versions of firmware (<2.00) did not flag the traffic by default, and required it to be **enabled** with the `Debug Option`.

### sanity
This directive is only used for debugging.

`sanity` tells `chan_voter` to disable all sanity checks for clients. You would **never** want to do that in production.

### puckit
This directive is only used for debugging.

`puckit` attempts to fix a problem with Garmin GPS pucks. Use at your own risk. Per Jim's notes in the source:

```
/* This is just a horrendous KLUDGE!! Some Garmin LVC-18 GPS "pucks"
 *sometimes* get EXACTLY 1 second off!! Some don't do it at all.
 Some do it constantly. Some just do it once in a while. In an attempt
 to be at least somewhat tolerant of such swine poo-poo, the "puckit"
 configuration flag may be set, which makes an attempt to deal with
 this problem by keeping a "time differential" for each client (compared
 with the "master") and applying it to time information within the protocol.
 Obviously, this SHOULD NEVER HAVE TO BE DONE. */
```

## VOTER Instances
Within `voter.conf`, there *may* exist more than one **instance**. An instance is defined by a stanza that is **not** named `[general]`, and is typically named for the node number it is associated with in `rpt.conf`.

This **must** match the name of the channel driver that is referenced from `rpt.conf` in the node definition there:

```
rxchannel = Voter/1999
```

It is **not** recommended to use anything other than numerical digits for the instance definition. Unpredictable results will happen (read, doesn't work).

This instance holds one or more **client definitions** that are *associated with each other* (ie. all operating on the same transmit/receive frequencies as part of the same repeater system).

```
[1999]				            ; define the 1999 instance stanza

Main = secret,transmit,master	; master - this client is the Master Timing source (the RTCM client that is on the same LAN as the Asterisk server.)
				                ; There can only be 1 Master Timing source per ENTIRE Asterisk server.
				                ; secret - password unique to this client
				                ; transmit - this client is intended to have transmit audio sent to it and will have a transmitter connected to it.

Remote = secret2		        ; satellite receiver site only 
```

The example above defines an instance named `1999`, and has two clients defined, which are named `Main` and `Remote`.

## Client Definition
A `client` is a particular VOTER/RTCM hardware device that is located somewhere, connected to Ethernet and a radio, and is feeding receive audio to (and optionally receiving transmit audio from) the Asterisk host and the configured channel in `rpt.conf` through `app_rpt`. Each `client` in an instance is defined using the format:

```
DISPLAY_NAME = secret[,options]
```

The `DISPLAY_NAME` can be any alphanumeric, non-breaking string, up to 50 characters in length. You probably want to keep it short, since you may need to type it on the Asterisk Console for debugging. You can use "_" in the name. This is the name that will be displayed on the Allmon/Supermon screens when looking at voting clients, and the **client name** in the Asterisk console.
 
The `secret` is a **unique** value for *each client* that **must** match the `Client Password` that is programmed into a particular VOTER/RTCM hardware device. This is how `chan_voter` determines which hardware client to associate with which client definition in the `voter.conf` file. The password may be up to 50 characters in length.

The `options` are any one or more of the following shown below, separated by a comma on each client definition line.

## Client Options
In addition to the above, there are a number of **options** that can be associated with any client.

If no `options` are specified for a client, then **none** of the options specified below are enabled for the particular client, and it will be treated as a standard (non-master), receive-only, Mu law audio client.

### master
There must be **one and only one client** in the whole `voter.conf` file that has the `master` option set, regardless of how many instances are defined. This **must** be a VOTER/RTCM hardware device that is located *on the same physical LAN* (ie. same switch) that the Asterisk server resides on. This VOTER/RTCM does not necessarily need a radio attached to it (but that is common), but it **does** need a GPS. It does not need to be a transmitter, it can just be a receiver site, if desired. This is the client that `chan_voter` uses for master timing of all operations, and will be the reference timing source that all clients will be compared with. A `master` is not required in "General-purpose" or "Mixed Mode" client applications, where GPS is not required at all.

### transmit
This client will have transmit audio sent to it by the channel driver. More than one client may have transmit audio sent to them, as in a simulcast application.

### adpcm/nulaw
By default, audio is sent between the client and the host in G.711 Mulaw (aka ulaw) format. This is the default, if neither adpcm or nulaw options are associated with a client.

`adpcm` will configure this client to exchange audio in 8000 samples/sec, 4-bit, IMA ADPCM format.

`nulaw` will configure this client to exchange audio in 4000 samples/second Mulaw (Nulaw, as we call it), rather than the standard 8000 samples/second.

### nodeemp
`nodeemp` tells this client not to perform de-emphasis of the receiver audio using the on-board hardware de-emphasis filter. This option manually switches the hardware de-emphasis **OUT** on the client. This is only to be used with non-voting clients.

### noplfilter
`noplfilter` tells this client not to pass the receive audio through the on-board hardware CTCSS filter. Normally, audio is filtered to remove any CTCSS tones on the VOTER/RTCM hardware client before being sent to the host. This option manually switches the hardware CTCSS filter **OUT** on the client.

### buflen=value
`buflen=value` sets a specific receiver buffer length value for this client. This option is used in special applications only. When this option is not specified, each client defaults to the `buflen` value defined in the `[global]` stanza.

### gpsid=value
`gpsid[=value]` specifies a gps identity to associate with the specified client (as referred in the `/etc/asterisk/gps.conf` file). It is also used as the filename to create "GPS Work and Data Files" associated to the client. If no value is specified, default filenames are used. If a `value` is specified, it appends the supplied `value` to the filename with a "_".

This appears to be associated with `app_gps`, which can be used for reporting AllStarLink's position to APRS. Presumably, since you already have a GPS connected for the VOTER, this allows you to share its position data with `app_gps`, instead of having to use a separate GPS? Sorry, better documentation is required on how to configure this option and how it works. Feel free to contribute!

### prio=value
`prio=value` will define a specific priority for this client when voting. Lower numbers are higher priority. Default is 0 if nothing specified. This is normally not specified, and voting will take place based on the best RSSI from all clients. This option is used in special applications only.

## Instance Options
The following options affect all clients registered under a instance.

```
plfilter = y			; use DSP IIR 6 pole High pass filter, 300 Hz corner with 0.5 db ripple (note clients filter PL by default already)
txctcss = 100.0			; Transmit CTCSS frequency
txctcsslevel = 62		; Transmit CTCSS level (default of 62 if txctcss is supplied, but txctcsslevel is not set)
txtoctype = phase		; Transmit tone control type: none,phase,notone
				; none - CTCSS tone encoding with no hang time (default)
				; phase - encode CTCSS and reverse phase (AKA "reverse burst") before unkeying TX
				; notone - encode CTCSS and stop sending tone before unkeying TX (AKA "chicken burst")

;gtxgain = 3.0			; adjust the audio gain to all transmitters (in db voltage gain)
;hostdeemp = y			; force the use of the DSP FIR Integrator providing de-emphasis at 8000 samples/sec. Used with Duplex Mode 3 setting in RTCM/VOTER
;mixminus = y			; send transmit audio to all clients EXCEPT the one receiving, used in special applications

thresholds = 255,110=5		;
; linger=6			; linger default is 6 if no other value specified
; streams = 67.215.233.178:1667 ; location to send voter data stream for this instance (used only with votemond Java program, which is deprecated)

; isprimary = y			; used in redundant server applications only. must be set on the primary server only
; primary = 10.20.20.1:667,mypaswd	; used in redundant server applications only. must be ONLY set on the secondary server to point to the primary
```

### mixminus
Enabling this feature causes transmit audio to be sent to all clients, **EXCEPT** the one that is receiving. In addition, DTMF will passthrough and be sent to all transmitters (which is different than all other channel drivers). This mode is **ONLY** supported on mix mode (aka general purpose) configurations. See [Mixminus Mode](../voter/voter-mixmode.md) for further information.

If this options is not specified, it will default to disabled.

### plfilter
Enabling this option uses the internal software DSP IIR 6-pole high-pass filter that has a 300Hz corner and 0.5dB ripple on the host. Note that all VOTER/RTCM clients already employ a hardware CTCSS filter that is enabled by default. So, if you are going to use this option, you probably want to use the `noplfilter` in the client options.

If this option is not specified, it will default to disabled.

### txctcss
This option controls the generation of transmit CTCSS. Refer to the VOTER Audio page for further details on the different applications and required radio connections (direct modulator).

`txctcss` is any valid CTCSS tone.

### txctcsslevel
This option controls the generation of transmit CTCSS. Refer to the VOTER Audio page for further details on the different applications and required radio connections (direct modulator).

`txctcsslevel` is the level of the CTCSS tone to generate. If no level is specified, then it will default to a level of 62.

### txtoctype
This option controls the generation of transmit CTCSS. Refer to the VOTER Audio page for further details on the different applications and required radio connections (direct modulator).

`txtoctype` is the type of CTCSS turn-off to use when the transmitter un-keys. It defaults to `none`, where the tone ends at the same time as the PTT un-keys. This usually isn't handled well by many radios, and results in squelch crashes in their receivers. The `phase` option (also known as "Reverse-burst") reverses the phase of the CTCSS tone, just before unkeying the transmitter. This is how Motorola turns off CTCSS tones, and was originally designed to force CTCSS reeds to stop vibrating by applying opposite polarity to them. The `notone` option (also known as "Chicken-burst") is similar to the `none` option, except here the CTCSS tone is stopped just prior to the transmitter unkeying. The theory behind that being, it gives time for the user's radio to detect the loss of CTCSS tone and squelch, before the transmitter drops, preventing the squelch from crashing.

Beware using this option, as it affects whether pre-emphasis is applied to your audio, or not. That means it affects how you have the RTCM/VOTER connected to your radio's transmitter. Using this option means you **must** be using a direct modulator connection, and not the mic audio input. Note that it is a valid configuration to use a direct modulation connection, and specify the `txctcsslevel` as `0` to correctly modulate the transmitter, but not send a CTCSS tone.

### gtxgain
This is a bit of an obscure option that is not widely known/used. It can be used to adjust the audio gain sent to all transmitters. The value is a floating number (versus an integer), and is in dB.

The equation used in the source code is:

```
p->gtxgain = pow(10.0,atof(val) / 20.0);
```

The default, if nothing is specified, is 0.0. Positive and negative values are supported.

The value is **voltage gain**, so 3dB would increase the transmitter audio level by 1.41, 6dB would double the amplitude.

### hostdeemp
Note that this option only works on a per-instance level.

This option is used with the `Duplex Mode 3` setting in the RTCM/VOTER.

This option forces receive audio from all clients to be sent through the host's DSP FIR Integrator providing de-emphasis at 8000 samples/sec. (normally, de-emphasis is done on the VOTER/RTCM hardware client before being sent to the host). This option is used in special applications only.

!!! note "Audio Processing"
	The de-emphasis only takes place between the receiver (received audio) and the channel driver in Asterisk. Recall that Duplex Mode 3 does "in-cabinet repeat", so the receiver audio is sent to the transmitter without any processing (ie de-emphasis).

### thresholds/linger
The `thresholds` and `linger` options determine how the voting algorithm works. You can find a thorough explanation on how to set these parameters on [this page](../voter/about-voter.md).

### isprimary/primary
These options configure hosts configured in redundant host applications. You can find a thorough explanation of how this works on the [Redundant Proxy Mode](../voter/voter-proxy.md) page.

Suffice to say, on the "primary" server, you would use the `isprimary` option (set to `y`). On the "secondary" (backup) server, you would use the `primary` option to point to the `IP address` of the primary server. **NOTE:** that the primary option also needs the `port` and the `host password` of the primary server, in order for it to properly authenticate.

### streams
`streams`, which specifies a list of `IP_ADDR:UDP_PORT` values indicating where to send the `votmond` (deprecated) redistribution stream associated with the specified system