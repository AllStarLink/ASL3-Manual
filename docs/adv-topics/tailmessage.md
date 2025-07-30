# Tail Messages
Tail messages are short audio files that are periodically played when a user un-keys (at the "tail" of their transmission). Tail messages can be "squashed" if a user keys up over them.
There are two methods that can be configured to setup the playing of tail messages, as shown below.

## Standard Tail Message Configuration

### tailmessagelist=
Found in `rpt.conf`, this option allows a comma-separated list of audio files to be specified for the tail message function. The tail messages will *rotate* from one to the next until the end of the list is reached, at which point the first message in the list will be selected. If no absolute path name is specified, the directory `/usr/share/asterisk/sounds/en` will be searched for the sound file.  If `sounds_search_custom_dir = yes` in the `asterisk.conf` file, `/usr/share/asterisk/sounds/custom` will also be searched. 
The file extension should be omitted.

Sample:

```
tailmessagelist = welcome,clubmeeting,wx  ; rotate 3 tail messages
```

## Alternate Tail Message Configuration

An extension `TAIL` can be added to the `extensions.conf` file under the context `[telemetry]` or a the context defined in [telemetry](#telemetry) parameter found in `rpt.conf`.  This allows full control of messages via the dialplan.

> [!NOTE]<br>
>If the `TAIL` extension exists, values in [tailmessagelist](#tailmessagelist) are ignored.

> [!NOTE]<br>
>[globals] context and global variables are required to "remember" values across dialplan executions.


Sample #1 - perform same rotating message list as "standard"
```
[globals]
TAILFILEINDEX=0

[telemetry]
exten => TAIL,1,Set(TAILFILES=/tmp/tailmsg,/tmp/tailmsg2) ; add , separated tail files to play
	same => n,Set(index=$[${GLOBAL(TAILFILEINDEX)} % ${FIELDQTY(TAILFILES,\,)} + 1])
	same => n,Set(file=${CUT(TAILFILES,\,,${index})})
	same => n,Playback(${file})
	same => n,Set(GLOBAL(TAILFILEINDEX)=$[${TAILFILEINDEX} + 1]) 
    same => n,Hangup() 
```

Sample #2 - rotating message + weather and traffic
```
[globals]
TAILFILEINDEX=0

[telemetry]
; Say message file
exten => TAIL,1,Set(TAILFILES=/tmp/tailmsg,/tmp/tailmsg2) ; add , separated tail files to play
	same => n,Set(index=$[${GLOBAL(TAILFILEINDEX)} % ${FIELDQTY(TAILFILES,\,)} + 1])
	same => n,Set(file=${CUT(TAILFILES,\,,${index})})
	same => n,Playback(${file})
 	;after playing the tail message, play a weather announcement
  	same => n,Playback(weather_file)
  	;after playing the weather announcement, play a traffic announcement
  	same => n,Playback(traffic_file)
	same => n,Set(GLOBAL(TAILFILEINDEX)=$[${TAILFILEINDEX} + 1]) 
  	same => n,Hangup()
```

## Options Common to Both Tail Message Methods

> [!NOTE]<br>
>"File Extensions"<br>
>ID recording files must have extension .gsm, .ulaw, .pcm, or .wav. The extension is left off when it is defined as the example shows above. File extensions are used by Asterisk to determine how to decode the file. All ID recording files should be sampled at 8KHz mono.

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
