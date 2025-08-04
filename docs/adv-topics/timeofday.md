# Time of Day
When the time of day message (`status, 12` or `status, 2`) is activated the node will report the local time.  This message can be customized by adding the extension `TIME` to [extensions.conf](../config/extensions_conf.md) under the context `[telemetry]` or the context defined in [telemetry](#telemetry) parameter found in `rpt.conf`.
The standard time message extension follows:
```
[telemetry]

; Say the time of day local
exten => TIME,1,NoOp(Announce time without 'o'clock')
 same => n,ExecIfTime(0:00-11:59,*,*,*?Playback(rpt/goodmorning))
 same => n,ExecIfTime(12:00-17:59,*,*,*?Playback(rpt/goodafternoon))
 same => n,ExecIfTime(18:00-23:59,*,*,*?Playback(rpt/goodevening))
 same => n,Playback(rpt/thetimeis)
 same => n,SayUnixTime(,,IMp)
 same => n,Hangup()
```

A version that eliminates the "o'clock" wording:

```
[telemetry]

; Say the time of day local
exten => TIME,1,NoOp(Announce time without 'o'clock')
 same => n,ExecIfTime(0:00-11:59,*,*,*?Playback(rpt/goodmorning))
 same => n,ExecIfTime(12:00-17:59,*,*,*?Playback(rpt/goodafternoon))
 same => n,ExecIfTime(18:00-23:59,*,*,*?Playback(rpt/goodevening))
 same => n,Playback(rpt/thetimeis)
 same => n,SayUnixTime(,,${IF($[${STRFTIME(${UNIXTIME},,%-M) = "0"}]?IMp:Ip)})
 same => n,Hangup()
```
