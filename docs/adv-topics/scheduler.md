# Scheduled Events
Not to be confused with `cron`, the `Asterisk/app_rpt` scheduler is owned and controlled by `app_rpt`.

To schedule anything, you should first declare what it is you want to do by making a [macro](./macros.md) for it in [`rpt.conf`](../config/rpt_conf.md).

!!! note "Not Applicable to Remote Base Nodes"
    If a node is defined as a ["remote base"](./remotebase.md), the scheduler is not available.

The `Asterisk/app_rpt` scheduler can *only* trigger macros. So, you first must create or pick a macro to run.

!!! warning "Cannot Execute Macro 0"
    Macro `0` is a reserved system macro (for the [`startupmacro`](../config/rpt_conf.md#startup_macro)). The Scheduler will not execute macro `0`.

When the time/date statement is true, the selected macro will be run once only, until true again.

You should create comments on each line to remember what it is for, in case you need to make adjustments later.

## Setting Up the System Scheduler
Scheduler events are put in the [`[schedule]`](../config/rpt_conf.md#schedule-stanza) stanza in [`rpt.conf`](../config/rpt_conf.md). If there is no defined `[schedule]` stanza, the scheduler does nothing.

Scheduler events are in the following format:

```
(macro number to run when true) = (MM) (HH) (DayOfMonth) (MonthOfYear) (DayOfWeek)
```

!!! warning "Not `cron` Format"
    While similar to time entries with `cron`, this is **not** `cron` formatting. Only the basic definitions shown below are valid (ie. single entries, no ranges).

Time entries are defined according to the following restrictions:

* There **must** be 5 time/day entries, `*` included

* The five time fields **must** each be separated by a single space

* Minutes after the hour are `0-59`

* Hours since midnight are `0-23`

* Day of month are `1-31`

* Month of year is `1-12`

* Day of week (days since Sunday) is `0-6` (Sunday starts as `0`, ending with Saturday as `6`)

* Any item that is all inclusive or "doesn't matter/every" can be set with a star `*` as a wildcard


Multiple scheduler entries are permitted, each on its own line.

Examples:

```
1 = 0 6 * * *                       ; run macro 1 at the 6th hour of any day
51 = 5 * * * *                      ; update wx forecast at 5 minutes past every hour every day
91 = 40 3 * * *                     ; /tmp cleanup script every day 3:40am
91 = 40 15 * * *                    ; same cleanup script every day 3:40pm
93 = 59 23 * * *                    ; archive logs daily at 59th min of only the 23rd hour every day
94 = 59 20 * * 5                    ; start net links at 8:59 on Friday
99 = 0 18 25 12 *                   ; merry xmas announcement 6pm Dec 25
```

## Scheduler Control
There are [`COP`](../config/rpt_conf.md#cop-commands) commands for turning the scheduler on and off that can be configured in [`rpt.conf`](../config/rpt_conf.md) and used in a macro:

```
xxx = cop,15		                ; scheduler enable
xxx = cop,16		                ; scheduler disable
```

There are also `skena` and `skdis` [`controlstates`](../config/rpt_conf.md#control-states-stanza) mnemonics available for use in defining node control states.

## System Cron
As an alternative, you can also use the built-in `cron` utility to execute any system command or script on a schedule. 

There are a number of different ways to use the built-in `cron`. Some of the options include:

Method|Description|Advantages|Disadvantages
------|-----------|----------|-------------
`sudo crontab -e`|Use `root`'s crontab|Can run any script|Can cause permission issues if commands in the script need to be further executed by Asterisk. Less safe from a security perspective, as it can easily cause unintended access to system files and commands
`sudo crontab -u asterisk -e`|Use `asterisk`'s crontab|Safer than using `root`'s crontab, as permissions are restricted to the `asterisk` user|Need to remember to edit (`-u asterisk`) the correct crontab file
`/etc/cron.d`|System `cron` folder|Can split out cron entries for a given function vs. having many unrelated jobs all clumped together, give them descriptive names, and using the "user" field run them as any user (e.g. `asterisk` or `root`)|As when using `root`'s crontab, pay attention to the user associated with each cron entry and the associated permissions and privileges.

!!! warning "File Permissions"
    Be sure if you are using the system `cron`, that your scripts can be executed by the user that `cron` is running the entry as. Quite often, failure to execute scripts is traced back to the calling user not having the permission to execute. See the [Permissions](./permissions.md) page for more information.

Any of the above options for using the system `cron` are acceptable. You should decide what works best for you, and stick with that method. It can be difficult to troubleshoot if you end up putting cron entries in different places.

Cron formatting and options are beyond the scope of this document, but there are lots of examples available on the internet, or review the system manual pages (`man cron`, `man crontab`, `man 5 crontab`).