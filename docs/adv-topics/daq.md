# DAQ Subsystem
**The DAQ subsystem code is unsupported, and is documented for reference only. Most of the information below comes from interpreting the source code.**

There is support in `rpt.conf` that interfaces with a Digital Acquisition device (DAQ).

It appears that the DAQ subsystem was probably written to interface to the [Starting Point Systems uChameleon(v1) DAQ](http://www.starting-point-systems.com/products.html). It appears that they still sell the [Version 2](http://www.starting-point-systems.com/specs.html), but the Version 1 has been discontinued, and they have no links to the documentation for it. 

The user manual for the uChameleon2 has been [archived here](https://wiki.allstarlink.org/images/2/21/MuChameleon2_Users_Manual.pdf), in case the manufacturer's website disappears.

The reasoning for suspecting the code was written for the Version 1 DAQ is that `rpt_uchameleon.c` expects the device to return an identification of `id Chameleon`, but according to the manual, the Version 2 DAQ should respond with `id μChameleon2`. Code inspection also leads to configuration commands that match the User Manual.

A function call to this system would appear to use the following syntax:

```
dtmfcommand=meter,device,channel,meter-face,[filter]
```

This is similar to the way you would invoke a [`cop`](./rpt_conf.md/#cop-commands) or [`ilink`](./rpt_conf.md/#link-commands) command.

Sample:
```
98 = meter,daq-cham-1,1,batvolts
```

The above example would query the dac-cham-1 device (defined in the `[daq-list]` stanza), on channel 1 (an analog input (inadc) channel), and invoke the batvolts `[meter-face]`, which should then play out over the air, 'The voltage is ? volts.".

The `device` and i/o pin parameters for the `channel` are defined in the [`[daq-list]`](#daq-list-stanza) stanza.

The `meter-face` to be called is defined in the [`[meter-face]`](#meter-faces-stanza) stanza.

The `filter` parameter is optional, and can be one of the following:

* none
* max
* min
* stmin
* stmax
* stavg

The stmin, stmax, and stavg are short-term min, max, and average, respectively.

In addition to being able to read a value and say it over the air with the meter function, it also appears that the DAQ subsystem can be used as a rudimentary [alarm system](#alarms-stanza).

**NOTE:** The DAQ only initializes when Asterisk is restarted (NOT on a reload from the console). If you make any config changes in `rpt.conf`, you will need to restart Asterisk completely to pick up the changes.

**NOTE:** Make sure to place the following configuration stanzas in the configuration for your node (either the main configuration, or your node-specific configuration). By default in the current `rpt.conf`, they exist down near the bottom of the file, and they can never be reached to be parsed (as they exist outside a configured node stanza).

## DAQ List Stanza
The `[daq-list]` stanza defines the available DAQ devices, and the i/o pin configuration for each channel.

```
; Data Acquisition configuration
[daq-list]
;device = device_name1
;device = device_name2
;Where: device_name1 and device_name2 are stanzas you define in this file

device = daq-cham-1

; Device name
[daq-cham-1]				    ; Defined in [daq-list]
hwtype = uchameleon			; DAQ hardware type
devnode = /dev/ttyUSB0	; DAQ device node (if required)
1 = inadc				        ; Pin definition for an ADC channel
2 = inadc
3 = inadc
4 = inadc
5 = inadc
6 = inadc
7 = inadc
8 = inadc
9 = inp				          ; Pin definition for an input with a weak pullup resistor
10 = inp
11 = inp
12 = inp
13 = in				          ; Pin definition for an input without a weak pullup resistor
14 = out				        ; Pin definition for an output
15 = out
16 = out
17 = out
18 = out
```

**These stanzas may normally appear in `rpt.conf` by default.**

## Meter Faces Stanza
Meter faces are used in conjunction with the [meter function call](#daq-subsystem) to play a message over the air with the value read from the DAQ device.

The meter faces are configured in the `[meter-faces]` stanza:

```
[meter-faces]

; face = [scale|range|bit],[parameters],[words],?,[words]
;
;face = scale(scalepre,scalediv,scalepost),word/?,...
;
; scalepre = offset to add before dividing with scalediv
; scalediv = full scale/number of whole units (e.g. 256/20 or 12.8 for 20 volts). MUST be >1.
; scalepost = offset to add after dividing with scalediv
;
;face = range(X-Y:word,X2-Y2:word,...),word/?,...
;
;face = bit(low-word,high-word),word/?,...
;
; word/? is either a word in /var/lib/asterisk/sounds or one of its subdirectories,
; or a question mark which is  a placeholder for the measured value.
;
;
; Battery voltage 0-20 volts
batvolts = scale(0,12.8,0),rpt/thevoltageis,?,ha/volts
; 4 quadrant wind direction
;winddir = range(0-33:north,34-96:west,97-160:south,161-224:east,225-255:north),rpt/thewindis,?
; LM34 temperature sensor with 130 deg. F full scale
;lm34f = scale(0,1.969,0),rpt/thetemperatureis,?,degrees,fahrenheit
; Status poll (non alarmed)
;light = bit(ha/off,ha/on),ha/light,?
```

The `face` is any variable name you desire (must match the call from the `meter function call`).

The meter face type can be any one of `scale`, `range`, or `bit`.

The `scale` meter face takes the following options:

* scalepre = offset to add before dividing with scalediv
* scalediv = full scale/number of whole units (e.g. 256/20 or 12.8 for 20 volts). MUST be >1.
* scalepost = offset to add after dividing with scalediv

The `bit` meter face takes two options:

* low-word = the sound file to play when the bit is 0
* high-word = the sound file to play when the bit is 1

All of the meter faces then will play a list of comma-seperated words. Place a ? where you would like the value from the DAQ to be inserted.

**This stanza may not normally appear in `rpt.conf` by default.**

## Alarms Stanza
The DAQ subsystem can apparently monitor inputs from the DAQ device for a change of state, and then invoke a DTMF function (macro?) on a high to low and/or low to high transition.

The alarms are configured in the `[alarm]` stanza:

```
[alarms]
;
;tag = device,pin,ignorefirst,node,func-low,func-hi
;
;tag = a unique name for the alarm
;device = DAQ device to poll
;pin = the device pin to be monitored
;ignorefirstalarm = set to 1 to throwaway first alarm event, or 0 to report it
;node = the node number to execute the function on
;func-low = the DTMF function to execute on a high to low transition
;func-high = the DTMF function to execute on a low to high transition
;
; a  '-' as a function name is shorthand for no-operation
;
door = daq-cham-1,9,1,2017,*7,-
;pwrfail = daq-cham-1,10,0,2017,*911111,-
```

The above should be self-explanatory. You would need to configure a DAQ device in the [`[daq-list]`](#daq-list-stanza) stanza.

In the above example, a door alarm (just a friendly label, not used for anything else) on `daq-cham-1` pin `9` would execute macro `*7` on node `2017` on a high to low transition of the pin. It would ignore the first occurance of this alarm, but if it persists the next time the alarm system is polled, it would execute (no idea how often that is). 

**This stanza may not normally appear in `rpt.conf` by default.**