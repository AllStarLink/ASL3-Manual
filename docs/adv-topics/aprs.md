# APRS
app_rpt can post position reports to the APRS :tm: network.
APRS is an acronym for Automatic Packet Reporting System. APRS is the
registered trademark of Bob Bruning, WB4APR (SK).
app_gps supports standard position reports and APRStt (touchtone).

For fixed position nodes, like repeaters, reporting your node's position allows visiting operators to easily
see the nodes/repeaters in the area. Some radios allow operators to
use the position reports to automatically tune their radios
to the node's frequency.

You can see a map of APRS unit locations at https://aprs.to or
https://aprs.fi.

An external GPS device can be configured to receive GPS position
information. This is needed for mobile nodes to post their
live position. Fixed stations do not require a GPS device.
app_gps can be configured with a default latitude, longitude,
and elevation.

app_gps posts position report to the global APRS-IS servers.  An
Internet connection is required.

### Configuration
#### Enable app_gps
To enable app_gps, edit `/etc/asterisk/modules.conf` and change
`noload => app_gps.so` to `load => app_gps.so`

#### Edit gps.conf
!!! note "Asterisk Templates"
The `gps.conf` file now uses Asterisk templates.  See [Templates](conftmpl.md.md)
for more information.

Edit `/etc/asterisk/gps.conf` with your favorite editor.  The 
configuration file is filled with comments to assist you with
the configuration.

If you will be using a GPS device, set the `comport` and `baudrate` for
your connected device.  If you don't have a GPS device, `comport`
should not have a value.

Update `call` with the node's callsign and SSID.  For example:
`WB6NIL-1`. Additional information on the callsign/SSID format 
can be found at https://www.aprs-is.net/Connecting.aspx

Update `password` with your APRS-IS password. This password is 
a computed number based on the callsign. 
You can generate the password on-line at https://n5dux.com/ham/aprs-passcode

*Note: This password must be correct for app_gps to log into
the APRS-IS server.*

The `gps.conf` contains a number of settings that configure
how your node is displayed on APRS maps. The comments in the
configuration file will help you configure your node.

The `comment`field can be used to describe your node and/or 
provide information about your local radio club. See the 
configuration file for more information.

You can configure the map symbol used for your node by changing
the `icontable` and `icon` values. To display an "R" inside a diamond, set
`icontable = R` and `icon = &`. See http://www.aprs.org/symbols.html
for more information.

*Note:  app_gps supports multiple nodes.  To add additional nodes,
add another section to the configuration file.  For example \[1998\](general).*

#### Restart Asterisk
After making these initial changes to `modules.conf` and `gps.conf`, restart
Asterisk at the command line type:

`systemctl restart asterisk`

Changes made to `gps.conf` in the future do not require restarting Asterisk.
After making changes to the configuration file, you can enter these
commands in the Asterisk CLI. 

```
module unload app_gps  
module load app_gps 
```

#### Monitoring the GPS device
You can get the status of the connected GPS device by typing the following
command in the Asterisk CLI.

`gps show status`

This command will tell you if the GPS device is locked on the
satellite signal and the current position.  If you are not using a 
GPS device, it will show the default latitude, longitude, and elevation.

## APRStt (touchtone)

APRStt allows operators with analog radios to report to the APRS
system.  Specially crafted DTMF sequences can be sent to app_rpt
to generate APRS position reports.

To enable this feature, edit `/etc/asterisk/rpt.conf` and
add or enable `aprstt = general` for your node.  The value after
'aprstt' is the section in `gps.conf` to use for APRStt.  This value
can be different for each node.  *It does require a matching
section in `gps.conf`.*

Callsigns received by APRStt are reported as objects to APRS using the 
`'-12'` SSID.

To send WB4APR using APRStt, you would send the DTMF sequence,
`A9A2B42A7A7C91#`.  app_rpt will translate the DTMF sequence and
send it to app_gps for processing.

For more information on the APRStt DTMF format and how to construct
DTMF sequences, see http://www.aprs.org/aprstt/aprstt-user.txt

*Note: Some radios natively support APRStt.*

*Note: At the time of this writing, app_rpt only supports
the APRStt A format.*



