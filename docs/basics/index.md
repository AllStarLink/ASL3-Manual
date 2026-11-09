# Getting Started With AllStarLink

If you are new to the AllStarLink network, this section of the manual should help you become familiar with how the system works as well as guide you through the prerequisites to get connected.

## Terminology to Know

AllStarLink/app_rpt has some unique terminology that is essential to understand to follow this manual.

### *Node Number*

A foundational concept in AllStarLink is the *Node Number*. A *Node Number* is a unique number that is assigned to every node on the network and is analogous to a telephone number. Like you do with a telephone, when you "dial" a node number, that will connect to a specific node on the network, linking those nodes together. You can link many nodes together simultaneously, creating a network of nodes that all participate in conversation together.

Node numbers are between four and six digits long. Currently, AllStarLink public node numbers are randomly assigned between 41000 and 69999.

Similar to a "private IP address" or "non-routable IP address" (RFC1918 for networking enthusiasts), there is also the concept of *private node numbers*. These are in a reserved block of 1000-1999. These numbers cannot be used on the public AllStarLink network but can be used within private networks and later connect out to AllStarLink.

### *Node*

A *Node*, in simplest terms, is a [Node Number](#node-number) configured in software (`Asterisk/app_rpt`) running on a computer (a [Server](#server) in AllStarLink terms). A Node is [Registered](#node-registration) to the network and then can connect to other Nodes.  A Node may have an RF radio interface, a non-radio audio interface, or even no interface. Nodes with no audio interfaces are commonly located in a cloud provider called a [Hub](#hub).

Multiple Nodes may be configured on a single Server in an N:1 relation. You do not need a 1:1 pairing of Node to Servers + Hardware.

### *Node Registration*

This is the process of a Node on a Server authenticating to the AllStarLink network. This causes the node to be registered in the public directory, propagate the technical data to other nodes, and allow a Node to connect to or receive connections from other Nodes.

### *Hub*

A hub is just another name for a node (they are configured the same). Any node can be a "hub", it is up to the owner how they advertise it. It may, or may not, have a radio attached to it. Hubs are like the hub of a wheel, they are designated nodes that users build that other users can connect their own nodes to (the "spokes" of the wheel). It is easier for everyone that wants to get together to chat to all connect to the same hub node, rather than trying to individually connect to each other. A hub can exist on a physical computer, it can co-exist with another node on the same computer, or it can be deployed "in the cloud" on a server somewhere.

A hub is also useful for [permanently linking](../adv-topics/permanentnode.md) nodes (repeaters) under your control together, such as a VHF and UHF repeater, and then other users can connect to the hub to be broadcast on both bands (instead of having to connect to the VHF and UHF nodes separately).

### *Server*

A server is a Linux-based computer that runs the `Asterisk/app_rpt` (ASL3) software. A variety of hardware is supported, from an inexpensive Raspberry Pi, a PC, or even a virtual machine. You need to configure at least one server in the [AllStarLink Portal](./portal.md), and associate at least one node to it. A server can host many nodes, up to its hardware resource limits.

## How do I use AllStarLink?

If you have a local FM repeater that is AllStarLink enabled, you may already be using it! However, before attempting to control a local FM repeater, check with the owner(s) first before doing so -- amateur radio etiquette applies.

AllStarLink is typically used in these ways:

* Via a FM repeater that is AllStarLink enabled. Controlled through [DTMF Commands](https://wiki.allstarlink.org/wiki/AllStar_Link_Standard_Commands), via the internet, or an autopatch
* Via a local "hotspot" node that is purchased by an amateur radio operator to join the AllStarLink network directly
* Via a mobile app such as [DVSwitch Mobile (Android)](https://play.google.com/store/apps/details?id=org.dvswitch&hl=en_US&gl=US) or [RepeaterPhone (iOS)](https://apps.apple.com/us/app/repeaterphone/id1637247024) to connect directly to a node
* Via IAXRpt (PC)/Transceive (MacOS) software that allows you to connect directly to a node over the internet. The computer microphone/speaker are used for audio

## Creating Your Own Node

If you want to create your own node to connect to the AllStarLink network, the rest of this manual is for you! In general the workflow for building your own Node is:

1. Create an account at the [AllStarLink Portal](./portal.md) which will will guide you through the process of creating a server, requesting a node number, and configuration the node's information.

2. Build/install a [Server](#server) with the desired hardware.

3. Use the [WebUI](../web-ui/first-setup) or [Menu](../user-guide/menu.md) to configure your [Node](#node) on it.

4. Once you have your node up and running, go check the [AllStarLink Nodelist](https://www.allstarlink.org/nodelist) and put your node number in the Filter box in the upper right of the screen. If your node number shows up with a green dot, it has successfully registered with the AllStarLink Network.

5. After your node has successfully registered, you will be able to connect to other nodes on the AllStarLink Network. If you have enabled network access to your server (e.g. port forwarding) then other nodes should be able to connect to your node.

!!! tip Be Patient
    When you first power on your node, it may take up to 30 minutes for your node's status to propagate through the whole network (many nodes still use an older registration update system that does scheduled updates to their local node list).

    It is recommended that you leave your node powered on and connected to the network, so that you registration stays active.
