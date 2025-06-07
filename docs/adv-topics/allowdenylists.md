# Allow and Deny Lists
ASL3 provides a way to establish either an "allowlist" or a "denylist" to limit access to your node(s). New to ASL3 is the capability for nodes on the same server to have different lists. Unlike ASL2, no modifications or scripts are required to the configuration files and there is no need to restart or reload the server. All changes are made to the Asterisk database. As soon as you make a change it takes effect.

The "allowlist" allows inbound connects and blocks all others. Nodes on the same server are always allowed. If any nodes are on the "allowlist" the "denylist" is ignored.

These lists can easily be updated using the [`asl-menu`](../user-guide/index.md). You can also choose to manage the lists using the Asterisk CLI. These lists were previously referred to as "whitelist" and "blacklist".

## Updating the access list with the ASL3 Menu
All changes to the node access lists can be made with the [`asl-menu`](../user-guide/index.md).  From [`asl-menu`](../user-guide/index.md), select `Node Settings`, select `AllStar Node Setup Menu`, select `Update node [your-node]`, and lastly select `Node access list`. Here, you will see if any node access limits have been established. You will also have the option to add, update, or remove nodes from the access lists.

## Updating the access list with the Asterisk CLI
While not recommended, you can also use the Asterisk CLI to manipulate the node access lists.

One important item to note is how the "allowlist" and "denylist" databases are used. Each database entry has a `<family>`, `<key>`, and `<value>`.  For ASL3, the `<family>` would be `allowlist/[your-node]` or `denylist/[your-node]`, the `<key>` is the node to be allowed or denied access, and we do not use the `<value>`.

### Adding nodes to the "allowlist"
The "allowlist" allows inbound connects and blocks all others. Nodes on the same server are always allowed. If any nodes are on the "allowlist" then the "denylist" is ignored.

* Add an allowed node at the Asterisk CLI `> database put allowlist/[your-node] [allow-node] "Our friend"`
* Add another allowed node with CLI `> database put allowlist/[your-node] [another-node] "Another friend"`

### Adding nodes to the "denylist"
The "denylist" prevents nodes from connecting to your node. A "denylist" works best if you only have a few nodes you want to block.

* Add a node to deny at the Asterisk CLI `> database put denylist/[your-node] [deny-node] "Not our friend"`
* Add another node to deny with CLI `> database put denylist/[your-node] [another-node] "Not our other friend"`

### View the access lists
To see what nodes are in the access lists:

* Show entire database at the Asterisk CLI `> database show`
* Show the "allowlist" for all your nodes with CLI `> database show allowlist`
* Show the "allowlist" for one node with CLI `> database show allowlist/[your-node]`
* Show whether one of your nodes will allow another with CLI `> database show allowlist/[your-node] [other-node]`

### Removing nodes from the access lists
To remove a node from the access lists, or delete the lists entirely:

* Remove an allowed node at the Asterisk CLI `> database del allowlist/[your-node] [node]`
* Remove the "allowlist" for your node with CLI `> database del allowlist/[your-node]`
* Remove the "allowlist" for all of your nodes with CLI `> database del allowlist`
