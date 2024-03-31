# Install AllStarLink

These instructions are for installing ASL on various computer systems. ASL3 has many changes so there's a bit of a learning curve. You'll want to read the whats new page so you know what you're getting to. You probably don't want to install on your production system right away. You’re going to be installing a new Debian OS on your computer, VM or microSD card.

## Raspberry Pi

<hr>

ASL can be installed on a Raspberry Pi 3, 4, or 5. You will install an image on a MicroSD and go. This is the simplest install. For most nodes the menu will walk you through the setup.

## Linux

<hr>

ASL can be installed on most Linux systems capable of running Debian 12.

## From Source

<hr>

Source install is for developers.

 - Source install does not include any helpers, Allmon3, asl3-menu, etc.
 - Installs and runs Asterisk as root

#### Install phreaknet.sh script

The phreaknet script compiles and patches Asterisk and DAHDI.

```bash
cd /usr/src && wget https://docs.phreaknet.org/script/phreaknet.sh && chmod +x phreaknet.sh && ./phreaknet.sh make
```

#### Install Asterisk 20 LTS

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

Asterisk should be running at this point but not app_rpt. Check install with `asterisk -r`.

#### Clone ASL3 repo

```bash
cd /usr/src
git clone https://github.com/AllStarLink/app_rpt.git
```

#### Install ASL3

This script does a git pull of app_rpt and compiles the branch you are on.

```bash
cd app_rpt
./rpt_install.sh
```

#### Install ASL3 configs
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

## Windows

<hr>

ASL will not install natively on Windows.

## Docker

<hr>

There is not currently a Docker install from ASL.
