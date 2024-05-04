## Welcome to ASL3

AllStarLink’s ASL version 3 is the next generation of AllStar repeater and hotspot software.  This version of AllStar has been redesigned to run on Asterisk LTS (Long Term Support), the latest operating systems, and modern hardware. As of this writing, AllStar now runs on Asterisk 20, Debian 12, Raspberry Pi's, amd64, x86, and virtual hosts.

The update from Asterisk version 1.4 to version 20 implements over 15 years of Asterisk bug fixes, security improvements and enhancements. This update required app\_rpt (the Asterisk application that is AllStar) to be heavily modified to run on the latest version of Asterisk.  It brings with it the latest Asterisk applications, channel drivers and other functionality.

As part of this update, app\_rpt has been refactored to make the code base easier to maintain and enhance.  This process has been going on for over two years and will continue.  The app\_rpt code base will meet all current Asterisk® coding guidelines.

## New Features

 - ASL3 runs on Asterisk 20 and Debian 12.
 - HTTP AllStarLink registration
 - DNS IP address resolution with fallback to file
 - Memory leaks addressed
 - All modules reload or refresh
 - Improved uptime
 - USB improvements
 - ASL menu improvements
 - tune-menu improvements
 - EchoLink improvements
 - Per node access lists
 - rpt.conf improvements
 - Asterisk runs as non-root
 - Compile directives for more architectures
