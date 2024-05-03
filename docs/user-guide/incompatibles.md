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
echo net.ipv4.ip_unprivileged_port_start=667 > /etc/sysctl.d/alsport667.conf
sysctl -p
systemctl restart asterisk
```