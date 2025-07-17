# Event Management Subsystem
The Event Management Subsystem is a method by which a user can specify actions to be taken when certain events occur, such as transitions in receive and transmit keying, presence and modes of links, and external inputs, such as GPIO pins on the URI (or similar USB devices) or the parallel port.

This also includes the ability to **set** the condition of external devices, such as output pins on a URI (or similar USB devices), or a parallel port. See the [Manipulating GPIO](./gpio.md) page for more information on how to configure GPIO.

The actions to be taken and the methods and steps required for doing so are specified in the [`rpt.conf`](../config/rpt_conf.md) file under the `[events]` stanza (or other named sections, defined with the [`events=`](../config/rpt_conf.md#events) option).

## Event Variables
This subsystem utilizes Asterisk channel variables (or global variables if you dare) to indicate the state of various signals and modes and are named as follows:

Variable Name|Decription
-------------|----------
RPT_RXKEYED|Set to `1` when the node's main (RF) receiver is receiving a valid signal
RPT_TXKEYED|Set to `1` when the node's main (RF) transmitter is transmitting
RPT_NUMLINKS|Count of links currently connected to the node
RPT_LINKS|List of Node numbers currently linked to this node and their mode and receive keying status, as follows: `<NUMLINKS>,<MODE><NODEMUM>[,<MODE><NODEMUM>...]`. For example: `2,T2000,R2001` would indicate that there are two nodes linked currently, the first one is node `2000` in **T**ransceive mode, and the second one is node `2001` in **R**eceive-only (monitor) mode.
RPT_NUMALINKS|Count of ***adjacent*** links currently connected to the node
RPT_ALINKS|List of node numbers currently linked ***adjacent*** to this node, their mode, and receive keying status as follows: `<NUMALINKS>,<NODEMUM><MODE><RXKEYED>[,<NODEMUM><MODE><RXKEYED>...]`. For example: `2,2000TU,2001RK` would indicate that there are two *adjacent* nodes linked currently, the first one is node `2000` in **T**ransceive mode, and is not presently sending a keying signal (**U**) towards this node; the second one is node `2001` in **R**eceive-Only (monitor) mode, and is presently sending a keying signal (**K**) towards this node.
 
!!! note "Adjacent Nodes"
    Adjacent nodes are ones that are ***directly connected*** to this node. This differs from the `RPT_LINKS` in that the `RPT_LINKS` is a list of **all** nodes, whether connected directly, or connected through a node that is connected directly. The keying information is not given with the `RPT_LINKS` because in that context, it is meaningless.

There may also be other variables included from external devices/sources, such as the URI (or similar USB devices), or a parallel port that will appear if so configured (within the configuration for that particular device), such as:

Variable Name|Decription
-------------|----------
RPT_URI_GPIO1|This would be the GPIO 1 pin, if configured as an input.
RPT_URI_GPIO4|This would be the GPIO 4 pin, if configured as an input.
RPT_PP12|This would be the parallel port, pin 12 (input)
 
These are set to `0` or `1` (the state of the input pin). 

## `[events]` Stanza
Each line of the `[events]` stanza is specified as follows:

```
<action-spec> = <action>|<type>|<var-spec>
```

`actions`:

* If the `action` is `v` (for "setting variable"), then the `action-spec` is the variable being set.

* If the `action` is `g` (for "setting global variable"), then the `action-spec` is the global variable being set.

* If the `action` is `f` (for "function"), then the `action-spec` is a DTMF function to be executed (if the result is `1`).

* If the `action` is `c` (for "rpt command"), then the `action-spec` is a raw `rpt command` to be executed (if the result is `1`).

* If the `action` is `s` (for "shell command"), then the `action-spec` is a shell command to be executed (if the result is `1`).
 
`types`:

* If `type` is `e` (for "evaluate statement" (or perhaps "equals")), the `var-spec` is a full statement containing expressions, variables and operators per the expression evaluation built into Asterisk.

* If `type` is `t` (for "going True"), the `var-spec` is a single (already-defined) variable name, and the result will be `1` if the variable has just gone from `0` to `1`.

* If `type` is `f` (for "going False"), the `var-spec` is a single (already-defined) variable name, and the result will be `1` if the varible has just gone from `1` to `0`.

* If `type` is `n` (for "no change"), the `var-spec` is a single (already-defined) variable name, and the result will be `1` if the variable has not changed.


Examples:

Set the channel variable `MYVAR` **true** if main receiver has valid signal and transmitter is not transmitting. Presumably, this variable will be used in a later statement for something.

```
MYVAR = v|e|${RPT_RXKEYED} & !${RPT_TXKEYED}
```

Have the system give the time of day after all links are disconnected. This performs the specified `rpt command` when the `RPT_NUMLINKS` variable goes from `true` to `false`, and therefore happens when all links are disconnected (if and only if some were connected previously).

```
status,2 = c|f|RPT_NUMLINKS
```

!!! note "Boolean Evaluation"
    Although `RPT_NUMLINKS` **is** an integer count of links, it can also be treated as a boolean, since non-zero values evaluate to the same as `1`. 
        
Execute the DTMF command `*1234` (whatever the heck that is) when node `2000` connects to this node.

```
TEMPVAR = v|e|${RPT_LINKS} =~ "\",2000.\""
*1234 = f|t|TEMPVAR
```

!!! note
    We are interested in executing the function ONLY when the node connects. Therefore, you must define a variable the meets the condition you are looking for in general (in this case, node 2000 being connected), **then** you have to execute the desired function when that variable goes from `1` to `0` (changes to `false`).
 
Any time you are using regex to look for a node number int the `RPT_LINKS` variable, you must put a comma in front of the qualifying string to make sure that it does not match some other node number that has the desired information (in this case, the digits `2000`) within a longer node number.

Get a detailed directory listing of the `/tmp` directory, and put its output into the file `/tmp/example.txt` every time node `2001` is connected to, and stops indicating keying towards our node (not that anyone would ever really want to do that... it's just an example).

```
TEMPVAR = v|e|${RPT_ALINKS} =~ "\",2001[TRC]K\"" 
ls -l /tmp > /tmp/example.txt = s|f|TEMPVAR
```

## CLI Commands
If you wish to set channel variable(s) for a node from the Asterisk CLI, use the following command:

```
*CLI> rpt set variable <nodenum> <name=value> [<name=value>...]
```

For example, this would set the `MYVAR` variable to `1` for node `2000`:

```
*CLI> rpt setvar 2000 MYVAR=1
```

If you wish to display all the variables for a node, use the following command:

```
*CLI> rpt show variables <nodenum>
```

Also, a channel variable for a node may be set from the Asterisk dialplan as follows:

```
rpt(<nodenum>,V,<name=value>)
```

For example, for extension `1234` priority `5`, set variable `MYVAR` to `0` for node `2000`:

```
exten => 1234,5,rpt(2000,V,MYVAR=0)
```

Granted, there may very well be some things (such as interesting information that can be expressed within this subsystem) that has been overlooked, and any suggestions and/or comments regarding this whole thing would be much appreciated.

This also opens a completely new avenue of customization and individual creativity for each system implementer. There are many innovative things that can be done with this. Also, there are many just plain silly ones, such as connecting your doorbell to one the input pins on the URI, and having the system connect to your favorite Echolink node or something when someone rings the doorbell.
