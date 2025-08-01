# Calling app_rpt in a Dialplan
If you look closely in [`extensions.conf`](../config/extensions_conf.md), you will see that a number of the contexts do some processing on the incoming call into the context's dialplan, and then will often hand the call off to `app_rpt` using a command like: `same => n(connect),rpt(${EXTEN})`.

There are a number of different options to call `app_rpt`, each used for specific applications or use cases. They are processed by the `rpt_exec` function in `app_rpt.c`.

The general format of the method to call `app_rpt` is:

```
exten => name,priority,rpt(${EXTEN},option)
```

The `${EXTEN}` variable is expected to be a node number that is passed into the relevant context by a channel driver. When the call is passed to `app_rpt`, it will get added to the conference bridge on the node.

The `option` values that `app_rpt` supports, and their purpose are as follows:

`option` value|Description
--------------|-----------
none|Same as `X`
`X`|Normal endpoint mode WITHOUT security check. Only specify this if you have checked security already (like with an IAX2 user/password or some other validation)
`Rannounce-string[|timeout[|timeout-destination]]`|Reverse Autopatch. Caller is put on hold, and announcement (as specified by the 'announce-string') is played on radio system. Users of radio system can access autopatch, dial specified code, and pick up call. Announce-string is a `:` separated list of names of	recordings/sound files, *or* `PARKED` to substitute code for un-parking, *or* `NODE` to substitute the node number (see the `[allstar-sys]` context in the default [`extensions.conf`](../config/extensions_conf.md))
`P,[CALLERID STRING]`|Phone Control mode. This allows a regular phone user to have full control and audio access to the radio system. For the user to have DTMF control, the [`[phone_functions]`](../config/rpt_conf.md#phone-functions-stanza) context must be defined for the node in [`rpt.conf`](../config/rpt_conf.md). `[CALLERID STRING]` is a string or variable that is passed to `app_rpt`, often used to display information about the calling party in the Allmon3 dashboard. An additional function ([`cop,6`](../config/rpt_conf.md#cop-commands)) must also be enabled so that PTT control is available
`D,[CALLERID STRING]`|Dumb Phone Control mode. This allows a regular phone user to have full control and audio access to the radio system. In this mode, the PTT is activated for the entire length of the call. For the user to have DTMF control (not generally recommended in this mode), the `[dphone_functions]` context must be defined for the node in [`rpt.conf`](../config/rpt_conf.md). Otherwise, no DTMF control will be available to the phone user.
`S`|Simplex Dumb Phone Control mode. This allows a regular phone user audio-only access to the radio system. In this mode, the transmitter is toggled on and off when the phone user presses the [`funcchar`](../config/rpt_conf.md#funcchar) (`*`) key on the telephone set. In addition, the transmitter will turn off if the [`endchar`](../config/rpt_conf.md#endchar) (`#`) key is pressed. When a user first calls in, the transmitter will be off, and the user can listen for radio traffic. When the user wants to transmit, they press the `*` key, start talking, then press the `*` key again or the `#` key to turn the transmitter off. No other functions can be executed by the user on the phone when this mode is selected. Note: If your	radio system is full-duplex, we recommend using either `P` or `D` modes as they provide more flexibility.
`V`|Set Asterisk channel variable for specified node (e.g. `Rpt(2000,V,foo=bar)`)
`Mxx`|Memory Channel Steer.  Where `xx` is the memory channel number. This appears broken, follow [Issue 737](https://github.com/AllStarLink/app_rpt/issues/737)
`F`|Forward call. No documentation available. Treated as an authenticated call (like `X`)
`q`|Query channel variables? No documentation available
`o`|Unknown, something to do with `channel_revert`? May revert to the last channel after using `Mxx`? No documentation available
`*x`|Load a macro number (`x`) to execute. Appears to be related to option `Z`. No documentation available
`Z`|Execute macro loaded with `*x` option. Does not appear to be implemented. No documentation available. This appears broken, follow [Issue 736](https://github.com/AllStarLink/app_rpt/issues/736)

!!! note "VOX Mode"
    Options `P`, `D`, `R`, and `S` all technically accept the `v` sub-option for VOX mode (ie. `Pv`). This only seems to really make sense for the `P`, `R`, and `S` options, as the `D` option should have the transmitter keyed all the time regardless.

!!! note "Monitor Mode"
    Options `P`, `D`, `R`, and `S` all accept the `m` sub-option for "monitor" mode. In this mode, no transmit or functions are allowed (monitoring only).

You can see how some of these options are implemented by reviewing the default [`[allstar-sys]`](../config/extensions_conf.md#allstar-sys-stanza) context in [`extensions.conf`](../config/extensions_conf.md):