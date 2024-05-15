# Known Issues

## HTTP Registration

The new `rpt show registrations` command will show the status as registered if the password is wrong.

Workarounds are:

- Use the [AllStar Nodelist](https://allstarlink.org/nodelist) to validate registration.
- Or *CLI>`core set debug 10 res_rpt_http_registrations` to show registration status.
- Do *CLI>`core set debug 0 res_rpt_http_registrations` to disable debug.
