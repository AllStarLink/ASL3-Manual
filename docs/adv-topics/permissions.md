# Permissions

## "asterisk" vs "root"

One of the new features with ASL3 is that the Asterisk process now runs as the "asterisk" user (not as the super-user; "root").
While sometimes handy this was potentially very dangerous.
This change was made for increased security.
It's a good thing!

We acknowledge that there are some applications, commands, and scripts that you may want to bring over from older (and other) versions of ASL and that these may be impacted by ASL3's heightened security.
Porting these over to ASL3 may require some simple changes to filesystem permissions.
Other issues may need other solutions (e.g. you can't execute a command that requires "root" privileges when you are not the "root" user).
For guidance, reach out to the [AllStarLink Community](https://community.allstarlink.org/).

In short, in ASL3 the Asterisk process now runs as the "asterisk" user.
If you modify the "/etc/asterisk/rpt.conf" file to execute a command (or script) it will NOT have super-user ("root") privileges.
The command itself and any file it references must be readable by the "asterisk" user.
Any files that the command needs to modify must be writable by the "asterisk" user.
Lastly, the parent directory of any file being created must also be writable.

## Filesystem Permissions

The following is a very brief overview of Linux filesystem permissions.
More in-depth information is available on the internet (search for “linux file permissions”).

On a Linux system, each file (and directory) has permissions that effect access by the “owner”, permissions that effect access to those logins in the same “group”, and permissions that effect access to “other” logins.
The permissions determine whether you (or some other process) can read, write, or execute the files (or search in directories).
There are commands to change the ownership (“chown”) and permissions (“chmod”) for each file/directory.

### File permissions

You can use the `ls -l [FILE]` command to view file permissions.
The permissions determine whether the calling process can read ("r"), write ("w"), or execute ("x") the file.
Here are some examples :

```
node63001:~/examples $ ls -l *file*
-rw------- 1 root root     0 Aug  5 08:28 1-file-owner-root-can-read-write
-rw-r----- 1 root asterisk 0 Aug  5 08:28 2-file-add-group-asterisk-can-read
-rw-r--r-- 1 root asterisk 0 Aug  5 08:27 3-file-add-everyone-can-read

node63001:~/examples $ ls -l *script*
-rwx------ 1 root root     0 Aug  5 08:28 1-script-owner-root-can-read-write-execute
-rwxr-x--- 1 root asterisk 0 Aug  5 08:28 2-script-add-group-asterisk-can-read-execute
-rwxr-xr-x 1 root asterisk 0 Aug  5 08:27 3-script-add-everyone-can-read-execute
```

In each case, the file permissions progress from the most restrictive (only the file owner can read/execute) to most available (all users can read/execute).

### Directory permissions

You can use the `ls -ld <directory>` command to view the permissions on a directory (vs. the contents of a directory).
The permissions determine whether the calling process can read ("r"), write ("w"), or search ("x") the directory.
Here are some examples :

```
node63001:~/examples $ ls -ld *dir*
drwx------ 2 root root     4096 Aug  5 09:56 1-dir-owner-root-can-read-write-search
drwxr-x--- 2 root asterisk 4096 Aug  5 09:56 2-dir-add-group-asterisk-can-read-search
drwxr-xr-x 2 root asterisk 4096 Aug  5 09:56 3-dir-add-everyone-can-read-search
```

In each case, the directory permissions progress from the most restrictive (only the directory owner can read/write/search) to most available (all users can read/search).

### Changing permissions

The following commands can be used to change the permissions of files and directories :

| Command | Description | Sample Usage |
|---------|-------------|--------------|
| chown | change file owner and group | # chown root /var/asl-backups/asl-backup-files |
| chgrp | change group ownership | # chgrp asterisk /var/spool/asterisk/monitor |
| chmod | change file mode bits | # chmod 640 /etc/asterisk/manager.conf |

Any process with "write" permission to a file can update (including completely overwrite) the file.
A process with "write" permission to a directory can add/remove/rename files in that directory.
If a command/script is writable then it can be changed to "do something different" when it is next executed.
When updating filesystem permissions, please remember that doing so can potentially expose the contents of files (and directories) to others.
Be cautious!