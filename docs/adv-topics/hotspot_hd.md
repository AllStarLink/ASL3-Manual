# Hot Spot Un-key Delay
When setting up a hot spot, select the `Duplex 1` option in [`asl-menu`](../user-guide/menu.md) to allow the hot spot to function. However, the un-key delay of the radio transmitter will likely be too long.

These steps will shorten the un-key delay and will greatly improve hot spot responsiveness:

From the Linux CLI, launch the `asl-menu` with `sudo asl-menu`. Select the following options:

* Select `6. Expert Configuration Menu`
* Select `1. Edit rpt.conf`
* Select `2. /bin/nano   <---- easiest` if asked
* Scroll down below the line with `[<your node number>](node-main)`
* On a blank line that is above `[functions]`
    * Type `wait_times = wait-times_hd`
    * Press enter and type `hangtime=100`
    * Save with ctrl-x, enter, yes
* On the `asl-menu` select `<Back to Main Menu>`
* Select `1. Node Settings`
* Select `2. Restart Asterisk`
* Select `<Back>`
* Select `<Exit Main Menu>`
* Select `<Yes>`

This setup will likely be a single menu selection with the next release of ASL3.