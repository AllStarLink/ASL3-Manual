# Raspberry Pi Install

ASL3 can be installed on a Raspberry Pi 3, 4, or 5. The Raspberry Pi image includes the OS, Allmon3 and Cockpit.  You will install an image on a microSD card and go. This is the simplest install. For most nodes the menus will walk you through the setup. For the well-initiated with loading a Raspberry Pi image, the image may be obtained from the [ASL3 Pi Release Page](#).

## Step-by-Step Pi Appliance Setup

These directions are specific for Windows by example , but in general,
should work the same for the same tool set on MacOS and Linux.

1. If you do not already have it installed, install the
[Raspberry Pi Imager](https://www.raspberrypi.com/software/).

2. Download the [latest release image](https://repo.allstarlink.org/images/pi/). This will
be named `allstar3-arm64-X.Y.Z.img.xz` where "X.Y.Z" is the version. The version will
be something like 3.0.1. Save it to your local `Downloads` directory.

3. Launch **Raspberry Pi Imager** from the start menu.
![Step 3](img/step-3.png)

4. Click on **CHOOSE DEVICE** and choose the type of
Pi hardware on which AllStarLink 3 Appliance is being installed.
![Step 4](img/step-4.png)

5. Click on **CHOOSE OS**. Scroll to the bottom of the
list that appears and select **Use custom**.
![Step 5](img/step-5.png)

6. A **Select image** dialog box will appear. Navigate to the
`Downloads` folder and select the image downloaded in step 2.
It will be named something like allstar3-arm64-3.0.1.img.xz.
Then click **Open**.
![Step 6](img/step-6.png)

7. Connect the SD card or the SD card in a USB adapter to
the computer. Then click on **CHOOSE STORAGE**. An option
will be presented named something such as "Mass Storage Device USB
Device - 16.0 GB". Click on that entry.
![Step 7](img/step-7.png)

8. Click **NEXT**

9. A box labelled "Use OS customisation?" will appear. Click on
**EDIT SETTINGS**
![Step 9](img/step-9.png)

10. Check the box next to **Set hostname** and enter a hostname
for the device to appear as on the network. It is recommended
to choose a functional name such as "asl3-node50185" (using your
node number) or "CALLSIGN-hotspot" (e.g. "w1aw-hotspot").

11. Check the box next to **Set username and password**
and enter a username and password. It is recommended to set the
username to 'asl' if you have no strong feeling about the
username. Choose a good password and record the password somewhere
safe. **NOTE: There is NO DEFAULT USER for the image. Failure to
set an account will require a reimage of the SD card with the
proper settings.**

12. If the device will be connected to WiFi, check the
box "Configure wireless LAN" and then enter
the name of the wireless network in **SSID** and the password for
that network in **Password**. Change the "Wireless LAN country" to **US**
or another country as appropriate. Setting this is not necessary
if the Pi will use a network cable rather than wireless.

13. Check the box next to **Set locale settings** and change the "Time zone"
to the desired region. The timezone settings will control any time-based
announcements and schedule jobs. After completing steps 10-13, the customization
should look something like:
![Step 13](img/step-13.png)

14. Click **SAVE** in "OS Customisation".

15. Click **YES** for "Use OS customisation?"

16. Click **YES** to continue to write the image to the SD card.
![Step 16](img/step-16.png)

17. Depending on the speed of the computer and the type of SD card
one will have time for a beverage of their choice. When the write is complete,
remove the card from computer and insert it into the Pi. If using a USB adapter
for the SD card, remove the SD card from the adapter and insert the card into
the Pi. The Pi __will not__ use the SD card in the USB adapter.

18. Power on the Pi. Wait approximately 2 minutes for the Pi to boot
and perform the various first boot tasks. If there is a screen connected
to the Pi, it will be noted that Pi will reboot several times.
This is normal and expected.

19. (Optional) Network connectivity may be tested using the command
to ping the hostname set in step 10. For example, if the hostname
set was "node460181" then do `ping -4 node460181.local` from a
command prompt or PowerShell window. When you get a response,
the host is connected to the network. In this example, the node
hostname was set to `node460181.local`:
![Step 19](img/step-19.png)

20. Open a web browser and navigate to `https://nodeNNNNNN.local`. For
example, if the name was `node460181` then one would enter
`https://node460181.local`. Depending on your network and
browser, one may have to  enter the name several times until the
page displayed. The first connection will report a message that
"Your connection isn't private". For the Pi appliance, this is
acceptable. Click on **Advanced** and then
**Continue to node460181.local (unsafe)**.
![Step 20](img/step-20.png)

21. The administration window will appear. This system is named Cockpit
and is an open source application for managing devices of all sorts. 
Enter the username and password set in step #11 and click **Log in**
![Step 21](img/step-21.png)

22. The Overview tab is displayed. Using Cockpit with AllStarLink 
is [covered in the manual](../pi/index.md). Click on
**Terminal** at the bottom of the left scrollable menu and the
admin console will appear:
![Step 22](img/step-22.png)

The Terminal window is a complete interface to AllStarLink,
Asterisk, and more. No SSH client is required although use
of SSH directly is fully supported.

## Quick Config va ASL-Menu
The node may now be configured. New users or those wanting a
quick start experience should [use the asl-menu utility](menu.md)
with `sudo asl-menu`.

## Asterisk Console
To start the asterisk console from the Terminal window
enter `sudo asterisk -rv`.

## Software Updates
One should also apply any latest updates and reboot the device
as described in [Cockpit Updates](../pi/cockpit-updates.md).

## Logging Out
When finished with the admin system, click on **Session**
in the upper right and then choose **Logout**.
