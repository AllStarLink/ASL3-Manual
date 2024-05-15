# Pi Appliance
AllStarLink 3 features a modern appliance of AllStarLink
while retaining the ubiquitous Raspberry Pi experience
that's well-documented and familiar to the amateur radio
community worldwide.

## Cockpit
The AllStarLink Pi Appliance includes the user-friendly
Cockpit system for ease of administration. Cockpit
is access on port 9090 of the appliance. For example, if
the appliance's hostname is `node460181` then pointing a
browser to `https://node460181.local:9090/` will bring up
the Cockpit interface. Note: The hostname only works
when your node and your PC are on the same LAN. Otherwise
use the IP or dns name you assign. Login is the username
and password that was setup during the Pi imgaging process.

Cockpit is fairly intuitive to use, but here's are a few
pointers to help get started:

* [Cockpit Basics](cockpit-basics.md)
* [Terminal / Console](cockpit-console.md)
* [Network Configuration](cockpit-network.md)
* [Services Management](cockpit-services.md)
* [Software Updates](cockpit-updates.md)