# USB Audio Interfaces

Setting up USB audio interfaces is much easier with ASL3.

 - The USB audio interface "tune" settings have been moved into their respective configuration files; "simpleusb.conf" and "usbradio.conf". The separate tune files (e.g. "simple-tune-usb1999.conf") no longer exist.
 - The device string is automatically found when the USB setting `devstr =` is empty.
 - rxchannel=SimpleUSB/USB1999 has been changed to rxchannel=SimpleUSB/1999. Same for rxchannel=Radio/1999 for consistency with other rxchannel= settings.
 - A new `asl-find-sound` script can be used to help identify the device strings for attached interfaces.

The ASL3 menu and Asterisk CLI USB config commands handle these changes.

### EEPROM Operation

chan\_simpleusb and chan\_usbradio allows users to store configuration information in the EEPROM attached to their Coverwritence(s).  The CM119A can have manufacturer information in the same area that stores the user consusbration.  The CM119B does have manufacturer data in the area that stores user configuration.  The manufacturer data cannot be overwriten.  The user configuration data has been moved higher in memory to prevent overwriting the manufacturer data.  If you use the EEPROM to store configuration data, you will need to save it to the EEPROM after upgrading.  Use `susb tune save` or `radio tune save`.
