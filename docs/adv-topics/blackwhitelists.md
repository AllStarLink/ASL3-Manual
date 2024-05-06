# Blacklist and Whitelist

ASL3 does not require updates to extensions.conf or iax.conf to implement a blacklist or whitelist. Only database changes are needed to modify the list. Nodes on the same server have different lists. Sample new database commands:

Whitelist node 12345 on 1998
`database put whitelist/1998 12345 "some value or comment must be here”`

Whitelist node 88888 on 1998
`database put whitelist/1998 88888 "some value must be here"`

Blacklist node 99999 on node 1998
`database put blacklist/1998 99999 "if whitelist exists blacklist will be ignored.”`

Show all database commands `database <tab><tab>` ‘ press tab twice’

database deltree removes one or more entries. Remove all whitelist entries `database deltree whitelist`

Remove node 1998 whitelist `database deltree whitelist/1998`
