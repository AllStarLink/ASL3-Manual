# Source-Based Installation

Software developers or users who want to make changes to ASL3 or those who want/need to install ASL3 on unsupported hardware or operating systems will need to install ASL3 from the source code.
Doing so will require you to download, compile, and install multiple projects.
You will also need to be very comfortable using various development tools and the Linux CLI.

## Where to get the ASL3 source code

All of the source code for ASL3 can be found in the GitHub [AllStarLink](https://github.com/AllStarLink) repositories.  The repositories include (but are not limited to) :

| Repository    | Description
|---------------|-----------------------------------
| ASL3          | Top-level
| app_rpt       | AllStarLink additions to Asterisk
| asl3-asterisk | Build environment for the .deb packages of Asterisk LTS + ASL3/app_rpt
| asl3-menu     | The ASL3 menu system (asl-menu, node-setup, etc)
| Allmon3       | Web-based monitoring and management for the AllStarLink application

## Asterisk + app_rpt

Details on building Asterisk + app\_rpt can be found in the "docs" directory of the GitHub [asl3-asterisk](https://github.com/AllStarLink/asl3-asterisk) repository.
Please note that the instructions are ONLY for building Asterisk with ASL's app_rpt.
The instructions does not include any helpers, Allmon3, asl3-menu, asl3-nodelist, etc.

The "docs" directory has two sets of instructions.

- The "build-asl3" instructions focus is on building Asterisk + ASL3/app_rpt and creating our Debian packages.
- The "build-phreaknet" instructions (and the `phreaknet.sh` script) targets those more interested in Asterisk installations with app_rpt.

