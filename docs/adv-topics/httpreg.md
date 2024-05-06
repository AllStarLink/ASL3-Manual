# HTTP Registration
AllStarLink registration is moving from IAX2 to HTTP registration.  IAX2 registration will remain in `chan_iax2` as part of Asterisk but may be removed from the AllStarLink servers at some far-off day. The module `res_rpt_http_registrations` handles HTTP registrations, `chan_iax2` still handles IAX2 registration. Please use and test either but do not configure both at the same time.

HTTP registration is configured by editing `/etc/asterisk/rpt_http_registrations.conf`.
```
[General]

[registrations]
;Change the register => line to match your assigned node number and password.
register => 1999:password@register.allstarlink.org    ; This must be changed to your node number, password
```