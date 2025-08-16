# asl-backup-menu

## NAME
`asl-backup-menu` - Backup AllStarLink node configuration

## SYNOPSIS
Usage: 
```
        /usr/bin/asl-backup-menu --help
        /usr/bin/asl-backup-menu [ --debug ] [ --sub-menu ]
        /usr/bin/asl-backup-menu [ --debug ] ( backup | backup-local )
        /usr/bin/asl-backup-menu [ --debug ] ( restore-local | restore-asl | restore-factory )
        /usr/bin/asl-backup-menu [ --debug ] remove
```

Required arguments:

None.

Optional arguments:

`--help`: show usage

`--debug`: log actions to `/tmp/asl-backup-menu.log`

`--sub-menu`: run as a "sub menu", normally invoked by `asl-menu`

`backup`: create a local backup to `/var/asl-backups` and prompt to backup to `backup.allstarlink.org` (via menu)

`backup-local`: create an immediate local backup to `/var/asl-backups` (no menu)

`restore-local`:

`restore-asl`:

`restore-factory`: restore all config files in `/etc/asterisk` to defaults
   
## DESCRIPTION
asl-backup-menu - Backup AllStarLink node configuration

The `asl-backup-menu` utility is normally invoked via [`asl-menu`](../user-guide/menu.md). However, it can be invoked from the Linux CLI with `sudo asl-backup-menu` by itself, or with any of the supported command line options.

The "Create" option will create a backup archive of your configuration. The archive will be stored locally in the `/var/asl-backups` directory in `.tgz` format. After the backup is created you will have the option to upload to archive to an AllStarLink backup server. The `/var/asl-backups` directory will be created automatically, if it doesn't already exist.

!!! warning "Maximum Archive Size"
    The maximum backup archive size permitted to be uploaded to `backup.allstarlink.org` is 2Mb. 

The "Restore" options will allow you to restore an AllStarLink configuration from a previously saved backup. The backup archive will be from either local storage or from the AllStarLink backup server. You also have the option to restore the ASL3 "default" configuration.

!!! note "Restore Factory"
    The `restore-factory` option (and it's related menu item) will re-install the `asl3-asterisk-config` package, overwriting all the `.conf` files in `/etc/asterisk` with their default versions. `asl-backup-menu` will *try* and keep the `secret` in `/etc/asterisk/manager.conf` when it re-installs the config files. **Asterisk must be restarted after this process to re-initialize with the new defaults.**

The "Delete" option will allow you to remove any of your locally stored backups.

The "Edit" option will allow you to view and/or update the file (and directory) path names that will be included in a backup archive. This information is stored in `/var/asl-backups/asl-backup-files`. The default `asl-backup-files` will be created the first time `asl-backup-menu` is run.

## BUGS
Report bugs to https://github.com/AllStarLink/asl3-menu/issues

## COPYRIGHT
Copyright (C) 2025 Allan Nathanson and AllStarLink under the terms of the AGPL v3.