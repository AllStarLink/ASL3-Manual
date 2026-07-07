# 44Net Connect
[44Net](https://wiki.ampr.org/wiki/Main_Page), also known as AMPRNet, is a block of globally routable IPv4 addresses allocated for amateur radio use.

[44Net *Connect*](https://connect.44net.cloud/) gives an amateur radio operator a publicly routable IPv4 address in the 44Net space. That address is delivered to the operator's system through a VPN tunnel.

For AllStarLink, 44Net Connect is most useful when a node cannot receive inbound IAX2 because it is behind NAT, CGNAT, a restrictive router, or a network where port forwarding is not available. 44Net Connect can provide a public `44.x.x.x` address that other nodes can reach.

Most users only need 44Net Connect for inbound AllStarLink IAX2 connections. It can also make other services reachable from the Internet, such as EchoLink or VOTER/RTCM, but every exposed service adds risk. Start with IAX2 only and add other services only when you know you need them.

## 1. Understanding Security Risks { #understanding-security-risks }

!!! danger "Firewall first!"
    44Net Connect adds a public Internet path to the machine through the VPN interface. You should:

    - Configure a firewall before starting the VPN
    - Only expose necessary services to the Internet
    - Secure any service reachable from the Internet with a strong, unique password or other strong authentication method

    A compromised public node can become an entry point into a private local network and other devices on that network.

The default 44Net Connect configuration is a full-tunnel VPN, which means the VPN tunnel is used as the default route and outbound IPv4 traffic is routed through the VPN. Traffic sent from the Internet to the assigned public `44.x.x.x` address can also reach the node through the VPN tunnel unless the firewall blocks it.

The safe setup method is:

1. Create a dedicated firewall zone for the VPN interface.
2. Allow only the inbound services you need.
3. Attach the VPN interface to the dedicated zone.
4. Start the VPN tunnel only after the firewall is configured.

## 2. Firewall Setup { #firewall-setup }
Complete the firewall section that matches your system before creating or starting the VPN tunnel.

### ASL3 Appliance Systems { #asl3-appliance-systems }
Use these instructions if the node is an [ASL3 Appliance](../install/pi-appliance/index.md). This includes the Raspberry Pi Appliance image and Debian systems where an [appliance package](../install/debian/deb-appliance.md) has been installed.

ASL3 Appliance systems include `firewalld` and custom AllStarLink firewall service definitions. The safest approach is to create a dedicated `44NetConnect` zone for the VPN interface and add only the services you need.

Do not assign the VPN interface that carries the public 44Net address to the appliance's default `allstarlink` zone unless you intentionally want the default appliance firewall policy on that address. See the advanced note at the end of this section for details.

??? info "Default appliance service definitions and ports"
    The ASL3 Appliance packages install a few custom `firewalld` service definitions for common AllStarLink services. The latest source for these definitions is in the [asl3-pi-appliance firewalld services directory](https://github.com/AllStarLink/asl3-pi-appliance/tree/main/src/firewalld/services).

    | Service Name | Purpose | Default Ports Opened |
    | ------------ | ------- | ----- |
    | `iax2` | AllStarLink IAX2 | UDP `4560-4580` |
    | `echolink` | EchoLink | UDP `5198-5199` |
    | `rtcm` | VOTER/RTCM | UDP `1667` |
    | `astmgr` | Asterisk Manager Interface (AMI) | TCP `5038` |

    These service definitions open the default ports used by the ASL3 Appliance. If you manually changed a service to listen on a different port, add that exact port and protocol to the `44NetConnect` zone instead of assuming the default service definition will match your configuration.

#### Create the 44NetConnect Zone { #create-the-44netconnect-zone }
Run these commands before enabling the VPN tunnel. The VPN interface does not need to be connected yet.

```bash
sudo firewall-cmd --permanent --new-zone=44NetConnect
sudo firewall-cmd --reload
```

If the first command reports that the `44NetConnect` zone already exists, continue with the service sections below.

The reload here makes the new zone available to `firewalld`. After this point, add all the services you want, then reload once at the end.

#### Allow Inbound IAX2 { #iax2 }
!!! info "IAX2 is the only service required for most users"
    IAX2 is the only inbound protocol most nodes need for normal AllStarLink connections.

Add `iax2` if you want to accept inbound IAX2 AllStarLink connections from the public Internet.

```bash
sudo firewall-cmd --permanent --zone=44NetConnect --add-service=iax2
```

??? note "Non-standard IAX2 ports"
    The default appliance `iax2` service opens UDP `4560-4580`, which includes the default IAX2 port `4569`.

    If your IAX2 port is outside UDP `4560-4580`, add that UDP port to the same firewall zone and make sure the IAX2 port in `/etc/asterisk/iax.conf` matches the IAX Port setting in the AllStarLink Portal.

    For example, if your IAX2 port is UDP `14569`:

    ```bash
    sudo firewall-cmd --permanent --zone=44NetConnect --add-port=14569/udp
    ```

#### Optional Additional Services { #appliance-optional-additional-services }
??? info "Optional: Echolink, VOTER, and more"
    If all you need is inbound IAX2, leave this section closed and continue to **Finish and Reload**. Add only the optional services you intentionally want reachable through the 44Net address.

    **EchoLink**

    Add `echolink` if you want to accept incoming EchoLink connections from the public Internet.

    ```bash
    sudo firewall-cmd --permanent --zone=44NetConnect --add-service=echolink
    ```

    **VOTER/RTCM**

    Add `rtcm` if you want to accept incoming VOTER/RTCM connections from the public Internet on the default UDP port `1667`.

    ```bash
    sudo firewall-cmd --permanent --zone=44NetConnect --add-service=rtcm
    ```

    If your VOTER/RTCM configuration uses a different UDP port, add that port instead. For example, if your VOTER/RTCM port is UDP `1668`:

    ```bash
    sudo firewall-cmd --permanent --zone=44NetConnect --add-port=1668/udp
    ```

    **Web dashboards and management tools**

    Dashboard and management tools should normally stay private. Use [Tailscale](https://tailscale.com/) or a similar private remote access service, a self-hosted WireGuard VPN such as [PiVPN](https://www.pivpn.io/), or a protected tunnel or reverse proxy such as [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/).

    Directly exposing a dashboard, web server, Cockpit, SSH, AMI, or another management service can create an entry point into the node and any private network connected to it. This page intentionally does not provide firewall commands for exposing those services directly to the public Internet.

    If you choose to expose one anyway, you need to understand the service configuration, use strong authentication, and open only the exact service you intend to expose. AMI is especially risky because it can control and inspect Asterisk; do not expose it unless you understand the risk and have secured and restricted `/etc/asterisk/manager.conf`.

    **Other custom services**

    If you need to expose another service on the 44Net address, prefer adding only the exact port and protocol needed:

    ```bash
    sudo firewall-cmd --permanent --zone=44NetConnect --add-port=12345/udp
    ```

    If you prefer a reusable named service, create a local `firewalld` service definition and add that service to the `44NetConnect` zone.

#### Finish and Reload { #finish-and-reload }
After adding the service(s) you want to your firewall configuration, attach the VPN interface (`wg0`) to the `44NetConnect` zone and reload `firewalld`.

```bash
sudo firewall-cmd --permanent --zone=44NetConnect --add-interface=wg0
sudo firewall-cmd --reload
```

All other inbound services remain blocked on the VPN interface.

??? danger "Do not use the default `allstarlink` zone on the VPN interface"
    On an ASL3 Appliance system, the [default `allstarlink` zone](https://github.com/AllStarLink/asl3-pi-appliance/blob/main/src/firewalld/zones/allstarlink.xml) includes services for normal node operation and local administration: SSH, HTTP, HTTPS, Cockpit, IAX2, EchoLink, VOTER/RTCM, mDNS, and DHCPv6 client handling. The zone also enables forwarding behavior. Assigning the VPN interface to this zone can make those services reachable or active on the public 44Net address.

    This is a last-resort option for users who have reviewed the active zone contents and intentionally want the default appliance firewall policy on 44Net. This page intentionally does not provide the command. If you cannot determine how to assign an interface to a `firewalld` zone after reviewing the active zone contents, do not use this approach.

    AMI is not included in the default `allstarlink` zone, but the appliance does provide an AMI service definition. Exposing AMI on a public interface is especially risky because AMI can provide powerful access to Asterisk. Do not expose AMI unless you understand the risk and have secured and restricted `/etc/asterisk/manager.conf`.

Next: [Create and start the tunnel](#create-and-start-the-tunnel).

### Non-Appliance Systems { #non-appliance-systems }
Plain Debian ASL3 installs do not install the ASL3 Appliance firewall configuration by default. If you installed ASL3 with `sudo apt install asl3` and did not install an appliance package, the `firewall-cmd` commands above may not exist or may not have the ASL service names.

!!! danger "Stop until a firewall is configured"
    Do not continue until the system has a host firewall or upstream firewall policy that protects the 44Net address. Bind the rule to the VPN interface (`wg0`) or to the assigned 44Net address so that only the intended services are reachable from the public Internet.

On Debian, you can manually install `firewalld` and use the same dedicated-zone approach as the ASL3 Appliance. The difference is that a plain Debian install does not include the ASL3 Appliance service definitions, so you add the port numbers directly.

#### Install firewalld { #install-firewalld }
Install and start `firewalld`:

```bash
sudo apt update
sudo apt install -y firewalld
sudo systemctl enable --now firewalld
```

#### Create the 44NetConnect Zone { #non-appliance-create-the-44netconnect-zone }
Create the `44NetConnect` zone:

```bash
sudo firewall-cmd --permanent --new-zone=44NetConnect
sudo firewall-cmd --reload
```

#### Allow Inbound IAX2 { #non-appliance-iax2 }
Most users only need inbound IAX2:

```bash
sudo firewall-cmd --permanent --zone=44NetConnect --add-port=4569/udp
```

??? note "Non-standard IAX2 port"
    If your IAX2 port is not UDP `4569`, replace `4569/udp` with your configured IAX2 port.

#### Optional Additional Services { #non-appliance-optional-additional-services }
??? info "Optional: Echolink, VOTER, and more"
    If all you need is inbound IAX2, leave this section closed and continue to **Finish and Reload**. Add only the optional services you intentionally want reachable through the 44Net address.

    **EchoLink**

    Add the EchoLink ports if you want to accept incoming EchoLink connections from the public Internet.

    ```bash
    sudo firewall-cmd --permanent --zone=44NetConnect --add-port=5198-5199/udp
    ```

    **VOTER/RTCM**

    Add the VOTER/RTCM port if you want to accept incoming VOTER/RTCM connections from the public Internet on the default UDP port `1667`.

    ```bash
    sudo firewall-cmd --permanent --zone=44NetConnect --add-port=1667/udp
    ```

    If your VOTER/RTCM port is not UDP `1667`, replace `1667/udp` with your configured VOTER/RTCM port.

    **Web dashboards and management tools**

    Dashboard and management tools should normally stay private. Use [Tailscale](https://tailscale.com/) or a similar private remote access service, a self-hosted WireGuard VPN such as [PiVPN](https://www.pivpn.io/), or a protected tunnel or reverse proxy such as [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/).

    Directly exposing a dashboard, web server, Cockpit, SSH, AMI, or another management service can create an entry point into the node and any private network connected to it. This page intentionally does not provide firewall commands for exposing those services directly to the public Internet.

    If you choose to expose one anyway, you need to understand the service configuration, use strong authentication, and open only the exact service you intend to expose. AMI is especially risky because it can control and inspect Asterisk; do not expose it unless you understand the risk and have secured and restricted `/etc/asterisk/manager.conf`.

    **Other custom services**

    If you need to expose another service on the 44Net address, prefer adding only the exact port and protocol needed:

    ```bash
    sudo firewall-cmd --permanent --zone=44NetConnect --add-port=12345/udp
    ```

#### Finish and Reload { #non-appliance-finish-and-reload }
After adding the port(s) you need, attach the VPN interface (`wg0`) to the zone and reload `firewalld`:

```bash
sudo firewall-cmd --permanent --zone=44NetConnect --add-interface=wg0
sudo firewall-cmd --reload
```

Do not expose SSH, Cockpit, HTTP, HTTPS, AMI, or other management ports on the 44Net address unless you have intentionally planned for public remote administration.

??? info "Other firewall tools"
    If you use a different Linux distribution or a different firewall tool, create equivalent rules for the VPN interface or assigned 44Net address. If you are not comfortable creating equivalent firewall rules for your system, use the ASL3 Appliance installation path or get firewall help before enabling the tunnel.

Next: [Create and start the tunnel](#create-and-start-the-tunnel).

## 3. Create and Start the Tunnel { #create-and-start-the-tunnel }
Only continue after the firewall rules for the VPN interface (`wg0`) are in place.

### Create a 44Net Connect Account
Create an account in the [44Net Portal](https://connect.44net.cloud/account/login) and complete callsign verification.

### Request a Tunnel
Follow the **Requesting Tunnels** instructions in the [44Net Connect User Guide](https://connect.44net.cloud/help/).

Copy the private key when the tunnel is created. You will need it when creating the WireGuard configuration file.

### Install and Configure the VPN Tunnel
44Net Connect uses WireGuard for the VPN tunnel. The following commands must be run as root or with `sudo`.

1. Install the WireGuard tools:

    ```bash
    sudo apt update
    sudo apt install -y wireguard resolvconf
    ```

2. Create the WireGuard configuration directory if it does not already exist:

    ```bash
    sudo install -d -m 700 /etc/wireguard
    ```

3. Create or edit `/etc/wireguard/wg0.conf`:

    ```bash
    sudo nano /etc/wireguard/wg0.conf
    ```

4. Paste the WireGuard configuration from the 44Net Connect portal into the file.

5. Replace `REPLACE_WITH_YOUR_PRIVATE_KEY` with the private key that was displayed in the portal when the tunnel was created.

6. Save the file and restrict access to it:

    ```bash
    sudo chmod 600 /etc/wireguard/wg0.conf
    ```

??? info "Why this is a full-tunnel VPN"
    The 44Net Connect configuration normally includes `AllowedIPs = 0.0.0.0/0`. That setting sends all IPv4 traffic through the VPN tunnel and is why the firewall must be configured before the tunnel is started.

### Enable the VPN Tunnel
The following commands must be run as root or with `sudo`.

!!! warning "Remote connections may drop"
    Starting a full-tunnel VPN can change the node's return path to the network. If you are connected from outside the local LAN, your SSH or Cockpit session may drop when the tunnel starts. Use local LAN access or console access if possible. Alternatively, use a terminal multiplexer like [tmux](https://github.com/tmux/tmux/wiki) to keep your terminal session running even if you lose connection.

1. Enable and start the VPN interface (`wg0`):

    ```bash
    sudo systemctl enable wg-quick@wg0
    sudo systemctl start wg-quick@wg0
    ```

2. Confirm that outbound IPv4 traffic is using the 44Net address:

    ```bash
    wget -4q -O- https://www.allstarlink.org/myip.php
    ```
    The returned address should begin with `44.`

3. Wait approximately two minutes, then check the Asterisk CLI to confirm the node registration is perceived from the same 44Net address. The exact IP address and port shown in the `Perceived` column will be different on your node; the address should be your assigned `44.x.x.x` address:

    ```bash
    asterisk -rx "rpt show registrations"
    ```
    ```
    Host                  Username    Perceived              Refresh  State
    52.44.147.201:443     63001       44.27.134.30:4567          179  Registered
    1 HTTP registration.
    ```

Your node should now operate through the 44Net Connect service.
