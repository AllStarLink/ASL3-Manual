# Beta Testing
Beta testing is the final phase of software testing before releasing a product to the general public. During this stage, a group of users representing the target audience
validates the product. They explore its features, uncover bugs, and provide feedback.

AllStarLink releases software packages to a beta channel on a periodic basis to address bug fixes and feature enhancements. The beta channel of packages is available to all users. However, please only select to run packages from the beta channel if you meet the following criteria:

1. If something goes wrong, your can easily recover your node from backups or other saved configuration

2. You have generalized Linux skills such as understanding basic commands, ability to use the shell terminal of Linux, ability to copy/paste output data into bug reports, etc.

3. You acknowledge that a beta release may have other bugs, incomplete fixes, or may in rare cases not work right at all *for your configuration* and that you can live with this

4. You may need to edit configuration files to fix issues or test things or to roll back to previous versions of software

If you cannot adhere to the above four conditions, you should not use the beta channel software.

## Enabling Beta Channel Software
Enabling beta channel software is done with the `asl-repo-switch` command as `root`. Set the channel to "beta" using `asl-repo-switch -l beta`. For example:

```
bash
# asl-repo-switch -l beta
Setting level beta... DONE
Run 'apt update' to refresh the package repo cache.
```

## Disabling Beta Channel Software
Disabling beta channel software is done with the `asl-repo-switch` command as `root`. Set the channel to "main" using `asl-repo-switch -l main`.

For example:

```
bash
# asl-repo-switch -l main
Setting level main... DONE
Run 'apt update' to refresh the package repo cache.
```

## Installing Updates Using Beta Channel
The most common case to use the beta channel for software packages is to test a proposed fix to a problem you are having. In those cases, the following commands should be run **one at a time** from a terminal/console as `root` (using `sudo` or `sudo -s`):

```
sudo asl-repo-switch -l beta
sudo apt update
sudo apt upgrade -y
sudo asl-repo-switch -l main
```

This will do a one-time installation of the packages in the beta channel and then switch back to main.

## Resetting Installation of ASL Back to Production
To reset your packages for ASL3 back to the production-release main versions:

For Pi Appliances:

```
sudo asl-repo-switch -r
sudo apt update
sudo apt install -y --reinstall asl3 asl3-asterisk asl3-asterisk-config \
  asl3-asterisk-modules asl3-menu asl3-update-nodelist \
  asl3-pi-appliance allmon3
```

For Debian 12 general installations:

```
sudo asl-repo-switch -r
sudo apt update
sudo apt install -y --reinstall asl3 asl3-asterisk asl3-asterisk-config \
  asl3-asterisk-modules asl3-menu asl3-update-nodelist
```

For DAHDI Kernel packages after doing the above, as necessary:

```
sudo apt install -y --reinstall dahdi-linux dahdi-dkms
```

**NOTE:** You may need to merge or fix configurations when rolling back from beta software to production. This is unusual but possible.