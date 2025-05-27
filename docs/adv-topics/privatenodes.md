# Private Nodes
Private nodes are nodes you create that do not directly connect to the AllStarLink (ASL) Network. In addition, you cannot directly connect to a private node from the ASL Network.

They can co-exist on an existing server along with a public node, or they can run on independent hardware exclusively.

## Private Node Numbering
The numbering system for private nodes is limited to node numbers under 2000 (ie 0000-1999). However, in practice it would be best advised to use 4 digit number to not confuse other parts of the dial plan in present or future expansion (thus using 1000-1999).

If a private node is going to be connected to an ASL Public Network node, you may want to consider using a node number outside of the normal node numbers used by examples in most how-to's, such as 1998 and 1999. This is due to "loopback protection" in the `app_rpt` code that prevents connection of the same node (detected as a loop) when you connect to other networks.

For example, if you have a private node 1999 connected to your public node 29999, and you proceed to connect 29999 with some other system like 2135 that also has someone connected that has a private node 1999 connected, it will be refused. ***This has been the source of many hairs being pulled out when folks do not realize why they can not connect.***

Of course, there is a more modern solution to fix this issue, using an Node Number Extensions with an assigned Node Number. NNX will create a extra digit on your existing node number, thereby making it 10 'potential' nodes, each unique and network connectable, or not. So, your assigned node 2000 would then expand to 20000-20009, giving you ten node numbers in your account to assign to your node devices. It would be wise to consider enabling NNX when you register, to allow for this flexibility "down the road" when you suddenly want to add a whole bunch more nodes after you realize the power and flexibility of ASL.

By using NNX, you can have a unique node number that can be set-up and not registered to the ASL network, thereby making it a private node (just comment out the appropriate registration line in `rpt_http_registrations.conf`).

And of course, you could later change that to a public node just by un-commenting the registration line and reviewing your settings to be sure they are public friendly.

## Node Setup
The easiest way to create a private node is to use the [ASL3 Menu](../user-guide/menu.md) and use `Node Settings` to create a new node.

This will create a new [template](./conftmpl.md) in [`rpt.conf`](../config/rpt_conf.md) for you to customize the settings for your new node.

## Advanced Configuration
When a new node is created, a [template](./conftmpl.md) for the node settings will be created in [`rpt.conf`](../config/rpt_conf.md), such as:

```
;;;;;;;;;;;;;;;;;;; Your node settings here ;;;;;;;;;;;;;;;;;;;
[1999](node-main)
rxchannel = SimpleUSB/1999      ; SimpleUSB
;startup_macro = *8132000
```

It will also create an entry in the [`[nodes]`](../config/rpt_conf.md#nodes-stanza) stanza to define how to connect/route calls to the node. Be sure to check that the options are correct for the `[nodes]` entry, based on what you are tying to do. If this is just another "normal" node on the same host, it will probably be okay with the defaults. If however, you were adding a [remote base](./remotebase.md#remote-base-node-definition) node, you're probably going to need to edit the entry.

### Connecting to Other Private Nodes
Remember, private nodes are just that, a node that you manage separately and independently from the ASL network. As such, the public ASL network knows very little (if anything) about the existence of your private node. As such, other public **or** private nodes have no idea how to connect to your private node, since they aren't registered in the public database (that stores all the IPs and ports on how to interconnect public nodes).

As such, if you want to connect to another private node on your LAN, the public internet, or anywhere other than on the current device, you need to tell Asterisk how to reach that node.

This is handled by making an entry in the `[nodes]` context in [`rpt.conf`](../config/rpt_conf.md#nodes-stanza).

If you want private nodes to be able to connect to each other, they both need to have corresponding entries in their `[nodes]` contexts, pointing at each other.

Sample `rpt.conf` entries:

```
; Server 1 (at bar.domain.com)
[nodes]
1000 = radio@127.0.0.1/1000,NONE               ; Private node on this server 
1001 = radio@foo.domain.com/1001,NONE          ; Private node on a server at foo.domain.com (on default port 4569)
1002 = radio@foo.domain.com:4570/1002,NONE     ; Private node on a different server at foo.domain.com (via NAT on WAN port 4570)
2501 = radio@127.0.0.1/2501,NONE               ; Public node on this server

; Server 2 (at foo.domain.com)
[nodes]
1000 = radio@bar.domain.com/1000,NONE          ; Private node on a server at bar.domain.com (on default port 4569) 
1001 = radio@127.0.0.1/1001,NONE               ; Private node on this server
1002 = radio@192.168.1.10:4570/1002,NONE       ; Private node on a different server on our LAN (listening on port 4570)
2502 = radio@127.0.0.1/2501,NONE               ; Public node on this server

; Server 3 (at foo.domain.com on port 4570)
1000 = radio@bar.domain.com/1000,NONE          ; Private node on a server at bar.domain.com (on default port 4569)
1001 = radio@192.168.1.20/1001,NONE            ; Private node on a different server on our LAN (listening on port 4569)
1002 = radio@127.0.0.1:4570/1002,NONE          ; Private node on this server (listening on port 4570)
2503 = radio@127.0.0.1:4570/2501,NONE          ; Public node on this server
```

As you can see, all three servers have entries in their `[nodes]` context that identify the node number, the IP address (or domain name), and port (if not default) of the each other's private nodes. This will allow all of them to be able to connect to each other.

See the section on [Multiple Nodes on the Same Network](./multinodesnetwork.md) for other considerations and tips on testing.

Remember, a private node can do practically anything you can do with a public node. So, for example, one of those private nodes in the example above could be configured as an Echolink node, but only the nodes you have control of can access it (instead of any public node). Likewise, one of those private nodes could be connected to a UHF link to some other analog system, and this would let you "link in" to that system from your ASL node, but the public can't.

You basically have a "multi-port" repeater controller that is pretty much as flexible as you desire.
