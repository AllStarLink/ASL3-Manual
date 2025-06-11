# tlb.conf
`tlb.conf` (`/etc/asterisk/tlb.conf`) is used to configure TheLinkBox channel driver, `chan_tlb`, for use with interfacing to [TheLinkBox](https://github.com/skiphansen/thelinkbox) stations.

The format of the file is:

```
[tlb0]
call = WB6NIL-R                     ; Callsign of the app_rpt station
port = 44966                        ; Start of UDP port range (this port, port + 1)
ipaddr = 44.128.252.1               ; Optional IP address to bind to
astnode = 63001                     ; app_rpt node associated with this instance (for incoming connections)
context = radio-secure              ; Asterisk context for incoming connections
codec = ULAW                        ; Default CODEC to be used


[nodes]
1001 = W6ABC,44.128.252.3,44966     ; This one is for W6ABC at ip 44.128.252.3:44966 default CODEC
1002 = W1XYZ,44.128.252.4,1234,G726 ; This one is for W1XYZ at ip 44.128.252.4:1234 with G726 CODEC
```


## Channel Definition Stanza
Define at least one channel stanza with the format `[tlbx]`, where `x` is a numeric digit.

You can have multiple instances defined (such as `[tlb1]`, etc.), as long as they are on different UDP port pairs.

The name of this context must match the reference for `rxchannel` in [`rpt.conf`](../config/rpt_conf.md).

Example:

```
In rpt.conf:

rxchannel = tlb/tlb0

In tlb.conf:
[tlb0]
...
```

### call=
This is the callsign of the local AllStarLink node.

Example:

```
call = WB6NIL-R                     ; Our callsign
```

### port=
This defines the **starting** port of the UDP port pair used for communication with TheLinkBox station. If not specified, the default ports used will be `44966/UDP` and `44967/UDP`.

Example:

```
port = 44966                        ; Start of UDP port range (this port, port + 1)
```

!!! note "UDP Port Numbering"
    The UDP port pair must start with an **even** port number. The even port is for the RTP (audio) and the odd port is for the RTCP (control/supervisory).

### ipaddr=
This optionally sets the local IP address to bind to. If not specified, it defaults to `0.0.0.0`, which will bind to any interface.

Example:

```
ipaddr = 44.128.252.1               ; Bind to the interface with the IP Address 44.128.252.1
```

### astnode=
This is the node number of the local AllStarLink node to associate to. It could be a public or private node, as setup in [`rpt.conf`](../config/rpt_conf.md).

Example:

```
astnode = 2008                      ; app_rpt node associated with this instance (for incoming connections)
```

### context=
This is the context in `etc/asterisk/extensions.conf` to associate incoming connections to. Typically, this would be the `[radio-secure]` context.

Example:

```
context = radio-secure              ; Asterisk context for incoming connections
```

### codec=
This defines the default codec to use when connecting to TheLinkBox stations.

Example:

```
codec = ULAW                        ; Default CODEC to be used
```

Valid codecs are: `ULAW`, `G726` and `GSM`.

## TLB Nodes Stanza
The `[nodes]` stanza defines a local private node number to associate with a specific TheLinkBox station.

The format is:

```
<privatenode> = <TLB CALL>,<IP ADDRESS>,<UDP PORT>,[CODEC]
```

Key|Value
---|-----
&lt;privatenode&gt;|The private (local) node number to associate with the remote TheLinkBox station
&lt;TLB CALL&gt;|The callsign of the remote TheLinkBox station
&lt;IP ADDRESS&gt;|The static IP address of the remote TheLinkBox station
&lt;UDP PORT&gt;|The **starting** UDP port of the remote TheLinkBox station
[CODEC]|Optionally, use a specific codec, other than the default to connect to the remote TheLinkBox station

Example:

```
[nodes]
1001 = W6ABC,44.128.252.3,44966     ; This one is for W6ABC at ip 44.128.252.3:44966 default CODEC
1002 = W1XYZ,44.128.252.4,1234,G726 ; This one is for W1XYZ at ip 44.128.252.4:1234 with G726 CODEC
```

In the above example, private node `1001` is defined to connect to TheLinkBox station with the callsign W6ABC, which is at IP 44.128.252.3:44966, using the default codec. Node `1002` would connect to W1XYZ, at 44.128.252.4 on UDP port 1234, and use the G726 codec.

