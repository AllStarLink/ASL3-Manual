# Permanent Node Connection
As opposed to a "normal" connection to a remote note, a "permanent" connection will attempt to create a *persistent* connection that will try and keep the nodes connected together as much as possible.

Specifically, permanent connections:

* Will continuously attempt to reconnect
* Survive network outages and **far end** reboots
* **Near end** reboots will **NOT** reconnect (use [`startup_macro`](../config/rpt_conf.md#startup_macro) for that)
* Must be disconnected by a "permanent disconnect" (`ilink,11`) command
* Either end may initiate the disconnect
* Does not block nodes from subsequently connecting again (use [Allow and Deny Lists](./allowdenylists.md) for that)

You could, for example, utilize this to keep your VHF and UHF repeaters (nodes) linked together "permanently", or keep a node connected to a (private) node that might be a UHF link to another system. 

# Configuration
The following commands should already exist in [`rpt.conf`](../config/rpt_conf.md), but may need to be uncommented under your [`[functions]`](../config/rpt_conf.md#functions-stanza) stanza:

```
811 = ilink,11                      ; Disconnect a previously permanently connected link
812 = ilink,12                      ; Permanently connect specified link -- monitor only
813 = ilink,13                      ; Permanently connect specified link -- transceive
818 = ilink,18                      ; Permanently Connect specified link -- local monitor only
```

In other words a `*813nnnnn` DTMF command will permanent connect your node to the node number represented by nnnnn.
 
If you would like a permanent connection automatically when your node boots you need a [`startup_macro`](../config/rpt_conf.md#startup_macro) to initiate the initial connection. 

For example, under your [Node Number Stanza](../config/rpt_conf.md#node-number-stanza) add:

```
startup_macro = *8131999            ; Permanently connect (transceive) to node 1999 when Asterisk starts
startup_macto_delay = 10            ; Wait 10 seconds after starting before running the startup_macro              
```

Reload/restart your system and it will auto connect to the node you specified above (after the `startup_macro_delay`).