# APIs and Datasets

The following APIs and datasets are available for consumption
by AllStarLink users and applications.

## Node Lookup Information
This information is needed for app_rpt and other clients
to connect to all the nodes in the AllStarLink mesh network.

The **preferred** way to do lookups of node connection information
(i.e., IP address, port) is to use DNS. This is the most efficient
way for both your node's data consumption as well as being friendly
to the AllStarLink project's budget. New nodes and node
connection information changes are generally propagated to DNS
within 60 seconds of registration. More information on using
DNS can be found at [DNS Servers](../adv-topics/dns-servers.md).

!!! danger "asnodes.org"
    Please note that the `asnodes.org` domain is not related to,
    maintained by, or supported by the AllStarLink project. All
    users should use the `nodes.allstarlink.org` domain.

The following URLs can be used to retrieve a text file containing
the current directory in the "extnodes" legacy format. Files are
served from a Cloudflare CDN Cache and are only updated on
the listed "Cache Time" interval.

| URL | Cache Time | Notes |
| - | - | - |
| https://snodes.allstarlink.org/gennodes.php | 5m / 300s | |
| https://snodes.allstarlink.org/diffnodes.php | 5m / 300s | Identical to `gennodes.php` and retained for backwards compatibility. Use `gennodes.php` for new implementations. |
| https://node1.allstarlink.org/cgi-bin/nodes.pl | 5m /300s | Deprecated; switch to `gennodes.php` |

Do not retrieve these APIs more than once every ${CACHE TIME} per listed
URL.

!!! note "The `?hash=` Parameter"
    Previously, the `diffnodes.php` endpoint had a "differential" parameter
    `?hash=` that would download a diff/patch version that could be merged
    with a "full" version using the `patch(1)` too. This parameter has been retired
    to reduce server load and bandwidth consumption and will be completely ignored.
    Nodes concerned about bandwidth utilization downloading the node database
    should use DNS lookups or retrieve the data file no more than once every
    ${CACHE TIME} seconds as listed above.

## Node Description Directory
This information is the node description information, informally
called the "Allmon Database" or "Allmon DB". Files are
served from a Cloudflare CDN Cache and are only updated on
the listed "Cache Time" interval.

| URL | Cache Time | Notes |
| - | - | - |
| https://allmondb.allstarlink.org/allmondb.php | 15m / 900s | |

Do not retrieve these APIs more than once every ${CACHE TIME} per listed
URL.

## Stats API
The Stats API can be used to retrieve certain information about nodes and
their links:

| URL | Rate Limit | Notes |
| - | - | - |
| https://stats.allstarlink.org/api/stats/ | 1 request / minute / IP  | All reporting nodes. |
| https://stats.allstarlink.org/api/stats/${NODE} | 30 requests / minute / IP total | Stats on an individual reporting node. Rate limited from a single IP regardless of the node(s) requested in any combination. |
| https://stats.allstarlink.org/api/stats/mapData | 1 request / minute / IP | |

These return JSON that is self-describing.

## Authentication APIs
There are node registration APIs available for applications.

### WebTransceiver
The original Web Transceiver (WT) was a browser-based Java applet that one could use from the AllStarLink website to call nodes directly. That feature itself has been long gone whenever browsers no longer supported Java Applets. However, the background technology still exists and has been leveraged for other applications.

Using this method, clients are issued a token by [allstarlink.org](https://www.allstarlink.org/) either "faking" a login on using the `/api/v2/auth-wt-legacy` API endpoint. Clients provide the ASL portal username and password and receive back a token. The client then places an unauthenticated IAX call to a node which is handled by the `[allstar-public]` context. Within that context is a a mechanism for verifying that the token for the incoming CallerID (the callsign) is valid. If it is, it lets the call through and connects the application to the node. If it can’t validate, then it hangs up.

If you are a node owner, and you wish to allow these applications to connect to your node via the Web Transceiver method, you need to ensure that it is enabled in your `Node Settings` in the Web Portal. See [Editing Node Parameters](../basics/portal.md#editing-node-parameters) for more information on how to find this setting.
You should also confirm that you have an `[allstar-public]` context in `extensions.conf`, and that it isn't commented out (it should be there and active, unless you've previously made changes).


### Simple Node Auth
This API is for authenticating infrastructure clients such as node audio
test sites using the Node number and node password. This API is not "open"
in that arrangement to use them must be made with the AllStarLink
Infrastructure Administrators. Contact N8EI or WA8WCO
on [The ASL Community](https://community.allstarlink.org).

**URL:** https://allstarlink.org/api/simple-node.auth.php

**HTTP Method:** POST

**Input:**
```json
    {
        'api':'API_PASSWORD ,       <--- provided by ASL Infra Admins
        'node':'NODE_NUMBER' ,
        'passwd' : 'NODE_PASSWORD',
        'cookie' : 'COOKIE'         <--- any string desired by the app
    }
```

**Output:**
```json
      {
           'status' : "OK" | "ERR"
           'auth' : "1" | "0" ,    <---- 1 = Success, 0 = Failure
           'cookie' : 'COOKIE'     <---- As provided by input or empty string
           'msg' : 'MESSAGE'       <--- If status = Error, has the error, otherwise blank
      }
```

!!! danger
    All other HTTP methods or malformed JSON will be ignored.