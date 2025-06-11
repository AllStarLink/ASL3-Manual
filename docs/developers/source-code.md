# Source Code

## ASL3 Source Code Repositories
All of the source code for ASL3 is available on [GitHub](https://github.com/AllStarLink).
The main repositories include :

### ASL3

- The **ASL3** [repository](https://github.com/AllStarLink/ASL3) sits at the top of the hierarchy.
- From a packaging point of view, this is the source of the `asl3` package.
- The repository / package also provides some of the "glue" needed to make everything work (OS services, OS configuration, scripts, etc).
- The `asl3` package is installed with the `apt install asl3` command.
- The package will, in turn, pull down the key dependencies.

### Asterisk

- The ASL3 project leverages the source code from the Asterisk project.  When building ASL3, we  snapshot one of the most recent LTS releases from the **Asterisk** [repository](https://github.com/asterisk/asterisk).

### app\_rpt

- The **app\_rpt** [repository](https://github.com/AllStarLink/app\_rpt) contains the source for the AllStarLink code that is added to (and works with) Asterisk. This includes the app_rpt module, the channel driver modules (SimpleUSB, USBRadio, etc), a few utilities (simpleusb-tune-menu, radio-tune-menu), and the initial set of "ASL" configuration files.

### asl3-asterisk

- The **asl3-asterisk** [repository](https://github.com/AllStarLink/asl3-asterisk) is what we use to pull the `Asterisk` and `app_rpt` source code together, compile all of the executables, and create the .deb packages.
- From a packaging point of view, this is the source of the `asl3-asterisk`, `asl3-asterisk-config`, `asl3-asterisk-modules`, and debugging packages.

### ASL3 Menu

- The **ASL3 Menu** [repository](https://github.com/AllStarLink/asl3-menu) contains the ASL Menu system (`asl-menu`, `node-setup`, etc).
- From a packaging point of view, this is the source of the `asl3-menu` package.

### ASL3 Manual

- The **ASL3 Manual** [repository](https://github.com/AllStarLink/ASL3-Manual) contains the source code for the our online documentation available at [allstarlink.github.io](https://allstarlink.github.io).

### Allmon3

- The **Allmon3** [repository](https://github.com/AllStarLink/Allmon3) contains the source code for `Allmon3`, the web-based monitoring and management application.
- From a packaging point of view, this is the source of the `allmon3` package.

