# TheLinkBox
It is possible to interface an `Asterisk/app_rpt` installation with [TheLinkBox](https://github.com/skiphansen/thelinkbox) program (by Skip, WB6YMH), using the `chan_tlb` channel driver.

The connection(s) are accessed and referred to by a locally-assigned (private) node number, starting with "1" (generally 1000-1999, private node numbering space). 

Since the interface is unique to the `app_rpt` installation, other AllStarLink nodes must first connect to the node(s) configured to connect with the desired TheLinkBox station(s).

Both TheLinkBox and `app_rpt` sides of the connection must choose a ***consecutive*** pair of UDP port numbers on which to communicate (ports `44966/44967` by default) and also must both be on **static** IP addresses.

TheLinkBox supports uLAW, G726 and GSM codecs. The `app_rpt` side of the connection dictates which codec is to be used.

To enable TheLinkBox connectivity, there must be a [`tlb.conf`](../config/tlb_conf.md) on the AllStarLink node, the `chan_tlb` channel driver module must be loaded, and [`rpt.conf`](../config/rpt_conf.md) must be configured to use the appropriate [`rxchannel`](../config/rpt_conf.md#rxchannel).

## `tlb.conf`
See the [`tlb.conf`](../config/tlb_conf.md) page for more information on the configuration options for the `chan_tlb` channel driver.

## `rpt.conf`
You need to define the appropriate [`rxchannel`](../config/rpt_conf.md#rxchannel) option to use `chan_tlb`, and pointing to a valid context in your `tlb.conf`.

Example:

```
In rpt.conf:

rxchannel = tlb/tlb0

In tlb.conf:
[tlb0]
...
```

## `modules.conf`
Ensure `/etc/asterisk/modules.conf` loads `chan_tlb.so`:

```
load => chan_tlb.so                 ;TheLinkBox Channel Driver 
```

## TheLinkBox Configuration
On TheLinkBox side, you must specify the following in the main configuration file (typically `tlb.conf`):

```
RTP_Port = 44966
```

And you must have an entry if your TheLinkBox ACL file (generally `tlb.acl`) for each `app_rpt` node as follows:

```
allow   WB6NIL   99.88.77.66     -       -R
```

This example would allow station WB6NIL-R access from ip 99.88.77.66. Note that WB6NIL-R is the `call` defined in the `app_rpt` node's `tlb.conf`.