# 44Net Connect for ASL
The 44Net Connect services provides publicly-routable IPv4 addresses
through a point-of-presence (POP) for amateur radio operators.
Connectivity is provided over VPN tunnels using the Wireguard
protocol and system.

## Create a 44Net Connect Account
To sign up for 44Net Connect, create an account in the
[44Net Portal](https://connect.44net.cloud/account/login)
and get your callsign verified.

## Obtaining a 44Net Connect Tunnel
Follow the **Requesting Tunnels** in the
[44Net Connect User Guide](https://connect.44net.cloud/help/). Be sure
to copy the private key at the completion of the tunnel creation
process.

## Install & Configure Wireguard
The following commands must all be run as root (`sudo -s`) or using `sudo`.

1. Install the Wireguard tools with the following commands:

    ```
    apt update
    apt install -y wireguard resolvconf
    ```

2. Create/edit a file named `/etc/wireguard/wg0.conf`

3. Paste in the Wireguard configuration from the 44Net.Connect
portal into the file.

4. Replace the string "`REPLACE_WITH_YOUR_PRIVATE_KEY`" with the
privacy key that was displayed in the portal when you created your tunnel.

5. Save the file.

## Enabling the Connection
The following commands must all be run as root (`sudo -s`) or using `sudo`.

!!! danger "VPN Tunnel is a Full-Tunnel"
    The default 44Net Connect Wireguard Tunnel is a "full tunnel"
    meaning that all traffic will be routed through the tunnel
    and out through the ARDC POP. If you are accessing your system
    outside of its local subnet/LAN, your connection will be
    interrupted and you must reconnect through the 44Net
    IP address you have been assigned.

1. Enable the `wg0` interface to autostart/autoconnect:

    ```
    systemctl enable wg-quick@wg0
    systemctl start wg-quick@wg0
    ```

2. Test connectivity to confirm you're traffic is routing
through the VPN tunnel. The returned text should start
with an IP address beginning with `44.`:

    ```
    # wget -4q -O- https://www.allstarlink.org/myip.php
    44.27.134.30
    ```

3. Wait approximately two minutes, and then confirm your registration
is perceived as being from that same IP address:

    ```
    node63001*CLI> rpt show registrations
    Host                  Username    Perceived              Refresh  State
    52.44.147.201:443     63001       44.27.134.30:4567          179  Registered
    1 HTTP registration.
    ```

4. Your node should now operate on the 44Net Connect service.

## Protecting a 44Net Connection
!!! danger "VPN Security Warning"
    Do not skip these steps. If you do, there will be no
    firewall or network protection for your node from
    the whole Internet.

### Linking Only Profile
If you only need to support linking over VPN and are
using another access method or a local LAN to manage the
system, enter the following commands:

```bash
sudo firewall-cmd --permanent --new-zone=44NetConnect
sudo firewall-cmd --permanent --zone=44NetConnect --add-service=iax2
sudo firewall-cmd --permanent --zone=44NetConnect --add-service=echolink
sudo firewall-cmd --permanent --zone=44NetConnect --add-interface=wg0
sudo firewall-cmd --reload
```

This will only permit IAX2 (normal AllStarLink connections)
and Echolink connections to the node.

### Full Node Profile
!!! danger "VPN Security Warning"
    This will expose SSH (port 22), webservers (ports 80, 443),
    Cockpit (port 9090), and the Asterisk AMI (port 5038)
    to the Internet. Ensure that all passwords and secrets
    (including AMI bind passwords)
    used in this configuration are strong - at least 16 characters
    long and a mix of letters and numbers.

If you need to manage your node through the VPN IP address
using SSH or Cockpit, the enter the following commands:

```bash
sudo firewall-cmd --zone=allstarlink --add-interface=wg0 --permanent
sudo firewall-cmd --reload
```

 Other restrictions such as AMI's
`bindaddr` in `manager.conf` will always be applied.
