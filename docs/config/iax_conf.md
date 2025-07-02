# iax.conf
iax.conf (`/etc/asterisk/iax.conf`) is where the primary authentication of connections to a node (Asterisk) takes place.

When IAX2 protocol connection requests are made to Asterisk, it figures out what context applies based on the incoming request, then forwards the processing to the relative context in `extensions.conf` if the call/connection is allowed to proceed for further processing.

See also [config file templating](../adv-topics/conftmpl.md/#asterisk-templates).

## `[general]` Stanza
The `[general]` stanza in `iax.conf` controls the main/global features of how IAX2 connections are handled.

### IAX Registration
Prior to ASL3, nodes registered with the AllStarLink Network using a `register` directive. This is no longer required, and has been replaced by HTTP registrations that leverage the power of DNS.

As such, you will currently see the following in your ASL3 default `iax.conf`:

```
; !!! IAX registration will be discontinued at some point !!!
; Setup rpt_http_registartions.conf instead.
; remove the leading ";"
;register => 1999:12345@register.allstarlink.org    ; This must be changed to your node number, password 
;register => 1998:12345@register.allstarlink.org
```

While node registration will still work (for now) using this method, please don't use it. It is not required. Your registration should be processed by an entry in `rpt_http_registrations.conf`, which in most cases the [`asl-menu`](../user-guide/index.md) utility will take care of configuring for you.

### `bindport =` and `bindaddr =`
The `bindport` and `bindaddr` directives determine where Asterisk is listening for incoming IAX2 connections.

The default port ASL3 uses (as well as previous versions) is port `4569/UDP`. 

You should see the following in your ASL3 default `iax.conf`:

```
bindport = 4569                 ; bindport and bindaddr may be specified

; NOTE: bindport must be specified BEFORE
; bindaddr or may be specified on a specific
; bindaddr if followed by colon and port
;  (e.g. bindaddr=192.168.0.1:4569)

; bindaddr = 192.168.0.1        ; more than once to bind to multiple
                                ; addresses, but the first will be the 
                                ; default
```

In most cases, the default `bindport = 4569` will work fine. However, if you are running multiple node servers behind a NAT firewall, you WILL need to change this so that they are all unique from each other. In that case, you also need to change the [IAX Port](../basics/portal.md#iax-port) in the [Web Portal](https://www.allstarlink.org/portal) to match.

!!! warning "Firewall Rules"
    If you are using a firewall on your internet connection (I sure hope so!), don't forget to allow port `4569/UDP`, and/or any other IAX2 port(s) you have configured through your firewall (and point it to the correct internal IP address, if using NAT).

    If you are using the [ASL3 Appliance](../install/pi-appliance/index.md), don't forget to update the firewall rules in the [Cockpit Firewall](../pi/cockpit-firewall.md) as well, if you are using a non-standard port.

Unless you have a specific reason to do so, leave `bindaddr` commented out. It is not required in the majority of use cases. 

### Outbound Codecs
Also in the `[general]` stanza is the configuration of **OUTBOUND** codecs to be used when making outbound connections to other nodes.

You should see the following in your ASL3 default `iax.conf`:

```
disallow = all                  ; The permitted codecs for outgoing connections 
;Audio Quality   Bandwidth
;allow = ulaw                   ; best      87 kbps
;allow = adpcm                  ; good      55 kbps
;allow = gsm                    ; mediocre  36 kbps
allow = ulaw
allow = adpcm
;allow = g722
;allow = g726aal2
allow = gsm
;allow = ilbc
```

The above starts by clearing the codec list (`disallow = all`), followed by `allow` statements for the codecs you prefer to use, in preferential order.

In the above example, we prefer our outbound connections to use u-law (G.711), ADPCM, and GSM, in that order. You can enable other codecs, if you desire, and change the priority too. However, you should be sure to keep u-law enabled, as that is the common standard that AllStarLink nodes expect to use.

!!! note "High Quality Codecs"
    ASL3 also supports the use of the slin and slin16 codecs. These are the internal codecs that Asterisk uses for high quality internal connections between channels. The slin codec is signed linear, 8kHz, 16-bit PCM; slin16 is signed linear, 16kHz, 16-bit PCM. They offer improved dynamic range over u-law, and may be good options to deploy on a hub node that would be connecting to other hub nodes (to maintain audio fidelity). A good discussion on codecs can be found [here](https://community.allstarlink.org/t/regarding-asl-hamvoip-and-default-codec-priority/22648).

### Remaining `[general]` Options
There are some other directives included in the `[general]` stanza of the default `iax.conf`:

```
jitterbuffer = yes
forcejitterbuffer = yes                                                           
dropcount = 2                                                                     
maxjitterbuffer = 4000                                                            
maxjitterinterps = 10                                                             
resyncthreshold = 1000                                                            
maxexcessbuffer = 80                                                              
minexcessbuffer = 10                                                              
jittershrinkrate = 1                                                              
tos = 0x1E                                                                  
autokill = yes                                                                    
delayreject = yes                                                                 
; iaxthreadcount = 30                                                              
; iaxmaxthreadcount = 150  
```

Unless you have a specific reason to change them (and you know why you are changing them), just leave them alone. You can break your node.

## `[radio]` Stanza
The `[radio]` stanza is where the majority of all incoming IAX2 connections to the node will terminate, in particular, connections from other nodes. 

You should see the following in your ASL3 default `iax.conf`:

```
[radio]
type = user
disallow = all
allow = ulaw
allow = adpcm
;allow = g722
;allow = g726aal2
allow = gsm
;allow = ilbc
codecpriority = host
context = radio-secure
transfer = no
```

There are a couple of important notes here about the directives in this stanza.

Most of the directives here deal with which audio codecs you allow, and in what priority for incoming connections. You ***could*** also include the high quality (and high bandwidth) slin16 and slin codecs, if desired (and bandwidth isn't a concern).

Incoming calls with the username of `radio` will reach this stanza, and then after the call is setup (codecs are negotiated) they are forwarded to `extensions.conf` for further processing. Per the `context = radio-secure` directive, the incoming connection will be processed by the `[radio-secure]` stanza that is found in `extensions.conf`, where it gets authenticated by `app_rpt` to see if it is a valid node that is allowed to connect.

The `type = user` directive tells this installation of Asterisk that the incoming connection (the "peer") is to be treated as a client connecting to us (the host). So, with `codecpriority = host`, *we* get to choose the supported codecs and their priority we prefer to connect with.

## `[iaxrpt]` Stanza
The `[iaxrpt]` stanza is often used to handle connections from the [IAXRpt](../user-guide/externalapps.md#iaxrpt-pc-client) software client (or other [External Apps](../user-guide/externalapps.md)). 

You should see the following in your ASL3 default `iax.conf`:

```
[iaxrpt]                         ; Connect from iaxrpt Username field (PC AllStar Client)
type = user                      ; Notice type is user here <---------------
context = iaxrpt                 ; Context to jump to in extensions.conf
auth = md5
secret = Your_Secret_Pasword_Here
host = dynamic
disallow = all                    
allow = ulaw
allow = adpcm
allow = gsm                       
transfer = no
```

The username this node is expecting to see from the client is the context name (`iaxrpt`), and it is going to forward the call to the the `[iaxrpt]` stanza in `extensions.conf`, as denoted by the `context = iaxrpt` directive.

Observe how we define the codecs that are allowed for incoming connections of this type, and their preferred priority.

Also note that this stanza requires a password from the client, denoted by the `secret =` directive. Your new ASL3 installation should have a randomly generated secret.

See [Node Configuration](../user-guide/externalapps.md#node-configuration) for more information on how to customize this stanza for multiple users.

!!! warning "Call Tokens"
    With ASL3 moving to Asterisk 20+, IAX2 now requires [IAX2 Call Tokens](https://docs.asterisk.org/Configuration/Channel-Drivers/Inter-Asterisk-eXchange-protocol-version-2-IAX2/IAX2-Security/), which some client software may not support, causing their calls to be rejected. You may need to add `requirecalltoken = no` to the affected context in `iax.conf` to resolve this.

## `[iaxclient]` Stanza
The `[iaxclient]` stanza is similar to the [`[iaxrpt]`](#iaxrpt-stanza) above. It was/is typically used for connections from the [Zoiper Softphone Client](https://www.zoiper.com/).

Zoiper is more cumbersome to configure and use than the other [External Apps](../user-guide/externalapps.md) that are now available that specifically support AllStarLink.

You should see the following in your ASL3 default `iax.conf`:

```
[iaxclient]                      ; Connect from iax client (Zoiper...)
type = friend                    ; Notice type here is friend <--------------
context = iax-client             ; Context to jump to in extensions.conf
auth = md5
secret = Your_Secret_Password_Here
host = dynamic
disallow = all
allow = ulaw
allow = adpcm
allow = gsm
transfer = no
```

The big difference between the `[iaxrt]` and `[iaxclient]` stanzas is the `type` directive. The `type = friend` tells this installation of Asterisk that the Zoiper client (peer) is both a client and a server, capable of both originating and receiving calls.

Also note that connections processed by this stanza are forwarded to the `[iax-client]` stanza in `extensions.conf`, per the `context = iax-client` directive.

## `[allstar-sys]` Stanza
The `[allstar-sys]` stanza is used by connections from the [AllStarLink Telephone Portal](../user-guide/phoneportal.md). 

You should see the following in your ASL3 default `iax.conf`:

```
[allstar-sys]
type = user
context = allstar-sys
auth = rsa
inkeys = allstar
disallow = all
allow = ulaw
allow = adpcm
allow = gsm
```

Observe how we define the codecs that are allowed for incoming connections of this type, and their preferred priority.

Also note that these connections are validated by a public/private key arrangement, as denoted by the `auth = rsa` and `inkeys = allstar` directives.

Connections processed by this stanza are forwarded to the `[allstar-sys]` stanza in `extensions.conf`, per the `context = allstar-sys` directive.

## `[allstar-public]` Stanza
The `[allstar-public]` stanza is used by connections that use the AllStarLink ["Web Transceiver"](../user-guide/externalapps.md#web-transceiver) method of connection. The original Web Transceiver application has been deprecated, however, there are other [External Apps](../user-guide/externalapps.md) that still utilize this method to connect to AllStarLink Nodes.

You should see the following in your ASL3 default `iax.conf`:

```
[allstar-public]
type = user
context = allstar-public
auth = md5
secret = allstar
disallow = all
;calltokenoptional=0.0.0.0/0.0.0.0
requirecalltoken=no
allow = ulaw
allow = adpcm
allow = gsm
```

Observe how we define the codecs that are allowed for incoming connections of this type, and their preferred priority.

Also note that while there is a `secret = allstar` directive that would imply that we use that for authentication, in fact, further authentication of the connection is done later down the chain using a token validation system to ensure that the client has a valid account on the [AllStarLink Web Portal](https://www.allstarlink.org/portal).

Connections processed by this stanza are forwarded to the `[allstar-public]` stanza in `extensions.conf`, per the `context = allstar-public` directive.
