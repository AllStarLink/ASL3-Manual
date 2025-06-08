# Debian 12 Appliance

!!! danger "Do This at Your Own Risk"
    A Debian 12 Appliance, similar to the Raspberry Pi Appliance, is still under development. In the meantime, you can get "close" to the same user experience by installing and configuring some additional packages. This is not generally recommended for most users at this time.

If you install the following packages, you’ll have everything you need to use the “appliance” configuration:

```
sudo apt install asl3 asl3-update-nodelist asl3-menu allmon3
```

You will still need to do certain things like configure [Allmon3](../../allmon3/index.md) by hand.

If you want to turn your configuration you described into the full appliance, you can try installing `asl3-pi-appliance` which will “take over” your system. 

This hasn't been rigorously tested against a non-Pi installation, but it should *mostly* work (if not completely work) - but YMMV. 

If you don’t want to take the risk of that, but still want all the web experience, you can install:

```
sudo apt install cockpit cockpit-networkmanager cockpit-packagekit \
  cockpit-sosreport cockpit-storaged cockpit-system cockpit-ws \
  python3-serial firewalld
```

Which should give you an unbranded, uncustomized `Cockpit` environment.

Again, doing the above is **experimental and not generally recommended**, but you are welcome to give it a try, and perhaps provide feedback on issues and changes to help push the development of a Debian 12 Appliance image along!