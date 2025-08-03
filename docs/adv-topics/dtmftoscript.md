# Passing DTMF to Shell Scripts
This is one method to pass DTMF "strings" to a shell script, to be evaluated and executed accordingly.

It is basically a workaround, as it is not normally possible with the radio channel in `Asterisk/app_rpt`.

This method uses an alternate "autopatch" command with a different Asterisk "context", and a few other settings that would be different than the normal autopatch function. These settings make it quiet and seamless.

!!! note "Existing Autopatch Command"
    If you have a existing autopatch command enabled, make sure the new command number is at least 2 digits, and different than your existing autopatch command.

It is recommended that you use a prefix starting with `6`, and keep your commands listed together with the autopatch command in numerical order for better readability.

You may want to consider changing the standard "autopatch down" command from `62` to `60`, so that you could utilize a command structure such as:

```
*60 - autopatch down
*61 - autopatch up
*62 - pass DTMF to script 1
*63 - pass DTMF to script 2
```

## Configuring `rpt.conf`
You need to modify [`rpt.conf`](../config/rpt_conf.md) to add another `autopatchup` command, with a **different** context, such as:

```
62=autopatchup,context=pass2script,noct=1,farenddisconnect=1,dialtime=10000,quiet=1 
```

The command above will take any digits after `*62` and send them to [`extensions.conf`](../config/extensions_conf.md) in the `[pass2script]` context. Additionally, it disables the courtesy tone, "hangs up" when your script ends, sets the inter-digit dial time to 10 seconds, and does all this quietly (no [`patchup` or `patchdn`](./courtesytones.md) telemetry).

## Configuring `extensions.conf`
In our dialplan, we need to create the context `pass2script`. This is done in [`extensions.conf`](../config/extensions_conf.md).

Example:

```
[pass2script]                                                       ; this context needs to be unique in the system
exten = _X.,1,Wait,1
exten = _X.,n,SayAlpha(/var/lib/asterisk/sounds/activated,${EXTEN}) ; allison says something and then speaks the dtmf string {EXTEN}
exten = _X.,n,Wait,3                                                ; pause for a chance to cancel by hitting DTMF # (hangup)
exten = _X.,n,System(/path/to/script.sh ${EXTEN})                   ; here we pass the DTMF string to shell script script.sh
exten = _X.,n,Hangup
```

## Putting it Together
With our example here, dialing `*6212345` would pass `12345` to the shell script `script.sh`.

The modified `autopatchup` command takes the DTMF string dialed, puts it in a variable, and sends it to the `pass2script` context in `extensions.conf`. From there, it becomes pure Asterisk for how you handle the variable in the dialplan. You can use all regular Asterisk dialplan functions to evaluate, reformat, or execute, based on the contents of the `${EXTEN}` variable.

You will need your shell script to receive the "DTMF number string" accordingly. Help for that is available on the internet by searching for "passing variables to shell scripts". You would likely use the variable `$1` in your shell script, since we are only sending one command line argument, which should contain the DTMF string. 

You don't *have* to pass the DTMF to an external script, you could also evaluate and pass it to internal `Asterisk/app_rpt` functions as well, just using the dialplan.

As noted above, you could have multiple autopatch DTMF hand-offs, as long as you first provide a new unique command number for it and a new unique context for it in your dialplan.

Example:

```
62=autopatchup,context=pass2script,noct=1,farenddisconnect=1,dialtime=10000,quiet=1 
63=autopatchup,context=sitecontrol,noct=1,farenddisconnect=1,dialtime=10000,quiet=1 
```

Practical uses can be site or home control via USB or network relays, radio control/digital mode control functions, web execution scripts etc., all dependent on your script/dialplan.