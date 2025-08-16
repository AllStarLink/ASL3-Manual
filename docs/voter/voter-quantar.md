# VOTER and the Quantar
This page discusses interfacing the Motorola Quantar to the VOTER/RTCM interface, for use with AllStarLink.

This page should get you up and running with how to connect a VOTER/RTCM to a Motorola Quantar (Quantro should be similar). These are just the basic configuration steps, based on the following scenario:

* Analog repeater
* Receive Carrier Squelch (with AllStarLink generating a TX-only PL)
* Main repeater in a voting system
* Supporting "offline" repeater mode

Some things to consider:

* Install JP1 on the Quantar's VOTER/RTCM. The squelch should calibrate at around 4 blinks rather than the 12 blinks or so without JP1
* Be sure you've done the diode and squelch calibration with the actual attached radio (no antenna)
* The Quantar firmware should be 20.14.48 as later versions have better noise output
* Each VOTER/RTCM should have the squelch 3 to 5 turns past threshold to prevent the squelch form being too loose. Somewhere around the 350 level seems about right
* Don't "and" CTCSS with squelch. That may override the VOTER/RTCM's squelch detection. Compare with CTCSS on and off to see effect, if any
* You may (probably) want to install the [DSP/BEW](./voter-audio.md#dspbew-firmware-version) firmware in the VOTER/RTCM

## Supporting Documentation

The following links are useful for reference:

* [W9CR Quantar Site](https://wiki.w9cr.net/index.php/Quantar), Bryan has a LOT of useful and relevant info on his page including manuals and firmware
* [Repeater Builder Quantar Site](http://www.repeater-builder.com/motorola/quantar/quantar-index.html), go here for additional documentation
* [RTCM Hardware Client](./rtcm-hardware.md) page on this site
* [VOTER Hardware Client](./voter-hardware.md) page on this site
* [Quantar/RTCM Interface Cable](./assets/QUANTAR-RTCM_INTERFACE_CABLE.pdf) or [this alternate](./assets/RTCM_2_Quantar.pdf)

## Firmware

### Quantar Firmware
You will want to have newer (ie R020.014.048) firmware in the Station Control Module (SCM). Head on over to [Bryan's Site](https://wiki.w9cr.net/index.php/Quantar) to download the firmware files. You will also want to get the RSS manual and Service Manual when you are there. 

Upgrade the firmware in your SCM and Wireline module, using the instructions in your RSS manual. You should end up with something like this when you go look at the versions screen in the RSS:

```
Station Control Firmware	R020.14.048
Station Wireline Firmware	R020.14.003
Station Exciter Firmware	R020.09.018
Station Boot2 Firmware		R020.14.015
Station Boot1 Firmware		R020.09.011
Codeplug Version		14
```

!!! note "Note"
    You will want to update your codeplug too, that is under the Tools --&gt; Codeplug Upgrade menu.

The firmware in the Exciter is not automatically upgraded. You will need to do that by burning a 27C512 EPROM, popping the cover off the exciter, and swapping the chip out. You **DO** want to do this, as there are a number of fixes in later firmware (apparently), especially if you plan on running P25 mixed mode at some point later.

### VOTER/RTCM Firmware
The Quantar is special in that the "discriminator" audio isn't really conventional analog discriminator audio as you would normally find in any other radio. The true discriminator audio is filtered through a 6kHz LPF filter, digitized, and then moved around the backplane bus to different cards.

The VOTER/RTCM traditionally uses high frequency (above the passband) discriminator audio to do it's RSSI calculations. Since the audio response is limited to <6kHz on the Quantar, this presents a challenge. To combat this, additional code was added to the VOTER/RTCM firmware called the "DSP/BEW" option. Read about it more on the [VOTER Audio](./voter-audio.md#dspbew-firmware-version) page.

Regardless, you will need to upgrade the firmware in your VOTER/RTCM (it likely comes with vanilla V1.50 firmware), to use one of the versions with DSP/BEW. Note that due to space constraints, the DSP/BEW firmware is mutually exclusive with the Diagnostics Mode in the VOTER/RTCM (there's not enough room for both).

You will also likely want to install a newer version with the ["Chuck" squelch](./voter-audio.md#chuck-squelch) fix... this is really a buffer overflow fix that makes the squelch reporting behave a bit better.

The RTCM needs the "smt" version files, the VOTER uses the non-smt version files.

Firmware is available on the [AllStarLink GitHub Repository](https://github.com/AllStarLink/voter/tree/master/board-firmware). Instructions and the other utilities needed are all listed on the [VOTER Firmware](./voter-firmware.md) page.


### Wiring/Connections
A good primer on the connections available on the backplane can be found over on [Repeater Builder](http://www.repeater-builder.com/motorola/quantar/q-interfacing/quantar-interfacing.html) Repeater Builder, or dig through the various manuals.

It is best to use the "Telco" connector, J17, to make the interface cable. This requires a 50-pin MALE Amphenol connector and 90 degree hood. Carefully solder the connections if you have to, or find your local communications installer buddy with an Amphenol "butterfly" tool to crimp one for you. 

A good cable to use is this one:
[Quantar/RTCM Interface Cable](./assets/QUANTAR-RTCM_INTERFACE_CABLE.pdf)

There are a couple minor notes when using this cable. The connection to Pins 26/27 are not required (those are Line 1- and Line 2-, which aren't used), instead, connect Pin 43 (RDSTAT-) to Pin 32 (GND).

In reality, if you are using the VOTER/RTCM to do squelch (which you should be), then the RDSTAT connection isn't even necessary.

For the RTCM, build the necessary breakout cable for the DB15 to split out the serial console, and the connections to your GPS. Note that you will need to configure JP4 and JP5 inside the RTCM for TTL/RS-232, as required. **Beware** the label on the RTCM is misleading, you want to use the GTX Pin (14) for data **from** your GPS **to** the RTCM. The GRX (data **from** the RTCM **to** the GPS is not required, as it is not used).

For the VOTER, build your appropriate interface cable.

## Quantar Audio
The biggest headache in the Quantar is audio.

As mentioned above, you don't get "true" discriminator audio out of the shelf, but you do get a reasonable facsimile.

If you go dig DEEP in the Quantar Digital-Capable Station Instruction manual, p/n 6881095E05, (on [Repeater Builder](http://www.repeater-builder.com/motorola/quantar/quantar-index.html)), and dive in to [Part 14 - Station Configuration](http://www.repeater-builder.com/motorola/quantar/qim/part-14-station-configuration.pdf), you will find a section called "Fast Keyup Feature".

This is where it talks about using Pins 5 and 30 on J17 to get audio in and out of the station, using the "Splatter Filter Connection Configuration". It also talks about using Pin 23 on the MRTI connector for PTT, but ignore that, we'll use the EXT PTT input on J17 instead.

Note that the actual "Fast Keyup" feature only shows up in the RSS if you enable WildCard=Enhanced, then it shows up on the RF Configuration screen.

The audio that shows up on J17 30, J14 7, and J14 22 is all the same. They are also all gated audio. You can't get un-squelched (ie open discriminator) audio unless you either configure the station for Un-squelched Audio on the Channel Information screen, or program the WildCard. Also know that if the WildCard is not programmed, you will not get ANY audio out on the back, unless you turn on the Phone Patch option.

We are going to do all the pre-emphasis and de-emphasis in the VOTER/RTCM and AllStarLink, so we want to make sure to disable any audio filtering on the channel inside the Quantar. If you don't your audio is going to sound like garbage.

### Important Audio RSS Settings
The following settings are needed to make the audio behave the way we want:

**Hardware Configuration Screen**

* Wireline: 8-wire
* WildCard: Enhanced
* Phone Patch Interface: Disabled

**Channel Information Basic**

* Analog RX Activation: S=Carrier Sql.
* Analog Rptr Activation: OFF
* Analog Rptr Hold-In: OFF
* Analog Rptr Access: NONE

**Channel Information Advanced**

* Pre-emphasis: DISABLED
* De-emphasis: DISABLED
* High-Pass Filter: DISABLED

**RF Configuration**

* Repeater Operation: BASE

### WildCard Programming
This is how you actually get the audio and logic to work. Without this, you can get audio out of the shelf using other configurations, but you can't key or or get modulation in.

The WildCard Input and Output screens should be fine at defaults. Just make sure that Aux Input 9 is set for LO (this is our PTT).

The important configuration is in the WildCard Tables.

Delete any existing WildCard Tables, you are going to create two new ones. Configure them as shown below:

This is the important one to actually turn on the discriminator audio output on the backplane when the station boots/reboots:

```
Description: DISC AUDIO ON
State: COLD RESET Cond: OR State: WARM RESET
Action: RXDSC-AUXRX-ON
Inaction: NULL
```

This is how we allow external PTT, and gate the AUX TX audio from Pin 5 to the Exciter:

```
Description: TX AUDIO
State: INPUT 9
Action: DEKEY FROM WL; AUXTX-TX OFF
Inaction: KEY FROM WL; AUXTX-TX ON
```

## AllStarLink (Asterisk) Configuration
The VOTER/RTCM connect to AllStarLink (Asterisk) using the `chan_voter` channel driver. Make sure you have that set up in [`rpt.conf`](../config/rpt_conf.md), something like:

```
rxchannel=voter/<nodenumber>
```

The rest of the configuration is done in [`voter.conf`](../config/voter_conf.md). We won't go in to all the details on the options here, but will go through some basic settings to get on the air and levels lined up.

You are going to want to start with something basic in [`voter.conf`](../config/voter_conf.md) like:

```
[general]
port = 667
buflen = 500
password = mypass                      ; This is the HOST PASSWORD in the RTCM
utos = y                               ; Turns on TOS packet marking from AllStar TOWARDS the RTCM

[1999]                                 ; your node number, referenced by the channel driver in rpt.conf
MAIN_SITE = clientpass,transmit,master ; clientpass is the CLIENT PASSWORD in the RTCM

plfilter = 0                           ; leave off for now
txctcss = 100.0                        ; set to your desired TRANSMIT PL tone, MUST set it to SOMETHING
txctcsslevel = 0                       ; set to 0 for now, until audio alignment is done later
txtoctype = phase                      ; the type of "reverse burst" to send when de-keying
```

That takes care of the basic settings required Asterisk. During the audio alignment, the `txctcsslevel` will be adjusted for the correct deviation.

## VOTER/RTCM Configuration
There is lots of stuff to configure in the VOTER/RTCM too. You will want to establish a serial console connection (through the DB9/DB15), using 57600/8N1.

!!! note "Save and Reboot"
    Remember to Save Values to EEPROM (`99`) and Reboot (`r`) when you make changes, or you will have unpredictable results. Some changes are immediate, but many are not, and will confuse you when things you expect to happen, don't.

Start with the `IP Parameters Menu`. This should be all straight forward. This will get your VOTER/RTCM on the network.

Back on the `Main Menu`, you will want to make sure your `VOTER Server Address`, `Port`, and `Passwords` are set. See the [notes](./voter-menus.md) about which password is which. You will also need to configure your GPS settings. Make sure to set the jumpers inside the RTCM for RS-232 or TTL, as needed. You may need to play with the `GPS Serial Polarity` and `GPS PPS Polarity` until you get data flowing. 

If you set the `Debug Level` to `32`, you will know right away if you are getting GPS data into the VOTER/RTCM, as this setting will print the NMEA or TSIP strings being received. This is an immediate setting, no need to save and reboot.

We want `External CTCSS` set to `Ignore` (this is where the RDSTAT would be connected, but we are not using that).

We want `COR Type` set to `Normal`. This is an important setting, as it also determines whether de-emphasis takes place, or not. See the [VOTER Audio](./voter-audio.md) page for an explanation of how that works.

We want `DSP/BEW Mode` set to `1` to enable it. 

Finally, we will configure the `Offline Mode Parameters` menu. 

We want to fail over to repeater mode, if we lose connection to the host, so set `Offline Mode` to `3`.

The `CW "Offline"` setting is what the VOTER/RTCM will send when it goes in to offline mode, the repeater callsign should go here.

The `"Offline" (CW ID) Period Time` is how often the repeater will ID in offline mode, set to `18000` to ID every 30 minutes.

Set the `Offline CTCSS Tone` for `100.0Hz` (or your desired TX PL tone). You will want this to be the same as you set in [`voter.conf`](../config/voter_conf.md).

Leave the `Offline CTCSS Level`, for now, it will be adjusted later.

Set the `Offline De-Emphasis Override` to `1 (OVERRIDE)`. `1` is the correct setting for this application.

That should be it for software configuration, remember to save and reboot the VOTER/RTCM.

For hardware settings, in the VOTER/RTCM you will want to make sure that JP1 is IN and JP2 is OUT. When you do the squelch calibration, the VOTER/RTCM should calibrate in about 4-6 blinks, instead of around 12. The `Squelch Noise Gain Value` should be around `43` (versus `93`). JP3 can remain at 1-2, as there is plenty of audio drive by default.

## Alignment
This section is based on using an HP8920 (HP8921) for alignment. Other test sets will differ. You **must** use a test set to properly tune the system... no "doing it by ear".

### Prerequisites
With the configuration above, you should have GPS lock, and the VOTER/RTCM should be connected to the AllStarLink host.

You should have already tuned the pre-selector on the receiver in the station. If not, follow the instructions in the manuals. Pro tip, with the station powered on, look into the receive port with your return loss bridge, and tune for a null (best match).

Do the squelch and diode calibration on the VOTER/RTCM: 

* Ensure the station receive cable is disconnected
* Install JP9/JP10 (VOTER) or turn ON (down) DIP SW2-2 and SW2-3 (RTCM)
* Reset the VOTER/RTCM
* Observe the RX LED blink slowly 4-6 times before going solid
* Remove JP9/10 (VOTER) or turn OFF DIP SW2-2 and SW2-3. The VOTE/RRTCM should reset. Confirm on the status screen (`98`) that the `Squelch Noise Gain Value` is around `43`, and the `Diode Cal. Value` is around `39`.

Set up your test set for Duplex Test.

Connect the RF IN/OUT to the Exciter output. Connect the Duplex Out to the Receiver input.

Duplex Screen Settings:

```
Tune Mode: Manual
Tune Freq: repeater TX frequency
Input Port: RF In
RF Gen Freq: repeater RX frequency
Amplitude: -80dBm (off)
Output Port: Dupl
AFGen1 Freq: 1kHz
AFGen1 To: FM 3.00kHz
AF Anl In: FM Demod
Filter 1: 50Hz HPF
Filter 2: 15kHz LPF
De-emphasis: 750uS
Detector: Pk+-Max
SINAD meter changed to AF Freq meter
```

Confirm that when you turn on the RF Gen, the station keys, and you should get audio demodulating on the test set as audio goes through the Asterisk host and back out. If not, troubleshoot your Asterisk configuration, check your RSS settings, wiring, etc.

### AllStar (Asterisk) Alignment
As mentioned above, we are starting by sending audio through the Asterisk host. 

* Send 1kHz @ 3kHz on-channel in to the receiver
* TX should key and audio should come back
* Use Menu `97` in the VOTER/RTCM to display audio level. Adjust the RX pot on the VOTER/RTCM until the bar graph hits the 3kHz mark
* Adjust the TX pot on the VOTER RTCM for 3kHz measured transmitter deviation on the test set

Sweep the AFGen1 Freq up and down from 1kHz, leaving the deviation at 3kHz, and observe that the transmitter deviation remains around 3kHz between 400-3kHz. The Quantar has pretty sharp filters, so you will see the deviation drop off below 400Hz (very sharply below 300Hz), and it will start to roll off slowly around 1.9kHz (measures around 2.7kHz deviation), but will drop sharply at 3kHz. If the deviation rolls off wildly, you have a setting wrong somewhere, either in the Channel Information in the RSS, or you didn't set the CTCSS tone and a level of `0` in [`voter.conf`](../config/voter_conf.md). 

De-key the station (turn off the RF Gen), and disconnect the GPS to force the VOTER/RTCM in to offline mode. Temporarily set the CTCSS tone to 0.0Hz, save and reboot.

* Turn on the RF Gen
* Send 1kHz at 3kHz deviation in to the receiver
* Confirm TX Deviation is still about 3kHz, tweak the TX pot if needed (or just leave it, it should be close)
* Sweep the AFGen1 Freq up and down as above, and confirm relatively flat deviation of the TX from 400Hz-3kHz, as noted above
* Turn off AFGen1 modulation (set AFGen1 To to OFF)
* Set Filter 1 to &lt;20Hz HPF and Filter 2 to 300Hz LPF to filter on CTCSS only
* Set CTCSS tone in VOTER/RTCM to desired TX CTCSS tone, save and reboot if necessary
* Adjust Offline CTCSS Level as needed to measure around 0.5kHz TX deviation on the test set
* De-key the station, save and reboot the VOTER/RTCM with the final setting

Lastly, we will set the PL deviation from the Asterisk host. Restore the GPS connection to the VOTER/RTCM, and ensure it locks and connects back to the host. The test set should still have the 1kHz modulation turned off, and filters set up to measure PL deviation.

* Key the station
* Set the txctcsslevel to around `55` (should have started at `0`). Reload Asterisk to pick up the change
* Measure TX deviation of the PL tone
* Adjust `txctcsslevel` (and reload Asterisk) until around 0.5kHz TX deviation is measured on the test set
* De-key the station
* Turn on the `plfilter` option in [`voter.conf`](../config/voter_conf.md) (if desired), to filter out user's PL tones, if they are transmitting one

Finally, with nothing connected to the receiver (or probably better, with the station antenna connected to pick up all the site noise), turn the SQL pot on the VOTER/RTCM CCW until the squelch opens. Then, turn the pot about 5 turns CW to tighten the squelch. Adjust as desired from there, you can note the squelch level setting in the Status Menu (`98`).

## Conclusion
That should be it, you should now have a fully functioning VOTER/RTCM AllStarLink interface. Your audio should sound great, and you can customize from here.

If you happen to be lucky enough to have Quantar Satellite Receivers, the process is pretty much the same, except you won't need to do any of the transmitter settings, nor the associated wiring. You really only need power and Aux RX Audio out of J17 to the VOTER/RTCM.

Once you get everything installed, the final thing you will need to do is configure all the buffer settings. See the [VOTER Buffers](./voter-buffers.md) page for the process to do that.
