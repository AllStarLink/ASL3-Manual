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
