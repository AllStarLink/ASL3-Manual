# Simple Voter
This feature requires that the USB radio devices on the remote voting receivers are connected directly to each voting receiver's discriminator/quadrature detector output. 

You need a complete node for each site you wish to implement in this scheme. Voting receiver nodes *should* be receive-only, *should* be implemented with private node numbers, and configured to **not** attempt to register or report to the AllStarLink network.

The receiver at the main/transmitter site **can** be one of the voting receivers, and **can** be a regular node that connects to the AllStarLink network. 

GPS receivers and additional hardware are **not** required for this scheme. As a result, you may notice audio artifacts as the system switches between receiver sites, as not everything will be totally synchronized.

!!! note "Not VOTER"
    This has nothing to do with the [VOTER](../voter/index.md) feature of ASL3 that uses the VOTER/RTCM radio interfaces for receiver voting and/or simulcast. This feature is a crude implementation of RSSI-based receiver voting, using node hardware.

You **must** use the [USBRadio](./usbinterfaces.md) channel driver. Signal strength reporting **must** be turned on for all voting devices in `/etc/asterisk/usbradio.conf` as follows:

```
sendvoter=1                         ; 0=default, no voter SSI, 1=enable voter
```

In the [`rpt.conf` `[nodes]`](../config/rpt_conf.md#nodes-stanza) stanza, voting receiver nodes must be identified by IP address or FQDN **and** have the keyword `,VOTE` at the end after `NONE`. For example,

```
[nodes]
...
63001 = radio@mycall.dyndns.org:4569/63001,NONE,VOTE
...
```

In the [`rpt.conf` Node Number](../config/rpt_conf.md#node-number-stanza) stanza, you need to add the voter options.

For your main/transmitter site:

```
[63001]
...
votertype=1                         ; 0=default, no voting, 1=voter repeater, 2=voter receiver
votermode=2                         ; 0=default, no voting, 1=voter one-shot, 2=voter continuous
votermargin=10                      ; 10=default sets signal margin to vote a new winner
startup_macro=*21999                ; connect to remote voter receiver in monitor only mode
...
```

For your remote receiver site:

```
[1999]
...
votertype=2                         ; 0=default, no voting, 1=voter repeater, 2=voter receiver
votermode=2                         ; 0=default, no voting, 1=voter one-shot, 2=voter continuous
...
```

Observe in the above, remote receiver sites are `votertype=2`.

Ensure your remote receiver sites have the `statspost_url` in [`rpt.conf`](../config/rpt_conf.md#statpost_url) commented out to prevent status posting to the AllStarLink network, and ensure the `register=` line is commented out in [`rpt_http_registrations.conf`](./httpreg.md). The remote receiver sites are receive-only, so there is no point in anyone having the ability to connect to them.

After testing, change the `startup_macro` on your main/transmitter node to make a [permanent monitor](./permanentnode.md) connection to your remote receiver(s).

With this feature, in addition to the usual repeater with voting receivers configuration, you can construct things like a repeater with voted sectored/directional receive antennas and receivers, or a centrally located transmit site with no duplexer/receiver and one or more voted remote receivers.

!!! note "RSSI Voting"
    This feature simply selects the receiver with the best signal strength. There will be a noticeable transition between receivers. So, it's not perfect, but for most applications, it's good enough considering the cost and complexity.
