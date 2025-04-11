# RX Toneburst
RX toneburst is a repeater access method (similar to CTCSS/PL or DCS) where the repeater will not become active until it receives the proper access tone.

It is/was a common access method used almost exclusively in Europe. The typical tone used was 1750Hz. A user would send an initial burst of 1750Hz, usually less than 500mS, which would "wake up" the repeater. Once the repeater was "active", it would usually revert to carrier access for the duration of the conversation. After a period of quiet time, the repeater would revert to being "inactive", until it received another wake-up toneburst.

## Configuring Receive Toneburst Access
If you wish to set up a node to require receive toneburst, you must at least specify the toneburst frequency. The following parameters would need to be added to [`/etc/asterisk/rpt.conf`](../config/rpt.conf.md) in the node configuration section of the desired node.

```
rxburstfreq = 1750          ; set the desired toneburst frequency, in Hz
rxbursttime = 500           ; minimum duration required for the tone to be present, in mS
rxburstthreshold=10         ; minimum signal to noise radio, in dB, to detect a valid tone
```