# simpleusb.conf
`simpleusb.conf` (`/etc/asterisk/simpleusb.conf`) is used to configure SimpleUSB channel driver, `chan_simpleusb`, for use with interfacing a radio interface module (often a C-Media compatible sound card) to `Asterisk/app_rpt`.

This file uses [`config file templating`](../adv-topics/conftmpl.md#asterisk-templates) to allow configuration for multiple devices. The main/default configuration is contained in the `[node-main](!)` stanza. Each device is then configured further in a device-specific stanza (ie. `[1999](node-main)`) to override any of the default settings, as required.

Remember, in [`rpt.conf`](./rpt_conf.md), you will need a directive to use the `chan_simpleusb` channel driver:

```
rxchannel = SimpleUSB/1999
```

The `1999` should match your node number and the corresponding device stanza defined in `simpleusb.conf` that holds all the definitions for your radio interface device.

To use the SimpleUSB channel driver, both the  `chan_simpleusb.so` and `res_usbradio.so` modules (in `/etc/asterisk/modules.conf`) **MUST** be loaded. Using the [`asl-menu`](../user-guide/menu.md) to configure your nodes ensures that the needed channel drivers will be loaded. Check and confirm that they have been changed from `noload` to `load`:

Change from:

```
noload => chan_simpleusb.so         ; CM1xx USB Cards with Radio Interface Channel Driver (No DSP)
noload => res_usbradio.so           ; Required for both simpleusb and usbradio
```

Change to:
```
load => chan_simpleusb.so           ; CM1xx USB Cards with Radio Interface Channel Driver (No DSP)
load => res_usbradio.so             ; Required for both simpleusb and usbradio
```

Restart Asterisk (`sudo systemctl restart asterisk.service`) if changes are made to this file.

## `[general]` Stanza
The `[general]` stanza in `simpleusb.conf` controls the main/global features for the channel driver. Presently, the only options configured in the `[general]` stanza are for the Jitter Buffer (if used), and configuring the parallel port (if available/used).

### Jitterbuffer Configuration
The SimpleUSB channel driver supports the use of an Asterisk Jitterbuffer. These options are typically **not required**, and left commented out. These options add a Jitterbuffer to the *read* side of the channel. This de-jitters the audio stream before it reaches the Asterisk core. This is a write only function.

#### jbenable=
This option enables the use of a jitterbuffer on the receiving side of a SimpleUSB channel. Defaults to `no`. An enabled jitterbuffer will be used only if the sending side can create and the receiving side can not accept jitter. The SimpleUSB channel can't accept jitter, thus an enabled jitterbuffer on the receive SimpleUSB side will always be used if the sending side can create jitter.

Sample:

```
jbenable = yes                      ; enable the jitterbuffer
```

#### jbimpl=
This option determines the jitterbuffer implementation used on the receiving side of a SimpleUSB channel. Two implementations are currently available, `fixed` (with a size always equal to `jbmaxsize`) and `adaptive` (with a variable size, actually the new jb of IAX2). Defaults to `fixed`.

Sample:

```
jbimpl = fixed                      ; use the fixed jitterbuffer implementation
```

#### jbmaxsize=
This option configures the maximum size of the jitterbuffer, in milliseconds. Defaults to `200`(ms).

Sample:

```
jbmaxsize = 200                     ; maximum length of the jitterbuffer in milliseconds.
```

#### jblog=
This option configures whether jitterbuffer frames are logged to `/tmp`. Defaults to `no`.

Sample:

```
jblog = yes                         ; enables jitterbuffer frame logging to /tmp
```

#### jbresyncthreshold=
This option configures the length in milliseconds over which a timestamp difference will result in resyncing the jitterbuffer. Defaults to `1000`(ms). Useful to improve the quality of the voice, with big jumps in/broken timestamps.

Sample:

```
jbresyncthreshold = 1000            ; resynchronize if timestamps are over 1000ms
```

### Parallel Port Configuration
In order to use hardware parallel port pins for general purpose input/output (GPIO), at least one parallel port pin definition ([`pp`](#pp)) must be defined. When using the parallel port, the base address and parallel port device can optionally be defined. See the [Manipulating GPIO](../adv-topics/gpio.md) page for more information on how to control parallel port pins.

#### pbase=
This option sets the base I/O address of the hardware parallel port. The default is `0x378`.

Sample:

```
pbase = 0x378                       ; use the default base address of the first hardware parallel port
```

**This option is not included in the default `usbradio.conf`**

#### pport=
This option sets the parallel port device name. The default is `/dev/parport0`.

Sample:

```
pport =  /dev/parport0             ; use the default device name
```

**This option is not included in the default `usbradio.conf`**

## `[node-main](!)` Stanza
The `[node-main](!)` stanza is the template for all the radio interface devices. It contains all the default values that will be used, if no matching option is specified in the device-specific stanza to override it.

### carrierfrom=
This option sets the source of the COR/COS signal. The default is `no`.

The valid options are:

* `no`: no carrier detection at all
* `usb`: from the COR line on the USB radio interface (active high)
* `usbinvert`: from the COR line on the USB radio interface (active low) - this is the option many devices use
* `pp`: use a defined parallel port pin (active high)
* `ppinvert`: use a defined parallel port pin (active low)

Sample:

```
carrierfrom = usbinvert             ; use COR from USB device (active low)
```

### clipledgpio=
This option sets the GPIO output pin that is to be used for the ADC clip detect ("clipping") indicator. The channel driver checks amplitude and distortion characteristics,
and returns true if clipping was detected. Default is `0` (not used). GPIO `1` is commonly used, as it is often available on C-Media USB devices (including the DMK URI). Sets the GPIO high for 500ms when audio clipping is detected.

Sample:

```
clipledgpio = 1                     ; use the GPIO 1 to drive the clipping indicator 
```


### ctcssfrom=
This option sets the source of the external CTCSS signal. The default is `no`.

The valid options are:

* `no`: no carrier detection at all
* `usb`: from the CTCSS line on the USB radio interface (active high)
* `usbinvert`: from the CTCSS line on the USB radio interface (active low) - this is the option many devices use when CTCSS is used
* `pp`: use a defined parallel port pin (active high)
* `ppinvert`: use a defined parallel port pin (active low)

!!! warning "Disable External CTCSS, if not Used"
    If you are not using external CTCSS logic from your radio, be sure to set `ctcssfrom = no`. Otherwise, the channel driver will be waiting for a valid CTCSS signal before allowing audio to be received from RF by the node. Having `carrierfrom=` and `ctcssfrom=` both set create "AND" squelch logic.

Sample:

```
ctcssfrom = no                      ; disable external CTCSS input
```

### deemphasis=
This option enables the de-emphasis filter to perform standard 6db/octave de-emphasis on received audio. The default is `no`. Set this to `yes` if you are using discriminator audio.

Sample:

```
deemphais = no                      ; set to no when using speaker/line audio out from radio
```

### duplex3=
This option when non-zero connects the receive audio from the radio interface directly to the transmit audio. Default is `0` (disabled). Non-zero values set the gain of the repeat path. The majority of users should leave this set to `0`, as "Duplex Mode 3" is a special application.

Sample:

```
duplex3 = 0                         ; disable duplex3 mode
```

### eeprom=
This option determines if an external EEPROM is present and attached to the USB radio interface in order to save audio configuration values. The default is `1`. Unless you know your USB radio interface has an EEPROM, **this should be set to `0`**. The settings saved in the EEPROM on the radio interface include: `rxmixerset`, `txmixaset`, and `txmixbset`.

Sample:

```
eeprom = 0                          ; no external eeprom present
```

### frags=
This option specifies the number of buffers and buffer size to allocate. This is a 4-byte value. The first 2-bytes specify the number of buffers. The second 2-bytes specify the size of the buffer. The default is `1966092`. Most users should not need to set/alter this setting. See [Sound Card Audio Buffers](#sound-card-audio-buffers) below for further explanation.

**This option is not included in the default `simpleusb.conf`**

### gpio=
This option defines additional GPIOs (if present) on the USB radio interface so that they can be controlled by the user/node. GPIOs can be defined as an input (`in`), an output normally low (`out0`), or an output normally high (`out1`).

Sample:

```
gpio5 = in                          ; set GPIO 3 as an input
gpio6 = out1                        ; set GPIO 6 as a normally high output
```

!!! warning "Some GPIOs In Use"
    Some USB radio interfaces use GPIOs for input/output signals. In particular, GPIO 3 is often used for PTT. Use care when attempting to manipulate additional GPIOs so you don't cause a conflict with a pre-defined signal.

See the [Manipulating GPIO](../adv-topics/gpio.md) page for more information on how to control additional GPIOs.

**This option is not included in the default `simpleusb.conf`**

### hdwtype=
This option defines the type of USB radio interface hardware that is attached. The default is `0`. Leave this set to `0` for USB radio interfaces designed for `app_rpt` or generic modified CM-xxx sound fobs. The available settings are:

* `0`: USB radio interfaces designed for `app_rpt`, "DudeUSB", RIM, URI, or generic modified CM-xxx sound fobs
* `1`: Dingotel/Sph interfaces
* `2`: NHC (N1KDO) interfaces (DudeUSB w/o user GPIO)
* `3`: for a custom interface

Sample:

```
hwtype = 0                          ; generic USB radio interface designed for app_rpt
```

See the [Hardware Type](#hardware-type-hdwtype) section below for more information.

### invertptt=
This option inverts the logic of the PTT signal. The default is `0` (not inverted/active low/ground to transmit). Active low is the desired way to control PTT on an attached radio. Setting this option to `1` means the PTT output is normally held low, and goes high/open to transmit.

Sample:

```
invertptt = 0                       ; ground to transmit
```

!!! warning "Open to Transmit"
    Using "open to transmit" (`invertptt = 1`) is highly discouraged. In this mode of operation, if the radio were to be disconnected from the USB radio interface, it will start transmitting uncontrollably. This is a highly undesirable situation!

### legacyaudioscaling=
This setting is an attempt to match levels to the original CM108 IC which has been out of production for over 10 years. If set to `1`, continue to do raw audio sample scaling and clipping, resulting in transmit audio levels increasing by 0.78dB and receive audio levels increasing by 0-1.5dB. **This should be set to `0` unless you have an existing node with precisely adjusted audio levels and are unable to adjust them.** This parameter and associated scaling/clipping code will be deleted once existing installs have been able to verify their audio levels. The default is `1`.

Sample:

```
legacyaudioscaling = 0              ; do not modify the gain values, recommended for new nodes
```

### pager=
This option sets which channel should be used to send POCSAG paging data. The valid options are `no`, `a` (left), or `b` (right). The default is `no`. 

Sample:

```
pager = b                           ; put normal repeat audio on channel "a", and paging data on channel "b"
```

**This option is not included in the default `simpleusb.conf`**

### plfilter=
This option determines whether the IIR 6 pole High pass filter (300Hz corner with 0.5dB ripple) is inserted in the receive audio path. The default is `no`.

Sample:

```
plfilter = yes                      ; enable the CTCSS (PL) filtering of received audio
```

### pp=
This option configures pins on a hardware parallel port to be used as inputs and/or outputs. Parallel port pins can be used for general purpose inputs and outputs, or they can be used for any of the COR/CTCSS/PTT signals. For general purpose, pins can be defined as an input (`in`), an output normally low (`out0`), or an output normally high (`out1`).

Sample:

```
pp2 = out1                          ; define pin 2 as a general purpose, normally high output
pp6 = ptt                           ; define pin 6 as the PTT output
pp10 = ctcss                        ; define pin 10 as the CTCSS input
pp11 = cor                          ; define pin 11 as the COR input
pp12 = in                           ; define pin 12 as a general purpose input
```

See the [Manipulating GPIO](../adv-topics/gpio.md) page for more information on how to control parallel port pins.

**This option is not included in the default `simpleusb.conf`**

### preemphasis=
This option determines whether to perform standard 6dB/octave pre-emphasis on the transmit audio. The default is `no`. This option is generally set to `no` when connecting the USB radio interface to the microphone input of a transmitter. If you are connecting to the "flat audio" or "digital audio" input of a transmitter, you will likely need to set this option to `yes` to add pre-emphasis to the transmit audio.

Sample:

```
preemphasis = no                    ; do not add pre-emphasis to the transmit audio
```

### queuesize=
This option sets the number of 20ms output buffers to use. The default is `5` (100ms of sound card output buffer).

Sample:

```
queuesize = 20                      ; use a 400ms output buffer
```

Most users should not need to set/alter this setting. See [Sound Card Audio Buffers](#sound-card-audio-buffers) below for further explanation.

**This option is not included in the default `simpleusb.conf`**

### rxboost=
This option sets whether the 20dB attenuator is **removed** from the receive audio path. The default is `no`. This option is generally set to `no` so that audio is attenuated by 20dB, putting it into the range of adjustment by `rxmixerset=`. If the audio level is too low, set `rxboost = yes` to remove the attenuator, and boost the audio by 20dB.

Sample:

```
rxboost = no                        ; do not boost the audio level by 20dB
```

!!! note "CM119B"
    C-Media CM119B devices always have `rxboost=yes`. This setting has no effect with USB radio interfaces using that chip.

### rxondelay=
This option determines the time in milliseconds to delay after the hardware COR goes active, before the signal is considered valid and COR is asserted to `app_rpt`. If `txoffdelay` is also set (non-zero), then the transmitter has to be off for `txoffdelay` **AND** COR has to be active for `rxondelay` before COR is asserted to `app_rpt`. The default is `0`, maximum is 60000 (60000ms = 60s). Leave this setting at `0` or commented out for normal "repeater" or other full duplex nodes.

Sample:

```
rxondelay = 0                       ; assert COR to app_rpt as soon as the hardware COR is valid
```

### txoffdelay=
This option determines the time in milliseconds the transmitter has to be un-keyed before a hardware COR signal is considered valid, and COR is asserted to `app_rpt`. If `rxondelay` is also set (non-zero), then the transmitter has to be off for `txoffdelay` **AND** COR has to be active for `rxondelay` before COR is asserted to `app_rpt`. The default is `0`, maximum is 60000 (60000ms = 60s). Leave this setting at `0` or commented out for normal "repeater" or other full duplex nodes.

Sample:

```
txoffdelay = 0                      ; do not lockout the receiver COR from being asserted
```

## `[node]` Stanza
The `[node]` stanza (ie. `[1999](node-main)`) contains all the custom settings for a particular node number on the server.

* Change `[1999]` to your actual node number that will use the USB radio interface (`node-setup` in `asl-menu` will often do this for you)
* Only place settings here that are **different** than the ones in the `[node-main]` staza that you want to customize for this interface
* The USB radio interface device string will be automatically found if you place `devstr=` here, and leave it empty
* When you run `simple-usb-tune`, the audio settings below will be updated with your adjusted values

### devstr=
This option sets the USB device string to use for the attached radio interface. When `devstr=` is not set, the channel driver will auto-assign an available audio device. See the [USB Audio Interfaces](../adv-topics/usbinterfaces.md) page for more information.

Sample:

```
devstr =                            ; let the channel driver auto-assign a suitable device
```

You can use the [`asl-find-sound`](../mans/asl-find-sound.md) utility to identify suitable device strings for USB interfaces attached to the node.

### rxmixerset=
This setting determines the level of the receive audio from the radio receiver to the channel driver. Present a 1kHz tone at 5kHz deviation into your receiver, and use `simpleusb-tune-menu` to adjust this setting to read 5kHz deviation on the bargraph. Reduce the deviation to 3kHz, and confirm the bargraph also drops to 3kHz. Sweep the audio frequency of the modulating tone above and below 1kHz, and confirm the deviation does not change (otherwise, check your `deemphasis` setting). If you cannot get enough signal from the receiver, you may need to try `rxboost=yes`. The default is 500.

!!! warning "Critical Level"
    This level is critical to set properly, as it determines the level at which you send audio into the AllStarLink network. When set properly, all nodes sound about the same when users connect (or on a hub). If this level is set incorrectly, your node will either sound too quiet or too loud, relative to other nodes. 

### txmixaset=
This setting determines the audio level being sent out of the left ("A") channel of the USB radio interface. Use `simpleusb-tune-menu` to send a test tone. Adjust this parameter until rated system deviation of the attached transmitter is obtained on a service monitor. The default is 500.

### txmixbset=
This setting determines the audio level being sent out of the right ("B") channel of the USB radio interface. Use `simpleusb-tune-menu` to send a test tone. Adjust this parameter until rated system deviation of the attached transmitter is obtained on a service monitor. The default is 500.

## Sound Card Audio Buffers
On some systems, the sound card driver buffers may need to be adjusted. If you see messages like `soundcard_writeframe: Channel usb_1999: Sound device write buffer overflow - used 6 blocks`, the number of allocated buffers is not sufficient. Increasing the `queuesize` may be needed.

The following entries can be added to `simpleusb.conf`:

```
queuesize = 20                      ; number of buffers
frags = 1966092                     ; request 30 buffers (fragments) of size 4096
```

`queuesize` specifies the maximum number of driver buffers that can be used before reporting a buffer overflow. This value should be less than the number of buffers requested with `frags`. The default value is `20`. This should always be `>=2`.

`frags` specifies the number of buffers and buffer size to allocate. This is a 4-byte value. The first 2-bytes specify the number of buffers. The second 2-bytes specify the size of the buffer. The buffer size is 2 raised to the value specified. There are a lot of differences in the way this parameter is supported by different drivers, so you may need to experiment a bit with the value. A good default for Linux is 30 blocks of 64 bytes, which results in 6 frames of 320 bytes (160 samples). FreeBSD works decently with blocks of 256 or 512 bytes, leaving the number unspecified. Note that this only refers to the device buffer size,	this module will then try to keep the length of audio buffered within small constraints.

The default `frags` value is `0x001E000C` (`1966092` decimal).  `0x001E` is `30` decimal. This asks for 30 buffers. `0x000C` is `12` decimal. This requests 2 raised to the power of 12, which is 4096 bytes. The value `1966092` decimal (`0x001E000C`) requests that the sound card driver give `chan_simpleusb` 30 buffers that are 4096 bytes in length.

## Hardware Type (hdwtype=)
The hardware type option (`hdwtype`) sets how `chan_simpleusb` expects different I/O signals to be mapped on the USB radio interface. The valid settings are `0`, `1`, `2`, or `3`. Those are further defined as:

```
hdwtype = 0                         ; USB radio interfaces designed for `app_rpt`, "DudeUSB", RIM, URI, or generic modified CM-xxx sound fobs
VOL DN - COR
VOL UP - EXT CTCSS
GPIO 3 - PTT
VALID GPIOs - 1, 2, 4, 5, 6, 7, 8 (5, 6, 7, 8 for CM-119 only)
```

```
hdwtype = 1                         ; Dingotel/Sph interfaces
GPIO 3 - COR
GPIO 2 - EXT CTCSS
GPIO 4 - PTT
VALID GPIOs - 1
```

```
hdwtype = 2                         ; NHC (N1KDO) interfaces (DudeUSB w/o user GPIO)
VOL DN - COR
VOL UP - EXT CTCSS
GPIO 3 - PTT
VALID GPIOs - 1, 2, 4
```

```
hdwtype = 3                         ; custom version
VOL DN - COR
GPIO 2 - EXT CTCSS
GPIO 3 - PTT
VALID GPIOs - 1
```