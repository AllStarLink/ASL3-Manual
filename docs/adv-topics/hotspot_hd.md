# Hot Spot Unkey Delay

When setting up a hot spot select the Duplex 1 option with the asl-menu
will allow the hot spot to function. However the unkey delay of the
radio transmiter will be too long.

These steps will shorting the unkey delay and will greatly
improve hot spot responsiveness.

- From the node's landing page click the  Web Admin Portal
- Select terminal
- Type `sudo asl-menu`
- Select `6. Expert Configuration Menu`
- Select `1. Edit rpt.conf`
- Select `2. /bin/nano   <---- easiest` if asked
- Scroll down below the line with `[<your node number>](node-main)`
- On a blank line that is above `[functions]`
    - type `wait_times = wait-times_hd`
    - press enter and type `hangtime=100`
    - Save with cntl-X, enter, yes.
- On the asl-menu select `<Back to Main Menu>`
- Select `1. Node Settings`
- Select `2. Restart Asterisk`
- Select `<Back>`
- Select `<Exit Main Menu>`
- Select `<Yes>`

This setup will likely be a single menu selection with the next release of ASL3.