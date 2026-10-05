# Courtesy Tones
This is how to use and define courtesy tones for ASL3. The telemetry tones to **use** are defined for each node in the [`[node]`](../config/rpt_conf.md#node-number-stanza) stanza. The telemetry **definitions** common to all nodes are in the [`[telemetry]`](../config/rpt_conf.md#telemetry-stanza) stanza.

Also see [config file templating](./conftmpl.md) for more information on where to put node-specific options.

## `[node]` Stanza Settings
The `[node]` stanza keys below define what un-key events you want to send courtesy tones for, and exceptions for un-key events on locally connected nodes (hosted on the same server).

Key|Value|Description
---|-----|-----------
`linkunkeyct`|telemetry stanza key|Courtesy tone sent when a networked user un-keys. The default for this is no courtesy tone
`nolocallinkct`|1 or 0|Send `unlinkedct` instead of `linkedct` if another local node is connected to this node (hosted on the same server)
`remotect`|telemetry stanza key|This courtesy tone will be sent in addition to any other courtesy tone when a remote base is connected to the node. The default is to send telemetry stanza key `ct3`
`unlinkedct`|telemetry stanza key|Send a this courtesy tone when the user un-keys if the node is not connected to any other nodes

Example `[node]` stanza:

```
[1234]                              ; Your node number
telemetry = telemetry               ; Points to the telemetry stanza
unlinkedct = ct2                    ; Send a this courtesy tone when the user un-keys if the node is not connected to any other nodes. (optional, default is none)
remotect = ct3                      ; remote linked courtesy tone (indicates a remote is in the list of links)
linkunkeyct = ct8                   ; sent when a transmission received over the link un-keys
;nolocallinkct = 0                  ; Send unlinkedct instead if another local node is connected to this node (hosted on the same server).
```

## `[telemetry]` Stanza Settings
The `[telemetry]` stanza is used to **define** a telemetry sequence. A telemetry sequence can be a morse code ID, morse code message, a tone sequence, or a sound file.

For clarity, the different types of telemetry methods supported are:

Telemetry Method|Telemetry Description
----------------|---------------------
`|i`|Morse ID
`|m`|Morse message
`|t`|Tone sequence
`<none>`|If the telemetry string does not start with a `|`, then the string is a path to a sound file

Since we are discussing courtesy tones, we will skip over the morse and voice options.

To define a telemetry sequence, you must first choose a telemetry key, then set the value for that key as follows:

```
mykey=|t(tone group)[(tone group)][...]
```

Where:

* `mykey` is a name for the courtesy tone, known as the *courtesy tone key*

* `tone group` is a way to define a single or dual tone sequence of arbitrary duration, frequency, and amplitude. There can be one or multiple tone groups for entry in the telemetry stanza

### Tone Group
A tone group is a set of 4 comma separated integers formatted as follows:

```
(frequency1,frequency2,duration,amplitude)
```

* `frequency1` and `frequency2` must be a number between `0` and `3000`. These specify the tone frequency in Hz

* `duration` is the tone on time in Milliseconds

* `amplitude` is the relative volume level of the tone or tones. This can be from `0` to `8192`

A tone group consisting of zeroes for amplitude and frequency will be sent as a silent period.

A single frequency tone can be sent by setting `frequency2` to `0`.

!!! note "No Spaces"
    There must be **no** spaces between the commas, numbers, or the parenthesis.

Example `[telemetry]` Stanza

```
 [telemetry]
 ct1=|t(350,0,100,2048)(500,0,100,2048)(660,0,100,2048)
 ct2=|t(660,880,150,2048)
 ct3=|t(440,0,150,4096)
 ct4=|t(550,0,150,2048)
 ct5=|t(660,0,150,2048)
 ct6=|t(880,0,150,2048)
 ct7=|t(660,440,150,2048)
 ct8=|t(700,1100,150,2048)
 remotetx=|t(1633,0,50,3000)(0,0,80,0)(1209,0,50,3000)
 remotemon=|t(1209,0,50,2048)
 cmdmode=|t(900,903,200,2048)
 functcomplete=|t(1000,0,100,2048)(0,0,100,0)(1000,0,100,2048)
 patchup=rpt/callproceeding         ; play the rpt/callproceeding sound file, instead of a tone sequence
 patchdown=rpt/callterminated       ; play the rpt/callerminated sound file, instead of a tone sequence
```
