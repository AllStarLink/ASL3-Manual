# echolink.conf
echolink.conf (`/etc/asterisk/echolink.conf`) is where the the EchoLink channel driver, `chan_echolink`, is primarily configured. There are also some associated options in [`rpt.conf`](./rpt_conf.md) that configure how EchoLink interacts with the AllStarLink node, see the [EchoLink Configuration](../adv-topics/echolink.md) page for more information.

## `[el0]` Stanza
The `[el0]` stanza is where most of the settings of the EchoLink channel driver take place. Some of the setting are optional, but a number of them are required/mandatory for the channel driver to function properly.

### astnode=
This setting is your AllStarLink node number. This is a **required** setting, and determines which node on the local server EchoLink calls will be connected to.

Sample:

```
astnode = 1999						; AllStarLink node number. Change this!
```

### call=
This setting is your callsign that you have registered with EchoLink that is associated to your EchoLink node number. This is a **required** setting. Maximum 12 characters.

Sample:

```
call = WB6NIL						; Callsign registered with EchoLink. Change this!
```

!!! note "From the EchoLink User Guide"
    Set the callsign exactly as you wish to be registered with EchoLink. If you have already registered, use the same callsign you used previously. The callsign must be at least 3 characters long and may not contain spaces or punctuation, except as part of an -L or -R suffix. If you are planning to run in Sysop mode, put an -R or -L at the end of your call to indicate a "repeater" or "link", respectively (for example, K1RFD-L). Use -L to denote a simplex link, or -R if the link is tuned to the frequency pair of a local repeater. 
    If you are expecting to run in User mode, do not use a suffix after your callsign.

### context=
This setting is the context in [`extensions.conf`](./extensions_conf.md#radio-secure-stanza) where EchoLink calls will be processed. Unless you have a specific reason to change it, leave it a the default `radio-secure`.

Sample:

```
context = radio-secure				; Context in extensions.conf to process EchoLink calls. Default is radio-secure
```

### deny=
This setting is a comma-delimited list of callsigns to deny connecting to your EchoLink node. EchoLink connections may be denied on a per-callsign basis. This is done by using the `deny` and `permit` options. The default is to allow all connections if the `permit` and `deny` keywords are **not** present (or commented out). If `deny` is specified, then the callsign(s) specified will be denied access and the connection will be terminated. Wildcards are supported so that whole classes of connections can be rejected.

Sample:

```
;deny = W1AW                       ; when un-commented, the station W1AW will be prevented from connecting
```

```
;deny = W1AW-*                     ; when un-commented, W1AW-L and W1AW-R would be prevented from connecting                        ;
```

Alternatively, you can use the built-in ASL3 [`Allow and Deny Lists`](../adv-topics/allowdenylists.md) to manage access, as all calls processed by `[radio-secure]` are checked against the allow and deny database.

### dir=
This option is used to show your antenna direction on the [EchoLink Status Page](https://echolink.org/links.jsp). This setting is optional.

Sample:

```
dir = 0								; 0=omni 1=45deg 2=90deg 3=135deg 4=180deg 5=225deg 6=270deg 7=315deg 8=360deg (Direction)
```

### email=
This setting is your email address that you have registered with EchoLink that is associated to your EchoLink node number. This is a **required** setting. Maximum 32 characters.

Sample:

```
email = wb6nil@allstarlink.org      ; registered email address
```

!!! note "From the EchoLink User Guide"
    Please enter your e-mail address. This address is used only for initial registration, and will not be published or displayed anywhere. After registration, please use the EchoLink Web site to inform us of any change in your e-mail address.

### freq=
This option is used to show your attached simples/repeater frequency (in MHz) on the [EchoLink Status Page](https://echolink.org/links.jsp). This setting is optional.

Sample:

```
freq = 0.0                          ; not mandatory Frequency in MHz
```

### gain=
This option is used to show your antenna gain on the [EchoLink Status Page](https://echolink.org/links.jsp). This setting is optional.

Sample:

```
gain = 0							; Gain in db (0-9)
```

### height=
This option is used to show your antenna height on the [EchoLink Status Page](https://echolink.org/links.jsp). This setting is optional.

Sample:

```
height = 0							; 0=10 1=20 2=40 3=80 4=160 5=320 6=640 7=1280 8=2560 9=5120 (AMSL in Feet)
```

### ipaddr=
This option binds the EchoLink channel driver to a specific IP address configured on the local server. **This is special application option, and normally should not be set.** 

Sample:

```
;ipaddr = 44.128.252.1              ; bind EchoLink to the interface with the address of 44.128.252.1
```

### lat=
This option is used to show your station latitude (in decimal degrees) on the [EchoLink Status Page](https://echolink.org/links.jsp). This setting is optional.

Sample:

```
lat = 0.0							; latitude in decimal degrees
```

### lon=
This option is used to show your station longitude (in decimal degrees) on the [EchoLink Status Page](https://echolink.org/links.jsp). This setting is optional.

Sample:

```
lon = 0.0							; longitude in decimal degrees
```

### maxstns=
This option is used to set the maximum number of EchoLink stations that are permitted to connect to your node. Be advised that you may run into issues with choppy audio or other connection issues if you set this number too high, and exceed the processing power of your CPU.

Sample:

```
maxstns = 20						; a maximum of 20 EchoLink stations are allowed to connect
```

### message=
This option sets a message to show on the [EchoLink status](https://echolink.org/links.jsp) page. Maximum size is 256 characters. Use `\n` for new lines. This setting is optional.

Sample:

```
;message = This is the first line\nThis is another line\nThis is a third line
```

### name=
This setting is your first name that you have registered with EchoLink that is associated to your EchoLink node number. This is a **required** setting. Maximum 32 characters.

Sample:

```
name = Jim					        ; your name registered with EchoLink
```

!!! note "From the EchoLink User Guide"
    This name will appear on the other station's screen when you establish a contact. Enter the name by which you wish to be called.

### node=
This setting is your **EchoLink node number** that you have registered with EchoLink. This is a **required** setting.

Sample:

```
node = 000000                       ; your EchoLink node number
```

### permit=
This setting is a comma-delimited list of callsigns to deny connecting to your EchoLink node. EchoLink connections may be denied on a per-callsign basis. This is done by using the `deny` and `permit` options. The default is to allow all connections if the `permit` and `deny` keywords are **not** present (or commented out). If a `permit` is specified, then only the callsigns specified in the `permit` statement will be allowed to connect. Wildcards are supported so that whole classes of connections can be rejected.

Sample:

```
;permit = W1AW,WB6NIL               ; when un-commented, only permit W1AW and WB6NIL to connect
```

```
;permit = *-*						; when un-commented, only allow RF (-L or -R) stations to connect, no computer connections
```

Alternatively, you can use the built-in ASL3 [`Allow and Deny Lists`](../adv-topics/allowdenylists.md) to manage access, as all calls processed by `[radio-secure]` are checked against the allow and deny database.

### port=
This option binds the EchoLink channel driver to a specific port range configured on the local server. The `port` parameter defines the EchoLink ***audio*** UDP port. 
The ***control*** port is always the next higher UDP port (typically `5199`). **This is special application option, and normally should not be set.** 

Sample:

```
;port = 5198                        ; bind the EchoLink channel driver to the port range 5198-5200
```

### power=
This option is used to show your transmitter power on the [EchoLink Status Page](https://echolink.org/links.jsp). This setting is optional.

Sample:

```
power = 0							; 0=0W, 1=1W, 2=4W, 3=9W, 4=16W, 5=25W, 6=36W, 7=49W, 8=64W, 9=81W (Power in Watts)
```

### pwd=
This setting is your password that you have registered with EchoLink that is associated to your EchoLink node number. This is a **required** setting. Maximum 16 characters.

Sample:

```
pwd = all5tarl1nk					; password for your EchoLink account
```

!!! note "From the EchoLink User Guide"
    If you had used EchoLink previously, type your original password here. Otherwise, select a password you can easily remember, and it will be assigned to you as
    you register. Be sure to make a note of it, in case you need to re-install the software.

### qth=
This setting is your station location that you have registered with EchoLink that is associated to your EchoLink node number. This is a **required** setting. Maximum 32 characters.

Sample:

```
qth = Anaheim, CA					; your station location
```

!!! note "From the EchoLink User Guide"
    Enter the location of your station, or a description of its function. This will appear in the list of available users. Examples: "Ridgefield, CT", or "Link to W2ABC/R, NYC".

### recfile=
This option sets where to record audio from EchoLink connections. This setting is optional.

Sample:

```
;recfile = /tmp/echolink_recorded.gsm   ; record audio to /tmp/echolink_recorded.gsm
```

!!! warning "Disk Space"
    Beware if you set this to somewhere on you actual filesystem (instead of `/tmp`), as you can fill up your hard drive/flash card, and crash your node. Recording to `/tmp/` is *safer*, as rebooting the node will free the memory used by the files in `/tmp`.

### rtcptimeout=
This option sets the timeout in seconds for "heartbeat" checks to EchoLink. If an `rtcp` packet has not been received before this timer expires, the station will be disconnected. The default value of `10` is usually sufficient.

Sample:

```
rtcptimeout = 10					; max number of missed heartbeats from EL
```

### server(1-4)=
This setting defines the EchoLink servers to connect to. The maximum number is four servers defined. There is no need to change these values, unless EchoLink changes their server names.

Sample:

```
server1 = nasouth.echolink.org
server2 = naeast.echolink.org
server3 = servers.echolink.org
server4 = backup.echolink.org
```

### tone=
This option is used to show your station's CTCSS tone (`0` for none) on the [EchoLink Status Page](https://echolink.org/links.jsp). This setting is optional.

Sample:

```
tone = 0.0                          ; CTCSS Tone (0 for none)
```
