# VOTER Redundant "Proxy" Mode

A "redundant" (backup) server may be set up, so that if the "primary" server fails, clients can detect this failure, and connect to the designated "backup" (or "secondary")
server.

Needless to say, since Internet connectivity is not by any means guaranteed to be consistent, it is possible for some clients to have working connectivity to the "primary" server and not others, even though the "primary" server is functional.

If this were to occur, actual voting and/or simulcast clients would have a "broken" system (being that all the clients need to be on the same server for any sort of functional operation).

To eliminate this possibility, functionality has been added so that a "secondary" server will "proxy" (forward) all of its VOTER packets to the "primary" (if the "primary" is on line), and the "primary" will generate all of the outbound VOTER packets, which (for clients "connected" to the "secondary" server) get sent to the "secondary" server to distribution to its clients.

This allows for a "unity" of all of the clients on a network, even though they may be connected to different servers.

In addition, it is assumed that "permanent linking" (at least of some sort) will be provided between the channel side of the `chan_voter` instances (presumably through a "permalink" provided by `app_rpt`). When the "secondary" is "proxying" (to the "primary") it does not provide direct connectivity to/from its locally-connected clients, thus allowing them to "connect" via the "primary" server instead. In "normal" mode, it works "normally".

The operation is performed by more-or-less "encapsulating" the VOTER packets received by the "secondary" server, and forwarding them on to the "primary" server, where they are "un-encapsulated" and appear to that server to be coming from clients connected directly to it (and keeps track of which ones are connected in this manner, etc). When it needs to send VOTER packets to a client connected through the "secondary", it "encapsulates" them, and sends them to the "secondary", where they get "un-encapsulated" and sent to their associated connected clients, based upon information in the "encapsulation".

If the "secondary" server loses (or does not make) connection to the "primary", it operates as normal, until such time as it can make the connection.

The server redundancy feature is local to each `chan_voter` instance.

For each `chan_voter` instance served by both the "primary" and "secondary" servers, the client list (parameters, etc) **MUST** be identical.

In addition, the following things must be added uniquely on each server:

* In the "primary" server, there needs to be a "primary connectivity" client specified for each "secondary" server for which it is "primary". Basically, this is a client that does NOTHING other than providing a means by which the "secondary" can determine whether the "primary" is on line.
* It is a standard `chan_voter` client, with nothing else specified other then its password. Again, although it is a "legitimate" client (technically), its only purpose **MUST** be to allow the secondary server to connect to it.

The "primary" server also needs to have the following in all of its instances that require redundancy:

* `isprimary = y`

The "secondary" server needs to have the following in all of its instances that require redundancy:

* `primary = 44.128.252.1:1667,mypswd` (where `44.128.252.1:1667` is the IPADDDR:PORT of the "primary" server, and `mypswd` is the password of the "primary connectivity" client)

!!! warning "Master Timing Sources"
    Master timing sources **MUST** be local to their associated server, and therefore, can not be operated in a redundant configuration. If a radio needs server redundancy, it **CAN NOT** be connected to a master timing source. Also, the master timing source **MUST** be associated with a `chan_voter` instance that **DOES NOT** have redundancy configured for it, even if a separate instance needs to be created just for this purpose.

Also, if non-GPS-based (mix mode/general purpose) operation is all that is needed, just the use of redundancy within the clients is sufficient, and does not require any use of the server redundancy features.