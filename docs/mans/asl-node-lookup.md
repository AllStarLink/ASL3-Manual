# asl-node-lookup

## NAME
`asl-node-lookup` - Display AllStarLink node information

## SYNOPSIS
usage: 

```
        /usr/bin/asl-node-lookup [--help] [--verbose] [--ns <name-server>] <node#>
```

Required arguments:

`<node#>`: ASL node number to query

Optional arguments:

`--help`: show help

`--verbose`: report additional information including the DNS "SOA" and "NS" records

`--ns <name-server>`: issue DNS queries to the specified name server

!!! note
    This command will also report `Asterisk/rpt` node lookup results if executed as `root` (or `asterisk`).
    
## DESCRIPTION
asl-node-lookup - Display AllStarLink node information

## BUGS
Report bugs to https://github.com/AllStarLink/ASL3/issues

## COPYRIGHT
Copyright (C) 2025 Allan Nathanson and AllStarLink under the terms of the AGPL v3.