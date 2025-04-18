# Incompatibilities, Changes, and Known Issues

## Incompatibilities and Changes Fom Legacy Versions
With the upgrade to Asterisk 20, and all the associated code changes that had to go along with it, ASL3 has certain incompatible with older versions of the AllStarLink system. There are also some changes in how certain things function.

### VOTER/RTCM Default Port
Modern installations of Asterisk runs as the unprivileged `asterisk` user rather than as `root`. Linux typically prohibits non-root users from listening on a TCP
port below `1024`. The default port for VOTERs/RTCMs was preiously port `667`. This has been changed to port `1667` to allow Asterisk to access the port, and connect to VOTERs/RTCMs.

If the VOTER/RTCM port cannot be easily changed, then the following configuration change can be made to the underlying operating system:

```
echo net.ipv4.ip_unprivileged_port_start=667 > /etc/sysctl.d/aslport667.conf
sysctl -p
systemctl restart asterisk
```

If running the AllStarLink Pi Appliance (or another system with a firewall), inbound to port `667/UDP` must be permitted. For directions on how to do this with the Pi Appliance see [Managing the Firewall](../pi/cockpit-firewall.md). **Don't forget to also allow this port through any firewall that may part of your internet connection.**

**NOTE:** While this workaround is available, its use is strongly discouraged, as it defeats a security measure in Linux. If at all possible, please try and update any of your VOTERs/RTCMs to use port `1667`. 

### Pi Serial Port(s) Available by Default
On the ASL3 Pi Appliance, the system comes pre-configured for `/dev/serial0` (formerly `/dev/ttyAMA0`) accessibility.

That means that Bluetooth and the default serial console are disabled. Any directions requiring editing of `config.txt` or `cmdline.txt` are unnecessary with the ASL3 appliance.

### Pi `/dev` Entry Changes
As ASL3 is based on Debian 12, users with Raspberry Pi devices must note that the serial port on the Pi expansion header is now `/dev/serial0` rather than the historical `/dev/ttyAMA0`. If you are following directions for Pi serial port operations, such as programming an SA818/DRA818-based radio hat or a SHARI node, use `/dev/serial0` in place of the `/dev/ttyAMA0` reference.

### USB `udev`
A `udev` rule is needed to allow Asterisk running as non-root access to the USB system. ASL3 systems installed from `.debs` using `apt install`, or Raspberry Pi images will already have this rule in place, so no additional action is required. This is documented for advanced users and developers.

```
/etc/udev/rules.d/90-asl3.rules
SUBSYSTEM=="usb", ATTRS{idVendor}=="0d8c", GROUP="plugdev", TAG+="uaccess"
```

The `udev` subsystem must be reloaded and then the USB device re-inserted into the port. `udev` is reloaded with the command:

```
udevadm control --reload
```

Alternatively, reboot the system.

### SimpleUSB and USBRadio Config Files
The way USB audio interfaces are handled, including their config files has changed. See the [USB Audio Interfaces](./usbinterfaces.md) page in this section for detailed information.

## Known Issues
The following issues are currently known to exist in ASL3 and, where possible, what the workarounds are.

### DTMF Linking + DNS Lookup Timeouts
There are intermittent cases of linking problems in the following situation:

1. When a linking command (e.g. `*3`) is sent in DTMF; AND
2. Certain network configurations or situations do not resolve DNS "fast enough"

This issue is fully described in [app_rpt GitHub issue #392](https://github.com/AllStarLink/app_rpt/issues/392). In summary, if the DTMF entry, decoding, and DNS resolution for a link command collectively takes longer than 3 seconds, linking can fail in silent and indeterminate ways.

If this problem is occurring **consistently**, changing the node lookup method to `file` works around the issue until updated code to resolve this problem can be developed and tested:

1. Install the `asl3-update-nodelist` package (not needed for those running the ASL3 Pi Appliance):

    ```
    sudo apt install -y asl3-update-nodelist
    ```

2. Edit `/etc/asterisk/rpt.conf`. Somewhere at or around line 10 (depending on file customizations) you will need to change the `node_lookup_method` to `file`
instead of `both`. After your change the file should look like:

    ```
    [general]
    node_lookup_method = file       ;method used to lookup nodes
                                    ;both = dns lookup first, followed by external file (default)
                                    ;dns = dns lookup only
                                    ;file = external file lookup only

    ```

    This file can be updated using `asl-menu` "Expert Configuration Menu" / "Edit rpt.conf file" or your favorite editor.

3. Restart Asterisk using `asl-menu` `Node Settings` / `Restart Asterisk` or use `systemctl restart asterisk` from the CLI.

Once the fix is completed and made available, it will be announced on the [ASL Community](https://community.allstarlink.org) and you should change `node_lookup_method` to `both`. Eventually the `file` method will be retired.

### resize2fs_once "Error"
There are intermittent cases of errors on the screen or in  the system logs about a failure of a service named `resize2fs_once.service` after the final first boot upon installation. The error may report that it "Failed to start" or "timed out". If the `/` partition has been properly resized, which has been the case in every known 
occurrence of the error, then there is no action to take and the issue will not appear on subsequent reboots.

A properly resized `/` should be a bit smaller than the full size of the SD card or USB drive used with the device.

In Cockpit, look at the Storage tab:

![Known issue resize2fs](../user-guide/img/known_issue_resize2fs.png){width="600"}

In this example, `/` is a 31G partition on a 32G SD card.

### Shutdown/Restart Issues with EZStream/Broadcastify Enabled
With the configuration for [Broadcastify](../adv-topics/broadcastify.md) enabled, shutting down or restarting Asterisk is not quick or always reliable. When issuing `systemctl stop` or `systemctl restart` for the `asterisk.service` unit it will take upwards of 90 seconds to properly terminate and exit/respawn.

Make sure any `lame` and `ezstream` processed are killed and not orphaned.

```
# ps auxww | grep asterisk
asterisk 1443572  0.0  0.0   2416  1024 ?        S    10:13   0:00 /bin/sh -c /usr/bin/lame --preset cbr 16 -r -m m -s 8 --bitwidth 16 - - | /usr/bin/ezstream -qvc /etc/ezstream.xml
asterisk 1443573  0.1  0.1  11920  5120 ?        S    10:13   0:00 /usr/bin/lame --preset cbr 16 -r -m m -s 8 --bitwidth 16 - -
asterisk 1443574  0.0  0.2  55232 10240 ?        S    10:13   0:00 /usr/bin/ezstream -qvc /etc/ezstream.xml
```

If Asterisk is shutdown, the processes above must be stopped with a `kill -9 PID` command.
