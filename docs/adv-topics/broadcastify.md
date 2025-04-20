# Streaming Node Audio to Broadcastify 
To broadcast your node's audio on [Broadcastify](https://www.broadcastify.com/), you will need a Broadcastify account. You can then apply for a feed. This [link](https://support.broadcastify.com/hc/en-us/articles/204740055-Becoming-a-Feed-Provider) provides information on applying for a feed.

After you have your account and feed credentials, you a ready to setup AllStarLink.

## Setup a Feed
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

## Migrating an Existing Feed
If you have an existing feed, you will need to upgrade your existing `xml` configuration file to the new format. You can use the following commands:

```
cd /etc
ezstream-cfgmigrate -0 ezstream.xml > ezstream.xml.new
cp ezstream.xml ~/
mv ezstream.new ezstream.xml
```