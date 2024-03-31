# test

Because Asterisk runs a non-root consider:

 - RTCM configs: We are recommending the use of port 1667 to avoid OS hacks for ports below 1024.
 - USB configs require a udev rule: `cat /etc/udev/rules.d.90-asl3.rules` SUBSYSTEM=="usb", ATTRS{idVendor}=="0d8c", GROUP="plugdev", TAG+="uaccess"
