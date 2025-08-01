# Tonemacros
A `tonemacro` is much like a normal macro (see the [Macros](./macros.md) page). A tonemacro activates the programmed macro/string based on a CTCSS tone received (or NOT).

Multiple CTCSS tones can each have their own macro execution. Each node may have its own set. 

!!! note "USBRadio Required"
    Tonemacros require that you are using the DSP functions of USBRadio and proper tone config (`rxctcssfreqs`) in `usbradio.conf`.

Sample:

```
[tonemacro]
100.0=*672 *8910
203.5=*712
```

Use your imagination as this can be used very powerfully. But, be careful in thinking out the full implications of what you are doing.