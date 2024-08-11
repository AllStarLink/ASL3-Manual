# Node Resolution

app_rpt has three ways to resolve a node number to an IP address.  
* An external node directory file.
* Domain Name Service (DNS).
* Statically entered in rpt.conf

The above mechanisms are used to translate a node number into its respective public IP address.  Connections are made directly between nodes using their public IP addresses.

app_rpt first looks to see if the node is statically configured.  If it is not found, the setting for **node_lookup_method** in the **[general]** stanza of rpt.conf determines the next step. The default setting is to perform a DNS lookup and if not found, attempt a lookup using the external file.  For more information see [HTTP Registration](https://allstarlink.github.io/adv-topics/httpreg/)

*Note:  The AllStarLink network maintains security by requiring node owners to register with AllStarLink. Beforehttps://github.com/AllStarLink/asl3-update-nodelist) a node is published to our directory it must successfully authenticate and register with our server.* 

## External Node Directory File

app_rpt can use an external node directory file to perform node resolution.  The [asl3-update-nodeList](https://github.com/AllStarLink/asl3-update-nodelist) service is used to periodically download the current list of authenticated nodes.

The name of this file is configured in rpt.conf using the **extnodefile** key and value.  By default the name of this file is /var/lib/asterisk/rpt_extnodes.  Multiple files can be specified based on your requirements.  The file names are separated with a comma.

When a file based lookup is performed, app_rpt reloads the external file before searching for a match.  This allows external scripts the opportunity to keep the file updated.

Here is an example of the external file format:

```
[extnodes]

2000=radio@162.248.93.134:4569/2000,162.248.93.134
2001=radio@162.248.93.134:4569/2001,162.248.93.134
```

## Domain Name Service DNS ##

AllStarLink now provides a DNS service for performing node resolution.  DNS is an Internet standard and is more efficient than using a file base solution.

When using DNS app_rpt must know the length of the longest node number.  The current maximum is 6 digits.  This number can be  overridden in rpt.conf by adding the **max_dns_node_length** key and value to the **[general]** stanza.

For more information on DNS see [AllStarLink DNS Servers](https://wiki.allstarlink.org/wiki/DNS_Servers).

## Statically Configured Node ##

In some cases, it is desirable to statically define the node information.  This is commonly used for private nodes or private networks.

To configure a static node, enter the information for the node in rpt.conf under the **[node]** stanza.  Here is an example configuration:

```
[nodes]
1001 = radio@192.168.0.1/1001,NONE
1998 = radio@127.0.0.1:4568/1998,NONE
1999 = radio@192.168.0.2:4569/1999,NONE
```

