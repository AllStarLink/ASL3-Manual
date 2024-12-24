# Autopatch
The autopatch feature in app_rpt allows users on the radio to interconnect with the public switched telephone network.  This means a HAM operator can dial a phone number from the radio and be connected to a phone.  The reverse is also possible with someone being able to dial a phone number and be connected to the node.  This is achieved using an account with a VOIP service provider and connecting the Allstar node.

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

## Duplex and VOX

Nodes with duplex set to 0 or 1 will use VOX automatically.  Nodes with duplex set to 2 or higher can use phone mode. In phone mode, one can key up the radio by dialing *99 and unkey by dialing #.  One can configure simplex autopatch to not use VOX, but simplex reverse autopatch must use VOX, so it is preferable to use VOX both ways for simplex nodes.  Nodes configured for VOX autopatch should advise callers to mute their phone and unmute only when talking.  Additional info in the [Simplex Autopatch](#simplex-autopatch) section.

## Selecting a VOIP Provider

Call termination into the public switched telephone network is a service offered by
a Voice Over IP provider (VOIP). This is a highly competitive business, 
and there are lots of VOIP providers offering termination for Asterisk users. 
Termination is usually provided using the SIP protocol, while IAX is offered 
by a few providers.

When selecting an VOIP provider, make sure they provide setup instructions with 
example configurations including usernames, and passwords. Quite a few VOIPs will 
automatically generate a custom SIP or IAX stanza for insertion into sip.conf, 
or iax.conf respectively. Not all providers will supply configuration examples. 
This guide includes example configuration files that may need adjustments to get 
working with specific providers and ASL versions.

This guide will document the general process for setting up IAX2 and SIP providers with expamples for voip.ms IAX and flowroute.com SIP.  Any provider should be setup in a similar fashion.

## VOIP Provider Setup
Whatever provider one chooses, the same things must be setup.  Different providers will have different names for each item but the setup will be similar.
- A phone number or DID must be purchased.
- E911 service should be setup.
- CallerID must be setup for the DID.
- Inbound routing will need to be setup so calls are routed to the node via IAX2 or SIP.
- Authentication for outbound calls must be configured.

## Firewall Setup
- If using IAX, the firewall will already be configured properly. If using SIP, on the Allstar Node, add SIP service on the firewall:
```
root@localhost:/# firewall-cmd --add-service=SIP --permanent
```
- On the router/firewall, forward/open ports as required:

    1) Traffic from IAX/SIP provider to TCP and UDP port 5060 on the node.

    2) Traffic from WAN to UDP port range 10000-20000 on the node.

## Configuration Files

Four configuration files will be used to setup the autopatch: **rpt.conf**, 
**extensions.conf**, **modules.conf**, and **iax.conf** or **pjsip.conf**. 
The VOIP provider should provide a stanza for you to insert in **iax.conf** 
or **pjsip.conf**. The configuration below shows how each of these files are 
used when an outgoing autopatch or reverse autopatch call is made.

### modules.conf
In the **/etc/asterisk/modules.conf** file, add these modules at the bottom of the file, but 
above the [global] stanza:

```
load => bridge_builtin_features.so
load => bridge_builtin_interval_features.so
load => bridge_holding.so
load => bridge_native_rtp.so
load => bridge_simple.so
load => bridge_softmix.so
load => chan_bridge_media.so
load => app_verbose.so
load => app_read.so

```
If using a SIP trunking provider, add these additional lines at the bottom of 
modules.conf, above the [global] stanza:

```
;
; modules for pjsip
;
noload = app_voicemail.so
load = bridge_builtin_features.so
load = bridge_builtin_interval_features.so
load = bridge_holding.so
load = bridge_native_rtp.so
load = bridge_simple.so
load = bridge_softmix.so
load = chan_bridge_media.so
load = chan_pjsip.so
load = func_pjsip_endpoint.so
load = func_sorcery.so
load = func_devstate.so
load = res_pjproject.so
load = res_pjsip_acl.so
load = res_pjsip_authenticator_digest.so
load = res_pjsip_caller_id.so
load = res_pjsip_dialog_info_body_generator.so
load = res_pjsip_diversion.so
load = res_pjsip_dtmf_info.so
load = res_pjsip_endpoint_identifier_anonymous.so
load = res_pjsip_endpoint_identifier_ip.so
load = res_pjsip_endpoint_identifier_user.so
load = res_pjsip_exten_state.so
load = res_pjsip_header_funcs.so
load = res_pjsip_logger.so
load = res_pjsip_messaging.so
load = res_pjsip_mwi_body_generator.so
load = res_pjsip_mwi.so
load = res_pjsip_nat.so
load = res_pjsip_notify.so
load = res_pjsip_one_touch_record_info.so
load = res_pjsip_outbound_authenticator_digest.so
load = res_pjsip_outbound_publish.so
load = res_pjsip_outbound_registration.so
load = res_pjsip_path.so
load = res_pjsip_pidf_body_generator.so
load = res_pjsip_pidf_digium_body_supplement.so
load = res_pjsip_pidf_eyebeam_body_supplement.so
load = res_pjsip_publish_asterisk.so
load = res_pjsip_pubsub.so
load = res_pjsip_refer.so
load = res_pjsip_registrar.so
load = res_pjsip_rfc3326.so
load = res_pjsip_sdp_rtp.so
load = res_pjsip_send_to_voicemail.so
load = res_pjsip_session.so
load = res_pjsip.so
noload = res_pjsip_t38.so
noload = res_pjsip_transport_websocket.so
load = res_pjsip_xpidf_body_generator.so
load = res_rtp_asterisk.so
load = res_sorcery_astdb.so
load = res_sorcery_config.so
load = res_sorcery_memory.so
load = res_sorcery_realtime.so
```

### rpt.conf
In the **/etc/asterisk/rpt.conf** configuration file, a context in extensions.conf is defined 
in a node stanza using the context key:

```
[1234]

context = autopatch					; dialing context for phone
callerid = "Repeater" <0000000000>	; callerid for phone calls
accountcode = RADIO                 ; account code (optional)
```
Also in the **/etc/asterisk/rpt.conf** file, entries are added to the function stanza so 
that users can bring up or take down the autopatch:
```
[functions]
61 = autopatchup,noct=1,farenddisconnect=1,dialtime=20000,context=autopatch,quiet=1
0 = cmd,/var/lib/asterisk/hangupPhones            ; Hangup All phone patches
```

#### Autopatch Options

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

#### Create a Script to Handle Terminating Calls
Create the following script to handle terminating calls. Without this script, you will be unable to forcefully terminate **incoming** calls:

```bash
nano /var/lib/asterisk/hangupPhones
```

Paste this script into the file:

```bash
#!/bin/bash
# Target pattern to match (adjust as needed for different calls)
TARGET_PATTERN="IAX2/voipms-"
# TARGET_PATTERN="PJSIP/flowroute-"
# Get the list of channels and their concise details
CHANNELS=$(asterisk -rx "core show channels concise")
echo "Checking for matching channels..."
echo "--------------------------------"
# Iterate over each line to find the target channel
while IFS= read -r line; do
    if [[ $line == $TARGET_PATTERN* ]]; then
        CHANNEL=$(echo "$line" | awk -F'!' '{print $1}')
        CALLERID=$(echo "$line" | awk -F'!' '{print $3}')
        echo "Found matching channel: $CHANNEL with Caller ID: $CALLERID"
        echo "Hanging up channel: $CHANNEL"
        asterisk -rx "channel request hangup $CHANNEL"
    fi
done <<< "$CHANNELS"
```

Make it executable:

```bash
chmod +x /var/lib/asterisk/hangupPhones
```

### extentions.conf

In **/etc/asterisk/extensions.conf**, a stanza for the autopatch context is added which 
refers to the peer stanza in iax.conf or pjsip.conf.  These examples will likely need to be adjusted to work with a specific provider: 

For outbound IAX connections extensions.conf:
```
[autopatch] 

; Match any 10-digit number (e.g., North American local format).
exten => _NXXNXXXXXX,1,Dial(IAX2/voipms/${EXTEN})
; After the call is completed, hang up the line.
exten => _NXXNXXXXXX,n,Hangup()

```
For outbound SIP connections extensions.conf, this example uses IP auth:
```
[autopatch]
; Match any 10-digit number (e.g., North American local format).
exten => _NXXNXXXXXX,1,Dial(PJSIP/flowroute-endpoint/sip:[tech-prefix]*+1${EXTEN}@us-east-va.sip.flowroute.com)
; After the call is completed, hang up the line.
exten => _NXXNXXXXXX,n,Hangup()
```

Setup 911 extention
```
; Match 911
exten => 911,1,Dial(IAX2/voipms/${EXTEN})
; The Dial command routes the call through the IAX2 channel to the "voipms" trunk,
; passing the dialed number (${EXTEN}) to the provider.

; After the call is completed, hang up the line.
exten => 911,n,Hangup()

; Optional: Reroute 911 to another number
; Uncomment the following lines to enable this feature:
; Instead of routing 911 directly, reroute it to the specified number (e.g., 1234567890).
; This could be used to route emergency calls to a different service or internal security.
; exten => 911,1,Dial(IAX2/voipms/1234567890)
; After the rerouted call is completed, hang up the line.
; exten => 911,n,Hangup()
```
And finally the reverse autopatch section
```
; REVERSE-AUTOPATCH - REPEATER RECEIVES INCOMING CALLS

[reverse-autopatch]
; Change below to the voip DID number
VOIPDID = 5555554321

exten => _X.,1,Verbose(1, Caller ${CALLERID(all)} has entered IVR menu)
; wait a bit before answering
exten => _X.,n,Wait(2)

; Answer the incoming call.
exten => _X.,n,Answer()

; Wait for 1 second to ensure the line is stable before playing the prompt.
exten => _X.,n,Wait(1)

; Optional: Bypass PIN for trusted caller
; Uncomment the below line to enable this feature:
; If the incoming call is from a trusted number (5551234567 or 5559876543 in this example),
; skip the PIN code and go directly to the "${VOIPDID}" label.
;exten => _X.,n,GotoIf($["${CALLERID(num)}" = "+15555551234"]?5555554321,1)
; Example of how to "trust" two (or more) phone numbers
; exten => _X.,n,GotoIf($["${CALLERID(num)}" = "5551234567" | "${CALLERID(num)}" = "5559876543"]?${VOIPDID},1)

; Initialize an attempt counter
exten => _X.,n,Set(ATTEMPTS=0)
; Play a message that asks the caller to enter their PIN followed by the pound/hash key, along with other information like mute/unmute procedure, ID with callsign, etc.
exten => _X.,n(start),Playback(message)

; Wait for the caller to enter a 4-digit PIN.
; - "PIN" is the variable where the entered digits will be stored.
; - "beep" will play a beep sound to prompt the user.
; - "4" specifies the PIN length (4 digits).
; - ",,5" sets a 5-second timeout for the user to start entering the PIN.
exten => _X.,n,Read(PIN,beep,4,,,5)

; SET YOUR PIN(s) HERE! THESE PIN(s) WILL BE USED TO PATCH INTO THE REPEATER
; Check if the entered PIN is one of the valid PINs.
; - If the PIN is correct, the call will go to the label "wait-for-pound".
; - If not, it will continue to the next step.
exten => _X.,n,GotoIf($["${PIN}" = "1234"]?wait-for-pound)
; Example of how to set up two (or more) PINs:
; exten => _X.,n,GotoIf($["${PIN}" = "1234" | "${PIN}" = "5678"]?wait-for-pound)

; Increment the attempt counter
exten => _X.,n,Set(ATTEMPTS=$[${ATTEMPTS}+1])

; If the PIN is invalid, play a message saying it was incorrect.
; "confbridge-invalid" says: "You have entered an invalid option."
exten => _X.,n,Playback(confbridge-invalid)

; Check if the attempt counter has reached 3
exten => _X.,n,GotoIf($[${ATTEMPTS} >= 3]?too-many-failures)

; Go back to the start and ask the user to enter the PIN again.
; This gives the user another chance to enter a valid PIN.
exten => _X.,n,Goto(start)

; If the user fails to enter a valid PIN after 3 attempts, play a message saying they have entered too many invalid PINs.
; "confbridge-pin-bad" says: "You have entered too many invalid personal identification numbers."
exten => _X.,n(too-many-failures),Playback(confbridge-pin-bad)

; Hang up the call after the failure message.
exten => _X.,n,Hangup()

; After the valid PIN is entered, wait for the user to press the "#" key.
; - This command waits for the user to press "#" to confirm the PIN entry.
; - The 5-second timeout will give the user time to press "#".
exten => _X.,n(wait-for-pound),WaitExten(5)

; If the user presses "#", go to the "${VOIPDID}" label.
exten => #,1,Goto(${VOIPDID},1)

; If "#" is not pressed, go to the start label.
exten => _X.,89,Goto(start)

; If the correct PIN was entered and "#" was pressed, play a message confirming the connection.
; "rpt/connected" could say something like: "You are now connected."
exten => ${VOIPDID},1,Playback(rpt/connected)

; Connect the caller to the repeater using the "rpt" command.
; The "|P" option is used to specify "phone" mode in app_rpt.
exten => ${VOIPDID},n,rpt(${NODE}|Pv)

; Hang up the call after the connection is made.
exten => ${VOIPDID},n,Hangup()
```

### iax.conf
If using an IAX provider, add the following lines to `/etc/asterisk/iax.conf` under the `[general]` stanza.  Items in between brackets should be replaced with specific account info, except the stanza names themselves:

```plaintext
; ENTER YOUR VOIP.MS CREDENTIALS AND SERVER HERE
register => [VOIPMS_ID]:[VOIPMS_PASSWORD]@[VOIPMS_HOST]
; Example: register => 123456:supersecretpassword@dallas1.voip.ms
```

Add this new stanza to `iax.conf`:

```plaintext
[voipms]
username=[VOIPMS_ID]; ENTER YOUR 6-DIGIT VOIP.MS USERNAME HERE
type=friend
context=reverse-autopatch
host=[VOIPMS_HOST]; ENTER THE VOIP.MS SERVER ADDRESS YOU SELECTED FOR YOUR DID HERE
secret=[VOIPMS_PASSWORD]; ENTER YOUR VOIP.MS IAX PASSWORD HERE
disallow=all
allow=ulaw
allow=g726aal2
allow=gsm
codecpriority=host
insecure=port,invite
requirecalltoken=yes
```

### pjsip.conf
If using a SIP provider, replace/create the **/etc/asterisk/pjsip.conf** file.  This file is based on a node behind NAT and should be updated for specfic providers and accounts:
```
;===============TRANSPORT

[sip-trans]
type=transport
protocol=udp
bind=0.0.0.0
local_net=[LAN Network IP]/24
local_net=127.0.0.1/32
external_media_address=[INET IP]
external_signaling_address=[INET IP]
;===============TRUNK

[flowroute-reg]
type=registration
outbound_auth=flowroute-auth
server_uri=sip:us-east-va.sip.flowroute.com
client_uri=sip:[Tech Prefix]@us-east-va.sip.flowroute.com
retry_interval=60
contact_user=[VOIP DID]@[WAN IP]

[flowroute-auth]
type=auth
auth_type=userpass
password=[password]
username=[Tech Prefix]
;realm=us-west-or.sip.flowroute.com


[flowroute-aor]
type=aor
contact=sip:[WAN IP]:5060

[flowroute-endpoint]
type=endpoint
context=reverse-autopatch
disallow=all
allow=ulaw
allow=g726aal2
allow=alaw
allow=gsm
;outbound_auth=flowroute-auth
aors=flowroute-aor
;outbound_proxy = sip:us-west-or.sip.flowroute.com
from_domain=[WAN IP]
 
[flowroute-id]
type=identify
endpoint=flowroute-endpoint
match=us-east-va.sip.flowroute.com
```

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
