# Telemetry Messages
Telemetry is a data message that is sent between nodes when connecting to or disconnecting from another node. Telemetry is *silently* sent to all other connected nodes through digital (out-of-band, non-audio) data over the VoIP connection. It is purely up to each local system to decide what to do with this information. It can announce it, ignore it or even change the message. The node owner/admin determines what is appropriate for their individual node. 

There are configuration and mode options allowing all telemetry (both local and obtained from other nodes) to be:

* Always announced
* Never announced
* Announced only when a function is locally executed and for short time thereafter

There are five telemetry channels which can be managed:

* Local Node - This node
* Foreign Node - A connected node 
* Phone - [Autopatch](./autopatch.md), [Phone Portal](../user-guide/phoneportal.md)
* Echolink - Echolink connections
* GUI - IAXRpt, SIP phone display, VoIP clients

## Telemetry Options
The telemetry options are set in [`rpt.conf`](../config/rpt_conf.md).

The relevant options are:

* [`telemdefault=`](../config/rpt_conf.md#telemdefault) 	
* [`telemdynamic=`](../config/rpt_conf.md#telemdynamic)
* [`eannmode=`](../config/rpt_conf.md#eannmode)
* [`echolinkdefault=`](../config/rpt_conf.md#echolinkdefault)
* [`echolinkdynamic=`](../config/rpt_conf.md#echolinkdynamic)
* [`phonelinkdefault=`](../config/rpt_conf.md#phonelinkdefault)
* [`phonelinkdynamic=`](../config/rpt_conf.md#phonelinkdynamic)
* [`guilinkdefault=`](../config/rpt_conf.md#guilinkdefault)
* [`guilinkdynamic=`](../config/rpt_conf.md#guilinkdynamic)

## Associated COP Commands
### Local Telemetry COP Commands
The [`cop`](../config/rpt_conf.md#cop-commands) that affect local telemetry are:

* `cop,33` 	Local Telemetry Output Enable
* `cop,34` 	Local Telemetry Output Disable
* `cop,35` 	Local Telemetry Output Timed

The `cop` commands override any of the `telemdefault`, `echolinkdefault`, `phonelinkdefault`, and `guilinkdefault` settings (all together), if any of their associated "dynamic" options are set to `1`.

For example, if you have `telemdynamic=0`, then issuing one of the `cop` commands will **not** change the setting of `telemdefault` from what it is currently set to.

### Foreign Telemetry COP Commands
Foreign telemetry is what is announced on the *local* node when a *remote* node connects. The [`cop`](../config/rpt_conf.md#cop-commands) that affect foreign telemetry are:

* `cop,36` 	Foreign Link Local Output Path Enable
* `cop,37` 	Foreign Link Local Output Path Disable
* `cop,38` 	Foreign Link Local Output Path Follows Local Telemetry Selection
* `cop,39` 	Foreign Link Local Output Path Timed

There are no `rpt.conf` settings that control foreign telemetry, it has to be controlled via `cop` command.

### EchoLink Announcement COP Commands
The following [`cop`](../config/rpt_conf.md#cop-commands) commands allow you to override the [`eannmode`](../config/rpt_conf.md#eannmode) option:

* `cop,42`  Announce node number only (`eannmode=1`)
* `cop,43`  Announce callsign only (`eannmode=2`)
* `cop,44`  Announce node number and callsign (`eannmode=3`)