# Allmon3 User Management
Allmon3 supports a robust multi-user configuration that  permits per-node granular access as desired and that abstracts Allmon3 from the Asterisk AMI Manager configuration.

Usernames and passwords are stored in `/etc/allmon3/users`.

The default-configured username and password combination is`allmon3 / password`.

<span style="color:red; size=1.2em">**You *must* change this before exposing a host to the Internet**</span>


## User Database
Allmon3's user database is managed by `allmon3-passwd`. Adding a new user or editing an existing user is the same command. If the user does not exist, it will be added. If the user does exist, the password will be updated. 

To add or edit a user's password: 

```
$ allmon3-passwd allmon3
Enter the password for allmon3: password
Confirm the password for allmon3: password
```

That's all there is to it. The `/etc/allmon3/users` file is readable to see that the Argon2 hash changed for the user.

Deleting a user is simply adding the `--delete` flag to the command:

```
$ allmon3-passwd --delete allmon3
```

After changing a user's password, the Allmon3 daemon must be reloaded with `systemctl reload allmon3`.

## Per-Node Restrictions for Users
Allmon3 implements a lightweight access control system to restrict commands from certain users to certain nodes. Restrictions are configured in `/etc/allmon3/user-restrictions`. Given that the average use case is all users have similar access, the access control is implemented in a named-restrictions model for least configuration complexity.

The logic is as follows when checking the restricted access list:

1. If the user is not listed in `user-restrictions` at all, then the user is permitted commands on all configured nodes.

2. If the user is listed in `user-restrictions`, and is listed as restricted to the node being commanded, the user is permitted to issue the command.

3. If the user is listed in `user-restrictions`, but the node is not listed for that user, the user is prohibited from issuing the command.

The format of the `user-restrictions` file is:

```
user1 | NODE[,NODE,NODE...]
user2 | NODE

```

Lines beginning with # are comments.
