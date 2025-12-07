# VOTER Mix Mode (General Purpose) Application
The primary use of the VOTER/RTCM is to implement multi-site receiver voting repeater systems. That leads itself then to also adding simulcast transmitters (if you already have the sites for receivers).

However, this is not the only use case.

The VOTER/RTCM also works very well as a repeater interface to a stand-alone repeater. In fact, in a few key areas, it is a superior choice for interfacing a repeater to AllStarLink:

* Hardened hardware (no SD card to corrupt with power failures)
* No operating system crashes
* No USB configuration issues
* No USB audio level configurations to get corrupted
* Supports CTCSS transmit tone generation
* Easily transits NAT networks with minimal network configuration

Remember, the VOTER/RTCM is basically a custom Radio over IP (RoIP) adapter. It was just designed from the ground up by a very smart amateur radio operator.

When used in "General Purpose"/"Mix Mode" (for a stand-alone repeater), you **do not** require a GPS for timing, therefore you do **not** define a `master` entry for any of the clients in the instance. There is nothing stopping you from using a GPS, but you **must** set the `GPS PPS Polarity` setting to `2` (ignore) to force the VOTER/RTCM into "General Purpose" mode.  

A simple [`voter.conf`](../config/voter_conf.md) for Mix Mode would look like this:

```
[general]
port = 1667
password = BLAH

[1999]
Site1 = pswrd1,master,transmit
Site2 = pswrd2,transmit
```

!!! warning "Set GPS PPS Polarity"
    Remember to set the `GPS PPS Polarity` to `2=NONE` (and save and reboot) on each Mix Mode VOTER/RTCM client to put it in to Mix Mode/General Purpose mode.

See the [VOTER Protocol](./voter-protocol.md#general-purpose-mode-operation) page for further details on how the underlying protocol works.

## Single Client Mode (RoIP Adapter)
You can use a single mix mode client to control a repeater over an IP link (versus a radio link). This has the advantage of using a hardened, firmware-based device as the repeater's radio interface (at the repeater site), and letting the AllStarLink host reside elsewhere (could even be on a VPS "in the cloud").

## Multiple Client Mode
You can use multiple Mix Mode clients under the same instance, and audio from all of them will be "mixed" together and sent out the defined transmitter(s). 

Think about that carefully, if all the receivers are on the same frequency and have overlapping coverage, this could provide undesirable results (you probably want to use voting clients in that case). 

You can, however, have multiple clients on multiple RX/TX frequencies, and they would all be effectively "linked" together and present themselves as a single AllStarLink node.

## Mixing With Voting Clients
As the name "Mix Mode" implies, you could have a "General Purpose" client that is mixed with voting clients, and `chan_voter` will "mix" the audio from non-voting clients with the voted audio. You might use this to add in some sort of "non-repeater" audio source.

## Mixminus Mode
There is also a special application of Mix Mode, and that is enabled by setting the configuration option [`mixminux = 1`](../config/voter_conf.md#mixminus) under the instance in [`voter.conf`](../config/voter_conf.md).

In this mode of operation, the receiver audio is sent to all transmitters, **EXCEPT** for the one that is receiving ("mix" and send the audio to all transmitters, "minus" the one receiving it). In addition, DTMF tones are passed through between all clients to all transmitters (this is **NOT** how all the other channel drivers work).

This mode is typically used to replace UHF links between multiple linked repeaters that currently utilize conventional repeater controllers. In this application, the VOTER/RTCM interfaces are connected to the conventional repeater controller's port in place of the existing UHF link radios. The reason the receiving client is excluded from transmitting is that the conventional controller is already taking care of repeating that, and (transmit) audio coming in on the link port from the VOTER/RTCM could lead to "echo" or other undesirable effects.

The DTMF passthrough allows the conventional repeater controllers to still be able to control each other (like they would with UHF links)

A typical `voter.conf` for this sort of application might look like:

```
[general]
port = 667
password = BLAH
utos = y
buflen = 250

[1999]
Site01 = secret1,transmit,nodeemp,noplfilter
Site02 = secret2,transmit,nodeemp,noplfilter
Site03 = secret3,transmit,nodeemp,noplfilter
Site04 = secret4,transmit,nodeemp,noplfilter
Site05 = secret5,transmit,nodeemp,noplfilter
mixminus = y
plfilter = n
```

## Troubleshooting
#### Mixed Client Error
"I am getting this error in Asterisk":

```
WARNING[2559643]: chan_voter.c:4864 voter_reader: VOTER client master timing source my_client attempting to authenticate as a mix client!! (HUH??)
```

This error means the VOTER/RTCM client in [`voter.conf`](../config/voter_conf.md) has `master` set in its client definition, but the `GPS PPS Polarity` on the client is set to `2 = NONE`. 

If you want to use a mix client (non-voted), make sure that client definition in [`voter.conf`](../config/voter_conf.md) **does not** have the `master` option set.

#### Mix Clients with Voted Client Issues
Situation...
"I have a private node with 6 voted receivers using RTCMs. I'd like to add a 7th RTCM to this node that is always mixed in rather than voted. I'm able to make this RTCM work as a 7th voted receiver with no problem. Everything I've read seems to indicate that if I change `GPS PPS Polarity` to `none` this will achieve my desired results, however, I am unable to get audio out of my transmit RTCM from this 7th site. It does change color to cyan in Allmon3 indicating it is a non-voted input, but I do not get any indication or audio when that unit's COR goes active."

"Setting `core set debug 3 chan_voter` in Asterisk shows the following message repeatedly scrolling by in a blur when the mix client detects COR (COR is active). I'm running software version 1.47 on all my clients:"

```
ERROR[2559564]: chan_voter.c:4300 voter_reader: Mix client my_client out of bounds! buflen must be >=160 in voter.conf with Mix clients!
DEBUG[2559564]: chan_voter.c:4298 voter_reader: Mix client my_client index 0 < bufflen 640 out of bounds, resetting!!
```

If you have a similar situation to the above... check your `buflen` in [`voter.conf`](../config/voter_conf.md). Make sure it is at >=160, as that is the minimum buffer size required for mix clients. You may also want to review [Buffer Tuning](./voter-buffers.md).