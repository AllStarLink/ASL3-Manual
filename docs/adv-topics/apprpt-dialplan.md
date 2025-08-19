# Calling app_rpt in a Dialplan
If you look closely in [`extensions.conf`](../config/extensions_conf.md), you will see that a number of the contexts do some processing on the incoming call into the context's dialplan, and then will often hand the call off to `app_rpt` using a command like: `same => n(connect),rpt(${EXTEN})`.

There are a number of different options to call `app_rpt`, each used for specific applications or use cases. They are processed by the `rpt_exec` function in `app_rpt.c`.

The general format of the method to call `app_rpt` is:

```
exten => name,priority,rpt(${EXTEN},option)
```

The `${EXTEN}` variable is expected to be a node number that is passed into the relevant context by a channel driver. When the call is passed to `app_rpt`, it will get added to the conference bridge on the node.

The `option` values that `app_rpt` supports, and their purpose are as follows:

|<div style="width:300px">`option` value</div>|Description|<div style="width:250px">Example</div>|
|---------------------------------------------|-----------|-------|
none or `X`|Normal endpoint mode WITHOUT any security checks. Only specify this if the security of the incoming call has already been checked (like with an IAX2 user/password or some other validation) |`exten => ${NODE},1,rpt(${EXTEN},X)`
`D[m|v][,CALLERID STRING]`|Dumb Phone Control mode. This allows a regular phone user to have full control and audio access to the radio system. In this mode, the PTT is activated for the entire length of the call. For the user to have DTMF control (not generally recommended in this mode), the `[dphone_functions]` context must be defined for the node in [`rpt.conf`](../config/rpt_conf.md). Otherwise, no DTMF control will be available to the phone user|`exten => _4.,n,Rpt(${EXTEN:1},D,${CALLERID(name)}-P)`
`P[m|v][,CALLERID STRING]`|Phone Control mode. This allows a regular phone user to have full control and audio access to the radio system. For the user to have DTMF control, the [`[phone_functions]`](../config/rpt_conf.md#phone-functions-stanza) context must be defined for the node in [`rpt.conf`](../config/rpt_conf.md). An additional function ([`cop,6`](../config/rpt_conf.md#cop-commands)) must also be enabled so that PTT control is available|`same => n,rpt(${NODE},P,${CALLSIGN}-P)`
`R[m|v]announce-string[,timeout[,timeout-destination]]`|Reverse Autopatch. Caller is put on hold, and announcement (as specified by the `announce-string`) is played on radio system. Users of the radio system can access autopatch, dial a specified code, and pick up the call. Announce-string is a `:` separated list of names of recordings/sound files, *or* `PARKED` to substitute code for un-parking, *or* `NODE` to substitute the node number (see the `[allstar-sys]` context in the default [`extensions.conf`](../config/extensions_conf.md))|`exten => _1.,1,Rpt(${EXTEN:1},Rrpt/node:NODE:rpt/in-call:digits/0:PARKED,120)`
`S[m|v][,CALLERID STRING]`|Simplex Dumb Phone Control mode. This allows a regular phone user audio-only access to the radio system. In this mode, the transmitter is toggled on and off when the phone user presses the `funcchar` (`*`) key on the telephone set. In addition, the transmitter will turn off if the `endchar` (`#`) key is pressed. When a user first calls in, the transmitter will be off, and the user can listen for radio traffic. When the user wants to transmit, they press the `*` key, start talking, then press the `*` key again or the `#` key to turn the transmitter off. No other functions can be executed by the user on the phone when this mode is selected. <br>**Note:** If your radio system is full-duplex, we recommend using either `P` or `D` modes as they provide more flexibility.|`same => n,rpt(${NODE},S,${CALLSIGN}-P)`
`V,<variable>=<value>`|Set an Asterisk channel variable for the specified node|`exten => ${NODE},1,rpt(${NODE},V,foo=bar)`

!!! note "`[CALLERID STRING]`"
    `[CALLERID STRING]` is a string or variable that is passed to `app_rpt`, often used to display information about the calling party in the Allmon3 dashboard. Be aware that if you terminate the option with `-P`, Allmon3 will treat that as a special case, and set the Description to "AllStar Telephone Portal User"

!!! note "Monitor Mode"
    Options `D`, `P`, `R`, and `S` all accept the `m` sub-option for "monitor" mode (e.g. `Pm`). In this mode, no transmit or functions are allowed (monitoring only). This appears broken, follow [Issue 768](https://github.com/AllStarLink/app_rpt/issues/768).

!!! note "VOX Mode"
    Options `D`, `P`, `R`, and `S` all technically accept the `v` sub-option for VOX mode (e.g `Pv`). This only seems to really make sense for the `P` and `R` options, as the `D` option should have the transmitter keyed all the time regardless, and `S` is restricted to function keying. **If you specify VOX Mode for option `D`, the node will NOT key.**

The options below are present in the source code, but their usage is not well documented/understood. If you have further insight to how these options work, please file a [GitHub Issue](https://github.com/AllStarLink/ASL3-Manual/issues).

|<div style="width:350px">`option` value</div>|Description|
--------------|-----------
`F`|Forward call? Treated as an authenticated call (like `X`)
`Mxx`|Memory Channel Steer.  Where `xx` is the memory channel number. This appears broken, follow [Issue 737](https://github.com/AllStarLink/app_rpt/issues/737)
`o`|Something to do with `channel_revert`? May revert to the last channel after using `Mxx`?
`q`|Query channel variables?
`*x`|Load a macro number (`x`) to execute. Appears to be related to option `Z`
`Z`|Execute macro loaded with `*x` option. Does not appear to be implemented. This appears broken, follow [Issue 736](https://github.com/AllStarLink/app_rpt/issues/736)

You can see how some of these options are implemented by reviewing the default [`[allstar-sys]`](../config/extensions_conf.md#allstar-sys-stanza) context in [`extensions.conf`](../config/extensions_conf.md):

```
[allstar-sys]
exten => _1.,1,Rpt(${EXTEN:1},Rrpt/node:NODE:rpt/in-call:digits/0:PARKED,120)   ; <-- R (Reverse Autopatch with Call Parking)
                                                                                ; Announces "NODE <node> in call 0 <parking extension>"
                                                                                ; Fall through to next (Hangup) after 120 seconds if not answered
exten => _1.,n,Hangup

exten => _2.,1,Ringing                                  ; Play "ringtone" to caller
exten => _2.,n,Wait(3)                                  ; Wait for 3 seconds
exten => _2.,n,Answer                                   ; Answer the call
exten => _2.,n,Playback(rpt/node)                       ; Play voice file "node" to caller followed by
exten => _2.,n,Saydigits(${EXTEN:1})                    ; speaking the node number digits
exten => _2.,n,Rpt(${EXTEN:1},P,${CALLERID(name)}-P)    ; <-- P (Phone Control Mode)
                                                        ; Set the displayed name (e.g in Allmon3) 
                                                        ; to CALLERID(name) with a -P suffix
                                                        ; (e.g. WB6NIL-P)
exten => _2.,n,Hangup

exten => _3.,1,Ringing
exten => _3.,n,Wait(3)
exten => _3.,n,Answer
exten => _3.,n,Playback(rpt/node)
exten => _3.,n,Saydigits(${EXTEN:1})
exten => _3.,n,Rpt(${EXTEN:1},Pv,${CALLERID(name)}-P)   ; <-- Pv (Phone Control Mode with VOX)
exten => _3.,n,Hangup

exten => _4.,1,Ringing
exten => _4.,n,Wait(3)
exten => _4.,n,Answer
exten => _4.,n,Playback(rpt/node)
exten => _4.,n,Saydigits(${EXTEN:1})
exten => _4.,n,Rpt(${EXTEN:1},D,${CALLERID(name)}-P)    ; <-- D (Dumb Phone Control Mode)
exten => _4.,n,Hangup

exten => _5.,1,Ringing
exten => _5.,n,Wait(3)
exten => _5.,n,Answer
exten => _5.,n,Playback(rpt/node)
exten => _5.,n,Saydigits(${EXTEN:1})
exten => _5.,n,Rpt(${EXTEN:1},Dv,${CALLERID(name)}-P)   ; <-- Dv (Dumb Phone Control Mode with VOX)
exten => _5.,n,Hangup
```