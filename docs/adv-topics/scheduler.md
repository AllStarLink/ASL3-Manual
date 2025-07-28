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

Note the following restrictions on defining the time:

* The five time fields **must** each be separated by a single space

* Minutes after the hour are `0-59`

* Hours since midnight are `0-23`

* Day of month are `1-31`

* Month of year is `1-12`

* Day of week (days since Sunday) is `0-6` (Sunday starts as `0`, ending with Saturday as `6`)

* Any item that is all inclusive or "doesn't matter/every" can be set with a star `*` as a wildcard

* There **must** be 5 time/day entries, `*` included

!!! warning "Not `cron` Format"
    While similar to time entries with `cron`, this is **not** `cron` formatting. Only the basic definitions shown above are valid (ie. single entries, no ranges).

Multiple scheduler entries are permitted, each on its own line.

Examples:

```
1 = 00 06 * * *                     ; run macro 1 at the 6th hour of any day

51 = 05 * * * *                     ; update wx forecast at 05min every hour every day

91 = 40 3 * * *                     ; /tmp cleanup script every 12hrs 3:40a

92 = 40 15 * * *                    ; /tmp cleanup script every 12hrs 15:40p

93 = 59 23 * * *                    ; archive logs daily at 59th min of only the 23rd hour every day

94 = 59 20 * * 5                    ; start net links at 8:59 on Friday

99 = 00 18 25 12 *                  ; merry xmas announcement 6pm Dec 25
```

## Scheduler Control
There are [`COP`](../config/rpt_conf.md#cop-commands) commands for turning the scheduler on and off that can be configured in [`rpt.conf`](../config/rpt_conf.md):

```
xxx = cop,15		                ; scheduler enable

xxx = cop,16		                ; scheduler disable
```

There is also a setting in [`controlstates`](../config/rpt_conf.md#control-states-stanza) if you want to set this in a personality profile.

```
skena 

skdis
```

Or via command line:

```
rpt fun skens

rpt fun skdis
```

## System Cron
As an alternative, you can also use the built-in `cron` utility to execute any system command or script on a schedule. You can put them in the `asterisk` cron schedule, which can be edited using `sudo crontab -u asterisk -e`. However, it is recommended to put your cron entries in `/etc/cron.d`, so that you don't have to remember which `crontab` you put your events into.

!!! warning "File Permissions"
    Be sure if you are using the system `cron`, that your scripts can be executed by the Asterisk user (and not only executable by `root`, or some other user). Quite often, failure to execute scripts is traced back to Asterisk not having the permission to execute. See the [Permissions](./permissions.md) page for more information.

Cron formatting and options are beyond the scope of this document, but there are lots of examples available on the internet.