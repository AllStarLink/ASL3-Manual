# Sleep Mode
Sleep Mode allows the local repeater receiver to be effectively disabled after a set period of inactivity (keeping the associated transmitter quiet). The repeater receiver will be re-enabled if any of the following events occur:

* An "awaken from sleep" ([`cop,53`](../config/rpt_conf.md#cop-commands)) command is decoded on any command source
* There is traffic coming in from a remote node
* There is telemetry coming in from a remote node

Additionally, the sleep inactivity timer will be reset if there are any signals on the repeater input which are received during the time the system is awake.

!!! warning "Caution"
    Be aware that enabling Sleep Mode will change how your repeater functions, and may lead to user confusion. Once the repeater enters Sleep Mode, the only way to wake it up locally would be by a `cop,53` command (whether that is in to the local receiver via DTMF, or some other macro on the CLI). That may lead to users thinking the repeater is "broken", when they try and key it up, and nothing happens, if they aren't aware that it may be in Sleep Mode. 

## How it Works

The intended purpose of Sleep Mode is to (temporarily) help combat local interference issues.

While the repeater is in normal use, the inactivity timer ([`sleeptime`](../config/rpt_conf.md#sleeptime)) will be constantly reset.

When activity on the repeater ceases, the inactivity timer counts down. When it reaches zero, the repeater will "go to sleep". The local receiver is still "active", listening for DTMF, but it won't respond to normal methods of "keying the repeater" (carrier and/or CTCSS). This effectively prevents interference sources from opening the receiver squelch, and keying the transmitter (broadcasting the noise).

In order to "wake" the repeater up, you would have to satisfy one of the above criteria. So, traffic or telemetry from a remotely connected node would "wake up" the local receiver, and allow its normal access methods to key the repeater. Or, a user would need to send a specified DTMF command, linked to `cop,53` to "wake up" the local receiver. As such, this mode is also known as, "touch tone up". 

## Associated COP Methods
The associated [Control OPerator](../config/rpt_conf.md#cop-commands) commands/methods associated with Sleep Mode are:

COP|Description
---|-----------
51|Enable Sleep Mode
52|Disable Sleep Mode
53|Awaken from Sleep Mode
54|Go back to sleep when the TX carrier drops

In order to manually "wake" the repeater up, you would want to assign `cop,53` to a DTMF command in the [`[functions]`](../config/rpt_conf.md#functions-stanza) stanza of [`rpt.conf`](../config/rpt_conf.md), such as:

```
953 = cop,53                        ; Wake up from sleep
```

You would also likely want to define commands to be able to enable and disable Sleep Mode too:

```
951 = cop,51                        ; Enable sleep mode
952 = cop,52                        ; Disable sleep mode
954 = cop,54                        ; Go to sleep
```

# Inactivity Timer
In addition to defining the commands to control Sleep Mode, you will likely also want to adjust the inactivity timer (`sleeptime`). This option is set in the [node number stanza](../config/rpt_conf.md#node-number-stanza) in [`rpt.conf`](../config/rpt_conf.md).

The default value for `sleeptime` is 900 seconds (15 minutes), if it is not specified (and you were to enable Sleep Mode). Set the value appropriately for your configuration:

```
sleeptime=300                       ; Set the inactivity timer for 300 seconds (5 minutes)
```