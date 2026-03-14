# IAX Proxy

!!! danger "Wiki Copied Page"
    This page was copied verbatim from the obsolete wiki.allstarlink.org.
    It is incomplete and possibly incorrect.

Occasionally there is a need to have an AllStarLink Server in an 'itinerant' location (one that is non-permanent and possibly even moving). In such a situation it is certainly quite likely that the device's IP address may change quite often (perhaps even several times per hour or more). Also, the form of IP connectivity available to the device may not necessarily be suitable for normal Server operation (such as being behind NAT translation, firewalls, etc. that the Server owner has no control of). Normal operation requires fairly stable IP addressing and full public access to at least UDP port 4569 (for IAX2 connectivity) to the Server. Typical examples of 'itinerant' environments include setting up a tiny portable node in a hotel room, utilizing the Internet connectivity provided by the hotel, or having a mobile node on a mobile data network that provides connectivity via some sort of NAT arrangement.

In a situation like this, it is possible to set up a Proxy relationship between such a Server and a Server located in a permanent position with a permanent IP address and good connectivity. For the purposes of explanation, the Server in the 'itinerant' location/situation will be referred to as the Server Proxy Client, and the Server that is in the Permanent/Stable location/situation will be referred to as the Server Proxy Server.

When such a relationship exists, all inbound traffic destined for Nodes on the Server Proxy Client is directed to the Server Proxy Server, which accepts and authenticates the traffic, then forwards it off to the Server Proxy Client via a direct (non-public) peering arrangement. Any traffic outbound from Nodes on the Server Proxy Client is directed to the Server Proxy Server, which forwards it to the appropriate location, thus requiring the Server Proxy Client only to be 'reachable' by the Server Proxy Server, and not all nodes on the entire Internet.

## Portal-Based Configuration for Server Proxy Clients

We don't support configuration of clients in the portal.  The best way is to set it up manually, and then add the IP of the proxy server in the portal for the client.

If you don't want to do this (or if your proxy server is quasi-static), and you have control of the proxy server, have the proxy server use your node number and password and register it to `register.allstarlink.org`.

In `/etc/asterisk/iax.conf` on the proxy server:

```
register=NODE#:PASSWORD@register.allstarlink.org:4569
```

Where node # is the number/pass of the proxied node.

## Manual Configuration for Server Proxy Clients
First, you must configure a peering arrangement with the Proxy Server.

This is done by adding the following into the `/etc/asterisk/iax.conf` file:

```
[radio-proxy]
type=user
deny=0.0.0.0/0.0.0.0
permit=<Server Proxy Server IP Address>/255.255.255.255
context=radio-secure-proxy
disallow=all
allow=g726aal2
transfer=no

[radio-proxy-out]
type=peer
host=<Server Proxy Server IP Address>
username=<First (or only) node number on this Server to be proxied>
secret=<Agreed-Upon Password for specified node (for Proxy peering)>
auth=md5
disallow=all
allow=g726aal2
transfer=no
```

You must put in an appropriate register statement for all nodes on the
Server Proxy Client allowing registration with the Server Proxy Server
using Agreed-Upon Passwords.

If the Server Proxy Server is the AllStarLink Network Registration Server, then
the IP Address will be 67.215.233.178, the Username and Password will be node number
and node password of one of the nodes on the system that is registered with it, and
no additional registration line is necessary, since there already is one for that
node.

The following needs to be added to the `/etc/asterisk/rpt.conf` file:
```
[nodes]
<Stuff that was already there, etc....>
_20XX = radio-proxy-out/0%s
_20XXX = radio-proxy-out/0%s
_21XX = radio-proxy-out/0%s
_21XXX = radio-proxy-out/0%s
_22XX = radio-proxy-out/0%s
_22XXX = radio-proxy-out/0%s
_23XX = radio-proxy-out/0%s
_23XXX = radio-proxy-out/0%s
_24XX = radio-proxy-out/0%s
_24XXX = radio-proxy-out/0%s
_25XX = radio-proxy-out/0%s
_25XXX = radio-proxy-out/0%s
_26XX = radio-proxy-out/0%s
_26XXX = radio-proxy-out/0%s
_27XXX = radio-proxy-out/0%s
_27XXXX = radio-proxy-out/0%s
_28XXX = radio-proxy-out/0%s
_28XXXX = radio-proxy-out/0%s
_29XXX = radio-proxy-out/0%s
_29XXXX = radio-proxy-out/0%s
_4XXXX = radio-proxy-out/0%s
_4XXXXX = radio-proxy-out/0%s
_5XXXX = radio-proxy-out/0%s
_5XXXXX = radio-proxy-out/0%s
; note the . wildcard doesn't work here in rpt.conf
;_2. = radio-proxy-out/0%s  don't work like extensions
```

The following needs to be added to the `/etc/asterisk/extensions.conf` file:

```
[radio-secure-proxy]
exten => _0X.,1,Goto(allstar-sys|${EXTEN:1}|1)
```

Plus, for each node on the system (also to be put in the radio-secure-proxy section):

```
exten => <Node Number>,1,rpt,<Node Number>|X
```

## Configuration for Server Proxy Servers

First, you must configure a peering arrangement with the Server Proxy Client.
This is done by adding the following into the `/etc/asterisk/iax.conf` file for each node in the peering arrangement:

```
[<Node Number>]
type=friend
host=dynamic
username=radio-proxy
secret=<Agreed-Upon Password for the Proxy peering>
auth=md5
context=radio-in
disallow=all
allow=g726aal2
transfer=no
```

The following needs to be done to the `/etc/asterisk/extensions.conf` file:

The following section needs to be added:
```
[radio-in]
exten => _0N.,1,Rpt(${EXTEN:1}|F)
exten => _0N.,n,Hangup
```

The following section needs to replace the existing `[radio-secure]` section:
```
[radio-secure]
exten=_20XX,1,Rpt,${EXTEN}
exten=_21XX,1,Rpt,${EXTEN}
exten=_22XX,1,Rpt,${EXTEN}
exten=_23XX,1,Rpt,${EXTEN}
exten=_24XX,1,Rpt,${EXTEN}
exten=_25XX,1,Rpt,${EXTEN}
exten=_26XX,1,Rpt,${EXTEN}
exten=_27XXX,1,Rpt,${EXTEN}
exten=_28XXX,1,Rpt,${EXTEN}
exten=_29XXX,1,Rpt,${EXTEN}
exten=_4XXXX,1,Rpt,${EXTEN}
exten=_5XXXX,1,Rpt,${EXTEN}
```

The following needs to be added to the `[allstar-sys]` section:

```
exten => _9.,1,Rpt(${EXTEN:2}|X|${EXTEN:1:1})
exten => _9.,n,Hangup
```

The following needs to be added to the /etc/asterisk/rpt.conf file:

```
[proxy]
ipaddr=<Public IP address of this Server Proxy Server>
```

The Server Proxy Server will be able to determine the nodes for which it needs to provide Proxy service.

