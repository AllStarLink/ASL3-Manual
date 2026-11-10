# Multiple Nodes on the Same Network
Multiple AllStarLink nodes on the same IP subnet (i.e. your "local network" or "LAN") when those nodes are behind a NAT device can be a challenge. The reason is that AllStarLink works exclusively with public IP addresses. 

When two (or more) nodes are on the same network behind the same NAT/router, they independently need to use a public IP address with the AllStarLink system, and they also need to know about each other's local IPs (rather than their shared public IP). Additionally, both nodes cannot use the same UDP port as they will fight over it with the NAT/router.

For this example, let's consider two nodes on the same subnet (LAN). The nodes are:

| Node | Local IP |
|-|-|
| 630010 | 192.168.0.10 |
| 630011 | 192.168.0.11 |

These nodes are behind a NAT/router with a public IP address of 203.0.113.186.

When each node connects and registers with AllStarLink, its perceived registration IP address will be 203.0.113.186. If another node asks "where is node 630010" it would get back the answer 203.0.113.186. However, this is also the case for the internal nodes. If node 630011 asks "where is node 630010" it also gets back 203.0.113.186. For various network reasons, this will not work.

One also has to consider the UDP port. By default, each Asterisk system uses the default UDP port of `4569`. This is a published standard. However, through a NAT device, only one system can use the port at a time. Thus our local nodes 630010 and 630011 will fight over that port.

To make two (or more) nodes on the same network function, the following steps must be taken:

1. Assign each node's server a different IAX port
2. Tell each node's server about the other node's internal address and port

In this example, node 630011 will be assigned a different UDP port. The table then of the nodes is:

| Node | Local IP | Port |
|-|-| - |
| 630010 | 192.168.0.10 | UDP 4569 |
| 630011 | 192.168.0.11 | UDP 4570 |

This document assumes one knows how to forward the port internally for one's router/NAT device and that is has already been done.

## Assigning a Different IAX Port
There are two places where the IAX port must be changed when using a non-standard port:

1. `/etc/asterisk/iax.conf`
2. The [AllStarLink Portal](https://allstarlink.org/portal/) for that node's server

### Changing `iax.conf`
The best way to edit the IAX port is to use [`asl-menu`](../user-guide/menu.md). Run `sudo asl-menu`. Choose **1 Node Settings** and then **4 Update Asterisk IAX port**. Set the new UDP port in the box and hit **OK**. Then choose **2 Restart Asterisk**. Then close `asl-menu`.

Alternatively, edit the file directly. As root (i.e. `sudo -s`), edit the file `/etc/asterisk/iax.conf`. Find the line:

```
bindport = 4569
```

and change it to a different port. The ASL3 appliance comes pre-configured to permit traffic on any port between `4560` and `4580`. It is recommended to choose a port in this range for any alternative IAX port. In this example, the node 630011 will be changed to port `4570`. Edit the file to state:

```
bindport = 4570
```

and save and close the file. Restart Asterisk with `systemctl restart asterisk`.

### Changing the Portal
!!! note "Server-Node Relationship"
    Following the operating model, the base `Asterisk/app_rpt` installation is the "Server" and a "Server" hosts one or more "Nodes". Make sure that each node is assigned to a  different server if the nodes are configured on different installations.

Do the following to change a node's server's IAX port.

1. Logon to [https://allstarlink.org](https://allstarlink.org) using your AllStarLink username and password.

2. Click on **Portal** and then **Node Settings**.

3. In the table, find the Server for the node you want to edit. In this example node 630011 is located on server node63011. Remember or jot down the server name.

4. Click on **Portal** and then **Server Settings**.

5. Click on the server from step #4 (in this case "node630011")

6. In the field **IAX Port** change the port number to the port configured in [Changing `iax.conf`](#changing-iaxconf) above. In this example, the port will be `4570`.

7. Click **Submit**

Propagation of the change takes 1-2 minutes.

## Telling Local Nodes About Their Neighbors
Each node on the same network needs to be hardcoded with information about the other node. In this example, node 630010 needs to be hardcoded for where 630011 is and vice-versa.

### Configuring Node 630010
As root (i.e. `sudo -s`) edit the file `/etc/asterisk/rpt.conf`. Locate the line with the node's own definition. For example:

```
630010 = radio@127.0.0.1/630010,NONE
```

After this line, add its local neighbor by its IP address *and* the alternative IAX port. In this example, add 630011 as follows:

```
630010 = radio@127.0.0.1/630010,NONE
630011 = radio@192.168.0.11:4570/630011,NONE
```

Note the inclusion of the port as `:4570`. This pattern can be repeated for multiple nodes on the same network. Save the file and restart asterisk with `systemctl restart asterisk`.

### Configuring Node 630011
The other node repeats same process but in the opposite direction. As root (i.e. `sudo -s`) edit the file `/etc/asterisk/rpt.conf`. Locate the line with the node's own definition. For example:

```
630011 = radio@127.0.0.1/630011,NONE
```

After this line, add its local neighbor by its IP address *and* the standard IAX port since it is unchanged. In this example, add 630010 as follows:

```
630011 = radio@127.0.0.1/630011,NONE
630010 = radio@192.168.0.10:4569/630010,NONE
```

Note the inclusion of the port as `:4569`. This pattern can be repeated for multiple nodes on the same network. Save the file and restart asterisk with `systemctl restart asterisk`.

### Testing Linking Locally
Test linking the two nodes together to ensure configuration. In this example, node 630010 will connect to node 630011 using the Asterisk CLI:

```
rpt cmd 630010 ilink 3 630011
```

Then the link should be shown to 630011 with the command:

```
rpt nodes 630010
```

that should display:

```
node630010*CLI> rpt nodes 630010

************************* CONNECTED NODES *************************

T630011
```

Disconnect the links with:

```
rpt cmd 630010 ilink 1 630011
```

After that, everything should work. The most common issue with this configuration is incorrect router/NAT port forwarding or a typo in `rpt.conf`.
