# Welcome to ASL3

AllStarLink’s ASL version 3 is the next generation of AllStar repeater and hotspot software.  This version of AllStar has been redesigned to run on Asterisk LTS (Long Term Support), the latest operating systems, and modern hardware. As of this writing, AllStar now runs on Asterisk 20, Debian 12, Raspberry Pi's, amd64, x86, and virtual hosts.

The update from Asterisk version 1.4 to version 20 implements over 15 years of Asterisk bug fixes, security improvements and enhancements.  It brings with it the latest Asterisk applications, channel drivers and other functionality. This update required app\_rpt (the Asterisk application that is AllStar) to be heavily modified. Many memory leaks have been addressed, modules load or refresh more reliably and many bugs have been squashed. This all adds up to improved stability and uptime.

As part of this update, app\_rpt has been refactored to make the code base easier to maintain and enhance.  The goal being to make app_rpt accessible to more developers. The app\_rpt code base will meet all current Asterisk® coding guidelines.  This process has been going on for over two years and will continue.

## New Features

In addition to the app_rpt code update, we've added many new features to make ASL3 the best AllStar release yet.

 - Runs on Asterisk 20 as non-root.
 - Runs on Debian 12 and some older operating systems.
 - Apt update including the kernel.
 - HTTP AllStarLink Registration.
 - DNS IP address resolution with fallback to file.
 - USB improvements including live logic view and auto device string discovery.
 - New Raspberry Pi image with system management appliance and services advertisement.
 - Apt install for x86 with image install in the works.
 - ASL menu improvements including compatibility with user config file edits.
 - EchoLink code has been extensively reworked to improve stability. Other improvements including chats and doubling prevention.
 - Access lists modified to individual per node lists with CLI or menu management.
 - Configuration templates to simplify edits and menu updates.
