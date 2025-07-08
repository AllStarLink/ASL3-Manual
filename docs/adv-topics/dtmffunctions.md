# DTMF Functions
This is how the DTMF function decoder works in `app_rpt`, and how to add and change DTMF function codes.


## How DTMF Function Decoding Works
The function decoder's job is to collect DTMF digits until a match with a command is found. The function decoder will start collecting digits when the [function start character](../config/rpt_conf.md#funcchar) (usually `*`) is seen, and will continue collecting until the digit time out is reached, or a match is found. The start character is not included in the match. The function decoder does not care what the state of COR or CTCSS are. In other words, if you un-key and re-key in the middle of entering a function, the un-key does not affect the digits collected. Five things will clear the collected digits in the function decoder:

* Lack of a match and a digit timer time out
* The detection of another function start character (usually `*`)
* The recognition and execution of a valid DTMF command
* The digit buffer is completely filled and no match is found
* The detection of a [function end character](../config/rpt_conf.md#endchar) (usually `#`)

## Matching Mechanism
A match occurs when the collected digits match a function on the left hand side of an entry in the [`[functions]`](../config/rpt_conf.md#functions-stanza) stanza. Here's an example:

```
[functions]
1=ilink,1
```

Above is an example of a function stanza with one entry defined. 

Since the function start character is implied, it is not present on the left hand side of the entry. In this particular case, a `*1` will execute the method 1 of the `ilink` function (which is disconnect link). 

Once a match is detected, any additional digits belong to the function which matched. In this particular case, the digits which follow `*1` will be passed to the disconnect link function where it will attempt to make a match with a connected node.

The first match found will be the one which is chosen. What this means is that you ***cannot*** have two DTMF functions with the same sequence of digits, and one having one additional digit, because the shorter one will always win and be executed first.

Will ***not*** work as intended:

```
[functions]
80=ilink,1
800=ilink,2
```

***Will*** work as intended:

```
[functions]
800=ilink,1
801=ilink,2
```

## Function Classes And Methods
Let's now devote our attention to the stuff on the right hand side of the equals sign. 

The right hand side is a list of arguments separated by commas. The first argument is the **function class identifier** which is a text string. The second argument can be a **method number** associated with the function class, one or more **configuration arguments**, or a **combination of both**. 

One example of a [function class](../config/rpt_conf.md#function-classes) is the `ilink` used above. Another example would be the [`COP`](../config/rpt_conf.md#cop-commands) function class used for control operator functions. 

Additionally, instead of or in addition to a **method number**, the **function class** itself might accept additional arguments for customizing how it behaves. The `autopatchup` method is a good example of this:

```
6=autopatchup,noct=1,farenddisconnect=1,dialtime=20000
```

A complete list of the function classes and methods are documented on the [`rpt.conf`](../config/rpt_conf.md) page.

