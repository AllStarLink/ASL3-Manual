# Using AllStarLink/app_rpt with Cloud Kernels

Many virtual hosts or VPS providers leverage the Debian "cloud kernel"
version of the Debian Linux OS. These providers include Amazon AWS,
Microsoft Azure, Linode, Vultr, and DigitalOcean. Using their stock
Debian 12 installation image comes with the "cloud kernel" installed.
While this kernel is usually beneficial due to its smaller footprint
than the full kernel through the removal of hardware elements, the
Asterisk app_rpt module requires the support of these elements.

After installing a Debian Linux 12 image that is using a cloud
kernel, the following procedure can be used to change the OS to use
the normal kernel that will allow the building of the DAHDI module
needed for app_rpt.

* Become root by doing `sudo -s`.

* Check the running kernel of the system to see if it is the 
reduced-footprint "cloud" version using `uname -a`:

    ```
    # uname -a
    Linux localhost 6.1.0-28-cloud-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.119-1 (2024-11-22) x86_64 GNU/Linux
    ```
	
	If the name of the kernel includes the phrase "cloud", this is the
	reduced-sized cloud kernel that removes all of the hardware drivers
	not relevant to a cloud VM. Unfortunately, use of Asterisk's DAHDI
	module requires the hardware-drivers-enabled kernel.

* Install the full kernel on the host:

    ```
	apt install linux-image-amd64
    ```	

* Remove the cloud kernels:

    ```
	apt remove -y ` dpkg -l | grep -E '^ii\s+linux' | grep cloud | awk '{print $2}'`
	```

    A box will appear warning that the running kernel is being removed. The default
    prompt is to abandon the process with "yes". Select "no" to remove the kernel.
  
* Reboot the system

* After reboot, check the running kernel with the command `uname -a`. It should now be running the
"non cloud" version of the kernel:

    ````
	# uname -a
    Linux localhost 6.1.0-28-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.119-1 (2024-11-22) x86_64 GNU/Linux
	````
	
* Note: depending on your platform type you may need to create a MOK for
kernel modules as documented at [UEFI SecureBoot](/adv-topics/uefi-secureboot).
Test the boot type as follows:

    ````
	[ -d /sys/firmware/efi ] && echo UEFI || echo BIOS
	````
	
	It will print "UEFI" for SecureBoot/UEFI systems that need MOKs or "BIOS" for everything
	else and does not need an MOK.

* Now ensure that the development headers are installed:

    ```
	apt install -y linux-headers-$(uname -r)
	```
	
* (Re)install the `dahdi-dkms` kernel so it will build the modules:

    ```
    apt install --reinstall -y dahdi-dkms	
	```
	
    The installation should include something that looks like this:
	
	```
	Setting up dahdi-dkms (1:3.4.0-4+asl) ...
	Loading new dahdi-3.4.0 DKMS files...
	Building for 6.1.0-28-amd64
	Building initial module for 6.1.0-28-amd64
	Done.
	
	dahdi_dummy.ko:
	Running module version sanity check.
	- Original module
	- No original module exists within this kernel
	- Installation
	- Installing to /lib/modules/6.1.0-28-amd64/updates/dkms/
	
	dahdi.ko:
	Running module version sanity check.
	- Original module
	- No original module exists within this kernel
	- Installation
	- Installing to /lib/modules/6.1.0-28-amd64/updates/dkms/
	
	dahdi_transcode.ko:
	Running module version sanity check.
	- Original module
	- No original module exists within this kernel
	- Installation
	- Installing to /lib/modules/6.1.0-28-amd64/updates/dkms/
	depmod...
	```
	
* Load the dahdi module:

	```
	modprobe dahdi
	```
	
* Check that the module is loaded with `1smod | grep dahdi`:

    ```
    # lsmod | grep dahdi
	 dahdi                 258048  0
    ```

Now setup of ASL3/app_rpt should be able to continue.