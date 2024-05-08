# Allow and Deny Lists

These changes can easily be made from the ASL3 menu. Here's change and view the lists at the Asterisk CLI should you choose to do so. These lists were previously referred to as whitelist and blacklist.

ASL3 provides a way to establish either an "allowlist" or a "denylist" to limit access to your node(s).  New to ASL3 is the capability for nodes on the same server to have different lists.  Unlike ASL2, no modifications or scripts are required to the configuration files and there is no need to restart or reload the server.  All changes are made to the Asterisk database.  As soon as you make a change it takes effect.

 The "allowlist" allows inbound connects and blocks all others. Nodes on the same server are always allowed. If any nodes are on the "allowlist" the "denylist" is ignored.

 - Add an allowed node at the Asterisk CLI> `database put allowlist/yournode/allownode "Our friend"`
 - Add another node to the "allowlist" with `database put allowlist/yournode/anothernode "Our other friend"`

 The "denylist" prevents nodes from connecting to your node. Add a "denylist" if you only have a few nodes you want to block.

 - Add a denied node at the Asterisk CLI> `database put denylist/yournode/denynode "Not our friend"`
 - Add a another denied node at the Asterisk CLI> `database put denylist/yournode/anothernode "Not our other friend"`

 To see what's in the database.

   - Show entire db CLI> `database show`
   - Show entire "allowlist" for all your nodes CLI> `database show allowlist`
   - Show entire "allowlist" for all your one node CLI> `database show allowlist/yournode`
   - Show just the one your one allowed one node CLI> `database show allowlist/yournode/othernode`

 To delete an entire "allowlist"

   - At the asterisk CLI> `database del allowlist`
   - To delete all allowed nodes CLI> `database del allowlist/yournode`
