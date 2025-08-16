# ASL Text-to-Speech
ASL provides the `asl-tts` command. This is a text to speech speaker for ASL3. It uses the [piper](https://github.com/rhasspy/piper) open source TTS system that is not dependent on cloud providers and has opensource voice models for dozens of languages.

If the `asl-tts` command doesn't exist on your system, you will need to install the `asl3-tts` package:

```
sudo apt install asl3-tts
```

## Basic Operation
`asl-tts` uses the `piper-tts` text to speech engine to generate ulaw files from text so that `Asterisk/apt_rpt` can speak any set of arbitrary text without needing to have a sound file installed for the word necessary. By default, `asl-tts` will cause `app_rpt` to immediately speak whatever text was specified.

!!! Note "asl-tts has a time delay"
    Running the `piper-tts` system takes a few seconds to compile the voice into the sound file. Larger text blocks may take tens of seconds to compile. `asl-tts` is not appropriate for time-sensitive communications such as speaking the current time.

The command format is as follows:

```
asl-tts -n NODE -t 'TEXT' [ -v VOICE ] [ -f FILE ]
```

The general use case is to speak to a node immediately. This this case speaking the text "Good morning" to node 63001 would look like this:

```
sudo asl-tts -n 63001 -t 'Good morning'
```

The TTS engine will start, create the audio, and execute the playback on the node. The playback follows normal `app_rpt` rules and will be played back as soon as its turn arrives. The command will not preempt or "talk over" other traffic on the node.

Keep in mind the differences between quoting in a shell command. In general, the `"` and `'` work the same but the double-quote will allow variable substitution while the single quote will not. This can be useful if you want to create text based on a system condition. For example:

```
TODAY=$(date +"%A, %B %d, %Y")
sudo asl-tts -n 63001 -t "Today is ${TODAY}"
```

Obviously the above example is a bit contrived as the `date` command doesn't generate nice words such as "first", "seventeenth", etc. However, it demonstrates the flexibility of the tool. A script could be used to populate `$TODAY` with natural words. For a hypothetical example:

```
TODAY=$(/path/to/today-script)
sudo asl-tts -n 63001 -t "Today is ${TODAY}"
```

More complex message can be created with additional shell coding. As an example here's how the current public IP address of the system could be obtained and spoken:

```
IPADDR=$(wget -q -O - checkip.dyndns.com | grep -Po "[\d\.]+" | sed 's/\./ dot /g')
MSG="The node public IP is ${IPADDR}"
sudo asl-tts -n 63001 -t ${MSG}
```

A `bash` shell variable can generally hold up to a 2 Mb-sized string so any reasonably-formatted text can be stored in a variable and then played with the `-t` command. Keep in mind that the text or the variable contents must not contain the same quote type used in the command without escaping it with a backslash. For example `"Nested \" mark"`.

!!! Warning "Temporary File Cleanups"
    Note that temporary files are written to directories named `/tmp/asl-tts*` and are not automatically cleaned up because it's impossible to know when Asterisk will actually need/speak the file contents. If this becomes a space problem, put in a `systemd` timer unit or a `cron` job to delete old files in `/tmp/asl-tts*`. The command can simply be `rm -rf /tmp/asl-tts*`.

## Creating a Sound File for Later
To create the text for other usage, such as cron jobs, use the `-f FILE` option to specify where the file should be created. Do not use an extension, the file will be automatically appended with the `.ul` suffix.

For example:

```
AUD_TEXT="The club net will begin in five minutes!"
asl-tts -n 460181 -t "${AUD_TEXT}" -f /tmp/netstartsin5
```

This will create a sound file `/tmp/netstartsin5.ul` that can be used later with an asterisk playback such as:

```
asterisk -rx 'rpt playback 63001 /tmp/netstartsin5
```

Note that `-n` is required but irrelevant to this use case.

## Voices
By default, the package provides the voice "Amy" from [https://github.com/rhasspy/piper/blob/master/VOICES.md](https://github.com/rhasspy/piper/blob/master/VOICES.md). This voice is the closest voice to the default Asterisk and `app_rpt` sounds ("Allison"). It is possible to download other voices, for any language, and store the `.onnx` and
`.onxx.json` files in `/var/lib/piper-tts` and then use them with the `-v` option. For example, to add the English (en\_GB) voice "Alan" from the voices repository:

1. Download the `.onnx` and `.onnx.json` file to `/var/lib/piper-tts`

2. Specify `-v en_GB-alan-low.onnx` on the command line to `asl-tts`. As an example:

```
asl-tts -n 63001 -v en_GB-alan-low.onnx -t "Good morning"
```

!!! note "File Quality"
    Since all files are squashed down to 8K uLaw format, there is no value in the "medium" or "high" quality models. Always use the "low" quality model.

## Reporting Bugs
Report bugs to [https://github.com/AllStarLink/asl3-tts/issues](https://github.com/AllStarLink/asl3-tts/issues)