# Macros

## What is a 'macro'?
The purpose of a macro is to store a sequence of DTMF command(s). Macros may be called by direct command, by the system scheduler, or even by an external script. They can be a series of commands to make short work of a larger task.

## Define Function
The first thing to configure when setting up macros is to define the [`[function]`](../config/rpt_conf.md#functions) that will call them.

This will define the DTMF prefix that will be used for calling macros.

Example:

```
[functions]
5 = macro
```

This will make `5` the prefix for calling a macro. Remember that the actual command needs to be prefixed with [`funcchar`](../config/rpt_conf.md#funcchar), which is typically `*`. So in this case, `*512` would call macro 12 (defined in the `[macro]` stanza). 

## Configuring Macro Stanzas
The next part of macro settings is the [`macro=`](../config/rpt_conf.md#macro) setting in [`rpt.conf`](../config/rpt_conf.md). The example here points to a stanza named `[macro]`. This is likely already in your config. If the `macro=` setting does not exist, the default is to use a stanza named `[macro]`.  

```
[1999]                              ; Assigned node number
rxchannel = SimpleUSB/1999	        ; Rx audio/signaling channel
duplex=2
linktolink=no
controlstates=controlstates         ; System control state list
scheduler=scheduler
events=events
morse=morse
macro=macro                         ; <===== note this in your rpt.conf, if it exists
tonemacro=tonemacro
functions=functions
phone_functions=phone_functions
link_functions=link_functions
wait_times=wait_times
telemetry=telemetry
```

If you have more than one node on a given server and you want all nodes to have the same macros, then the above `macro=macro` (or nothing defined) is fine. If you want to assign different macros to different nodes on the server, see the [Structure of Config Files](../config/config-structure.md#settings-to-name-other-stanzas) page which outlines how to redirect names to call other stanzas.

Then, later in `rpt.conf` you need an actual `[macro]` stanza:

```
[macro]
1=*81#                              ; Say time
2=*81 P *31999 P *934#              ; Say time, pause, connect node 1999, pause, and turn off telemetry for net
3=*31999 *934 *512#                 ; Here we connect node 1999, turn off telemetry, then call macro (12). 
12=*949#                            ; Disable incoming connections
```

## Macro Definitions
Finally, define each desired macro in the appropriate `[macro]` stanza.

Each macro command string is on the same line separated by a space, and ending the string with a `#` (hashtag). 

A `P` can be used to cause a pause of 500mS, or a series of them for more. This would allow time for a script or connection to execute before the next command is issued. The system reads/executes them left to right when called. You should test them after creating them to be sure timing has no interference before you actually need to use them. 

Looking at the above example, you can see how multiple DTMF commands can be chained together into a single macro, so that you wouldn't have to execute the commands individually.

And note that use of our macro 2 (executed as `*52`) might also require us to create a new one to 'undo' any of our changes. Which, in this case, might be manually called at the end of the net.

Example:

```
4=*11999 P *933#                    ; End of net macro, unlink from node 1999 and turn telemetry back on
```

# Scheduler Execution
With the example configuration shown, macros are called with a `*5` prefix and followed with the number assigned in the [macro] stanza.

You can also call them from the system schedular by number. Calling a macro number is the only method the scheduler supports. So if you wish to schedule with the system scheduler, you need a macro to execute it.