# AllStarLink Standard Commands
**This section contains the suggested prefix digits, mandatory command codes, and suggested command codes for AllstarLink.**

## Mandatory Command Codes
These are the mandatory command codes which all AllStarLink nodes must support to provide command code consistency to the users.

Command|Description
-------|-----------
`*1<node>`|Disconnect Link
`*2<node>`|Connect link in monitor mode
`*3<node>`|Connect link in transceive mode
`*4<node>`|Enter command mode on a remote node
`*70`|Local connection status
`*99`|DTMF Phone Key (Assert PTT from Phone Portal)

Notes:

* `<node>` is an AllStarLink node number
* Node number zero (`0`) is shorthand for the last node operated on by a previous command
* Monitor mode means listen to a node, but do not send any audio to it
* Command mode means send all received DTMF digits to the node number specified (bypassing the local command decoder). Send # to exit command mode, and restore local command decoding.

## Prefix Digit Suggestions
These are the suggested DTMF command prefixes (including the mandatory 1-4).

Prefix|Description
------|-----------
`*1`|Disconnect from link 
`*2`|Connect to node in monitor (receive only) mode 
`*3`|Connect to node in transceive mode
`*4`|Enter remote command mode
`*5`|User-defined macros
`*6`|User defined functions, such as autopatch
`*7`|Connection status / other functions
`*8`|User defined functions
`*9`|User defined functions
`*0`|User defined functions
`*A`|User defined functions
`*B`|User defined functions
`*C`|User defined functions
`*D`|User defined functions

## Optional Command Codes
These are suggested, but are typically configured by default on ASL3 nodes.

Command|Description
-------|-----------
`*80`|Force system ID
`*81`|Say system time
`*980`|Say app_rpt software version
`*75`|Link connect (local monitor only)
`*72`|Last active node (system-wide)
`*73`|System-wide connection status
`*71`|Disconnect all links (macro)
`*74`|Reconnect all links (macro)

## Complete List of AllStarLink Commands
The default AllStarLink DTMF commands are well commented in the configuration file [`/etc/asterisk/rpt.conf`](../config/rpt_conf.md). These may be changed if you or someone else edited the file, so take a look at the actual file on your node to be sure.

All of the possible [commands are documented](https://github.com/AllStarLink/app_rpt/blob/master/apps/app_rpt.c) at the top of the source. You don't need to be a C programmer to read the comments.
