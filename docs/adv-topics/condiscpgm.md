# Connect and Disconnect Scripts
ASL3 supports a method to run a script or program when there is a node connecting or disconnecting.

This is handled by the [`connpgm` and `discpgm`](../config/rpt_conf.md#connpgm-and-discpgm) directives in [`rpt.conf`](../config/rpt_conf.md).

!!! warning "Every Connect/Disconnect"
    Think your project through as this will run on **every connect or disconnect**. There is no way to limit it. However, your script could have a provision to ignore certain nodes or certain times.

Each node requiring this can have its own in that node's stanza. See [Asterisk Templates](./conftmpl.md) for more information on how to apply this to individual node templates.

There is no requirement for using both `connpgm` and `discpgm`. Use the one you need, or both.

Shell scripts need to be readable and executable by `asterisk`. See the [Permissions](./permissions.md) page for more information.

## `connpgm`
`connpgm` executes a program or script you specify on connect. 

An example to log connections to the node (`conlog.sh`):

```
#!/bin/bash

echo $1 connected $2  on $(date +"%T") - $(date +"%m-%d-%Y")  >> /var/www/html/nodelogs/conlog.txt
```

Example configuration in `rpt.conf`:

```
connpgm = /etc/asterisk/custom/conlog.sh
```

## `discpgm`
`discpgm` executes a program or script you specify on disconnect.

An example to log disconnects from the node (`dislog.sh`):

```
#!/bin/bash

echo $1 disconnected $2  on $(date +"%T") - $(date +"%m-%d-%Y")  >> /var/www/html/nodelogs/conlog.txt
```

Example configuration in `rpt.conf`:

```
discpgm = /etc/asterisk/custom/dislog.sh
```

## Execution and Passing Variables
Asterisk uses `bash -c <connpgm-string> <us> <them> &` when it runs `connpgm` and `discpgm`. Using the `-c` option means that commands are read from the string (script) specified. If there are arguments after the string (script), they are assigned to the positional parameters, starting with `$0` (search the Internet for "Bash positional arguments").

As noted above, `app_rpt` adds two additional variables to the end of the command string being executed, `<node number in this stanza>` (us) and `<node number being connected to us>` (them). You don't NEED to use these variables, but they are provided for your use if your script wants to do something with them. 

This also means you can pass variables/arguments to your script(s), if desired. 

Sample:

```
connpgm=/etc/asterisk/custom/myscript abc 1234
```

The above example would then execute `bash -c /etc/asterisk/custom/myscript abc 1234 <us> <them>` when a node connects. 

