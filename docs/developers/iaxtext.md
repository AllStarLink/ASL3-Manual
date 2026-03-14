# app_rpt IAX Text Protocol

app_rpt application relies on IAX text frame to extend its protocol capabilities and exchange information with other nodes or clients.  There does not seem to be any existing documentation for this. This page details the various type of commands in existence as observed "in the wild". This is based a compilation of reading the source code of app_rpt, and reverse engineering of known clients such as IAXRpt and WebTransceiver. As such it's likely to contain errors or misunderstandings. If you have knowledge in some of these areas, please contribute your edits.

!!! danger "Wiki Copied Page"
    This page was copied verbatim from the obsolete wiki.allstarlink.org.
    It is incomplete and possibly incorrect. Please see
    [https://github.com/AllStarLink/ASL3-Manual/issues/223](https://github.com/AllStarLink/ASL3-Manual/issues/223)

## T: Telemetry

### General Format
```
 T <NODE_NB> <CMD>,<PARAMS>
```

* `NODE_NB` Node sending message
* `CMD'` Telemetry command ALLCAPS
* `PARAMS` Optional comma separated list of command specific parameters

### Complete
Action is complete
```
 T 51696 COMPLETE
```

### Status
Report connection status for the node. Sent in response to *70 status DTMF command.
```
 T <NODE_NB> STATUS,<NODE_1>,0,<NODE_LIST>
```

* `NODE_NB` Node sending message
* `NODE_1` Node reporting status
* `0` Unknown
* `NODE_LIST` List of nodes connected to NODE_1. Each node number is prefixed by a connection mode as follow:
    * `T` Transceive mode, send and receive audio
    * `R` Receive audio only
    * `C` Connection is pending

```
 T 51696 STATUS,51696,0,TWH6GJL-P,R29277
```


### Connected
Node connection succeeded

```
 T <NODE_NB> CONNECTED,<NODE_1>,<NODE_2>
```

* `NODE_NB` Node sending message
* `NODE_1` Node initiating connection
* `NODE_2` Other node connected to

```
 T 51696 CONNECTED,51696,29277
```

### Disconnected
Remote node disconnected

```
 T 51696 REMDISC,29277
```

### Remote Already Connected
Remote node is already part of the network. Note that it could be a direct
connection or it could be the node is connected via other nodes.
```
 T 51696 REMALREADY
```

### Connection Failed
Remote node can't be connected to.

```
 T 522540 CONNFAIL,51696
```

### Stats Version
app_rpt module version.
```
 T 51696 STATS_VERSION,161.327
```

### Unknown
```
 T 522540 ARB_ALPHA,123#
```

## L: Linked
Sent periodically by a node to broadcast all node linked to it.
```
 L <MODE><NODE_NB>,<MODE><NODE_NB>,...
```

* `MODE` Each node number is prefixed by a connection mode as follow:
    * `T` Transceive mode, send and receive audio
    * `R` Receive audio only
    * `C` Connection is pending
    * `NODE_NB` Linked node

If no other nodes are connected, the list is empty and only L is sent.

## K: Key
Sent by a node to update its keyed status
```
 K <TO> <NODE_NB> <KEYED> <LAST_KEYED_X_SEC_AGO>
```
* `TO` Destination to broadcast this message to. Usually * seems to indicate all connected nodes.
* `NODE_NB` Node reporting its keyed status
* `KEYED` 1 = node is keyed, 0 = node is not keyed
* `LAST_KEYED_X_SEC_AGO` Number of second since node was last keyed

```
 K * 51696 1 2
```

## K?: Key Query
Message to request other nodes to report their keyed state. Initiating this command results in
all connected nodes replying with their keyed status.
```
 K? <TO> <NODE_NB> 0 0
```

* `TO` Destination to broadcast this message to. Usually * seems to indicate all connected nodes.
* `NODE_NB` Node requesting status? Could be * here as well

```
 K? * 51696 0 0
```

## M: Message
Text message. Can be sent as node to node or broadcast to all nodes.
```
 M <TO> <FROM> <BODY>
```

* `TO` Destination node number. 0 indicates all connected nodes
* `FROM` Source node number
* `BODY` Message content

```
 M 0 51696 Reminder net starts at 10:00 pm PST tonight.
```

## J: WebTransciever Frequency
Status message reporting repeater frequencies. Seems to be only used in the context of the WebTransceiver client.
```
 J Remote Frequency \n<FREQ> FM\n<OFFSET> Offset\n<POWER> Power\nTX PL <TXPL>\nRX PL <RXPL>\n
```
## Miscellaneous signaling

There are several messages being exchanged that alter the behavior of the app_rpt application. It's unclear as to their purpose.

### New Key
Seems that this is meant to be some sort of handshake. When a party receives this command it should send it back.

```
 !NEWKEY!
```

### New Key1
Seems that this is meant to be some sort of handshake. When a party receives this command it should send it back.

```
 !NEWKEY1!
```

### IaxKey
Seems that this is meant to be some sort of handshake. When a party receives this command
```
 !IAXKEY!
```

it should reply with

```
 !IAXKEY! 1 1 0 0
```

### Disconnect
```
 !!DISCONNECT!!
```
