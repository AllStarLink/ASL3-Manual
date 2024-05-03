# Source-Based Installation
Source install is for developers or users who need to install AllStarLink 3
on unsupported hardware or operating systems. Installing ASL from source
code is primarily for developers.  Doing so will require you to download,
compile, and install multiple projects.  You will also need to be very
comfortable using various development tools and the Linux CLI.

The following instructions are for building ONLY Asterisk with ASL's app_rpt.

 - Source install does not include any helpers, Allmon3, asl3-menu, asl3-nodelist, etc.
 - Installs and runs Asterisk as root (this is, in general, bad)

## Install phreaknet.sh script
The phreaknet script compiles and patches Asterisk and DAHDI.

```bash
cd /usr/src && wget https://docs.phreaknet.org/script/phreaknet.sh && chmod +x phreaknet.sh && ./phreaknet.sh make
```

## Install Asterisk 20 LTS

Use -t or -b for developer mode. Both are optional.

 - The -t is for backtraces and thread debug. Thread debugging is resource intensive.
 - Use -b for backtraces only, recommended on 386 or for submitting core dumps.
 - The -s is for sip if you need it still, leave off the -s if you don’t
 - The -d is for DAHDI and is required
 - The -v is to install the latest of the major version specified, 20 in this case
 - Use -f to force a reinstall (upgrade)

```
phreaknet install -d -b -v 20
```

Asterisk should be running at this point but not app_rpt. Check the install with `asterisk -r`.

## Clone ASL3 repo

```bash
cd /usr/src
git clone https://github.com/AllStarLink/app_rpt.git
```

## Install ASL3

This script does a git pull of app_rpt and compiles the branch you are on.

```bash
cd app_rpt
./rpt_install.sh
```

## Install ASL3 configs

This adds ASL3 configs to the full set of Asterisk configuration files. ASL3 modules.conf limits what actually runs.

```bash
cp /usr/src/app_rpt/configs/rpt/* /etc/asterisk
```

> reboot the system

You should now have a complete ASL3 install.

```bash
asterisk -rx "rpt localnodes"
```
You should see node 1999.
