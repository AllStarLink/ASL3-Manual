### tailmessagelist=
This option allows a comma-separated list of audio files to be specified for the tail message function. The tail messages will *rotate* from one to the next until the end of the list is reached, at which point the first message in the list will be selected. If no absolute path name is specified, the directory `/usr/share/asterisk/sounds/en` will be searched for the sound file. The file extension should be omitted.

Sample:

```
tailmessagelist = welcome,clubmeeting,wx ; rotate 3 tail messages
```

Alternately, an extension `TAIL` can be added to the `extensions.conf` file under the default context `[telemetry]` or a the context defined in [telemtry](#telemetry)`  .  This allows full control of messages via the dialplan.
NOTE: If the `TAIL` extension exists, values in [tailmessagelist](#tailmessagelist) are ignored.

Sample #1 - perform same rotating message list
```
[globals]
TAILNUMFILES=2 ; set number of & separated files
TAILFILES=tailmsg&tailmsg2 ; add & separated tail files to play.
TAILFILEINDEX=0

[telemetry]
exten => TAIL,1,Set(index=$[${TAILFILEINDEX} % ${TAILNUMFILES} + 1])
same => n,Set(file=${CUT(files,&,${index})})
same => n,Playback(${file})
same => n,Set(GLOBAL(TAILFILEINDEX)=$[${TAILFILEINDEX} + 1])
same => n, Hangup()
```

Sample #2 - rotating message + weather and traffic
```
[globals]
TAILNUMFILES=3 ; set number of & separated files
TAILFILES=tailmsg&tailmsg2&tailmsg3 ; add & separated tail files to play.
TAILFILEINDEX=0

[telemetry]
; Say message file
exten => TAIL,1,Set(index=$[${TAILFILEINDEX} % ${TAILNUMFILES} + 1])
same => n,Set(file=${CUT(files,&,${index})})
same => n,Playback(${file})
same =>  n, Playback(weather)
same =>  n, Playback(traffic)
same => n,Set(GLOBAL(TAILFILEINDEX)=$[${TAILFILEINDEX} + 1])
same => n, Hangup()
```

Tail messages can be "squashed" if a user keys up over them.

!!! note "File Extensions"
    ID recording files must have extension gsm,ulaw,pcm, or wav. The extension is left off when it is defined as the example shows above. File extensions are used by Asterisk to determine how to decode the file. All ID recording files should be sampled at 8KHz mono.

See the [Sound Files](../adv-topics/soundfiles.md) page for more information.

### tailmessagetime=
This option sets the amount of time in milliseconds between tail messages. Tail Messages are played when a user unkeys on the node input at the point where the hang timer expires, and after the courtesy tone is sent.

Sample:

```
tailmessagetime = 900000            ; 15 minutes between tail messages
```

The maximum value is 200000000mS (55.5555 hours).

### tailsquashedtime=
If a tail message is "squashed" by a user keying up over the top of it, a separate time value can be loaded to make the tail message be retried at a shorter time interval than the standard `tailmessagetime=` option. The `tailsquashedtime=` option takes a value in milliseconds.

Sample:

```
tailsquashedtime = 300000           ; 5 minutes
```

### telemetry=
This option allows you to override the stanza name used for the `telemetry` stanza in `rpt.conf`. Telemetry definitions define courtesy tone parameters, and tones sent when certain actions take place on the node.

Sample:

```
telemetry = telemetry               ; name telemetry to 'telemetry'

[telemetry]
...
```
