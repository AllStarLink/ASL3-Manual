# IAX-Based Registration
This documents how to use IAX-based registration instead of 
HTTP-based registration with ASL3.

!!! danger "Do Not Do This "Just Because""
    Only convert your node to using IAX-based registration because you
    have a known problem using HTTP registration. Use of IAX registration
    is significantly higher server use than HTTP registration and 99+% of all
    users **DO NOT** have a reason to use it.

## Reason to use IAX-Based Registration
The following are the __only__ reasons to use IAX-based registration
with ASL3:

1. Outbound HTTP/HTTPS is blocked but you have outbound UDP port access
available. For example, your node sits behind a proxy or other security
or content filtering device that breaks ASLv3 registration.

2. Your node is behind a connections that handle HTTP traffic differently
than IAX traffic. A known example is AT&T and T-Mobile hotspots. These
hotspots intercept/direct web (HTTP/HTTPS) traffic and route it differently
from IAX traffic. In these use cases, the HTTP-based registration will
register a proxy/accelerator IP address rather than the IP being used
by the node.

## Using IAX Registration Instead of HTTP Registration
To change from HTTP to IAX registration, do the following **as root**
(i.e. use `sudo -s`):

1. Edit `/etc/asterisk/modules.conf` and change the line for
`res_rpt_http_registrations.so` from "load" to "noload":
    ```
    noload => res_rpt_http_registrations.so
    ```
2. Edit `/etc/asterisk/iax.conf` and add a `register =>` line
under the `[general]` stanza. This can be copied from a functional
`rpt_http_registrations.conf` file:
    ```
    [general]
    register => 63001:VerySecret@register.allstarlink.org
    ```

3. Restart asterisk with `systemctl restart asterisk`

4. Run the asterisk console with `asterisk -r` and test the IAX registration
with the command `iax2 show registry`:
    ```
    node63001*CLI> iax2 show registry
    Host                  dnsmgr  Username  Perceived                 Refresh  State
    34.105.111.212:4569   Y       63001     192.0.2.171:4569          180      Registered
    ```

    If it lists "State" as "Registered" you're all set.
