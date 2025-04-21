# allmon3-passwd

## NAME

`allmon3-passwd` - Manage the `Allmon3` password file

# SYNOPSIS

usage: `allmon3-passwd [-h|--help] [--delete] [--debug] [--file FILE] [--version] <user>`

Positional arguments:

**&lt;user>**: username to create/modify

Optional arguments:

**\-h, \-\-help**: show help message and exit

**\-\-delete**: delete the user specified by `<user>`

**\-\-debug**: enable debug-level logging output

**\-\-file FILE**: alternate file to edit; default `/etc/allmon3/users`

**\-\-version**: print the the version of the software

# DESCRIPTION

Allmon3's user database is managed by `allmon3-passwd`. Adding a new user or editing an existing user is the same command. If the user does not exist, it will be added. If the user does exist, the password will be updated.

To add or edit a user's password:

```
allmon3-passwd allmon3
 Enter the password for allmon3: password
 Confirm the password for allmon3: password
```

The `/etc/allmon3/users` file is readable to see that the Argon2 hash has changed for the user.

To delete a user, add the `--delete` flag to the command:

```
allmon3-passwd --delete allmon3
```

# BUGS

Report bugs to https://github.com/AllStarLink/Allmon3/issues

# COPYRIGHT

Copyright (C) 2025 Jason McCormick and AllStarLink under the terms of the AGPL v3.