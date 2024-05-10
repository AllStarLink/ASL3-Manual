# Incompatible Changes in ASL3
AllStarLink v3 has certain incompatible changes with older
versions of the AllStarLink system.

## Voter/RTCM Default Port
Modern installations of Asterisk runs as the unprivileged `asterisk` user rather than
as `root`. Standard Linux convention prohibits non-root users to listen on a TCP
port below 1024. The default port for Voters/RTCMs has been changed to `1667` when
previously it was `667`.

If the Voter/RTCM port cannot be easily changed, then the following
configuration can be made to the underlying operating system:

```bash
echo net.ipv4.ip_unprivileged_port_start=667 > /etc/sysctl.d/aslport667.conf
sysctl -p
systemctl restart asterisk
```

If running the AllStarLink Pi Appliance (or another system with a firewall),
inbound to port 667/UDP must be permitted. For directions on how to do this
with the Pi Appliance see [Managing the Firewall](../pi/cockpit-firewall.md).

## USB udev
A udev rule is needed to allow Asterisk running as non-root access to the USB system. ASL3 systems installed from debs, apt install or images will already have this rule in place.

```text
/etc/udev/rules.d/90-asl3.rules
SUBSYSTEM=="usb", ATTRS{idVendor}=="0d8c", GROUP="plugdev", TAG+="uaccess"
```

The UDev subsystem must be reloaded and then the USB device re-inserted
into the port. UDev is reloaded with the command

```
udevadm control --reload
```

Alternatively, reboot the system.


