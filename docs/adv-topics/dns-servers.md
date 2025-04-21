# DNS Servers

ASL3 utilizes DNS servers based on Knot DNS with an HTTP backend as a way to retrieve node information, such as IAX ports, or IP address.

These DNS servers support the following:
* AllStarlink.org DNS authoritative
* Registration server redundancy 
* DNS lookup for nodes information

## Authoritative DNS Servers   

The authoritative DNS servers run on `register-west.allstarlink.org` and `register-east.allstarlink.org`. 

DNSSEC is enabled on all domains, and trust is expanded to all sub servers.

##  DNS Node Lookup

`nodes.allstarlink.org` is delegated to a DNS running in AWS. The users_Nodes table has a trigger which is run and creates or edits entries on the records table in the `allstar` database. This populates a `SRV`, `TXT` and `A`record for every node in the system when it's updated. The trigger has been optimized, and has little to no performance impact on the registration process.  

**NOTE:** Servers not in nodes list can appear in DNS, there is no ageing out of entries in DNS. It's up to the server to know it's registered. 

# SRV Record
 
 The `SRV` records will return the IAX port of the server.

 A query such as:

 ```
 dig SRV _iax._udp.<nodenumber>.nodes.allstarlink.org
```

will return for a node as follows:

```
  _iax._udp.50000.nodes.allstarlink.org. 30 IN SRV 10 10 4569 50000.nodes.allstarlink.org.
```

where 4569 is the IAX port.

A remote base will be returned like:

```
 _iax._udp.50000.nodes.allstarlink.org. 30 IN SRV 10 10 4569 50000.remotebase.nodes.allstarlink.org.
```

## A Record

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

## TXT Record

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