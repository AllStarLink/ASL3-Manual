# Streaming Node Audio to Broadcastify
To broadcast your node's audio on [Broadcastify](https://www.broadcastify.com/), you will need a Broadcastify account. You can then apply for a feed. This [link](https://support.broadcastify.com/hc/en-us/articles/204740055-Becoming-a-Feed-Provider) provides information on applying for a feed.

After you have your account and feed credentials, you a ready to setup AllStarLink.

## Modern Method
!!! note "Version Note"
    These directions require the asl3 package version 3.18.2-2 or later.
	Legacy directions can be found below under "Legacy Method".

The "modern method" of streaming to Broadcastify uses a helper application
`/usr/libexec/asl3/rpt_audio_writer` to take the audio out of Asterisk/app_rpt
via the `outstreamcmd` directive and write it to a FIFO pipe. The asl-broadcastify
service then picks up the audio from the pipe and streams it to Braodcastify
via ffmpeg. This method allows independent restarting of the asl-broadcastify
service in the case of a hiccup with Broadcastify that doesn't require restarting
all of Asterisk.

### Configure `asl-broadcastify` Config
The asl-broadcastify service is a "templated" multi-instance systemd service.
This means that each stream is started and stopped independently. For example,
if node 63001 is configured to stream, the service would interact with
`asl-broadcastify@63001` - for example `systemctl start asl-broadcastify@63001`.
This allows independent management of each stream.

In each command, replace "63001" with your node number.

* Log into your node either using `Cockpit` or SSH and become root with
`sudo -s`

* `cd /etc/asterisk/broadcastify`

* Copy the `1999.conf.example` to your node number followed by conf - e.g., `cp 1999.conf.example 63001.conf`

* Edit the file with your favorite editor - e.g., `nano 63001.conf`

* Within the file, edit `FIFO` to replace "NODE" with your node number. Then
set the various variables that start with `ICECAST_` to match your feed information
from within Broadcastify. The information is found inside the "Feed Technical Details"
screen on Broadcastify. Then set the `STREAM_` variables in the "Stream Metadata" section.
Do not change the items at the end of the file unless you know what you're doing
and why you're changing them. Save the file. An example might look like:

    ```bash
	# Broadcastify stream configuration for node 63001
	# This file must be named NODE.conf - e.g. 1999.conf

	# FIFO path (where rpt_audio_writer is configured in outstreamcmd=)
	# This needs to be readable by the asterisk user.
	# Replace "NODE" with the node number.
	FIFO=/var/lib/asterisk/63001.fifo

	# Icecast server details
	# This is configuration found in your "Feed Technical Details"
	# section of your configured Broadcastify Stream
	ICECAST_HOST=audio9.radioreference.com
	ICECAST_PORT=80
	ICECAST_MOUNT=/8yjcvp04gfwl
	ICECAST_USER=source
	ICECAST_PASSWORD=i8o9092j

	# Stream metadata - This can be wha tever you want within quotes
	STREAM_NAME="WB6NIL 147.390 MHz"
	STREAM_DESCRIPTION="Nets and live feeds from the WB6NIL repeater"
	STREAM_URL="allstarlink.org"

	# Don't change these unless you know why you're changing it
	STREAM_PUBLIC=1
	STREAM_GENRE="Amateur Radio"
	INPUT_SAMPLERATE=8000
	INPUT_CHANNELS=1
	OUTPUT_BITRATE=16k
	```

* Enable and start the service:

	```bash
	systemctl enable asl-broadcastify@63001
	systemctl start asl-broadcastify@63001
	```

Log output can be found by reviewing `journalctl -xu asl-broadcastify@NODE` -
e.g. `journalctl -xu asl-broadcastify@63001`.

Multiple services can be run simultaneously on the same system by simply
using multiple node numbers for the configuration and the systemd commands.
Each unit is managed independently:

```bash
/etc/asterisk/broadcastify/63001.conf
/etc/asterisk/broadcastify/40608.conf

systemctl enable asl-broadcastify@63001
systemctl enable asl-broadcastify@40608

systemctl start asl-broadcastify@63001
systemctl start asl-broadcastify@40608


systemctl stop asl-broadcastify@63001
systemctl stop asl-broadcastify@40608
```

### Configure Asterisk

* Edit `/etc/asterisk/rpt.conf` using your favorite editor - e.g., `nano /etc/asterisk/rpt.conf`.

* Within the configuration for the node you want to stream configure `outstreacmd` to be
the string `/usr/libexec/asl3/rpt_audio_writer,/var/lib/asterisk/NODE.fifo` replacing
"NODE" with your node number. For the node 63001, an example would look like:

	```conf
	[63001](node-main)
	statpost_url = http://stats.allstarlink.org/uhandler
	idrecording = |iWB6NIL
	duplex = 2
	rxchannel = Local/pseudo
	outstreamcmd = /usr/libexec/asl3/rpt_audio_writer,/var/lib/asterisk/63001.fifo
	```

* Save the file.

* Restart asterisk with `systemctl restart asterisk`.

Then wait for a few minutes and Broadcastify should mark your stream as online.


## Legacy Method
!!! note "Version Note"
    It is strongly suggested to upgrade to ASL3 3.18.2-2 or later.
	These directions are for old versions of asl3 package version 3.18
	or earlier.

### Setup a Feed
* Log into your node either using `Cockpit` or SSH and type the following commands:

```
sudo apt update
sudo apt install libshout-dev libtagc0-dev lame ezstream
```

* Edit `/etc/ezstream.xml` with your favorite editor, for example `sudo nano -w /etc/ezstream.xml`. You will be creating a new file. Copy, paste, and edit the following contents
into the file:

```xml
<ezstream>
	<servers>
		<server>
			<protocol>HTTP</protocol>
			<hostname>Replace with Broadcastify URL</hostname>
			<port>80</port>
			<password>Replace with your stream password</password>
			<tls>none</tls>
		</server>
	</servers>

	<streams>
		<stream>
			<mountpoint>Replace with your mount point path</mountpoint>
			<format>MP3</format>
    			<stream_name>Replace with your feed name</stream_name>
    			<stream_url>Your web page</stream_url>
    			<stream_genre>Amateur Radio</stream_genre>
    			<stream_description>Replace with your stream description</stream_description>
    			<stream_bitrate>16</stream_bitrate>
    			<stream_channels>1</stream_channels>
    			<stream_samplerate>22050</stream_samplerate>
    			<stream_public>Yes</stream_public>
		</stream>
	</streams>

	<intakes>
		<intake>
			<type>stdin</type>
		</intake>
	</intakes>
</ezstream>
```

* Save the file

* Ensure the file is owned and readable only by the Asterisk user:

```
sudo chown asterisk:asterisk /etc/ezstream.xml
sudo chmod 660 /etc/ezstream.xml
```

* Edit `/etc/asterisk/rpt.conf` with your favorite editor, i.e. `sudo nano -w /etc/asterisk/rpt.conf`

* Locate the node stanza for the node from which to stream to Broadcastify. The stanza is `[NNNNN](node-main)`. For example, if your node is 63001 then look for `[63001](node-main)`. Within that configuration stanza, add the following line:

```
outstreamcmd = /bin/sh,-c,/usr/bin/lame --preset cbr 16 -r -m m -s 8 --bitwidth 16 - - | /usr/bin/ezstream -qvc /etc/ezstream.xml
```

The above parameters have these meanings:

```
-- preset cbr 16` = use constant bit rate 16
-r = Assume the input file is raw pcm
-m m = Mode mono
-s 8 = sample rate 8
--bitwidth 16 = bit width is 16 (default)
```

* After these changes have been made, you will need to restart Asterisk:

```
sudo systemctl restart asterisk
```

If you experience any problems, look at `/var/log/ezstream.log` for error messages

### Migrating an Existing Feed
If you have an existing feed, you will need to upgrade your existing `xml` configuration file to the new format. You can use the following commands:

```
cd /etc
ezstream-cfgmigrate -0 ezstream.xml > ezstream.xml.new
cp ezstream.xml ~/
mv ezstream.new ezstream.xml
```