# Parrot Mode
Parrot Mode echos back the audio you transmit to the node. When a user keys up after parroting is enabled, the node's receive audio (your transmit) will be recorded and then played back a selectable amount of time later (`parrottime`) after the user un-keys.

## Associated COP Methods
The associated [Control OPerator](../config/rpt_conf.md#cop-commands) commands/methods associated with Parrot Mode are:

COP|Description
---|-----------
21|Enable Parrot Mode
22|Disable Parrot Mode
23|"Birdbath" (cancel/flush parrot audio stream)
55|Parrot Once By Command

## `rpt.conf` Settings
In order for some of the Parrot Mode COP commands to function, [`parrot`](../config/rpt_conf.md#parrot) must be set to a zero value in [`rpt.conf`](../config/rpt_conf.md).

### `parrot=`
Parrot Mode can be configured as follows:

parrot|Description
----------|-----------
0|Parrot Mode Disabled
1|Parrot Mode Enabled

#### Parrot Mode Disabled
Parroting is disabled by default (`parrot = 0`).  When disabled in `rpt.conf`, parroting can be still be controlled using the [Parrot Mode With COP Commands](#parrot-mode-with-cop-commands) and [Parrot Mode Once With COP Command](#parrot-mode-once-with-cop-command).

```
parrot = 0                      ; Parrot mode off or enabled with COP commands (default = 0)
```

#### Parrot Mode With COP Commands
This mode allows two COP commands (`cop,21`, `cop,22`) to be used to enable and disable Parrot Mode, respectively. Once Parrot Mode is enabled then all received signals will be echoed back until Parrot Mode is disabled. To select this mode, the value for `parrot` should be set to `0` in the [`Node Number Stanza`](../config/rpt_conf.md#node-number-stanza):

#### Parrot Mode Once With COP Command
This mode, initiated with the `cop,55` COP command, allows Parrot Mode to be enabled for one transmission only. To select this mode, the value for `parrot` should be set to `0` in the [`Node Number Stanza`](../config/rpt_conf.md#node-number-stanza):

Recording will commence as soon as the command is decoded, so the DTMF command to enable `cop,55` should be terminated with [`endchar`](../config/rpt_conf.md#endchar) and the user should **not** un-key (the recording starts immediately).

#### Parrot Mode Enabled (Always)
This mode **permanently** places the node in Parrot Mode. This is useful when you want to make a simplex repeater, or a dedicated node for audio testing that echos everything it hears. The parrot enable and parrot disable COP commands will have **no effect** when operating in this mode. To select this mode, the value for `parrot` should be set to `1` in the [`Node Number Stanza`](../config/rpt_conf.md#node-number-stanza):

```
parrot = 1                      ; Enable Parrot Mode on command via cop,21 and cop,22
```

### `parrottime`
The other setting associated with the above `parrot` modes is `parrottime`. `parrottime` set the time, in mS, that the system waits after the user un-keys, before playing back the recorded audio buffer.

```
parrottime = 1000                   ; Wait 1s (1000mS) before playback
```

## Functions
The four COP methods should be mapped to DTMF sequences in the [`[functions]`](../config/rpt_conf.md#functions-stanza) stanza to enable them, as desired.

Example:

```
921 = cop,21                        ; Enable Parrot Mode
922 = cop,22                        ; Disable Parrot Mode
923 = cop,23                        ; Birdbath (Current Parrot Cleanup/Flush)
955 = cop,55                        ; Parrot Once if parrot mode is disabled
```