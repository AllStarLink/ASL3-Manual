# Manipulating GPIO
There are 2 types of GPIO as they currently exist in the software. I/O's from a URI/sound fob or equivalent, and I/O's from a hardware driven Parallel Port.

!!! warning "USB Parallel Ports Not Supported"
        USB converted parallel ports can not be bit-banged for control, and are therefore not supported.

## URIs/USB Sound Fobs (CM108, CM119)
The GPIO (general-purpose I/O) pins on a URI (or similar USB device using a C-Media chip) may be individually used as either input or output pins. Not all pins are available for control, some may be reserved for existing functions. Check the datasheet for your particular chip and/or the manufacturer's documentation for the radio interface, to see what pins may be available for GPIO.

`chan_usbradio` and `chan_simpleusb` support configuration of the GPIO pins in the following manner (from within the section of `usbradio.conf` or `simpleusb.conf` that is for the desired device):

```
gpio1 = in                          ; in, out0 or out1
gpio4 = out0                        ; in, out0 or out1
```

When you configure a GPIO pin, you can either designate it as `in` (input), `out0` (output with a default state of `off`), or `out1` (output with a default state of `on`).

## Parallel Port
Parallel port pins 2-9 can be used for outputs, and pins 10-13 and 15 can be used for inputs. Pins 18-25 are ground, and all other pins are to be treated as no connection.

!!! warning "Check Your Hardware"
    There are many different types of parallel ports, check your pins with a DVM and proceed carefully so that you don't damage your hardware. Outputs may switch between Vcc and GND, inputs may have internal pull-up resistors. It is quite likely that your input pins will have a pull-up to Vcc, will be active-low (ground to activate), and therefore require `ppinvert` to function correctly.

!!! warning "Beware of Pin 4"
    Pin 4 (output) MAY go high when your computer boots, until Asterisk starts. Consider this if you are using this pin as an output, as it could lead to unanticipated results with your attached hardware.

!!! note "Doug Hall RBI-1"
    If you imagine you might use a Doug Hall RBI-1 interface, then use Parallel Port pins starting **after** `pp4` as the first three (`pp2`, `pp3`, and `pp4`) would be used for that device, and is unchangeable.

### Port Configuration
There are a few places that the parallel port can be configured. The defaults are to use base address `0x378` (LPT1) and device `/dev/parport0`. These settings can be overridden.

If you are using the [Remote Base](./remotebase.md) features, then you can override the base address with the [`iobase=`](../config/rpt_conf.md#iobase) option in [`rpt.conf`](../config/rpt_conf.md).

If you are using the parallel port for general purpose I/O, or for COR/PTT, then you can override the base address and device in `simpleusb.conf` or `usbradio.conf` depending on which channel driver you are using.  

### Enable Pins
The pins you want to use (input or output) need to be defined in `simpleusb.conf` or `usbradio.conf`, depending on which channel driver you are using.

!!! warning "Enable at Least One Pin"
    In order for the parallel port to be active, at least one pin must be defined in either `simpleusb.conf` or `usbradio.conf`, **even if you are not going to use them for PTT or COR.**

To define a pin as an input (pp10 to pp13, or pp15), it needs to use the `in` keyword:

Sample:

```
pp10 = in                           ; use pin 20 as an input
```

To define a pin as an output (pp2 to pp9), it needs to use either of the keywords: `out0`, or `out1`. The `out0` keyword initializes the pin in the `off` state, whereas `out1` will initialized the pin in the `on` state.

Sample:

```
pp2 = out1                          ; use pin 2 as an output, and turn it on by default
pp9 = out0                          ; use pin 9 as an output, and turn it off by default
```

### Parallel Port Pins for COR/CTCSS/PTT
When you configure an input pin (10,11,12,13 or 15), you can either designate it as `cor` (RX input signal) or `ctcss` (use as the "CTCSS tone valid" signal). 

If you choose `cor` or `ctcss`, you also need to set the associated `carrierfrom` or `ctcssfrom` to either `pp` (to use the associated input pin non-inverted) or `ppinvert` (use the associated input pin inverted).

Configuring an output pin (2-9) as `ptt` makes the pin the PTT signal, either non-inverted or inverted, depending on the `invertptt=` setting.

Sample:

```
pp6 = ptt
pp10 = ctcss
pp11 = cor
invertptt = 0
carrierfrom = ppinvert                ; could also be ctcss, ctcssinvert, pp
```

## Usage
The GPIO and Parallel Port pins can be controlled directly using [`cop`](../config/rpt_conf.md#cop-commands) commands `cop 61` and `cop 62`. The difference between the two is that `cop 62` manipulates the pin "quietly" (suppresses telemetry output).

Sample:

```
rpt cmd 1999 cop 61,PP2=0           ; turn physical pin 2 off
rpt cmd 1999 cop 61,PP2=1           ; turn physical pin 2 on
rpt cmd 1999 cop 61,GPIO1=0         ; turn GPIO1 off
```

!!! note "Syntax Note"
    `PP` and `GPIO` must be in **CAPS**.

Use `core set debug 4` to show commands being sent to the channel driver.

Multiple pins can be controlled at the same time with a single command:

```
rpt cmd 1999 cop 61,PP2=1,PP3=1,PP4=1   ; turn physical pins 2, 3, and 4 ON
rpt cmd 1999 cop 61,PP2=0,PP3=0,PP4=0   ; turn physical pins 2, 3, and 4 OFF
```

Use `0` or `1` to set the specified output to `off` or `on`, or use a number greater than `1` (`N+1`) to specify how many milliseconds to invert its current state. For example, to pulse the pin for 500ms you would use the value `501` (currently, specified time only significant in increments of 50ms). Specifying a value of `N+1` to indicate `N` milliseconds was done so that in the future, support for granularity down to the millisecond level could be specified.


## Status and Channel Variables
The status of the input pins configured are made available via channel variables (e.g. `RPT_URI_GPIO1`, `RPT_URI_GPIO4`, `RPT_PP12`, etc.) which can be used by the [Event Management Subsystem](./eventmgmt.md).

To see the current state of the channel variables, use the `rpt show variables <node>` command:

```
asl3*CLI> rpt show variables 1999
Variable listing for node 1999:
   RPT_TXKEYED=0
   RPT_ETXKEYED=0
   RPT_RXKEYED=0
   RPT_PP15=1
   RPT_PP13=1
   RPT_PP12=1
   RPT_PP11=1
   RPT_ALINKS=0
   RPT_LINKS=0
   RPT_NUMALINKS=0
   RPT_NUMLINKS=0
   RPT_AUTOPATCHUP=0
    -- 12 variables
```

## DTMF Control
If you want to have a DTMF function that turns GPIO 1 on, you would specify the following in the `[functions]` section of `rpt.conf`:

```
1234 = cop,61,GPIO1=1               ; turn on GPIO 1
```

A simple example command structure for using all 8 parallel port pins for output switches:

```
98920=cop,61,PP2=0                  ; pport pin 2 off
98921=cop,61,PP2=1                  ; pport pin 2 on 
98930=cop,61,PP3=0                  ; pport pin 3 off
98931=cop,61,PP3=1                  ; pport pin 3 on 
98940=cop,61,PP4=0                  ; pport pin 4 off
98941=cop,61,PP4=1                  ; pport pin 4 on
98950=cop,61,PP5=0                  ; pport pin 5 off
98951=cop,61,PP5=1                  ; pport pin 5 on
98960=cop,61,PP6=0                  ; pport pin 6 off
98961=cop,61,PP6=1                  ; pport pin 6 on
98970=cop,61,PP7=0                  ; pport pin 7 off
98971=cop,61,PP7=1                  ; pport pin 7 on
98980=cop,61,PP8=0                  ; pport pin 8 off
98981=cop,61,PP8=1                  ; pport pin 8 on
98990=cop,61,PP9=0                  ; pport pin 9 off
98991=cop,61,PP9=1                  ; pport pin 9 on
```

Using an easier to remember structure as you think of it as - 989 (for pp switch cmd) + 2-9 (pp pin#) + 1/0 (on/off).
