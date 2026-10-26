# Fallback Access Point

The ASL3 appliance images (asl3-appliance-pc and asl3-appliance-pi) include a **fallback access point** (AP) system. If the node has a WiFi adapter but no usable network connection, the node turns its WiFi adapter into a temporary access point. You can join that network from a phone or laptop and reach the [Cockpit web console](../pi/cockpit-basics.md) to configure WiFi or other network settings. When the node gets its network connection back, it shuts the AP down and goes back to normal operation.

The main use is first-time setup when the credentials provided to the imager were incorrect or moving a node to a new location where its saved WiFi network isn't available. Without the fallback AP, a node with no Ethernet connection and no known WiFi network can't be reached at all.

The fallback AP is enabled by default on new or upgraded installs of asl3-appliance-pc and asl3-appliance-pi starting with version 2.2.2-1.

!!! warning Mobile Nodes
    Users of nodes that are frequently mobile and away from active Wifi for periods
    of time will want to disable this feature to avoid node reboots. See
    below.

## Using the Fallback AP

Two minutes after boot, and every five minutes thereafter,
the fallback-ap system will look at the state of the networking on
the system. The following is, in general, the decision process:

1. If the system has active networking, wired or wireless, no action is taken.

2. If the system has no active networking, the system is searched for
a wireless interface. If no wireless interface is found, no action is taken.

3. If one or more wireless interfaces are found, then the alphabetically-first
interface is chosen to host the fallback AP.

4. A network with an SSID of `AllStarLink_{MAC}` is created where `{MAC}` is
the Ethernet address of the wireless adapter. It will be named something like
`AllStarLink_DCA632AB322E`. A small IPv4 network is created.

Once the network is created, the Node may be connected to with a laptop or phone
to configure the networking. Have your device connect to the `AllStarLink_{MAC}`
network and use the password "AllStarLink".

In most cases, upon connect, the node will trigger the device to open its
browser and connect to Cockpit. Not all devices implement this consistently.
If your device does not autoconnect, browse to `https://192.168.187.65`.

!!! note "Certificate Warning"
    You browser will show a security warning before it opens the page. This is expected, and it's safe to accept the warning on the fallback AP.

Configured a normal IP connection or setup a WiFi configuration in Cockpit. For WiFi
configuration, see [Changing WiFi Settings via Cockpit](../pi/cockpit-network.md#changing-wifi-settings-via-cockpit).
Once configured, reboot the system.

!!! note "Reboot is Required"
    Saving a new WiFi network while connected to the AP doesn't take the node out of AP mode by itself. The radio is busy being the AP, so the node can't join the new network, and connectivity never comes back. After saving the new WiFi network, reboot the node. It then joins the new network, and the AP doesn't start. Plugging in Ethernet also restores connectivity, and the watchdog stops the AP on its next run.

## Disabling, Enabling, and Troubleshooting

The fallback AP is controlled by the `fallback-ap.timer` systemd timer, which is enabled by default.

Check whether it is enabled:

```
systemctl is-enabled fallback-ap.timer
```

Disable it. If the AP is up at the time, also stop it and remove the profile:

```
sudo systemctl disable --now fallback-ap.timer
sudo nmcli connection down asl-fallback-ap
sudo nmcli connection delete asl-fallback-ap
```

Enable it again:

```
sudo systemctl enable --now fallback-ap.timer
```

To see what the watchdog has been doing, check the service's log:

```
journalctl -u fallback-ap.service
```

Each run logs the connectivity state it found, and any action it took, such as creating the profile, turning off autoconnect on other profiles, or starting or stopping the AP.

To force a check right away instead of waiting for the timer:

```
sudo systemctl start fallback-ap.service
```

## Theory of Operations for System Administrators

Most users will not care about this information, but it is provided for completeness.

### Watchdog and Timers

The fallback AP is a small watchdog script run by a systemd timer, `fallback-ap.timer`. The timer first runs the watchdog two minutes after boot, and then once a minute after that. The watchdog doesn't stay running between checks; each run checks the network state, makes any needed change, and exits.

Each time it runs, the watchdog:

1. **Finds a wireless interface.** It looks for interfaces in `/sys/class/net` that have wireless capability. If there are none, it does nothing. If there is more than one, it uses the first one in alphabetical order (usually `wlan0`).

2. **Makes sure the AP profile exists.** The AP is a NetworkManager connection profile, named `asl-fallback-ap` by default. If the profile doesn't exist, the watchdog creates it. The profile is set to never autoconnect, so it only comes up when the watchdog starts it.

3. **Checks connectivity.** The watchdog asks NetworkManager for the overall connectivity state (`nmcli general status`). A state of `none` or `limited` means the node has no usable network connection.

4. **Starts or stops the AP.**
    * If connectivity is degraded and the AP isn't running, the watchdog starts the AP.
    * If connectivity is fine and the AP is running, the watchdog stops the AP.
    * Otherwise, it leaves things alone.

Because the decision is based on overall connectivity and not on WiFi alone, a node with working **Ethernet** never starts the AP, even if it has no WiFi network configured.

### Sharing the Radio with Client WiFi

A WiFi adapter can either join a network as a client or act as an access point, but not both at once. To start the AP, the watchdog disconnects the wireless interface and starts the AP profile.

!!! note "Getting Off the AP"
    Saving a new WiFi network while connected to the AP doesn't take the node out of AP mode by itself. The radio is busy being the AP, so the node can't join the new network, and connectivity never comes back. After saving the new WiFi network, reboot the node. It then joins the new network, and the AP doesn't start. Plugging in Ethernet also restores connectivity, and the watchdog stops the AP on its next run.

### Addressing, DHCP, and DNS

The AP profile uses NetworkManager's `shared` IPv4 method. NetworkManager runs its own `dnsmasq` instance that hands out DHCP addresses to clients only while the AP is up, and stops it when the AP goes down.

| Setting | Value |
|---------|-------|
| AP (node) address | `192.168.187.65` |
| Subnet | `192.168.187.64/29` (6 usable addresses) |
| IPv6 | Disabled |

The subnet is a small, uncommon part of the RFC 1918 private address space, chosen so it's very unlikely to clash with a home or office network. Several other reserved ranges were tried first and didn't work with common clients. For example, iOS won't fully join a network that gives out addresses in the `169.254.0.0/16` link-local range.

IPv6 is turned off on the AP. An IPv6 setup with only unique local addresses (ULAs) makes Windows mark the network as "local only" and skip captive portal detection, which would undo the redirect described below.

The watchdog also writes `/etc/NetworkManager/dnsmasq-shared.d/asl-fallback-ap.conf`. This file tells the AP's `dnsmasq` to answer **every** DNS lookup with the node's AP address (`192.168.187.65`).

### Captive Portal Redirect

When a phone or laptop joins a WiFi network, it checks for internet access by fetching a known web page. On the fallback AP, the DNS setup above sends that request to the node instead. Because the answer isn't what the operating system expects, it treats the network as a captive portal, the same way it would at a hotel or coffee shop. Most devices then open a sign-in window by themselves.

The node's Apache web server is set up so that any request from the `192.168.187.64/29` subnet that doesn't match a real file is redirected to a static **AllStarLink 3 Setup** page (`fallback-ap.html`). That page has an **Open Web Admin Portal** button that links to Cockpit at `https://192.168.187.65:9090/`.

The landing page links to Cockpit instead of showing Cockpit in the sign-in window. Showing Cockpit through Apache's reverse proxy was tried, but Cockpit's login and session handling didn't work reliably that way.


### Firewall

The AP profile is assigned to the `allstarlink` firewalld zone. Without that, NetworkManager would put the shared connection in its own `nm-shared` zone, which allows only DHCP, DNS, and SSH, and blocks Cockpit and the web server. The watchdog sets the zone on the profile every time it runs, which also fixes AP profiles created by older versions.

The `allstarlink` zone has two extra rules for the AP. One accepts DHCP requests. The other accepts DNS requests, but only from the AP subnet `192.168.187.64/29`, so the node doesn't answer DNS queries from other networks.

## Connecting to the Fallback AP

1. Wait until the node has been powered on for at least two to three minutes without a network connection. The first check runs two minutes after boot.

2. On a phone or laptop, look for a WiFi network named `AllStarLink_` followed by the node's WiFi MAC address with the colons removed, for example `AllStarLink_DCA632A1B2C3`.

3. Connect using the default passphrase `AllStarLink`.

4. Your device should open the **AllStarLink 3 Setup** page by itself. If it doesn't, open a browser and go to `http://192.168.187.65/`.

5. Click **Open Web Admin Portal**, accept the certificate warning, and log in to Cockpit.

6. Configure the network. For WiFi, see [Changing WiFi Settings via Cockpit](../pi/cockpit-network.md#changing-wifi-settings-via-cockpit).

7. Reboot the node so it joins the new network (see the note in [Sharing the Radio with Client WiFi](#sharing-the-radio-with-client-wifi)).

!!! note "Shared Passphrase"
    Every appliance uses the same AP passphrase. Anyone in range of a node that is in fallback mode can join the AP and reach the Cockpit login page, but still needs a valid login to get any further. If that's a concern for a node deployed somewhere you don't control, disable the fallback AP (see below).

## Default Settings

| Setting | Value |
|---------|-------|
| SSID | `AllStarLink_` followed by the WiFi MAC address (colons removed, uppercase) |
| Passphrase | `AllStarLink` (WPA2-PSK) |
| Node address | `192.168.187.65` |
| Band and channel | 2.4GHz, channel 11 |
| NetworkManager profile | `asl-fallback-ap` |
