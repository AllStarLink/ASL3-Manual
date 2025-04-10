# Structure of Config Files
Configuration files have a simple structure consisting of stanzas, `key=value` pairs and comments. A stanza is a block of text within a configuration file. It starts with a name (or number) surrounded by square brackets on a line by itself. Configuration files will have one or more stanzas. Each stanza continues until the next stanza or end of file. 

```
[this is a stanza]
...

[this is another stanza]
...
```

Stanzas contain one or more `key=value` pairs. `Key=value` pairs set various values within each stanza.

```
myname=timothy ; There are some who call me Tim?
```

Config file comments are preceded with a semicolon. In this example of two nodes the stanza is the node number and the `key=value` pairs set the CW ID and the ID timer:

```
[1998]
idrecording = |iW1ABC
idtime = 540000          ; 9 minutes

[1999]
idrecording = |iW1XYZ
idtime = 540000 
```

## Settings to name other Stanzas
Within the [`[node]`](../config/rpt_conf.md#node-number-stanza) stanza in `rpt.conf`, some `key=value` pairs point to other stanzas. This allows nodes on the same `Asterisk/app_rpt` server to have the same settings (without duplicate entries) or different settings in some cases. For example, the phone patch command may be \*6 on one node, yet \*61 on another.

For example:

```
[1000]
functions=functionsVHF

[1001]
functions=functionsVHF   ;same functions as node 1000

[1002]
functions=functionsUHF

[functionsVHF]
; Two meter Autopatch up is *6
6=autopatchup,noct=1,farenddisconnect=1,dialtime=20000 
0=autopatchdn       ; Autopatch down

[functionsUHF]
; 440 Autopatch up is *61
61=autopatchup,noct=1,farenddisconnect=1,dialtime=20000  ; Autopatch up
0=autopatchdn       ; Autopatch down
```

## Named Stanzas in rpt.conf
The `key=value` pairs that redirect to other named stanzas in `rpt.conf` are:

* controlstates=
* events=
* functions=
* link_functions=
* macro=
* morse=
* nodes=
* phone_functions=
* scheduler=
* telemetry=
* tonemacro=
* wait_times=

**Note:** A stanza is also called a context in Asterisk PBX terminology, particularly related to the dialplan.

