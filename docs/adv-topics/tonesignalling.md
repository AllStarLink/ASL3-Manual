# Tone Signalling
[COP function 48](../config/rpt_conf.md#cop-commands) is associated with transmitting arbitrary tone sequences. These tone sequences can be any combination of single tones, dual tones, and silence periods.

These tone sequences are only heard on the repeater transmitter and not sent over the network.

## Tone Sequences
Tone sequences are specified as `!Tone_A+Tone_B/Duration_in_MS`. `Tone_B` is optional and if not specified, the `+` operator must be omitted.

The exclamation point (`!`) operator is **required** when specifying arbitrary tones.

## DTMF Tones
DTMF tones can be entered in shorthand fashion as single digits, separated by commas.

Examples:

```
881=cop,48,1,2,3,4,#                ; Send DTMF 1,2,3,4, and #
882=cop,48,!399/1000,!339/2000      ; Send two tone paging sequence: Motorola codes 144, 141
883=cop,48,!1100+1700/100,!0/60,!700+900/60,!0/60,!700+1100/60,!0/60,!700+900/60,!0/60,!1500+1700/60 ; Send MF tone sequence KP121ST
```