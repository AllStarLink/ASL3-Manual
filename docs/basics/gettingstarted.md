# Basics
## What is a "Node"?
A node, in simplest terms, is software (`Asterisk/app_rpt`) running on a computer (a "server" in AllStarLink terms) that connects to the AllStarLink network. Nodes typically have an RF radio interface as well as an internet connection. Radios can range in size from a repeater radio to a low power radio integrated into a node. A node allows you to connect to other nodes in the AllStarLink network. 

The node software can run on a variety of hardware, see [Servers](#what-is-a-server) below.

***A node must be associated to a "server".*** You can have multiple nodes assigned to, and configured on, the same server (if desired).

## What is a "Node Number"?
A node number is a unique number that is assigned to every node on the network. It is analogous to a telephone number (Asterisk, upon which ASL3 is based is a telephony switch after all). Like you do with your telephone, when you "dial" a node number, that will connect to a specific node on the network, linking those nodes together. You can link many nodes together simultaneously, creating a network of nodes that all participate in conversation together.

## What is a "Hub"?
A hub is just another name for a node (they are configured the same). Any node can be a "hub", it is up to the owner how they advertise it.

It may, or may not, have a radio attached to it. Hubs are like the hub of a wheel, they are designated nodes that users build that other users can connect their own nodes to (the "spokes" of the wheel). It is easier for everyone that wants to get together to chat to all connect to the same hub node, rather than trying to individually connect to each other.

A hub can exist on a physical computer, it can co-exist with another node on the same computer, or it can be deployed "in the cloud" on a server somewhere.

A hub is also useful for [permanently linking](../adv-topics/permanentnode.md) nodes (repeaters) under your control together, such as a VHF and UHF repeater, and then other users can connect to the hub to be broadcast on both bands (instead of having to connect to the VHF and UHF nodes separately). 

## What is a "Server"?
A server is a Linux-based computer that runs the `Asterisk/app_rpt` (ASL3) software. A variety of hardware is supported, from an inexpensive Raspberry Pi, a PC, or even a virtual machine.

You need to configure at least one server in the [AllStarLink Portal](./portal.md), and associate at least one node to it.

A server can host many nodes, up to its hardware resource limits.

## Getting on AllStarLink
* If you wish to create your own node, follow the directions below to create an account. After your account is active, you will need a suitable Raspberry Pi, PC, or virtual machine to install and run ASL3
* If you wish to use a local FM repeater that is AllStarLink enabled, you do not need an AllStarLink account. Check out our [Active Nodes List](https://stats.allstarlink.org/) to find a repeater near you. If you type your city name in the search box, you will be given a list of active nodes. However, before controlling any node via RF or DTMF, be sure to talk to the operator(s) of that node and receive permission first 
    * For a list of possible commands, visit the [AllStarLink Standard Commands](https://wiki.allstarlink.org/wiki/AllStar_Link_Standard_Commands) page
    * Some nodes may be local/non-public nodes, so look for information that the node is in fact public
* If you wish to purchase a pre-made or complete node, check out our [Radio Connections](https://wiki.allstarlink.org/wiki/Radio_Connections) page for a list of vendors
* You can also use one of the mobile/PC apps noted below. See their installation instructions to determine whether you need an AllStarLink Portal account (and perhaps a node number)

## How do I use AllStarLink?
If you have a local FM repeater that is AllStarLink enabled, you may already be using it! However, before attempting to control a local FM repeater, check with the owner(s) first before doing so -- amateur radio etiquette applies.

AllStarLink is typically used in these ways:

* Via a FM repeater that is AllStarLink enabled. Controlled through [DTMF Commands](https://wiki.allstarlink.org/wiki/AllStar_Link_Standard_Commands), via the internet, or an autopatch
* Via a local "hotspot" node that is purchased by an amateur radio operator to join the AllStarLink network directly
* Via a mobile app such as [DVSwitch Mobile (Android)](https://play.google.com/store/apps/details?id=org.dvswitch&hl=en_US&gl=US) or [RepeaterPhone (iOS)](https://apps.apple.com/us/app/repeaterphone/id1637247024) to connect directly to a node
* Via IAXRpt (PC)/Transceive (MacOS) software that allows you to connect directly to a node over the internet. The computer microphone/speaker are used for audio
* Via a reverse-autopatch

## Creating Your Own Node
If you need to create your own node to connect to the AllStarLink network, the rest of this manual is for you! Before you get to installing software and connecting up radios, you'll need to get a node number assigned to you. The next section about the [AllStarLink Portal](./portal.md) will guide you through the process of requesting a node number.

!!! note "Private Nodes"
    In order to connect to other public AllStarLink nodes via the internet, you need a public node number assigned. If you just want take things for a "test drive" to get comfortable first, you can opt to build and deploy a [Private Node](../adv-topics/privatenodes.md) first.  

## Node Registration
If you've created a public AllStarLink node, it needs to be registered with the AllStarLink Network before you will be able to connect to other nodes, or before other nodes can connect to you.

The [ASL3 Menu](../user-guide/index.md) program will help you configure your node, and should take care of configuring [HTTP Registration](../adv-topics/httpreg.md) for you.

Once you have your node up and running, go check the [AllStarLink Nodelist](https://www.allstarlink.org/nodelist) and put your node number in the Filter box in the upper right of the screen. If your node number shows up with a green background, it has successfully registered with the AllStarLink Network.

After your node has successfully registered, you will be able to connect to other nodes on the AllStarLink Network. If you have enabled network access to your server (e.g. port forwarding) then other nodes should be able to connect to your node.

When you first power on your node, it may take up to 30 minutes for your node's status to propagate through the whole network (many nodes still use an older registration update system that does scheduled updates to their local node list).

It is recommended that you leave your node powered on and connected to the network, so that you registration stays active.