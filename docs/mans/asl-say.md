# asl-say

## NAME
`asl-say` - Cause Asterisk to speak

## SYNOPSIS
usage: `asl-say -n NODE -w ( time | time24 | ip4 | ip6 )`

## DESCRIPTION
`asl-say` will speak the one of the following things on the node specified with `-n` as directed by `-w`

Required arguments:

**-n NODE**: node number

**-w**: speak what from the list of options

**time**: the current time

**time24**: the current time in 24-hour format

**ip4**: the first IPv4 address of the system

**ip6**: the first global-scope IPv6 of the system

## EXAMPLE
`asl-say -n 1999 -w time` will speak the current time on node 1999.

## BUGS
Report bugs to https://github.com/AllStarLink/ASL3/issues

## COPYRIGHT
Copyright (C) 2025 Jason McCormick and AllStarLink under the terms of the AGPL v3.