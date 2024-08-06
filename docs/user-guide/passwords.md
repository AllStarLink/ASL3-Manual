# Logins and Passwords

Yes, there are many "different" logins and passwords associated with AllStarLink, the ASL3 software, and the related applications.  A typical ASL3 server / node will directly or indirectly use the following login/password pairs :

- AllStarLink login (for "node" information)
- Linux login
- AMI user/secret
- Web application (Allmon3) login

## AllStarLink website ([www.allstarlink.org](https://www.allstarlink.org))

Th AllStarLink website is where you register for an AllStarLink account, add ASL servers, and request ASL nodes.

- Your AllStarLink account with have a "login" and "password"

- Using the AllStarLink website's "Portal" menu you can:

	- Add/configure "servers" (computers) that will be running the ASL software.  Each "server" specifies the IAX port used to communicate with your node.  Most nodes will use the default port (4569).  The most common reason to specify an alternate port would be configuring multiple servers that would be running behind a NAT router (e.g. when the servers would be sharing the same public IP).

	- Add/configure "nodes" that will be running on a server.  Each ASL "node" will have an associated password.  You will use the node number and password pair when configuring your ASL node.

- Some desktop and mobile applications use "Web Transceiver" to connect to AllStarLink nodes.  Many of these applications use your AllStarLink website login and password for authentication.

## Linux

Your desktop, laptop, Raspberry Pi, or Virtual Machine will be running the Linux operating system (e.g. Debian).  To access the operating system on your OS you will need a login "user" and "password".

You will use the Linux "user" and "password" when logging in to your system :

- with the systems display / keyboard
- over the network using SSH
- over the network using the Cockpit web page

You may have heard about the Linux "root" account.  The root account is also called the super-user; it is a login that bypasses all security protection on your system.  The root account should only be used to perform system administration, and only used for as short a time as possible.  With ASL3, we are trying to limit our usage of the "root" account.

<!---
How do I setup a Linux login?

- For those using the Raspberry Pi Imager you will use the "OS Customisation" to setup a new login account.  Here, you will specify your login "user" and "password" (or provide an SSH public key for password-less access)

- For those installing the Debian OS using the install .iso you should be prompted to setup an initial account.  This is where you will specify your login "user" and "password".

- Some VM's will have you use a pre-configured image with a default "user" and "password".  Check the documentation associated with the image for details.
--->

Note: there is NO DEFAULT USER included in the ASL3 Raspberry Pi Appliance image.

## Asterisk Manager Interface (AMI)

Your AllStarLink server system runs as process named "asterisk" that is the heart of your node(s).  The Asterisk Manager Interface, AMI, is the standard management interface into your Asterisk server.

The AMI configuration, stored in "/etc/asterisk/manager.conf", includes "user" categories and associated "secret" passwords.  For example :

```
[admin]
secret = my-AMI-password
...
```

This "user" (admin) and "secret" (my-AMI-password) would need to be specified in the configuration file for any applications that use AMI to interact with Asterisk.

## Web Applications (e.g. Allmon3)

Many will install one (or more) web applications that monitor/control their ASL nodes.  These applications can provide access to many users on the web and those users may have no relation to those who setup/administer/use your systems.  As such, these applications typically maintain their own list of users and associated passwords.

Please refer to the web application manual for information on how to manage who is allowed access to the web pages.

Also, as mentioned above, many of these applications use AMI to interact with your Asterisk and your nodes.  The web application manual should have information on where to specify the AMI credentials.
