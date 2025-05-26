# Parrot Mode
Parrot Mode is a mode which sends back your transmitted audio when you have un-keyed for a selectable amount of time (`parrottime`). There are 4 parrot modes:

* Parrot Off
* Parrot On
* Parrot Always
* Parrot Once by Command

When a user keys up after parroting is enabled, the receive audio will be recorded, and then played back a selectable amount of time later (`parrottime`) after the user un-keys.

## Associated COP Methods
The associated [Control OPerator](../config/rpt_conf.md#cop-commands) commands/methods associated with Parrot Mode are:

COP|Description
---|-----------
21|Enable Parrot Mode
22|Disable Parrot Mode
23|"Birdbath" (cancel/flush parrot audio stream)
55|Parrot Once By Command

## `rpt.conf` Settings
In order for some of the Parrot Mode COP commands to function, [`parrotmode`](../config/rpt_conf.md#parrotmode) must be set to a non-zero value in [`rpt.conf`](../config/rpt_conf.md).

### Parrot Disabled
Parroting is disabled by default (`parrotmode = 0`), unless it is specifically enabled. As such, by default the parrot enable and parrot disable COP commands will have no effect. 

However, even if Parrot Mode is disabled, the [Parrot Once By Command](#parrot-once-by-command) mode is still available.

### Parrot On Command
This mode allows two COP commands (`cop,21`, `cop,22`) to be used to enable and disable Parrot Mode, respectively. Once Parrot Mode is enabled, then all received signals will be echoed back until Parrot Mode is disabled. To select this mode, the value for `parrotmode` should be set to `1` in the [`Node Number Stanza`](../config/rpt_conf.md#node-number-stanza):

```
parrotmode = 1                      ; Enable Parrot Mode on command via cop,21 and cop,22
```

### Parrot Always
This mode **permanently** places the node in Parrot Mode. This is useful when you want to make a simplex repeater, or a dedicated node for audio testing that echos everything it hears. The parrot enable, and parrot disable COP commands will have **no effect** when operating in this mode. To select this mode, the value for `parrotmode` should be set to `2` in the [`Node Number Stanza`](../config/rpt_conf.md#node-number-stanza):

```
parrotmode = 2                      ; Set this node to permanently echo all received audio
```

### `parrottime`
The other setting associated with the above `parrotmode` modes is `parrottime`. `parrottime` set the time, in mS, that the system waits after the user un-keys, before playing back the recorded audio buffer.

```
parrottime = 1000                   ; Wait 1s (1000mS) before playback
```

## Parrot Once by Command
This mode allows the Parrot Mode to be enabled for one transmission only. 

Parrot Once by Command is initiated with the `cop,55` COP command. It can be used even if `parrotmode` is disabled (set to `0`, which is default if nothing else is specified).

Recording will commence as soon as the command is decoded, so the DTMF command to enable `cop,55` should be terminated with [`endchar`](../config/rpt_conf.md#endchar) and the user should **not** un-key (recording starts immediately). 

## Functions
The four COP methods should be mapped to DTMF sequences in the [`[functions]`](../config/rpt_conf.md#functions-stanza) stanza to enable them, as desired.

Example:

```
921 = cop,21                        ; Enable Parrot Mode
922 = cop,22                        ; Disable Parrot Mode
923 = cop,23                        ; Birdbath (Current Parrot Cleanup/Flush)
955 = cop,55                        ; Parrot Once if parrot mode is disabled
```