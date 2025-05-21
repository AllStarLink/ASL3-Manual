# DNS Servers

AllStarLink's DNS-based node lookup issues queries to Amazon's Route53 servers that are synchronized to the node registration database.  This allows clients to retrieve node information such as IP addresses and IAX ports.

## DNS Node Lookup

The `nodes.allstarlink.org` domain name is populated with `SRV`, `TXT` and `A` records for every active node in the system.

**NOTE:** The DNS records for a node will remain available for a period of time after a node is no longer active. 

### SRV Record
 
The `SRV` records return the IAX port of the server.

A query such as:

```
dig SRV _iax._udp.<nodenumber>.nodes.allstarlink.org
```

will return a record for a node as follows:

```
_iax._udp.50000.nodes.allstarlink.org. 30 IN SRV 10 10 4569 50000.nodes.allstarlink.org.
```

where 4569 is the IAX port.

A remote base node will return a record like:

```
_iax._udp.50000.nodes.allstarlink.org. 30 IN SRV 10 10 4569 50000.remotebase.nodes.allstarlink.org.
```

### A Record

The `A` records will return the IP address of the IAX server or the proxy IP, if defined.

A query such as:

```
dig <nodenumber>.nodes.allstarlink.org

and

dig <nodenumber>.remotebase.nodes.allstarlink.org
```

will return:

```
2000.nodes.allstarlink.org. 60	IN	A	162.248.93.134
```

### TXT Record

The `TXT` record is used for debugging purposes with a query below:

```
dig TXT <nodenumber>.nodes.allstarlink.org
```

will return:

```
"NN=50000" "RT=2019-02-28 18:41:29" "RB=0" "IP=44.98.248.144" "PIP=" "PT=4569" "RH=register-west"
```

Where:

* NN is the node number
* RT is the last update registration time
* RB is 1 for node is not a remote base, RB is 0 if it is a remote base
* IP is the IP address of the node
* PIP is the proxy IP of the node if set
* PT is the IAX port
* RH is the registration server the node last registered to.

## `asl-node-lookup`

On ASL3 systems, the [`asl-node-lookup`](../mans/asl-node-lookup.md) command can also be used to query the DNS servers for information about a node.
