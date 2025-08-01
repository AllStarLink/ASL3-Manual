# Tail Messages
Tail messages are short audio files that are periodically played when a user un-keys (at the "tail" of their transmission). Tail messages can be "squashed" if a user keys up over them.
There are two methods that can be configured to setup the playing of tail messages, as shown below.

## Standard Tail Message Configuration

### [tailmessagelist=](../config/rpt_conf.md#tailmessagelist)
Found in [`rpt.conf`](../config/rpt_conf.md)
{% include-markdown "../config/rpt_conf.md" start="<!-- start:tailmessagelist -->" end="<!-- stop:tailmessagelist -->" %}


## Alternate Tail Message Configuration

An extension `TAIL` can be added to the `extensions.conf` file under the context `[telemetry]` or a the context defined in [telemetry](#telemetry) parameter found in `rpt.conf`.  This allows full control of messages via the dialplan.

!!! NOTE
	If the `TAIL` extension exists, values in [tailmessagelist](#tailmessagelist) are ignored.

!!! NOTE
	[globals] context and global variables are required to "remember" values across dialplan executions.


Sample #1 - perform same rotating message list as "standard"
```
[globals]
TAILFILEINDEX=0

[telemetry]
exten => TAIL,1,Set(TAILFILES=custom/yourtailmsg,/tmp/yourothertailmsg) ; add , separated tail files to play
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
exten => TAIL,1,Set(TAILFILES=custom/yourtailmsg,/tmp/yourothertailmsg) ; add , separated tail files to play
	same => n,Set(index=$[${GLOBAL(TAILFILEINDEX)} % ${FIELDQTY(TAILFILES,\,)} + 1])
	same => n,Set(file=${CUT(TAILFILES,\,,${index})})
	same => n,Playback(${file})
 	;after playing the tail message, play a weather announcement
  	same => n,Playback(/tmp/current-weather)
  	;after playing the weather announcement, play a traffic announcement
  	same => n,Playback(/tmp/current-traffic)
	same => n,Set(GLOBAL(TAILFILEINDEX)=$[${TAILFILEINDEX} + 1]) 
  	same => n,Hangup()
```

## Options Common to Both Tail Message Methods

!!! note
	"File Extensions"<br>
	ID recording files must have extension .gsm, .ulaw, .pcm, or .wav. The extension is left off when it is defined as the example shows above. File extensions are used by Asterisk to determine how to decode the file. All ID recording files should be sampled at 8KHz mono.

See the [Sound Files](../adv-topics/soundfiles.md) page for more information.

### [tailmessagetime=](../config/rpt_conf.md#tailmessagetime)
Found in [`rpt.conf`](../config/rpt_conf.md)
{% include-markdown "../config/rpt_conf.md" start="<!-- start:tailmessagetime -->" end="<!-- stop:tailmessagetime -->" %}

### [tailsquashedtime=](../config/rpt_conf.md#tailsquashedtime)
Found in [`rpt.conf`](../config/rpt_conf.md)
{% include-markdown "../config/rpt_conf.md" start="<!-- start:tailsquashedtime -->" end="<!-- stop:tailsquashedtime -->" %}

### [telemetry=](../config/rpt_conf.md#telemetry)
Found in [`rpt.conf`](../config/rpt_conf.md)
{% include-markdown "../config/rpt_conf.md" start="<!-- start:telemetry -->" end="<!-- stop:telemetry -->" %}

