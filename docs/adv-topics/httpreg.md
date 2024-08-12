# HTTP Registration

AllStarLink is moving from IAX2 to HTTP registration. ASL3 has a new module for http registration. ASL3 menu users need not be concerned about this change. The asl3-menu sets this for you.

The conf new file is `/etc/asterisk/rpt_http_registrations.conf`. The setting values are the same as they were in IAX2 registration.

```text
[General]

[registrations]
;Change the register => line to match your assigned node number and password.
register => 1999:password@register.allstarlink.org    ; This must be changed to your node number, password
```

While IAX registration still works, please do not register with both HTTP and IAX. That would result in unnecessary server load for no gain. The long term plan is to do away with IAX registration. HTTP registration also allows load balancing and other advantages not available with IAX. The ASL3 IAX module has been replaced with the Asterisk LTS IAX2 module for upstream compatibility.
