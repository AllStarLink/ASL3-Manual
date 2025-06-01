# VOTER Audio
Audio is critical component of proper VOTER/RTCM operation, as well as node operation in general. This is an extensive topic, with lots of caveats. So, we will lay it all out here.

Before we get in to the different ways audio is routed, there is an important consideration you need to make if you are using the RTCM/VOTER for voting. 

The way the voting process works, it needs **discriminator audio** to determine the signal to noise level from each satellite receiver. As such, you will **need** to be feeding discriminator audio into the RX audio pin, so that the hardware/software can vote properly. That means you also **need** to let the hardware/software (VOTER/RTCM) do the squelch action.

If you **need** RX CTCSS, you'll **need** to feed logic from an external CTCSS decoder (ie an output from your radio) into the External CTCSS input pin.

Also, **don't disable COR in the RTCM/VOTER**... *it will cause it to disable the squelch and it will report an RSSI of 255 (full quieting) for all received signals*. Setting COR to Ignore is only used in "General-purpose" mode, and allows you to feed processed audio in (instead of discriminator audio), as long as you are also sending COR (and/or) CTCSS in to the External CTCSS input to control the squelch (externally).

The RTCM/VOTER is **totally flexible** regarding emphasis. Although the way it is set is **completely obscure**. It tries to automatically do the right thing for you, which is great, most of the time. But when it’s not, it's hard to know what is going on. 

If you are changing the COR Type settings, or using `nodeemp` in [`voter.conf`](../config/voter_conf.md), make sure you save/reboot the RTCM/VOTER **every** time you make a change... changes are **not** effective until the RTCM/VOTER reboots!

## Chuck Squelch 
Early versions of firmware had flavors that included "Chuck Squelch". That is no longer a option, as "Chuck Squelch" is now the standard. 

"Chuck Squelch" relates to firmware changes made by Chuck Henderson, WB9UUS.

One of the changes fixes an issue with weak signals producing RSSI readings all over the place. It is caused by a 16 bit value that was overflowing (it is the RSSI change in the firmware). It results in rock-solid RSSI values being reported, even on barely or non-readable signals. 

The other firmware change changes how the squelch responds (it looks at the noise in the last two audio samples) and makes the two-stage "Micor squelch" action work better.

Since the original squelch code was buggy, it has been removed (and "Chuck Squelch" is now used in its place).

## DSP/BEW Firmware Version
If you look in the [AllStarLink GitHub Repository](https://github.com/AllStarLink/Voter/tree/master/VOTER_RTCM-firmware/firmware-images), you will see there are *BEW* versions of the firmware.

DSP BEW Firmware is mutually exclusive with the diagnostic menu. There is not enough space for both, if you load the DSP/BEW firmware, you will **NOT** have a diag menu.

BEW stands for **B**aseband **E**xamination **W**indow.

Typically, the discriminator of an FM communications receiver produces results containing audio spectrum from the "sub-audible" range (typically < 100 Hz) to well above frequencies able to be produced by modulating audio. These higher frequencies can be utilized to determine signal quality, since they can only contain noise (or no noise, if a sufficiently strong signal is present).

As is done in the VOTER, if you filter and rectify this broadband noise, you get a DC voltage. A noisy signal will produce a large DC voltage, a full-quieting signal will produce a small DC voltage. 

For receivers (such as the Motorola Quantar, etc.) that do not provide sufficient spectral content at these "noise" frequencies (for various reasons), the "DSP/BEW" feature of the firmware may be utilized. 

These receivers are perfectly capable of providing valid "noise" signal with **no modulation** on the input of the receiver, but with **strong modulation** (high frequency audio and high deviation, ie. voice), it **severely interferes** with proper analysis of signal strength.

This feature provides a means by which a "window" of baseband (normal audio range) signal is examined by a DSP, and a determination of whether or not sufficient audio is present to cause interference of proper signal strength is made. During the VERY brief periods of time when it is determined that sufficient audio is present to cause interference, the signal strength value is "held" (the last valid value previous to the time of interference) until such time that the interfering audio is no longer present.  

The DSP/BEW feature is selectable, and **should not** normally be used for a receiver that does not need it (squelch will perform better on a *normal* receiver that has lots of frequency response).

A note on the Motorola SLR5700 per VE7FET. DSP/BEW definitely makes a difference on what Allmon reports for the signal strength of received signals. It is less reactive when DSP/BEW = 1 than with it set to 0, which is expected. The SLR5700 can be generally categorized with the Quantar in how it processes audio.

## Receiver De-emphasis
On the receive audio side, the `COR Type` setting in the RTCM/VOTER determines whether the de-emphasis filter is used for receive audio. 

`COR Type 0=Normal` means the RTCM/VOTER squelch circuit *is* in use and it is expecting discriminator audio on the receive audio pin (to be able to do the squelch action), and therefore it **will** provide de-emphasis (audio is routed THROUGH the de-emphasis RC filter circuit) to the receiver audio. 

`COR Type 1=IGNORE COR` uses the CTCSS input pin for COR or CTCSS *logic* and it then expects de-emphasized receive (line, speaker, processed, etc.) audio on the receive audio pin, and therefore will **not** provide de-emphasis to the received audio (the RC filter is switched **out** and audio passes straight through). This **cannot** be used in voting/simulcast applications, and is only usable in "General-purpose" applications.

Most of the time, you do **not** need to override the automatic filter selection. However, if you do, and you are sure you have a good reason to, you *can* switch the de-emphasis filter **out** of the circuit so that audio passes straight through to the encoder. You would do this by setting the `nodeemp=1` option in [`voter.conf`](../config/voter_conf.md). When you set `nodeemp=1`, the [VOTER Protocol](./voter-protocol.md) tells the RTCM/VOTER to switch the filter **out**, so audio is passed straight through.

## Transmitter Pre-emphasis
On the transmit audio side, the RTCM/VOTER normally expects to connect to the transmitter's **external audio** or **microphone audio** input. In other words, the **transmitter** is providing the pre-emphasis, limiting, and splatter filtering, not the RTCM/VOTER (you are **not** directly modulating the transmitter). The **transmitter** would also be responsible for generating any CTCSS that is required.

If, on the other hand, you do need to connect directly to the modulator (auxiliary modulation input, 9600 baud transmit input, flat audio input, etc.), that can be accomplished, see the next section about CTCSS.

If a CTCSS tone **and** level are defined in [`voter.conf`](../config/voter_conf.md), the RTCM/VOTER **will** provide pre-emphasis to the audio, and expects that you will be connecting to your repeater's flat audio input (direct modulation).

!!! warning "Transmitter Audio Processing"
    In this state, even though the VOTER/RTCM is providing the pre-emphasis, typically you may still have bypassed the limiter and splatter filter by injecting audio direct to the modulator. You need to **FULLY** understand how audio is processed in your radio if you go this route, or you WILL cause adjacent channel interference!

If you don’t want a TX CTCSS tone but **do** need pre-emphasis, set an arbitrary (any) CTCSS tone in [`voter.conf`](../config/voter_conf.md), and set the level to **0**. This will force the RTCM/VOTER to pre-emphasize the audio it generates on the TX pin, but it won't actually mix in a CTCSS tone.

## Transmit CTCSS
If transmit CTCSS is desired or you have a need to connect directly to your modulator anyways, the `txctcss` and `txctcsslevel` (and optionally the `txtoctype`) parameters **must** be specified in your [`voter.conf`](../config/voter_conf.md). In order to facilitate generation and transmission of CTCSS along with the normal system audio, the VOTER/RTCM client (and host) generate “flat” (pre-emphasized/limited) audio, which is intended to directly modulate a transmitter (to be applied at a direct modulation point, **not** a line level or microphone input, as in most VOTER/RTCM applications). 

The `txctcss` parameter specifies the transmit CTCSS frequency in Hertz. The `txctcsslevel` specifies the arbitrary level of the CTCSS tone (0-250). Optionally, the `txtoctype` parameter may be specified, which determines the “turn-off” (when transmitter un-keys) style for the CTCSS. Setting this parameter to:

* `none` (default) - means that the transmitter immediately stops transmitting when the system “un-keys”
* `phase` - means that the CTCSS tone will briefly be transmitted 120 degrees out of phase when the system “un-keys” (also known as “reverse-burst”, etc)
* `notone` - means the transmitter will continue transmitting for a brief period with no CTCSS after the system “un-keys” (also known as “chicken-burst”).

If transmit CTCSS is not desired, **DO NOT specify ANY** of the `txctcss` ,`txctcsslevel` or `txtoctype` parameters. The audio that is produced by the VOTER/RTCM hardware (and the host) will therefore be *normal line-level* (intended for an external audio or microphone input) and will **not** be pre-emphasized (as this would be done in the **RADIO**). 

!!! note "Transmit Audio Processing"
    MAKE SURE YOU UNDERSTAND THIS BECAUSE IT AFFECTS HOW YOU HOOK UP TRANSMIT AUDIO TO YOUR TRANSMITTER!

!!! note "No Tone"
    It *is* a valid configuration to hook up the VOTER/RTCM hardware directly to your transmitter modulator and specify a `txctcss=<some tone>` and `txctcsslevel=0` (or some other very small value). This will have the effect of NOT actually transmitting a CTCSS tone, but leaving you the option to do so down the road, without having to change the wiring to the radio and re-align the levels. In this application, pre-emphasis is done by the VOTER system (in software), as noted above. You MAY want to consider this if you are using the "offline repeat" function of the VOTER/RTCM hardware to keep your repeater on the air, in the event of a loss of connection between the VOTER client connected to the transmitter (with associated receiver, of course) and the Asterisk VOTER host.

## Level Setting
There are multiple requirements for setting up audio levels, depending on your application.

### Asterisk
In all applications, you will need to set levels through Asterisk... that's why you're using this solution, right?

Ensure you have a connection to your Asterisk host properly configured (proper configuration in [`rpt.conf`](../config/rpt_conf.md) and [`voter.conf`](../config/voter_conf.md)). Remember, if you make changes to these files while making adjustments, you will need to ***restart Asterisk*** or do a `voter reload` from the Asterisk Command Line Interface.

Connect your service monitor to generate a signal in to the receiver, and measure the deviation of the transmitter.

#### No CTCSS Generated By Asterisk
To set the audio levels:

* Send a 1kHz@3kHz on-channel, full-quieting, signal into the repeater's receiver
* Use [Menu 97](./voter-menus.md#97-rx-level-display) on the RTCM/VOTER to display the receive level.
* Adjust the RX Input Level potentiometer until the bar graph reaches (matches) 3kHz
* Now set the TX Level potentiometer to get 3kHz out of the transmitter (ensure any CTCSS in your transmitter is turned off)

As a final check, change the modulation from 1kHz tone to 800Hz followed by 1.8kHz and verify that the deviation level doesn't change as the tone frequency changes. **Changing levels indicates a pre/de-emphasis issue.** You will want to read the above sections on how audio is handled, and figure out where your issue is.

If you are transmitting CTCSS with your transmitter you have to account for that deviation, unless you filter it out with your service monitor.

#### CTCSS Generated by Asterisk
The requisite settings in your [`voter.conf`](../config/voter_conf.md) file are:

```
txctcss = 136.5                 ; set to your desired tone frequency in Hz
txctcsslevel = 47               ; ***this is a calibrated value, DO NOT CHANGE once set***
txtoctype = phase               ; configure for your turn-off style
```

To set the audio levels:

* Start with `txctcsslevel` in [`voter.conf`](../config/voter_conf.md) set to 0
* Set the `txctcss` and `txtoctype` options in [`voter.conf`](../config/voter_conf.md) as necessary for your application
* Send a 1kHz@3kHz on-channel, full-quieting, signal in to the repeater's receiver
* Use [Menu 97](./voter-menus.md#97-rx-level-display) on the RTCM/VOTER to display the receive level
* Adjust the RX Input Level potentiometer until the bar graph reaches (matches) 3kHz
* Set the TX Level potentiometer to get 3kHz out of the transmitter
* Turn off the modulation (1kHz tone) that you are sending in to the receiver, so that you are just sending carrier
* Now, go change the `txctcsslevel` in [`voter.conf`](../config/voter_conf.md) to some arbitrary number (and remember to restart Asterisk)
* Measure the deviation of the CTCSS tone being transmitted (turn on your 300Hz LPF in your service monitor, if applicable)
* Keep adjusting the level in [`voter.conf`](../config/voter_conf.md), until you get about 500Hz of deviation of the CTCSS tone

As a final check, turn the 1kHz tone back on, and change the modulation from 1kHz tone to 800Hz followed by 1.8kHz and verify that the deviation level doesn't change as the tone frequency changes. **Changing levels indicates a pre/de-emphasis issue.** You will want to read the above sections on how audio is handled, and figure out where your issue is.

### Offline Repeat
Optionally, if you are using the built-in "offline repeat" functions, fail the connection to the host Asterisk server (pull the LAN cable), and make sure your repeat audio performs the same as above.

```
OffLine Mode Parameters Menu

Select the following values to View/Modify:

1  - Offline Mode (0=NONE, 1=Simplex, 2=Simplex w/Trigger, 3=Repeater) (3)
2  - CW Speed (400) (1/8000 secs)
3  - Pre-CW Delay (4000) (1/8000 secs)
4  - Post-CW Delay (4000) (1/8000 secs)
5  - CW "Offline" (ID) String (N0CALL/R)
6  - CW "Online" String (OK)
7  - "Offline" (CW ID) Period Time (18000) (1/10 secs)
8  - Offline Repeat Hang Time (15) (1/10 secs)
9  - Offline CTCSS Tone (136.5) Hz
10 - Offline CTCSS Level (0-32767) (0)
11 - Offline De-Emphasis Override (0=NORMAL, 1=OVERRIDE) (1)
99 - Save Values to EEPROM
x  - Exit OffLine Mode Parameter Menu (back to main menu)
q  - Disconnect Remote Console Session, r - reboot system

Enter Selection (1-9,99,c,x,q,r) :
```

* Ensure that the `Offline Mode` is set to `3`
* `Offline CTCSS Tone` should be set to any valid tone (doesn't really matter) but `Offline CTCSS Level` **must** be set to `0`
* `Offline De-Emphasis Override` will depend on how you have your **transmit audio** coupled to your transmitter
    * If you are using microphone audio input (so that the audio gets pre-emphasized and splatter filtered), this would be set to `0`
    * If however, you are using an auxiliary modulation input that goes direct to the modulator (because you may want the VOTER/RTCM to generate CTCSS), then this would be set to `1`. In *normal* (0) mode, receive audio **will** be de-emphasized, as the VOTER/RTCM is expecting the **transmit** audio to be connected to the microphone input. In *override* (1) mode, receive audio will **not** be de-emphasized, as the VOTER/RTCM is expecting that the **transmit** audio is connected directly to the modulator (with no pre-emphasis); as such, the receiver audio would already be pre-emphasized (from the user's radio), and just needs to be sent to the transmitter (avoiding "double pre-emphasis")
* If you are going to generate CTCSS in the VOTER/RTCM (or `chan_voter` via [`voter.conf`](../config/voter_conf.md)), you will need to connect your transmit audio directly to the modulator... so for OffLine mode, you're probably going to want to set this to `1=Override (1)`
* With the Ethernet cable removed (so there is no connection to the host), applying a 1kHz tone at 3kHz deviation should cause the VOTER/RTCM to key the transmitter (in offline mode)
* Adjust the Transmit Level potentiometer to set the transmitter deviation to 3kHz (3kHz in, 3kHz out)
* Now change the modulation from 1kHz tone to 800Hz followed by 1.8kHz and verify that the deviation level doesn't change as the tone frequency changes. **Changing levels indicates a pre/de-emphasis issue.** You will want to read the above sections on how audio is handled, and figure out where your issue is (maybe you need to toggle the `Offline De-emphasis Override`).

If you are going to set the CTCSS Level, remove the modulating tone from your signal generator and, if applicable, set your service monitor filters to 300Hz LPF.

* Adjust the `Offline CTCSS Level` to get about 500Hz of deviation of your desired CTCSS tone
* Remember to `save (99)` and probably `reboot (r)`, to make sure all the changes are effective
* Remove the receiver signal when you are complete.

At this point, if you have a properly configured AllStarLink host (including settings in [`voter.conf`](../config/voter_conf.md)), re-connecting the Ethernet cable to the VOTER should restore the connection to the host and exit Offline mode. Ensure that the connection to the host is established. Now, when you send your 1kHz at 3kHz deviation in to the receiver, it should come out the transmitter at 3kHz deviation as well.

## Troubleshooting

### "Sensitive" Transmit Audio Adjustment
With some combinations of VOTER/RTCM boards and radios, getting a good enough resolution with R61 when setting levels is a problem. You move a small amount on the pot and it jumps several hundred Hertz of deviation. Inserting a 4:1 voltage divider between the VOTER board and transmitter helps with this. Something such as a 1K and 330 ohm resistor will work. This allows for much finer adjustment on the transmit audio (R61).

### "Crappy" Transmit Audio
Does your repeated audio sounded really bassy, muffled, and not very understandable? 

There was a situation where, compared to a typical simplex radio-to-radio transmission, the audio through the repeater (VOTER/RTCM and Asterisk) was unacceptable. What was discovered was that the VOTER/RTCM's internal pre-emphasis function was disabled. 

The user had intentionally disabled `txctcss` and `txctcsslevel` in [`voter.conf`](../config/voter_conf.md) because he didn't want the VOTER/RTCM transmitting CTCSS (the Quantar was doing that already). He ultimately found a post on the mail list explaining the settings above that said enabling `txctcss = <some valid tone>` (114.8 in his case) and setting `txctcsslevel = 0` would turn on the pre-emphasis function in the VOTER/RTCM without transmitting CTCSS tones. Yup.

He did, and it worked like a charm! Audio now had more treble and was less bassy/muffled (because the audio was now being properly pre-emphasized).

Hence the note above in audio level setting about changing the modulating tone, and seeing if the deviation changes.

### Pulse Noise on Transmit Audio
It has been noticed sometimes on built VOTER boards that it has low level DAC noise which sometimes is apparent as a pulsing noise on the audio output. Adding a 4:1 voltage divider inline between the transmitter and VOTER board helps reduce or eliminate this as described above.

### Squelch Issues
Troubleshooting squelch issues:

* If anyone is off frequency a little bit, that will make the voice talk off worse. Double check that the repeater and the users are all on frequency
* Don't use narrow bandwidth on the repeater receiver
* Make sure that the discriminator audio is not rolled off even a little bit at the high end. There should not be any resistors in series or capacitors to ground between the discriminator chip output pin and the VOTER/RTCM board input, for best results. If your audio does not have enough "high-end" noise, you may need to try using the DSP/BEW firmware option.

