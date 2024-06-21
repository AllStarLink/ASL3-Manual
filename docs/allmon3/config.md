# Configuration
All configuration resides in `/etc/allmon3`. The stock configuration
files are always available at `/usr/share/doc/allmon3/` for recovery
and documentation.

After changing any configuration file, the service `allmon3` must be
restarted using `systemctl restart allmon3`.

## Node Configuration
Allmon3's node connections are configured in `/etc/allmon3/allmon3.ini`. The
`allmon3.ini` file is a standard INI-formatted file. Each stanza in 
the file is a node number. Each node stanza then can take the following
options:

| Option | Req'd / Opt | Default | Description |
|--------|------------|---------|-------------|
| **host** | Req'd | - | DNS name or IP address of the Asterisk/ASL node |
| **port** | Opt | 5038 | Port of the Asterisk manager |
| **user** | Req'd | - | username of the Asterisk monitor, most commonly 'admin' |
| **pass** | Req'd | - | password of the monitor user |
| **multinodes** | Opt | - | this node is a server hosting multiple nodes and this is the "primary" record for the host. |
| **voters** | n[,n,...] | = | List voters on this server, comma separate. No value disabled voters|
| **pollinterval** | Opt | 1 | polling interval to asterisk in default is 1. this value can be expressed as a decimal fraction of a second - e.g., .5 is 500ms, .375 is 375ms, etc. |
| **vpollinterval** | Opt | 1 | Broadcast interval of voter data in seconds default is 1. this value can be expressed as a decimal fraction of a second - e.g., .5 is 500ms, .375 is 375ms, etc. |
| **retryinterval** | Opt | 15 | Seconds between retries if initial connection to asterisk is lost (optional, default 15)
| **retrycount** | Opt | "Infinite" | number of times to retry a lost asterisk connection before ending (default infinite)

An example minimal node configuration would be:
```
[12345]
host = 127.0.0.1
user = admin
pass = Passw0rd
```

An example of a server with multiple nodes on it:
```
[12345]
host = 127.0.0.1
user = admin
pass = Passw0rd
multinodes = 12345, 23456
```

Here's an example for monitoring three ASL Nodes:
```
[50815]
host=172.17.16.36
user=admin
pass=password

[460180]
host=172.17.16.217
user=admin
pass=password

[48496]
host=192.2.0.145
user=admin
pass=password
voter=y
votertitle=Megavoter
```

## Server Customization
Allmon3 has multiple configuration files to consider:

* `/etc/allmon3/web.ini` - This is the customization interface
for the Allmon3 web interface. I

* `/etc/allmon3/custom.css` - Certain CSS customizations to change
colors in the application. Follows standard CSS rules and syntax.

* `/etc/allmon3/menu.ini` - Allows for the customization of the
Allmon3 web menu. By default, the menu is a list of all nodes
found in `allmon3.ini`. Customized menus can be configured
as described in `menu.ini.example`.

### web.ini
The `web.ini` file has four configuration sections - 
*web*, *syscmds*, *node-overrides*, and *voter-titles*. 

#### [web]
The *web* section has the basic customizations
for the Allmon3 site. Each item in this section
is documented in the file.  

#### [syscmds]
The *syscmds* section defines the templates in the "system commands" menu.
This stanza lists commands that are templates for the systems command
modal dialog. The format is:

```
[syscmds]
  command text = Command Label
  command text = Command Label
  command text = Command Label
  ...
```
In any command text the @ will be replaced with the node the command
modal was selected from. For example:
```
    rpt status @ = Show Node Status
```
wll result in the command 'rpt status 1999' assuming this command was
selected from Node #1999.

It is possible to create optional stanzas named in the format
`[syscmds-NODE]` (e.g. `[syscmds-1999]`) and have those commands
templates appear only for the given NODE listed. Example:

```
[syscmds-1999]
rpt cmd @ cop 999 xxx = Execute function 999
```


#### [node-overrides]
The *node-overrides* section can be used to override information
from the ASL database. Using this section, the AllStarLink DB
labels for a node may be replaces with custom text. The format is:

```
[node-overrides]
    NODE1 = TEXT HERE
    NODE2 = TEXT HERE 2
```
This section must exist even if it's empty. For example:

```
[node-overrides]
    1999 = My special private node
    2010 = Wild Party Node
```

#### [voter-titles]
The *voter-titles* section is used to set display names for voters.
This functions identically to `[node-overrides]`. For any
voter not named here, voters will have an auto-generated
name of "Voter NODE".

### menu.ini
If this file is present in the api/ subdirectory of Allmon3's web interface
and named `menu.ini`, this file will override the default behavior of the
web interface simply listing the configured nodes in the left navbar.
If this file is not present, all nodes in allmon3.ini/allmon3.ini.php
will display singly in configured order.

NOTE: Not listing a node in the menu WILL NOT cause the node to go
un-polled if it is already configured in allmon3.ini. This allows
the system administrator to have "hidden" nodes. If you want to completely
stop polling an Asterisk/ASL node, the node must be removed from allmon3.ini.

The format for this file is as follows:

```
[ TITLE ]                         :: The stanza header is the label
                                  :: for this menu item
type  = ( menu | single )         :: If type = menu, the item is interpreted as a dropdown
                                  :: menu with each LABEL item displaying. If the
                                  :: type = single, then only a the first LABEL = TARGET
                                  :: will be displayed as a non-dropdown. In the case of
                                  :: type = single, the [ TITLE ] is ignored completely

LABEL = TARGET                    :: Each [ TITLE ] displays one or more LABELS
LABEL = TARGET                    :: with a link to TARGET. When TARGET is all numbers
LABEL = TARGET                    :: then TARGET is assumed to be a ASL node and
                                  :: the link will filter down to the TARGET node
                                  :: specified. Any other pattern will be interpreted
                                  :: as a full or partial URL/URI.
                                  ::
                                  :: Of special node, creating a menu item of
                                  :: multiple nodes to display, TARGET and simply be
                                  :: #NODE,NODE,NODE - e.g. #1999,1998,1997
```
Note that the order of the nodes within a stanza is irrelevant. They will be displayed
as sorted alphabetically ascending according to UTF-8 (e.g. 0-9, A-Z, +).

An example custom menu may look like:
```
[ W8WKY ]
type = menu
W8WKY = 43211
48496 = 48496
45839 = 45839

[ N8XPK ]
type = menu
N8XPK = 42993
43118 = 43118
47987 = 47987

[ Test ]
type = single
AllStarLink = https://www.allstarlink.org
```

## Using Nginx instead of Apache
Nginx can be used instead of Apache. Instead of using the `apache2`
package, install `nginx` using the above directions. After configuring
nginx, edit `/etc/nginx/sites-available/default` (or your preferred site
configuration) and add an `include` directive within the appropriate
`server { }` configuration block. For example:

```
server {
    listen 80 default_server;

    [... other stuff ...]

    include /etc/allmon3/nginx.conf;

    [... other stuff ...]
}
```

