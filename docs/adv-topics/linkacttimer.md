# Link Activity Timer
The link activity timer may be used to reset a link configuration back to a default configuration if a user changes how the node is linked. This helps in situations where the user forgets to reset the system to the default values, or drives out of range.

The activity timer is armed when the link state is changed by a local DTMF function. The activity timer is zeroed whenever a signal is heard on the receiver, and the activity macro is executed when the timer reaches the `lnkacttime` value.

!!! note "RF Activity Only"
    This timer is only reset by activity on the local receiver (RF). It is **NOT** reset by activity coming from linked nodes. Consider this in your application.

## COP Functions
There are three [COP](../config/rpt_conf.md#cop-commands) commands associated with the Link Activity Timer:

COP|Function Description|Telemetry Response
---|--------------------|------------------
45|Link Activity timer enable|LATENA
46|Link Activity timer disable|LATDIS
47|Reset "Link Config Changed" Flag|none

`cop,45` and `cop,46` enable and disable the activity timer function.

`cop,47` is used to reset the "Link Config Changed" Flag. This flag is set whenever a user connects or disconnects a link. This is useful for implementing macros where you want to change the link state without arming the activity timer.

## Settings
All of the key value pairs noted below are placed in the [`rpt.conf`](../config/rpt_conf.md) node stanza. There are four key value pairs related to the link activity timer.

* `lnkactenable=`
    * Set to `1` to enable the link activity timer at initialization, or `0` to leave it disabled. The default is `0`. **Note:** If the activity timer is disabled in `rpt.conf`, it can still be enabled with the COP command.
* `lnkacttime=`
    * This sets the amount of time to wait before executing the inactivity macro. Set to a value between `180` and `2000000` seconds.
* `lnkactmacro=`
    * This is the function to execute when the activity timer expires. This can either be a function or another macro defined in the [`[macros]`](./macros.md) stanza.
* `lnkacttimerwarn=`
    * For a 30 second warning message, set this to the path of a ulaw or pcm sound file to play locally when there is 30 seconds left on the activity timer. **Note:** Do not include the extension name of the sound file. If no absolute path is specified, the default path will be `/usr/share/asterisk/sounds/en`.

Example:

```
 lnkactenable=1                     ; Enable link activity timer         
 lnkacttime=900                     ; 15 minute link activity timer    
 lnkactmacro=*52                    ; Use macro 2 in the [macros] stanza for link activity timer
 lnkacttimerwarn=rpt/timeout-warning; Sound file for 30 second warning message located in /usr/share/asterisk/sounds/en
```