# Autopatch
The autopatch feature in app_rpt allows users on the radio to interconnect with the public switched telephone network.

## Regulatory Issues


*Some countries do not allow third-party traffic through autopatching or 
telephone interconnection on amateur radio frequencies. In addition, if a system 
is linked between one country which allows autopatching and one which doesn't, 
just the passing of the traffic itself across the link could be considered a 
violation of the rules in the prohibiting country. In countries which permit 
autopatching, users need be made aware of this and should take the node off-link 
before using the autopatch.*

## Security Issues

*The examples provided here do not secure the autopatch against toll fraud. A lot 
can be done to prevent or reduce toll fraud, but the prevention measures vary by 
where you are located geographically. Most of the prevention measures will be in 
extensions.conf. You can write contexts to reject certain number sequences. 
The [asterisk book](http://www.asteriskdocs.org/) should be consulted to see how to do 
this, Before placing any autopatch in service, please make sure you have secured 
your system so that toll fraud does not become an issue.*

## Selecting a VOIP Provider

Call termination into the public switched telephone network is a service offered by
a Voice Over IP provider (VOIP). This is a highly competitive business, 
and there are lots of VOIP providers offering termination for Asterisk users. 
Termination is usually provided using the SIP protocol, while IAX is offered 
by a few providers.

When selecting an VOIP provider, make sure they provide setup instructions with 
example configurations including usernames, and passwords. Quite a few VOIPs will 
automatically generate a custom SIP or IAX stanza for insertion into sip.conf, 
or iax.conf respectively.

## Configuration Files

Three configuration files will be used to setup the autopatch: **rpt.conf**, **extensions.conf** and 
**iax.conf** or **sip.conf**. The VOIP provider should provide a stanza for you to insert in 
**iax.conf** or **sip.conf**. The configuration below shows how each of these files are 
used when an outgoing autopatch call is made.

In the **rpt.conf** configuration file, a context in extensions.conf is defined 
in a node stanza using the context key:

```
[1234]

context = autopatch					; dialing context for phone
callerid = "Repeater" <0000000000>	; callerid for phone calls
accountcode = RADIO                 ; account code (optional)
```
Also in the **rpt.conf** file, entries are added to the function stanza so 
that users can bring up or take down the autopatch:
```
[functions]
61 = autopatchup,noct=1,farenddisconnect=1,dialtime=20000,context=autopatch
62 = autopatchdn 
```

In **extensions.conf**, a stanza for the autopatch context is added which 
refers to the peer stanza in iax.conf or sip.conf. 

For outbound IAX connections extensions.conf
```
[autopatch] 

exten => _1NXXNXXXXXX,1,Dial,IAX2/peername/${EXTEN} 
exten => _1NXXNXXXXXX,2,Congestion 
```
For outbound SIP connections it should look like this:
```
[autopatch] 

exten => _1NXXNXXXXXX,1,Dial,SIP/peername/${EXTEN} 
exten => _1NXXNXXXXXX,2,Congestion 
```

The peer stanza you insert in **iax.conf** or **sip.conf** should preferably be 
provided by your VOIP provider. You'll want to use the stanza they identify for 
performing outgoing connections. A nonoperational example of an iax2 peer stanza 
looks like this:
```
[peername]
type=peer 
host=127.0.0.1 
secret=nunya
auth=md5 
disallow=all 
allow=gsm 
allow=ulaw
```

## Autopatch Options

There are several options that can be passed to the autopatchup command class.

This table summarizes what they do:

| Autopatch Option | Description |
|---------|-------------|
| context | Override the context specified for the autopatch in rpt.conf |
| dialtime | The maximum time to wait between DTMF digits when a telephone number is being dialed. The patch will automatically disconnect if this time is exceeded. The value is specified in milliseconds. |
| farenddisconnect | When set to 1, the patch will automatically disconnect when the called party hangs up. The default is send a circuit busy tone until the radio user brings the patch down. |
| noct | When this is set to 1, the courtesy tone during an autopatch call will be disabled. The default is to send the courtesy tone whenever the radio user unkeys. |
| quiet | When set to 1, do not send dial tone, voice responses, just try to connect the call. |
| voxalways | When set to 1, enables vox mode. |
| exten | Overrides the default autopatch extension. |
| nostar | Disables the repeater function prefix |

## Simplex Autopatch
For nodes with duplex set to 0 or 1, Simplex Autopatch operation is supported.
This is accomplished by using a VOX on the audio coming from the telephone call, 
because of the half-duplex nature of the node. To avoid having audio from the 
telephone call keep the transmitter engaged for extended periods of time (if there 
is some source of continuous audio), there are two time-out values. 

Vox timeout, which is the maximum amount of time that the VOX can hold the transmitter 
engaged, which by default is 10 seconds. The other one is the Vox recovery time, which
is the amount of time that the Vox is disabled during times of continuous audio, after
the Vox timeout, which is 2 seconds. During continuous audio, it transmits for 
10 seconds, then stops for 2 seconds (so that you can transmit to it and perhaps 
disconnect the call), then transmits for another 10 seconds, then stops for 2 seconds.
This repeats until the call is disconnected.

Additionally, to prevent 'chop-off' of the first syllable or two of the audio from the 
telephone call, the audio is delayed to allow for the transmitter to start transmitting 
and any CTCSS tones to be decoded. This delay is typically 500ms, but can be adjusted
using the 'simplexpatchdelay' parameter. It is specified in units of 20 milliseconds.

These time-out values may be overridden by using the following configuration parameters
located in the [node-number] section of **rpt.conf**:
```
[1999]
voxtimeout = 10000 ; vox timeout time in ms
voxrecover = 2000  ; vox recover time in ms
simplexpatchdelay = 25 ; Delay for transmit while in patch in 20ms increments
simplexphonedelay = 25 ; Delay for phone while in patch for 20ms increments
```
