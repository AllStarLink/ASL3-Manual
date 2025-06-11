# European Repeater Operation
We realize that there are different requirements for repeater operation in different parts of the world. Until recently, we have not dealt much with these, not out of insensitivity, but out of unfamiliarity.

Two things have been brought to our attention that we have added functionality to support.

## ID Beaconing
In the UK, it is necessary for a repeater to identify on a periodic basis, regardless of activity. This is controlled with the [`beaconing`](../config/rpt_conf.md#beaconing) setting in [`rpt.conf`](../config/rpt_conf.md). 

To enable this feature, set the `beaconing` option to `1` in the [Node Number Stanza](../config/rpt_conf.md#node-number-stanza):

```
beaconing = 1                       ; Periodically identify at the idtime interval, regardless of activity
```

This option, when set to `1` will send the repeater ID at the [`idtime`](../config/rpt_conf.md#idtime) interval, regardless of whether there was repeater activity or not. By default (if not defined) this option is disabled.

## RX Toneburst
Also, many countries still require access to the repeater be with a tone burst (generally 1750 Hz). See the [RX Toneburst](./rxtoneburst.md) page for how to enable that feature.
