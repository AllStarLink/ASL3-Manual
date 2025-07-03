# extensions.conf
`extensions.conf` (`/etc/asterisk/extensions.conf`) contains the “dialplan” of Asterisk. It is your master plan of control or execution flow for all of its operations. It controls how incoming connections get routed to `app_rpt` and is used for outgoing autopatch connections via various channels and VoIP termination providers.

Since ASL3 is built on top of the Asterisk PBX software, if you want to make changes to this file, you should familiarize yourself with how Asterisk dialplans work, their syntax, and their function. There is plenty of documentation available on the Internet about Asterisk dialplans, a good place to start is the [Asterisk Project Documentation](https://docs.asterisk.org).

We will cover the basics here in how the information in the default ASL3 `extensions.conf` relates to node operations.

## `[general]` Stanza
The `[general]` stanza is used to set global options that apply to all extensions in the file. The options specified in the `[general]` section can be overridden by individual extension sections, but if not overridden, will be used as the default for all extensions. 

You should see the following in your ASL3 default `extensions.conf`:

```
static = yes       					; These two lines prevent the command-line interface
writeprotect = yes 					; from overwriting the config file. Leave them here.
```

These two directives mean that extensions cannot be altered or deleted via the Asterisk Management Interface (AMI) or the Command Line Interface (CLI). The only way to change them is by editing the relevant stanzas in `extensions.conf`.

## `[globals]` Stanza
The `[globals]` stanza sets global variables that can be used by multiple extensions within the file to dynamically set values or parameters in dialplan logic.

You should see the following in your ASL3 default `extensions.conf`:

```
[globals]
HOMENPA = 999 						; change this to your Area Code
NODE = 1999   						; change this to your node number
```

## `[default]` Stanza
The `[default]` stanza is a special Asterisk dialplan extension. It acts as a fallback or catch-all when a specific stanza is not defined or is not reachable. It's the stanza Asterisk uses when a more specific stanza is not available or if a dialplan error occurs.

You should see the following in your ASL3 default `extensions.conf`:

```
[default]
exten => i,1,Hangup
```

In ASL3, the default behavior is to hang up (terminate) the call/connection.

## `[radio-secure]` Stanza
The `[radio-secure]` stanza is called from the `[radio]` stanza in `iax.conf`. It is used to handle IAX2 connections between nodes, and determines if and how to route the connection to the `app_rpt` application that does all the "repeater" functions.

You should see the following in your ASL3 default `extensions.conf`:

```
[radio-secure]
;exten => ${NODE},1,rpt(${EXTEN})
exten => _XXXX!,1,Set(NODENUM=${CALLERID(num)})
	same => n,NoOp(Connect from node: ${NODENUM})
	same => n,NoOp(Connect to: ${EXTEN})
	same => n,NoOp(Channel type: ${CHANNEL(channeltype)})
	same => n,GotoIf($["${CHANNEL(channeltype)}" = "IAX2"]?:allowlist)              ; if not IAX2, skip IP check

	; if peer IP is localhost, connect
	same => n,NoOp(Channel Peer IP: ${CHANNEL(peerip)})
	same => n,GotoIf($["${CHANNEL(peerip)}" = "127.0.0.1"]?connect)                 ; if localhost; connect

	; if allowlist/extension doesn't exist, check the denylist
	same => n(allowlist),GotoIf($[${DB_KEYCOUNT(allowlist/${EXTEN})} = 0]?denylist) ; no allowlist, check denylist
	; if allowlist/extension/callerID exists, connect
	same => n,GotoIf(${DB_EXISTS(allowlist/${EXTEN}/${NODENUM})}?connect)           ; in allowlist, connect
	same => n,NoOp(${EXTEN} not in allowlist, Hangup)
	same => n,Hangup

	; if denylist/extension/callerID doesn't exist, connect
	same => n(denylist),GotoIf(${DB_EXISTS(denylist/${EXTEN}/${NODENUM})}?:connect) ; not in denylist, connect
	same => n,NoOp(${EXTEN} is in denylist, Hangup)
	same => n,Hangup

	; connect!
	same => n(connect),rpt(${EXTEN})
	same => n,Hangup
```

The `[radio-secure]` stanza above checks to see if the incoming connection is an IAX2 connection, whether it is a node defined on this server (localhost, which is allowed to connect), and then whether the calling node number is on the [Allow and Deny Lists](../adv-topics/allowdenylists.md). Successful connections are then passed to `app_rpt`.

## `[iaxrpt]` Stanza
The `[iaxrpt]` stanza is called from the `[iaxrpt]` stanza in `iax.conf`. It is typically used to process connections from the [IAXRpt](../user-guide/externalapps.md#iaxrpt-pc-client) software client (or other [External Apps](../user-guide/externalapps.md)).

You should see the following in your ASL3 default `extensions.conf`:

```
[iaxrpt]
; Entered from iaxrpt in iax.conf
; Info: The X option passed to the Rpt application
; disables the normal security checks.
; Because incoming connections are validated in iax.conf,
; and we don't know where the user will be coming from in advance,
; the X option is required.
exten => ${NODE},1,rpt(${EXTEN},X)       ; NODE is the Name field in iaxrpt
```
As shown, this stanza doesn't do a whole lot, other than connect the client to our node via `app_rpt`. Note that since authentication was handled in `iax.conf`, `app_rpt` is called with the `X` option which translates to a normal endpoint but bypassing further authentication checks.

## `[iax-client]` Stanza
The `[iax-client]` stanza is called from the `[iaxclient]` stanza in `iax.conf`. It was/is typically used for connections from the [Zoiper](https://www.zoiper.com/) softphone client.

Zoiper is more cumbersome to configure and use than the other [External Apps](../user-guide/externalapps.md) that are now available that specifically support AllStarLink.

You should see the following in your ASL3 default `extensions.conf`:

```
[iax-client]                            ; for IAX VoIP clients.
exten => ${NODE},1,Ringing()
	same => n,Wait(10)
	same => n,Answer()
	same => n,Set(CALLSIGN=${CALLERID(name)})
	same => n,NoOp(Caller ID name is ${CALLSIGN})
	same => n,NoOp(Caller ID number is ${CALLERID(number)})
	same => n,GotoIf(${ISNULL(${CALLSIGN})}?hangit)
	same => n,Playback(rpt/connected-to&rpt/node)
	same => n,SayDigits(${NODE})
	same => n,rpt(${NODE},P,${CALLSIGN}-P)
	same => n(hangit),NoOp(No Caller ID Name)
	same => n,Playback(connection-failed)
	same => n,Wait(1)
	same => n,Hangup
```

This stanza is a little more involved than the [`[iaxrpt]`](#iaxrpt-stanza) stanza. It starts off sending some ringing tone to the client, checks to see if the client is sending a CallerID name (Callsign), and hangs up the call if there is no Callsign sent. Otherwise, it plays "Connected to Node", followed by the node number before passing the call to `app_rpt`. `app_rpt` is called with the `P` option, which means "Phone Control Mode". This allows a regular phone user to have full control and audio access to the radio system. For the	user to have DTMF control, the [`phone_functions`](./rpt_conf.md#phone-functions-stanza) parameter must be specified for the node in `rpt.conf`. An additional function ([`cop,6`](./rpt_conf.md#cop-commands)) must be listed so that PTT control is available.

## Autopatch Stanzas
There are a bunch of stanzas that relate to operation of the autopatch (if configured). This is for **outbound** calls, typically to the Public Switched Telephone Network (PSTN).

You should see the following in your ASL3 default `extensions.conf`:

```
; Comment-out the following clause if you want Allstar Autopatch service
[pstn-out]
exten => _NXXNXXXXXX,1,playback(ss-noservice)
	same => n,Congestion

; Un-comment out the following clause if you want Allstar Autopatch service
;[pstn-out]
;exten => _NXXNXXXXXX,1,Dial(IAX2/allstar-autopatch/\${EXTEN})
; same => n,Busy

[invalidnum]
exten => s,1,Wait(3)
	same => n,Playback(ss-noservice)
	same => n,Wait(1)
	same => n,Hangup

[radio]
exten => _X11,1,Goto(check_route,${EXTEN},1);
exten => _NXXXXXX,1,Goto(check_route,1${HOMENPA}${EXTEN},1)
exten => _1XXXXXXXXXX,1,Goto(check_route,${EXTEN},1)
exten => _07XX,1,Goto(parkedcalls,${EXTEN:1},1)
exten => 00,1,Goto(my-ip,s,1)

[check_route]
exten => _X.,1,NoOp(${EXTEN})
; no 800
exten => _1800NXXXXXX,2,Goto(invalidnum,s,1)
exten => _1888NXXXXXX,2,Goto(invalidnum,s,1)
exten => _1877NXXXXXX,2,Goto(invalidnum,s,1)
exten => _1866NXXXXXX,2,Goto(invalidnum,s,1)
exten => _1855NXXXXXX,2,Goto(invalidnum,s,1)
; no X00 NPA
exten => _1X00XXXXXXX,2,Goto(invalidnum,s,1)
; no X11 NPA
exten => _1X11XXXXXXX,2,Goto(invalidnum,s,1)
; no X11
exten => _X11,2,Goto(invalidnum,s,1)
; no 555 Prefix in any NPA
exten => _1NXX555XXXX,2,Goto(invalidnum,s,1)
; no 976 Prefix in any NPA
exten => _1NXX976XXXX,2,Goto(invalidnum,s,1)
; no NPA=809
exten => _1809XXXXXXX,2,Goto(invalidnum,s,1)
; no NPA=900
exten => _1900XXXXXXX,2,Goto(invalidnum,s,1)

; okay, route it
exten => _1NXXXXXXXXX,2,Goto(pstn-out,${EXTEN:1},1)
exten => _X.,2,Goto(invalidnum,s,1)

[my-ip]
exten => s,1,Wait(1)
	same => n,SayAlpha(${CURL(http://myip.vg)})
	same => n,Hangup
```

All of these stanzas work together. First and foremost, the main stanza for the autopatch is `[radio]`. This is defined in [`rpt.conf`](../config/rpt_conf.md#context) using the [`context`](./rpt_conf.md#context) directive. Note that the [`autopatchup`](../adv-topics/autopatch.md#autopatch-options) function allows this context to be overwritten using an option. 

The `[radio]` stanza does a few different things:

* If a three digit number, matching the pattern X11 is dialed, send it to `[check_route]`

* If a seven digit number is dialed, prepend it with the `HOMENPA` global variable, then send it to `[check_route]`

* If an eleven digit number is dialed, send it to `[check_route]`

* If a special number matching the pattern 07XX is dialed, pick up the parked call in slot XX

* If a special number of 00 is dialed, say the node's IP address over the radio (using the `[my-ip]` stanza)

The `[check_route]` stanza is the core of the autopatch dialplan. It is used to filter out numbers you do not want to allow to be dialed. This includes things like toll-free numbers, X11 numbers, 976/809/900 (toll) numbers, and the invalid 555 prefix. All of the filtered numbers get sent to the `[invalidnum]` stanza, which plays a mesage and hangs up.

If the call passes `[check_route]`, it gets sent to the `[pstn-out]` stanza. You will note that there are two options for `[pstn-out]`. The default is to play a message and hang up. By swapping which one is active (moving the comments around), you can send the call to the `[allstar-autopatch]` stanza in `iax.conf`. You can also configure your own VoIP provider, and send the call there (preferred).

## `[allstar-sys]` Stanza
The `[allstar-sys]` stanza is called from the `[allstar-sys]` stanza in `iax.conf`. The `[allstar-sys]` stanza is used by connections from the [AllStarLink Telephone Portal](../user-guide/phoneportal.md).

You should see the following in your ASL3 default `extensions.conf`:

```
[allstar-sys]
exten => _1.,1,Rpt(${EXTEN:1},Rrpt/node:NODE:rpt/in-call:digits/0:PARKED,120)
exten => _1.,n,Hangup

exten => _2.,1,Ringing
exten => _2.,n,Wait(3)
exten => _2.,n,Answer
exten => _2.,n,Playback(rpt/node)
exten => _2.,n,Saydigits(${EXTEN:1})
exten => _2.,n,Rpt(${EXTEN:1},P,${CALLERID(name)}-P)
exten => _2.,n,Hangup

exten => _3.,1,Ringing
exten => _3.,n,Wait(3)
exten => _3.,n,Answer
exten => _3.,n,Playback(rpt/node)
exten => _3.,n,Saydigits(${EXTEN:1})
exten => _3.,n,Rpt(${EXTEN:1},Pv,${CALLERID(name)}-P)
exten => _3.,n,Hangup

exten => _4.,1,Ringing
exten => _4.,n,Wait(3)
exten => _4.,n,Answer
exten => _4.,n,Playback(rpt/node)
exten => _4.,n,Saydigits(${EXTEN:1})
exten => _4.,n,Rpt(${EXTEN:1},D,${CALLERID(name)}-P)
exten => _4.,n,Hangup

exten => _5.,1,Ringing
exten => _5.,n,Wait(3)
exten => _5.,n,Answer
exten => _5.,n,Playback(rpt/node)
exten => _5.,n,Saydigits(${EXTEN:1})
exten => _5.,n,Rpt(${EXTEN:1},Dv,${CALLERID(name)}-P)
exten => _5.,n,Hangup
```

The option used when calling the Telephone Portal (Node Access or Reverse Autopatch) determines which extension gets used for processing in `[allstar-sys]`. Reverse Autopatch processes calls through extension 1 (which parks the call until someone on the radio side picks up the parked call). The Node Access method processes calls through extension 2 (function codes for keying PTT) or 3 (VOX for PTT).

## `[allstar-public]` Stanza
The `[allstar-public]` stanza is called from the `[allstar-public]` stanza in `iax.conf`. The `[allstar-public]` stanza is used by connections that use the AllStarLink ["Web Transceiver"](../user-guide/externalapps.md#web-transceiver) method of connection. The original Web Transceiver application has been deprecated, however, there are other [External Apps](../user-guide/externalapps.md) that still utilize this method to connect to AllStarLink Nodes.

You should see the following in your ASL3 default `extensions.conf`:

```
[allstar-public]
exten => s,1,Ringing
	same => n,Set(RESP=${CURL(https://register.allstarlink.org/cgi-bin/authwebphone.pl?${CALLERID(name)})})
	same => n,GotoIf($["${RESP:0:1}" = "?"]?hangit)
	same => n,GotoIf($["${RESP:0:1}" = ""]?hangit)
	same => n,GotoIf($["${RESP:0:5}" != "OHYES"]?hangit)
	same => n,Set(CALLSIGN=${RESP:5})
	same => n,Set(NODENUM=${CALLERID(num)})

	; if allowlist/extension doesn't exist, check the denylist
	same => n,GotoIf($[${DB_KEYCOUNT(allowlist/${NODENUM})} = 0]?denylist)              ; no allowlist, check denylist
	; if allowlist/extension/callsign exists, connect
	same => n,GotoIf(${DB_EXISTS(allowlist/${NODENUM}/${CALLSIGN})}?connect)            ; in allowlist, connect
	same => n,NoOp(${CALLSIGN} not in allowlist, Hangup)
	same => n,Hangup

	; if denylist/extension/callsign doesn't exist, connect
	same => n(denylist),GotoIf(${DB_EXISTS(denylist/${NODENUM}/${CALLSIGN})}?:connect) ; not in denylist, connect
	same => n,NoOp(${CALLSIGN} is in denylist, Hangup)
	same => n,Hangup

	; connect!
	same => n(connect),Set(CALLERID(name)=${CALLSIGN})
	same => n,Set(CALLERID(num)=0)
	same => n,Wait(3)
	same => n,Playback(rpt/connected-to&rpt/node,noanswer)
	same => n,SayDigits(${NODENUM})
	same => n,Rpt(${NODENUM},X)
	same => n,Hangup

	; hangup!
	same => n(hangit),Answer
	same => n,Wait(1)
	same => n,Hangup
```

When a client connects to the node using the Web Transceiver method, it sends its token from the AllStarLink system (if the client user has a valid [AllStarLink Portal](https://allstarlink.org/portal) account) as the CallerID Name. The first step is to authenticate if that is a valid token, which is done by a query to the API. If the token is valid, the associated **callsign** to that token checked against the [Allow and Deny Lists](../adv-topics/allowdenylists.md) (you can add callsigns to the database, in addition to node numbers). If that passes validation, it is sent to the connect part of the dialplan. The connect section of the dialplan plays the message, "Connected to node" followed by the node number, and passes the connection to `app_rpt` with the `X` option which translates to a normal endpoint but bypassing further authentication checks.

