# Pi Appliance
AllStarLink 3 features a modern appliance of AllStarLink
while retaining the ubiquitous Raspberry Pi experience
that's well-documented and familiar to the amateur radio
community worldwide.

## Cockpit Web Admin Interface
The AllStarLink Pi Appliance includes the user-friendly
Cockpit system for ease of administration. Cockpit
is access on port 9090 of the appliance. In these examples
the hostname `node63001` is used and should be replaced
with the name you set during setup. If the name
`node63001` was used at setup, then pointing a
browser to `https://node63001.local:9090/` will bring up
the Cockpit interface. Note: The hostname only works
when your node and your PC are on the same LAN. Otherwise
use the IP or dns name you assign. Login is the username
and password that was setup during the Pi imaging process.

The first connection will report a message that
"Your connection isn't private". For the Pi appliance, this is
acceptable. Click on **Advanced** and then
**Continue to node63001.local (unsafe)**. This only must be done
the first time.
![Browser Warning](../user-guide/img/step-20.png)

Enter the username and password configured during the imaging process
above. Click **Log in**
![Cockpit Login](/user-guide/img/step-22.png)


Cockpit is fairly intuitive to use, but here's are a few
pointers to help get started:

* [Cockpit Basics](cockpit-basics.md)
* [Terminal / Console](cockpit-console.md)
* [Network Configuration](cockpit-network.md)
* [Services Management](cockpit-services.md)
* [Software Updates](cockpit-updates.md)