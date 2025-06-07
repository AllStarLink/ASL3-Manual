# HTTP-Based Registration
AllStarLink is moving from IAX2 to HTTP registration. ASL3 has a new module for HTTP registration, which is used by default.

The associated config file is `/etc/asterisk/rpt_http_registrations.conf`. The setting values are the same as they were in IAX2 registration.

When you configure your node with [`asl-menu`](../user-guide/index.md), no action is required. The `asl-menu` utility will populate the config file accordingly to enable HTTP registration.

The contents of the `rpt_http_registrations.conf` file would typically look something like:

```
[General]

[registrations]
;Change the register => line to match your assigned node number and password.
register => 1999:password@register.allstarlink.org    ; This must be changed to your node number, password
```

While [IAX registration](./iaxreg.md) still works, please *do not* register with both HTTP and IAX. That would result in unnecessary server load for no gain. 

The long term plan is to do away with IAX registration. HTTP registration allows load balancing and other advantages not available with IAX. The ASL2 IAX module has been replaced with the Asterisk LTS IAX2 module for upstream compatibility.

If you feel you absolutely need to use IAX registration, see the [IAX-Based Registration](./iaxreg.md) page in this section for more information.
