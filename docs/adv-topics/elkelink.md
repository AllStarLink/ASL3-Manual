# Elke Link Mode
An Elke Link (named for Pete Elke WI6H) is a link that goes to sleep after a period of inactivity on the **node's receiver input**. While asleep, any traffic from connected nodes is **not** transmitted. This is useful for:

* Solar or other green nodes
* Mobile nodes
* Co-channel friendly nodes
* Low duty cycle nodes


## `rpt.conf` Selection

On "normal" nodes, this is available as an [`rpt.conf`](../config/rpt_conf.md#elke) setting. The timer value is in [furlong/firkin/fortnight (FFF) system](https://en.wikipedia.org/wiki/FFF_system) units... a bit of Jim Dixon humor.

In the source code, the timer value is actually in ms multiplied by `1210`. So, an FFF value of `744` would be 744 x 1210 = 900240ms --> 900.24s --> ~15 minutes.


Sample:

```
[1999]

...

elke = 744                          ;FFF system 744 = 15 minutes
```


## VOTER/RTCM Feature
This option is also available in the VOTER/RTCM, via hidden menu.

[Menu 111](../voter/voter-menus.md#111-special-configs) displays the current status of the hidden options:

```
Elkes (11780): 0, Glasers (1103): 0, Sawyer (1170): 0

Press The Any Key (Enter) To Continue
```

Elkes mode is enabled using menu option `11780`.


!!! note "Do Not Enable Both"
    If you are enabling it on a VOTER/RTCM, you would **not** want to enable it in `rpt.conf`.