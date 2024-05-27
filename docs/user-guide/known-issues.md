# Known Issues
The following issues are currently known to exist in AllStarLink 3 and,
where possible, what work-arounds are.

## HTTP Registration

The new `rpt show registrations` command will show the status as registered if the password is wrong.

Workarounds are:

- Use the [AllStar Nodelist](https://allstarlink.org/nodelist) to validate registration.

Or a techie way:

- Insure `/etc/asterisk/logger.conf` has debug enabled: `console => notice,warning,error,dtmf,debug`
- At the *CLI>`core set debug 10 res_rpt_http_registrations` to show registration status.
- and *CLI>`module refresh res_rpt_http_registrations.so`
- To disable debug do *CLI>`core set debug 0 res_rpt_http_registrations` to disable debug.

https://github.com/AllStarLink/app_rpt/issues/325

## Pi Hat-based Radio Modules
For the ASL3 pi appliance image, the current image (v3.0.6) does not make
`/dev/serial0` (formerly `/dev/ttyAMA0`) available as a UART port
for programming a hat-connected radio board. This is a common need for
hat-based modules based on the SA818/DRA818 chip such as the W6IPA
PIRIM and other similar board.

1. Run `sudo raspi-config` from the Web Console Terminal

2. Select **3 Interface Options***

3. Select **I5 Serial Port**

4. When asked "Would you like a login shell..." choose **NO**

5. When asked "Would you like the serial port hardware to be enabled?" choose **YES**

6. Select **OK**

7. Reboot when prompted - you MUST reboot for this configuration change
to become operable.

Note: With Debian 12, the onboard UART is no longer `/dev/ttyAMA0`
but is now `/dev/serial0`. Much older Pi documentation will still
(incorrectly) refer to `/dev/ttyAMA0` for the UART TTL port on the
Pi header.

## Simple Tune Menu
Simple-tune-menu item `B) Toggle RX Boost` updates the display
but `W) Write (Save) Current Parameter Values` is not saving to
the config file. Obvious workaround is to use the asl-menu,
`5 Expert Configuration Menu`,  `9  Edit simplusb.conf file`,
and set `rxboost = true`.

https://github.com/AllStarLink/app_rpt/issues/331