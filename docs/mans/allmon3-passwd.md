# allmon3-passwd

## NAME

`allmon3-passwd` - Manage the `Allmon3` password file

# SYNOPSIS

usage: 

```
        /usr/bin/allmon3-passwd [-h|--help] [--delete] [--debug] [--file FILE] [--password PASSWORD] [--version] <user>
```

Positional arguments:

`<user>`: username to create/modify

Optional arguments:

`-h`, `--help`: show help message and exit

`--delete`: delete the user specified by `<user>`

`--debug`: enable debug-level logging output

`--file FILE`: alternate file to edit; default `/etc/allmon3/users`

`--password PASSWORD`: provide password on CLI rather than gather interactively

`--version`: print the the version of the software

# DESCRIPTION

Allmon3's user database is managed by `allmon3-passwd`. Adding a new user or editing an existing user is the same command. If the user does not exist, it will be added. If the user does exist, the password will be updated.

To add or edit a user's password:

```
allmon3-passwd allmon3
 Enter the password for allmon3: password
 Confirm the password for allmon3: password
```

To specify the password for a user directly from the command line:

```
allmon3-passwd --password foobar allmon3
```

This will set the password for the `allmon3` user to `foobar` directly.


!!! note "Default Password"
    During previous installations, an `allmon3` user may have been created with a default password. If that user still exists on your node, and the password was not changed, that user will be modified and a **random** password will be generated for the `allmon3` user when you upgrade the Allmon3 package. That random password can be found in `/etc/allmon3/random-password.txt`. You will likely want to change it using the [`allmon3-passwd`](../mans/allmon3-passwd.md) utility, or delete the `allmon3` user entirely, and provision your own.

The `/etc/allmon3/users` file is readable to see that the Argon2 hash has changed for the user.

To delete a user, add the `--delete` flag to the command:

```
allmon3-passwd --delete allmon3
```

# BUGS

Report bugs to https://github.com/AllStarLink/Allmon3/issues

# COPYRIGHT

Copyright (C) 2025 Jason McCormick and AllStarLink under the terms of the AGPL v3.