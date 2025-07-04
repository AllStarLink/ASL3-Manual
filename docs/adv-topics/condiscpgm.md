# Connect and Disconnect Scripts
ASL3 supports a method to run a script or program when there is a node connecting or disconnecting.

This is handled by the [`connpgm` and `discpgm`](../config/rpt_conf.md#connpgm-and-discpgm) directives in [`rpt.conf`](../config/rpt_conf.md).

!!! warning "Every Connect/Disconnect"
    Think your project through as this will run on **every connect or disconnect**. There is no way to limit it. However, your script could have a provision to ignore certain nodes or certain times.

Each node requiring this can have its own in that node's stanza. See [Asterisk Templates](./conftmpl.md) for more information on how to apply this to individual node templates.

There is no requirement for using both `connpgm` and `discpgm`. Use the one you need, or both.

Shell scripts need to be owned by `asterisk` and have the execution bit set. See the [Permissions](./permissions.md) page for more information.

## `connpgm`
`connpgm` executes a program you specify on connect. It passes two command line arguments to your program:

* node number in this stanza (us) as `$1`

* node number being connected to us (them) as `$2`

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
`discpgm` executes a program you specify on disconnect. It passes two command line arguments to your program:

* node number in this stanza (us) as `$1`

* node number being connected to us (them) as `$2`

An example to log disconnects from the node (`dislog.sh`):

```
#!/bin/bash

echo $1 disconnected $2  on $(date +"%T") - $(date +"%m-%d-%Y")  >> /var/www/html/nodelogs/conlog.txt
```

Example configuration in `rpt.conf`:

```
discpgm = /etc/asterisk/custom/dislog.sh
```

