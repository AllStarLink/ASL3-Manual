# IAX Direct Authentication
IAX Direct Authentication is the most flexible and reliable way to connect to an ASL node without using the full ASL Registration infrastructure. This document is to aid in node operators creating IAX direct connections.

## Configuring IAX
!!! warning
    If upgrading from an ASL1, ASL2, HamVOIP, or DIAL legacy configuration you cannot simply copy/paste the old configuration into ASL3.

The default `/etc/asterisk/iax.conf` installed with your ASL3 installation should contain the following context *template*:

```ini
; The (!) for the [iaxrpt](!) section indicates this is a template. As such, we can store the
; actual users to authenticate in a separate file, to keep from cluttering up iax.conf.
; The actual file used to store the users is included with the #tryinclude directive below.
[iaxrpt](!)                      ; Connect from iaxrpt Username field (PC AllStar Client (iaxRpt))
type = user                      ; Notice type is user here <---------------
context = iaxrpt                 ; Context to jump to in extensions.conf
auth = md5
host = dynamic
disallow = all
;allow = slin16                   ; un-comment to allow high-fidelity codec (make sure to load module)
;allow = slin                     ; un-comment to allow high-fidelity codec (make sure to load module)
allow = ulaw
allow = adpcm
allow = gsm
transfer = no
requirecalltoken = no            ; Required for iaxRpt to connect, because it is SO old
; Source the users to authenticate from here:
#tryinclude custom/iax/iaxrpt-users.conf      ; PC clients to authenticate
```

!!! warning "Call Tokens"
    IAX2 now requires [IAX2 Call Tokens](https://docs.asterisk.org/Configuration/Channel-Drivers/Inter-Asterisk-eXchange-protocol-version-2-IAX2/IAX2-Security/), which some client software may not support, causing their calls to be rejected. You may need to add `requirecalltoken = no` to the affected context in `iax.conf` to resolve this.
    Most common client applications working with ASL do not support calltokens, unfortunately.

!!! warning "Codec Selection"
    Pay attention to the allowed codecs (defined by the `allow =` directives). Clients (IAXRpt in particular) may need to be configured to use a codec you support. If, for example, you delete `gsm` from your allowed codecs list (because it sounds like garbage), client connections may fail if they are trying to negotiate to use that codec.


Then, in `/etc/asterisk/custom/iax/iaxrpt-users.conf`, each user can be configured according to the following pattern:

```ini
[N0CALL]](iaxrpt)                   ; pull in the config from the [iaxrpt] section in
user = N0CALL                      ; iax.conf and then add this user's specific information
secret = Some_Secret_Password_Here ; (user, secret, and callerid). n0call is the USERNAME in
callerid = "N0CALL" <0>            ; the iaxRPT client account configuration.
```

Obviously, replace N0CALL with the appropriate callign and "Some_Secret_Password_Here" with a reasonably strong password.

!!! tip "Reload IAX for New Users"
    After adding a new user, execute `iax2 reload` from the Asterisk console to reload the configuration information.



## Configuring Extensions
!!! warning
    If upgrading from an ASL1, ASL2, HamVOIP, or DIAL legacy configuration you cannot simply copy/paste the old configuration into ASL3.

The default `/etc/asterisk/extensions.conf` installed with your ASL3 installation should contain the following context:

```ini
[iaxrpt]
; Entered from iaxrpt in iax.conf
; Info: The X option passed to the Rpt application
; disables the normal security checks.
; Because incoming connections are validated in iax.conf,
; and we don't know where the user will be coming from in advance,
; the X option is required.
exten => _XXXX!,1,Set(NODENUM=${CALLERID(num)})
	same => n,NoOp(Connect from node ${NODENUM} to node ${EXTEN} using ${CHANNEL(channeltype)})
	same => n,ExecIf($[!${RPT_NODE(${EXTEN},exists)}]?Hangup) ; disconnect if requested node is not on this server
	same => n,Rpt(${EXTEN},X)
	same => n,Hangup
```

!!! tip "Restart Asterisk"
    If you have to edit `extensions.conf` make sure you restart asterisk.