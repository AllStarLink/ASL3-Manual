# Tonemacros
A `tonemacro` is much like a normal macro (see the [Macros](./macros.md) page). A tonemacro activates the programmed macro/string based on a CTCSS tone received (or NOT).  The default behavior is to only trigger a macro for the first time a CTCSS tone is received.  Additional keyups with the same CTCSS tone will not execute the macro.  When a different CTCSS tone is received the matching macro will execute one time.

Adding an R to the macro string will allow the `tonemacro` to execute for each keyup with a given CTCSS tone.

Multiple CTCSS tones can each have their own macro execution. Each node may have its own set. 

!!! note "USBRadio Required"
    Tonemacros require that you are using the DSP functions of USBRadio and proper tone config (`rxctcssfreqs`) in `usbradio.conf`.

Sample:

```
[tonemacro]
100.0=*672 *8910
203.5=*712
94.8=R*123 *4556 ;This macro will execute on each keyup
```

Use your imagination as this can be used very powerfully. But, be careful in thinking out the full implications of what you are doing.