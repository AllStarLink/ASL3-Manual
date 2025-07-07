# Sound Files
Your AllStarLink node has a LOT of built-in sound files that can be used for all sorts of notifications, messages, identification, telemetry, status, etc.

If you can't find the words you need, you can record your own sound files and upload them, use an online Text to Speech (TTS) sound generator to create your own sound files, or use the built-in [`asl-tts`](https://github.com/AllStarLink/asl3-tts) tool.

## Sound File Locations
Asterisk searches a default sound file path of `/usr/share/asterisk/sounds/en` (ASL3) or `/var/lib/asterisk/sounds` (previous versions), unless a path name is specified with the name of the sound file.

`Asterisk/app_rpt` stores its sound files in:

* ASL3: `/usr/share/asterisk/sounds/en/rpt`
* Previous versions: `/var/lib/asterisk/sounds/rpt`

Custom node name messages are stored in `/var/lib/asterisk/sounds/rpt/nodenames`. Those files are equivalent to whatever you wish to replace Allison's saying the node number.

If a sound file exists there for the node number (ie. 63001.gsm), it will play. Otherwise, Allison will speak the node number digits when required on connect and disconnect messaging.

You may need to adjust the location of this pointer to match your use, see [`[nodenames=]`](../config/rpt_conf.md#nodenames) in [`rpt.conf`](../config/rpt_conf.md).

## Sound File Formats
Asterisk supports many common sound file formats, but we use these three universally: ulaw, pcm, and gsm.

All sound files should be recorded at 8KHz mono in one of these formats. 

All files should be header-less.

## Sound File Naming Convention
Sound files can have any valid file name, but the extension must identify one of the supported formats (ie. gsm, pcm, or ulaw).

!!! note "Omitting Extensions"
    When specifying an ID message file in `rpt.conf`, you might omit the extension and just supply the file name. Asterisk will accept known formats to it, looking in particular order. 

It is better to specify the path and extension to know exactly what file is to be played when debugging. Especially as your system expands and search paths change.

A final note to check/change file [ownership and permissions](./permissions.md) appropriately for files you create.


## Sound File Recording and Manipulation
There are many utility programs to allow you to convert or manipulate your sound files.

SoX and MPEG123 are two of those. [Audacity](https://audacityteam.org) is another popular choice for editing sound files, but there are others out there that do just as well and are a bit skinnier.

Here is an (older) [how-to](./assets/RecordingSoundFiles.pdf) on using Audacity to record sound files for your node.

Regardless of the method you use to record sound files, be sure to record in a quiet environment (no fans, animals, children crying). For even better results, invest in a decent USB podcasting microphone (most built-in computer microphones are not great, and pick up lots of external noise (like laptop fans)).




