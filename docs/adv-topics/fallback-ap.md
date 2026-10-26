# Fallback Access Point

The ASL3 appliance images (`asl3-appliance-pc`, `asl3-appliance-pi`, and `asl3-appliance-uno-q`) include a **fallback access point** (AP) system. If the node has a WiFi adapter but no usable network connection, the node turns its WiFi adapter into a temporary access point. You can join that network from a phone or laptop and reach the [Cockpit web console](../pi/cockpit-basics.md) to configure WiFi or other network settings. When the node gets its network connection back, it shuts the AP down and goes back to normal operation.

The main use is first-time setup when the credentials provided to the imager were incorrect or moving a node to a new location where its saved WiFi network isn't available. Without the fallback AP, a node with no Ethernet connection and no known WiFi network can't be reached at all.

The fallback AP is enabled by default on new or upgraded installs of
`asl3-appliance-pc`, `asl3-appliance-pi`, and `asl3-appliance-uno-q`
starting with version 2.2.2-1.

!!! note "Mobile Nodes"
    A node that is often away from its saved WiFi networks will bring the AP up
    whenever it has no connection. While the AP is up and nothing is connected to
    it, the node checks every 5 minutes for a saved WiFi network and rejoins it
    when one is in range. To keep the AP from coming up at all, disable it (see
    [Disabling, Enabling, and Troubleshooting](#disabling-enabling-and-troubleshooting)).

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
Once configured, disconnect your device from the AP, or reboot the node.

!!! note "Leaving the AP"
    The node can't join the new WiFi network while its radio is busy being the AP, and it won't take the AP down while a device is connected to it. Phones and laptops usually rejoin a network they remember, so forget the `AllStarLink_` network on your device. The node looks for its saved WiFi networks every 5 minutes, so within 5 minutes of your device leaving, it takes the AP down and tries them. If none of them is in range, the AP comes back after about 15 seconds; if one is in range but doesn't connect, after a minute. Rebooting the node joins the new network right away. Plugging in Ethernet also restores connectivity, and the watchdog stops the AP on its next run, within five minutes.

## Disabling, Enabling, and Troubleshooting

The fallback AP is controlled by the `fallback-ap.timer` systemd timer, which is enabled by default. It also starts and stops `fallback-ap-scan.timer`, which looks for saved WiFi networks while the AP is up, so there is only one timer to manage.

Check whether it is enabled:

```
systemctl is-enabled fallback-ap.timer
```

Package upgrades enable the timer again, so to turn the fallback AP off, mask the timer. If the AP is up at the time, also stop it and remove the profile:

```
sudo systemctl mask --now fallback-ap.timer
sudo nmcli connection down asl-fallback-ap
sudo nmcli connection delete asl-fallback-ap
```

Turn it back on:

```
sudo systemctl unmask fallback-ap.timer
sudo systemctl enable --now fallback-ap.timer
```

To see what the watchdog has been doing, check the service's log:

```
journalctl -u fallback-ap.service
```

Each run logs the connectivity state it found, and any action it took, such as creating the profile or starting or stopping the AP.

The search for saved WiFi networks while the AP is up has its own log:

```
journalctl -u fallback-ap-scan.service
```

To force a check right away instead of waiting for the timer:

```
sudo systemctl start fallback-ap.service
```

To force a search for saved WiFi networks right away (it only does something if the AP is up and nothing is connected to it):

```
sudo systemctl start fallback-ap-scan.service
```

## Theory of Operations for System Administrators

Most users will not care about this information, but it is provided for completeness.

### Watchdog and Timers

The fallback AP is a small watchdog script run by a systemd timer, `fallback-ap.timer`. The timer first runs the watchdog two minutes after boot, and then every five minutes after that, counted from the start of the previous run. If the timer is started later than two minutes after boot, for example when it's turned back on or the package is upgraded, it runs the watchdog right away. The watchdog doesn't stay running between checks; each run checks the network state, makes any needed change, and exits.

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

While the radio is the AP, the node can't see whether a saved WiFi network is back in range. A second timer, `fallback-ap-scan.timer`, handles this. It runs 5 minutes after boot and every 5 minutes after that, on its own schedule rather than from when a device leaves the AP. Like `fallback-ap.timer`, it runs right away if it's started later than that, for example when the fallback AP is turned back on. Each time, if the AP is up, no device is connected to it (checked with `iw dev <interface> station dump`), and at least one saved WiFi network is set to connect automatically, it:

1. Takes the AP down so NetworkManager can scan and connect to a saved network.
2. Waits up to 60 seconds for the interface to connect and for connectivity to come back. If after 15 seconds none of the saved networks shows up in the scan and the interface isn't connecting, it stops waiting. A saved hidden network never shows up by name, so if one is saved it always waits the full 60 seconds.
3. Brings the AP back up if no network connected.

So when no saved network is in range, the AP is gone for about 15 seconds every 5 minutes.

If a device is connected to the AP, or the node can't tell, the AP is left alone. While a search is running, the watchdog waits for it to finish, so it can't bring the AP back in the middle of one.

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

The AP profile is assigned to the `allstarlink` `firewalld` zone. Without that, NetworkManager would put the shared connection in its own `nm-shared` zone, which allows only DHCP, DNS, and SSH, and blocks Cockpit and the web server. The watchdog sets the zone on the profile every time it runs, which also fixes AP profiles created by older versions.

The `allstarlink` zone has two extra rules for the AP. One accepts DHCP requests. The other accepts DNS requests, but only from the AP subnet `192.168.187.64/29`, so the node doesn't answer DNS queries from other networks.

The package installs the zone in `/usr/lib/firewalld/zones/`. If the node has its own copy in `/etc/firewalld/zones/`, for example because a port was opened in Cockpit, firewalld uses that copy instead, and package upgrades add both AP rules to it.

## Connecting to the Fallback AP

1. Wait until the node has been powered on for at least two to three minutes without a network connection. The first check runs two minutes after boot.

2. On a phone or laptop, look for a WiFi network named `AllStarLink_` followed by the node's WiFi MAC address with the colons removed, for example `AllStarLink_DCA632A1B2C3`.

3. Connect using the default passphrase `AllStarLink`.

4. Your device should open the **AllStarLink 3 Setup** page by itself. If it doesn't, open a browser and go to `http://192.168.187.65/`.

5. Click **Open Web Admin Portal**, accept the certificate warning, and log in to Cockpit.

6. Configure the network. For WiFi, see [Changing WiFi Settings via Cockpit](../pi/cockpit-network.md#changing-wifi-settings-via-cockpit).

7. Disconnect your device from the AP and forget the `AllStarLink_` network, so the device doesn't rejoin it. Within 5 minutes the node takes the AP down and joins the new network, usually within a few seconds. To join it right away, reboot the node instead (see [Sharing the Radio with Client WiFi](#sharing-the-radio-with-client-wifi)).

!!! note "Shared Passphrase"
    Every appliance uses the same AP passphrase. Anyone in range of a node that is in fallback mode can join the AP and reach the Cockpit login page, but still needs a valid login to get any further. If that's a concern for a node deployed somewhere you don't control, disable the fallback AP (see [Disabling, Enabling, and Troubleshooting](#disabling-enabling-and-troubleshooting)).

## Default Settings

| Setting | Value |
|---------|-------|
| SSID | `AllStarLink_` followed by the WiFi MAC address (colons removed, uppercase) |
| Passphrase | `AllStarLink` (WPA2-PSK) |
| Node address | `192.168.187.65` |
| Band and channel | 2.4GHz, channel 11 |
| NetworkManager profile | `asl-fallback-ap` |
| Connectivity check | 2 minutes after boot, then every 5 minutes |
| Search for saved WiFi while the AP is idle | 5 minutes after boot, then every 5 minutes; waits up to 60 seconds, or 15 seconds when no saved network is in range |

The SSID prefix, passphrase, band, channel, and how long the search waits (`AP_SCAN_TIMEOUT`) are set in `/etc/default/fallback-ap`. The timer intervals are set in the `fallback-ap.timer` and `fallback-ap-scan.timer` units; change them with `sudo systemctl edit`.
