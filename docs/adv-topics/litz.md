# Long Tone Zero (LiTZ)
LiTZ is a simple method to indicate to others on an amateur VHF / UHF FM radio frequency that you have an immediate need to communicate with someone, anyone, regarding a priority situation or condition.

LiTZ stands for Long Tone Zero (i-added to make it easier to pronounce). The LiTZ signal consists of transmitting DTMF ZERO for at least 3 seconds. After sending the LiTZ signal, the node executes a pre-programmed DTMF control sequence.

The parameters for setting the command string, for overriding the default DTMF tone for LITZ mode, and the required time for activation are as follows:

```
litzchar = 0     ; DTMF character required to initiate the LiTZ feature (default is 0)
litzcmd = *6911  ; Command sequence to execute upon LiTZ activation -- Call 911 on autopatch (default is not set)
litztime = 3000  ; Time required to hold down DTMF (default is 3000mS)
```

The above options would be placed in the node's configuration stanza in `rpt.conf`.

By default, `litzcmd` is not set (blank), which disables the feature (as even if a user sends `litzchar` for `litztime`, there is nothing to execute).
