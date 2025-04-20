# SA818 RF Modules
SA818 RF modules are inexpensive RF transceiver modules, often used to build a personal RF "hot spot" AllStarLink node.

Setting up an SA818 RF module is much easier on ASL3.

Two new commands were added to ASL3 Pi Appliance systems to program the module. We believe that most will prefer using `sa818-menu`, a visual interface to the RF module settings. For those who prefer a command line interface, we have also included `sa818`.

## sa818-menu
To program your SA818 with the menu utility, use the following command from the Linux CLI:

```
sudo sa818-menu
```

Here, you will be able to view the last saved (or default) settings.

**NOTE:** The "last saved" settings are those saved by the `sa818-menu` command on your system. There is no way to "read" settings from the SA818 RF module.

The settings include :

| Setting | Description |
|---------|-------------|
| Band | Specify the module type (VHF, UHF) |
| Bandwidth | Narrow (12.5KHz) or **Wide (25.0KHz)** |
| Receive Frequency | |
| Transmit Frequency | |
| Squelch Value | Default = **1** |
| Volume | Default = **1** |
| Sub-audible tone | **None**, CTCSS, DCS |
| Pre-Emphasis/De-emphasis | Default = **Disabled** |
| High pass Filter | Default = **Disabled** |
| Low pass Filter | Default = **Disabled** |
| Serial Port | Default = **/dev/serial0** or **/dev/ttyUSB0** |
| Connection Speed | Default = **9600** |

If you change the sub-audible tone setting to CTCSS or DCS you will be presented with a list of possible tone frequencies. When using CTCSS tones, you will also have a setting for the CTCSS Reverse Burst (tail tone).

The RF module will be programmed when you exit the menu.

**NOTE:** If you make changes that you do not wish to have stored, then use the ESC key to exit the menu.

## sa818

To program your SA818 using the command line you can execute the `sa818` command. For command usage information, use `sa818 --help`.

