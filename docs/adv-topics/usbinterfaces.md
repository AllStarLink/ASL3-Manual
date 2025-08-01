# USB Audio Interfaces
Setting up USB audio interfaces is much easier with ASL3.

 * The USB audio interface "tune" settings have been moved into their respective configuration files, `simpleusb.conf` and `usbradio.conf`. The separate tune files (e.g. `simple-tune-usb1999.conf`) no longer exist
 * The device string is automatically found when the USB setting `devstr =` is empty
 * `rxchannel=SimpleUSB/USB1999` has been changed to `rxchannel=SimpleUSB/1999`. Same for `rxchannel=Radio/1999` for consistency with other `rxchannel=` settings
 * A new [`asl-find-sound`](../mans/asl-find-sound.md) utility can be used to help identify the compatible device strings for attached interfaces
 * We now support the ability to specify vendor and product identifiers (VID and PID) for non-natively supported audio interface chips

The [`asl-menu`](../user-guide/index.md) and Asterisk CLI USB config commands handle these changes.

!!! warning "`devstr=` Auto-assignment"
    Upon initial installation, the `devstr=` option to assign a USB audio device in `simpleusb.conf` and `usbradio.conf` will be blank. The channel driver, when finding no specific device assignment, will automatically assign an available audio device. When a user runs `simpleusb-tune-menu` or `radio-tune-menu`, the "Write (Save) Current Parameter Values" option includes the currently assigned device in the settings saved to the `.conf` file. If this is not desired, you will need to update the configuration files manually to change the `devstr=` to the desired audio device. If you remove an assigned interface from `devstr=` the behavior will, again, be to assign an available audio device.


## USB Interface IC Support
Nearly all USB Interface products that are used with ASL nodes use C-Media CM108 and CM119 USB interface ICs (or their variants). These ICs provide the following features:

 * Two 16-bit DAC audio outputs, capable of driving line level or headphone outputs
 * One 16-bit ADC mic/audio input with switchable mic preamp
 * Internal hardware mixers allowing ADC input and DAC output levels to be adjusted within a range of approximately 40dB, making it easy to optimally match input and output audio levels within the ASL tune utility settings, as well as a mixer allowing input audio to be mixed into output audio with zero latency
 * GPIO lines that support a PTT output, a Status LED, a Clip LED, COS and CTCSS inputs, and one or more additional general-purpose I/O (GPIO) lines that can be controlled by ASL in response to events or DTMF commands
 * Support for an attached EEPROM IC to store user configuration and manufacturer information.

The CM119 provides an additional 4 GPIO lines (GPIOs 5-8) versus the CM108. The original CM108 and CM119 ICs were replaced in the early 2010's with the CM108AH and CM119A. These ICs are still used in many USB Radio Interfaces (URIs). Newer versions of the CM1xx ICs, the CM108B and CM119B, are now available and have some minor differences in gain settings and other specifications, but are fully compatible with the earlier IC versions and with ASL.

### Supported C-Media Chips
ASL3 natively supports C-Media chips with the vendor identifer **(VID)** `0x0d8c` with the following list of product identifiers **(PID)** .

| Chip     | Product Identifier (PID)|
|----------|-------------------------|
| CM-108   | 0x000c, 0x000d, 0x000e, 0x000f |
| CM-108B  | 0x0012 |
| CM-108AH | 0x013c |
| CM-119   | 0x0008 |
| CM-119A  | 0x013a |
| CM-119B  | 0x0013 |
| N1KDO    | 0x6a00 |

There are more variants of the C-Media chips that can be used with ASL3. If your sound card is not natively supported, you can configure ASL3 to recognize your card's vendor id **(VID)** and product id **(PID)**. To determine the vendor id and product id of your sound card, use the `lsusb` command at the Linux CLI prompt.

You will see something similar to the following:

```
Bus 001 Device 003: ID 0d8c:013b C-Media Electronics, Inc. USB PnP Sound Device
```

The vendor identifier **(VID)** is `0d8c` with a product identifier **(PID)** of `013b`.  This chip does not appear in the list of natively supported chips. You can enter this non-natively supported chip in `res_usbradio.conf`.  

!!! note "Multiple VID:PID Entries"
    You can enter multiple VID:PID pairs by separating the pairs with a comma.

Edit `/etc/asterisk/res_usbradio.conf` with your favorite editor. You will see the following:

```
;usb_devices = 1209:7388    ;comma delimited list of usb
                            ;descriptors to allow.
                            ;format vvvv:pppp in hexadecimal
                            ;vvvv=vendor id, pppp=product id
                            ;
                            ;1209:7388 = AIOC (all in one cable)
```

!!! note "AIOC Emulation"
    The All-In-One-Cable (AIOC) uses a default VID:PID of 1209:7388. You can re-program the AIOC with a VID:PID that emulates the C-Media CM-108 chip, or you can just enable the actual VID:PID by un-commenting the above line in `res_usbradio.conf` (and restarting Asterisk).

If your audio interface has a non-supported (but C-Media compatible) chipset then replace `;usb_devices = 1209:7388` line with `usb_devices = vvvv:dddd` (`vvvv:dddd` are the vendor and product IDs). Save your changes and restart Asterisk. The added VID:PID will now be available to the `chan_simpleusb` and `chan_usbradio` channel drivers.

!!! note "`asl-find-sound` and Custom VID:PID"
    The [`asl-find-sound`](../mans/asl-find-sound.md) utility will include the custom VID:PID pairs entered in `res_usbradio.conf`.

## Setting Audio Levels
When setting up a new node, or if any changes have been made such as use of a different radio, microphone, other audio hardware, or gain settings, checking and setting audio levels is **very important**. 

If you have a radio attached to your node, you are **stongly encouraged** to tune your audio settings (and this your transmit deviation) using a communications service monitor. Failure to do so can easily result in you modulating distorted audio, as well as potentially causing adjacent channel interference due to excessive deviation or splatter. 

Radio equipment such as HTs or mobile radios, and many electronics products such as VOIP phones often restrict end-user audio adjustment capabilities to ensure consistent audio levels. AllStarLink nodes and USB interfaces however, generally allow greater flexibility and thus extra attention is required to be sure your audio interface gains are properly matched to the external audio input and output levels. Failure to calibrate your audio levels could mean your node is much quieter or louder than it should be when linked to other nodes, which could be disruptive to other users and systems. It can also mean that the signal from your RF transmitter may cause interference with other radio systems, which carries serious consequences from spectrum regulators.

Many nodes use the `SimpleUSB` channel driver (`chan_simpleusb`). Nodes that require more advanced features such as DSP squelch detection, CTCSS tone encode/decode, or additional audio filtering options may use the `USBRadio` channel driver (`chan_usbradio`). These channel drivers both have tune utilities for setting audio levels and other functions. Once a node has been configured in the [`asl-menu`](../user-guide/index.md) **Node Settings**, you will end up in the appropriate tune application. The following options should then be used to check and optimize audio level settings:

!!! warning "Disconnect from Other Nodes" 
    Be sure you are not connected to any other nodes when doing any of the following tests and adjustments.

* `Set Rx Voice Level (using display)` provides a level meter. Talk at a normal and steady volume into the microphone and be sure that the average level does not go past the "3KHz" point, and that peak levels do not go significantly past the "5KHz" point. Note that for proper mic technique you should talk no closer than 2 to 3 inches (5 - 10 cm) from the microphone, and it should be held at an angle to minimize pops/plosives. Once you see where the audio levels are, hit the Enter key and you'll then be prompted to change the setting. If for example the current setting is 500 and your levels were too high, try entering 400 for a new value and then repeat the test. Continue to iteratively adjust the settings until the average audio levels stay around the "3KHz" mark. For a more precise calibration with radio nodes a 1KHz test tone can be input into another radio at a level that results in 3KHz FM deviation, then calibrate the node to the 3KHz mark, however this can be more complicated to set up and may not account for other differences such as different mics or mic gain settings.
* `Set Transmit A Level`, `Set Transmit B Level` (or `Set Transmit Voice Level` for USBRadio) allow the node audio output levels to be set. For nodes connected to a radio transceiver the level should be set such that the transmitted FM deviation is no higher than 3KHz, and the audio does not sound distorted or overly loud. When listening on another radio it can also be helpful to confirm the audio levels from your node sound about the same as levels on FM repeaters in your area.
* `Toggle RX Boost` enables a preamp in the CM1xx for use with very low mic-level input signals. This should be disabled in almost all cases.
* `View Rx Audio Statistics` shows precise audio level information. If when running this option and talking at a normal to loud volume into your mic, you see `Pk` levels of any higher than -3.0 dBFS, `Avg Pwr` levels of higher than -12 dBFS, or any `ClipCnt` value greater than 0, you should reduce your rxmix setting (using the `Set Rx Voice Level` menu option), and then repeat this step. "dBFS" is a logarithmic unit of measurement, where 0dBFS equals the Full-Scale (largest possible) value of a digital signal. Digital signals cannot exceed 0dBFS. If an Analog-to-Digital Converter (ADC) is over driven, clipping, distortion and greatly reduced audio quality results.
* `Toggle Echo Mode` will record each of your transmissions and echo ("parrot") back to you. After setting your levels with the above menu options first, echo tests are the final step to confirm your audio is clear and intelligible. If anything does not sound right or you have any questions be sure to visit the AllStarLink Community for additional help. When done with Echo Mode testing don't forget to disable it. DTMF commands can be enabled to make it easy to do echo testing any time. To enable `parrot mode` DTMF commands uncomment the 3 lines in `/etc/asterisk/rpt.conf` that start with `921 =`, `922 =`, and `923 =`. Then, restart Asterisk or reboot the node. Entering `*921` on a DTMF keypad will then enable parrot mode and `*922` will disable it.
* `Print Current Parameter Values` shows the current audio level settings.
* `Write (Save) Current Parameter Values` saves any changed settings to disk. Be sure to execute this option before exiting the menu if you have changed any settings and want those to be the new defaults.
 
The tune utilities can also be run from the command line without needing to use [`asl-menu`](../user-guide/index.md). For SimpleUSB run `sudo /usr/sbin/simpleusb-tune-menu` or for USBRadio run `sudo /usr/sbin/radio-tune-menu`.

## EEPROM Operation
The SimpleUSB and USBRadio channel drivers allow users to store configuration information in an EEPROM IC attached to the C-Media CM1xx USB Interface IC. The CM119A can have manufacturer information in the same area that stores the user configuration. The CM119B does not have manufacturer data in the area that stores user configuration. The manufacturer data cannot be overwritten. The user configuration data has been moved higher in memory to prevent overwriting the manufacturer data. If you use the EEPROM to store configuration data, you'll need to save it to the EEPROM after upgrading. Use `susb tune save` or `radio tune save` in the Asterisk CLI.
