# VOTER Buffer Tuning
There are two types of buffers involved in the VOTER/RTCM. 

In both the receive and transmit cases, the buffer length is a fixed value. This will **hard-set** the delay time between actual reception and presentation time to the Asterisk channel (in the case of receive), and presentation from the Asterisk channel and actual transmission (in the case of transmit).

Since the overall system time delay (the amount of time between reception and re-transmission of the signal) is determined as the sum of the receiver buffer length, the (very minimal) latency within `Asterisk/app_rpt` and the Transmit buffer length, it is **very necessary** to keep these settings to a *reasonable* minimum (without sacrificing packet consistency/integrity by making it too short based upon network latency/jitter). 

In other words, if you listen to yourself on the output of your repeater (through headphones, on another radio) as you transmit in to the receiver, your audio will be delayed by the amount configured in the buffer settings (as summarized above). So, the larger you make the buffers, the longer the repeat delay will be. Hence, keeping the buffers tuned to a reasonably low level will reduce the repeat delay.

## Transmit Buffer
This buffer is the [TX Buffer Length](./voter-menus.md#main-menu-options) parameter located on **each** VOTER/RTCM.


This buffer stores audio **from** the host **to** each **transmitter**, queuing it before sending it out over the air. 

!!! note "Simulcast Launch Delay"
    The `Simulcast Launch Delay` is additionally added to the `TX Buffer Length` to allow fine-tuning of each transmitters launch delay.

This buffer has a value (length) of **samples**. It is **not** a time value! So, with 8000 samples per second, 8 *samples* = 1 millisecond. Each sample is 125uSec.

## Receive Buffer

This buffer is the `buflen` parameter in [`voter.conf`](../config/voter_conf.md).

This buffer is a **common** buffer for *all* clients. It determines how much audio to buffer **from** the clients **to** Asterisk. It must be larger than the longest *network* delay from the *worst* client, plus padding (40-100mS is a good start), to ensure that audio will arrive at the host from all clients to be voted on.

This buffer has a value (length) of **milliseconds**. The default is 500 milliseconds, and that is what the value will be set to, if it is not specified in [`voter.conf`](../config/voter_conf.md). That should cover *all* worse-case scenarios... and is going to typically be **way** to big. **You should tune this!**

## Setting Voter Buffers
In order to properly set the buffers, you need to quantify the latency between your host (master) site, and all the clients. That is why it is desirable to keep as much of the network between the host and the clients in your control as possible, so that you can control the latency. If you have your buffers tuned "on the edge", and the latency between some of your clients increases unexpectedly, that is going to impact your system performance.

`voter ping` is useful for end-to-end network evaluation when ICMP ping is turned off and/or the VOTER/RTCM is behind a firewall and is not ICMP reachable. It can also help with finding the correct VOTER/RTCM and [`voter.conf`](../config/voter_conf.md) buffer settings. `voter ping` is an Asterisk console command, so you will need to be logged in to your host.

### Voter Ping Usage
The `voter ping` asterisk CLI syntax is:

```
*CLI>voter ping nameOfClient [packetCount]
```

If `packetCount` is not specified, 8 pings will be sent. Use a `packetCount` of `0` to stop an in progress voter ping. Set `packetCount` to at least `100` when evaluating link quality.

The result will be similar to:

```
...
PING (nameOfClient): Packets tx: 100, rx: 100, oos: 0, Avg.: 26.710 ms
PING (nameOfClient):  Worst: 38 ms, Best: 22 ms, 100.0% Packets successfully received (0.0% loss)
```

The output above is self evident except for `oos` which is a count of out of sequence packets. `voter ping` requires VOTER/RTCM firmware 1.23 or newer and `chan_voter` 2013-08-04 or newer.

### RX Buffer Size
Ping all the receiver sites and look for the worst response of the worst client. As a rough rule of thumb the `buflen` setting in [`voter.conf`](../config/voter_conf.md) should be set to **the worst response + 40ms** or **120**, whichever is greater. Using the above case, the `buflen` should be set to `120` (38 + 40 = 78 which is less than the minimum of 120, so use 120mS).

The 40mS is padding to account for buffer ingress/egress.

### TX Buffer Size
Ping all the transmitter sites and look for the worst response of the worst client. The VOTER/RTCM `TX Buffer Length` should be set to **(worst response + 40ms) * 8** or **480** whichever is greater. Using the above case, the VOTER/RTCM `TX Buffer Length` should be set to `624` ((38 + 40) * 8).

The 40mS is padding to account for buffer ingress/egress.

## Assumptions

* The minimum `TX Buffer Length` is 480 (60mS) and the minimum RX buffer (`buflen`) is 120mS. These were derived by testing on a LAN segment with `chan_voter` 2013-08-04 and VOTER/RTCM 1.26.
* The ping times are in fact round trip times. Therefore the worst response could (should?) be divided by 2. ie. RX buffer (`buflen`) = (38/2)+40 = 59 and `TX Buffer Length` = ((38/2) + 40) * 8 = 472. Minimums still apply, however.
* The internet path to and from the VOTER/RTCM under test is symmetrical.
* The added 40mS pad is an estimate of buffer ingress and egress.

As always, your mileage may vary. Some trial and error may be required to find the optimum settings.
