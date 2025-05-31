# VOTER GPS Requirements
This page will outline the requirements and troubleshooting for using a GPS with the RTCM/VOTER.

## GPS
The RTCM/VOTER will work with most GPS available. It requires either NMEA or Trimble TSIP binary data. It only receives data **from** the GPS (GPS TX), it does not send anything **to** the GPS.

!!! note "Voting and Simulcast"
    If you are planning on doing voting and/or simulcast, your GPS also needs to have a "Pulse-per-second" (PPS) output.

The RTCM/VOTER firmware is specifically written to talk to Trimble Thunderbolt receivers using Trimble's TSIP binary data interface, however, other Trimbles GPS receivers that talk TSIP are generally compatible. There are some specific *hacks* that have now been added to the firmware to work with the Thunderbolt to overcome *week number rollover* issues.

## NMEA Sentences
If you are using an NMEA GPS (as opposed to a Trimble using the TSIP binary interface), the RTCM/VOTER is looking for the following NMEA sentences:

```
$GPGGA
$GPGSV
$GPRMC
```

It wants `$GPGSV` to see the number of satellites in view is `>0` (determines whether we are getting any GPS data).

It uses `$GPRMC` to get the timestamp.

It uses `$GPGGA` to determine whether we have a valid GPS fix, and get the latitude/longitude/altitude.

## Trimble TSIP Packets
The VOTER/RTCM when in TSIP mode (Trimble), assumes it is a Trimble Thunderbolt and is looking for two packets:

```
0x8F-AB - Primary Timing Packet
0x8F-AC - Supplemental Timing Packet
```
Grab a copy of the [Thunderbolt User Guide](./assets/Thunderbolt-2012-02.pdf).

Pages 78-83 are the important ones.

Packet 0x8F-AB is what grabs the timing information, and packet 0x8F-AC is what is used for everything else (including debug).

## RTCM GPS Connections
There are some quirks specific to the RTCM that are not well documented.

The GPS connections for the RTCM are on the DB15 connector. Note that the labels for `GTX` and `GRX` are misleading. `GTX` is the data **FROM** the GPS **TO** the RTCM (GPS TX/RTCM RX). `GRX` is data from the RTCM to the GPS, but that is currently not used, so it does not need to be connected.

`PPS` is obvious, that is your PPS signal from your GPS.

Also note, inside the RTCM, there are [jumpers](./rtcm-hardware.md#jumpers) to set for TTL or RS-232 data, depending on the type of GPS you are connecting. Set them accordingly. The RS-232 setting loops the data through a MAX3232 converter on the board.

You will still need to set the data and PPS polarity, and baud rate in the [configuration menus](./voter-menus.md) to get everything to work.

## GPS Lock
The GPS LED will go solid regardless of the connection LED. That **has** to happen or it won't connect to the Asterisk server. 

It is not unusual for it to take up to 20 mins to get a GPS lock LED (ie. using a Trimble Thunderbolt) after any reboot. It is highly dependent on how long your GPS takes to lock up, whether it has a current almanac, etc. 

## GPS Issues

### GPS Desense
If you are having odd loss of lock issues (or can't get/maintain lock), consider you may have interference to your GPS antenna from strong RF nearby. A note from Jesse Lloyd:

```
I also had crazy problems with poor signal on my GPS when I set it up sitting in a window, and once installed at site I had the GPS antenna maybe 6 ft from the VHF antenna, and after some troubleshooting found it was getting swamped with RF and loosing lock. 

I found the debug setting of 32 useful in the RTCM, you can see a hex output of the GPS status.  
```

If you are in a known high-RF environment (lots of co-located transmitters, broadcast, etc.), you will probably be disappointed if you try using a cheap patch antenna. You will need to get a decent active antenna that also has a built-in bandpass filter for the L1 frequency. Most commercial (surplus or otherwise) antennas fit this category.

### Trimble Thunderbolt
You may find your Trimble Thunderbolt is showing the incorrect date at the moment. It could be showing the year as 1997. This is due to the date in the Thunderbolt being reported incorrectly.

**This can cause some of your voting receivers to not connect, if they are used with other GPS in your system.** If you have **ALL** Thunderbolts, or **NO** Thunderbolts, you are probably fine. If you have **ALL** Thunderbolts, the date/time is probably wrong, but they will ALL be wrong, so they will connect.

GPS Time is a continuous counting time scale beginning at the January 5, 1980 to January 6, 1980 midnight. It is split into two parts: a time of week measured in seconds from midnight Sat/Sun, and a week number. The time of week is transmitted in an unambiguous manner by the satellites, but only the bottom 10 bits of the week number are transmitted. This means that a receiver will see a week number count that goes up steadily until it reaches 1023 after which it will “roll over” back to zero, before steadily going up again. Such a week rollover will occur approx. every 20 years. A GPS week rollover occurred in 1999 and another one happened in 2019.

The Thunderbolt manual states:

*"The ThunderBolt adjusts for this week rollover by adding 1024 to any week number reported by GPS which is less than week number 936 which began on December 14, 1997. With this technique, the ThunderBolt will provide an accurate translation of GPS week number and TOW to time and date until July 30, 2017."*

As such, the Trimble Thunderbolt has a firmware issue with the GPS Week rollover that manifested itself on July 30, 2017, causing the date to become incorrect. The Thunderbolt thinks the week changed from 935 to 936 (actual week 1959-1024=935), so it stopped adding 1024 to the week.

We have added a brute-force fix starting in RTCM/VOTER firmware >=1.51. This fix adds 619315200 seconds (1024 weeks) to the time reported by the GPS. It fixes the Thunderbolts, we have not done extensive testing to see how it affects other TSIP receivers.

That was fine until the week in the Thunderbolt hit the next rollover... when it rolled back to week 0, so additional checks were added, and now we have to add 2048 weeks (since the current GPS week is >2048). Hopefully, by the time November 21, 2038 rolls around, all the Thunderbolts will have had their OCXO's drift too far to correct, and will be turned in to pop cans. 

### Garmin

#### Garmin 18x LVC Wiring Issues
If you have issues with your GPS 18x LVC not talking to the VOTER/RTCM, it may not be hooked up to the VOTER/RTCM correctly. 

The Garmin pin labeling is backwards to what you may think. See below. You probably need to swap pins 6 and 14.

```
RTCM   	                 GPS 18x LVC      
6 GRX 	<-- Rx Data 	 6 Green  
7 GPPS 	<-- Pulse Output 1 Yellow  
8 GND   Ground 		     3 Black  
8 GND   Ground 		     5 Black  
13 +5V 	-->Vin 		     2 Red  
14 GTX 	--> TX Data 	 4 White
```

Log into the VOTER/RTCM and do `98` and you should see something like this:

```
Current Time: Sun  Apr 20, 2014  04:37:02.820
Last Rx Pkt System time: 04/20/2014 03:55:35.580, diff: 2487260 msec
Last Rx Pkt Timestamp time: 04/20/2014 03:55:32.064, diff: 3515 msec
Last Rx Pkt index: 160, inbounds: 1
```

#### Garmin and the RTCM
Beware when buying newer Garmin GPS's to use with the Micro-Node RTCM.

The RTCM expects a 5V PPS signal.

Newer Garmin's (GPS 18X, 18X LVC, etc.) MAY NOT output 5V, and can cause issues. **Check the Garmin datasheet**.

The VOTER is designed to accept both 3.3V or 5V signals, and *should* work fine.

#### Garmin Speed Issues
Some of the Garmin GPS's come with 4800 baud set as default. If you are getting a "Warning: GPS Data time period elapsed" error on your RTCM, change both the GPS and RTCM to use 9600 baud. 

To do this, interface the GPS to a DB9 connector as per Page 9 of the [ manual](./assets/GPS_18x_Tech_Specs.pdf) (remembering to ONLY use 5V as the power source *facepalm*). 

Once done, download, extract and open [http://www8.garmin.com/support/download_details.jsp?id=4053](http://www8.garmin.com/support/download_details.jsp?id=4053) SNSRXCFG ([local copy](./assets/SNSRXCFG_350.exe)) and run.

1. Select your GPS (in most cases GPS 18x PC/LVC). Press F10 to switch to NMEA mode (Config > Switch to NMEA Mode)
2. Select Config > Setup and choose the COM port your GPS is connected too. Leave baud rate as auto for now, OK
3. Select Comm > Connect to connect to the GPS
4. Go to Config > Get Configuration from GPS to download it's current configuration
5. Click File > Save to save the current configuration
6. In Config > Sensor Configuration change the Baud Rate to 9600. You can also check to make sure 1PPS is enabled here too. Click OK
7. Hitting F7 when in the main window of the software also brings up the GPS sentences to output if that is of interest
8. File > Save to a different file than Step 5
9. Press F9 or Config > Send Configuration to GPS. This will then send all the changes you made to the GPS unit (including baud rate so a reconnect may be needed)

### uBlox GPS
You can use uBlox GPS modules with the VOTER/RTCM. The ones readily available usually have a 5 pin header on them (5V, GND, TXD, RXD, PPS), as well as an integrated patch antenna, and a SMA connector for an external antenna.

As noted above, beware of desense. You may have variable success using a mag-mount patch antenna. You may want to use a commercial-grade GPS external antenna to benefit from better filtering of the GPS signal.

Data is TTL, so make sure to set the jumpers inside the RTCM for TTL data. Baud rate is 9600 by default, and uses NMEA. Set those accordingly in the configuration menu.

The RTCM and VOTER require different settings for data and PPS polarity. The VOTER wants **inverted** for both, and the RTCM wants **non-inverted** for both.

Make sure to save (`99`) and reboot (`r`) your VOTER/RTCM after making changes for them to be effective.

## GPS Debug
To turn on GPS Debugging, set the `Debug Option Level` in the VOTER/RTCM to `32`.

See [Debug levels](./voter-hardware.md#debug-options) for more information on how this works.

## Trimble Debug Status Decoding 
The VOTER/RTCM when in TSIP mode (Trimble), assumes it is a Trimble Thunderbolt and is looking for two packets:

```
0x8F-AB - Primary Timing Packet
0x8F-AC - Supplemental Timing Packet
```

Grab a copy of the [Thunderbolt User Guide](./assets/Thunderbolt-2012-02.pdf).

Pages 78-83 are the important ones.

Packet 0x8F-AB is what grabs the timing information, and packet 0x8F-AC is what is used for everything else (including debug). Not all bytes are used by all TSIP devices.

Presently, the debug strings that the VOTER/RTCM reports are:

```
printf("GPS-DEBUG: gps_epoch_time: %ld, ctime: %s, gps_week: %d\n",gps_time,ctime((time_t *)&gps_time),gpsweek);

printf("GPS-DEBUG: TSIP: ok %d, 2,3,9 - 14: %02x %02x %02x %02x %02x %02x %02x %02x\n",
happy,gps_buf[2],gps_buf[3],gps_buf[9],gps_buf[10],gps_buf[11],gps_buf[12],gps_buf[13],gps_buf[14]);
```

In real life, this is output like:

```
Example Unhappy Message:

GPS-DEBUG: gps_epoch_time: 1643742941, ctime: Tue Feb  1 19:15:41 2022
, gps_week: 2195
GPS-DEBUG: TSIP: ok 0, 2,3,9 - 14: 07 00 00 00 00 08 08 00
```

The `gps_epoch_time` is GPS time, in seconds since epoch, plus any corrections added (GPS Time Offset, "Fix 1 Second Off" debug code). It *should* be corrected for any leap seconds (it should be UTC time).

The `ctime` is conversion of `gps_epoch_time` into `calendar time`. It is the human-readable conversion of the `gps_epoch_time`. 

The flag after `TSIP: ok` is the `happy` GPS flag. The GPS is flagged as **NOT HAPPY** in TSIP mode if **ANY** of the following are TRUE:

* If GPS Decoding Status (Byte 12) is anything other than "Doing Fixes"
* If Disciplining Activity is not Phase Locking or Recovery Mode
* Any Critical Alarms
* Any Minor Alarms

The other 5 bytes are GPS buffer bytes 2, 3, and 9-14 (in hex). That translates to 0x8F-AC message bytes 1, 2, and 8-13.

Inspecting the rest of the debug string to look at the 0x8F-AC bytes:

```
Msg:  07   00   00   00   00   08   08   00
Byte: 1    2    8    9    10   11   12   13
```

```
Byte 1 - Receiver Mode
0     Automatic (2D/3D)
1     Single Satellite (Time)
3     Horizontal (2D)
4     Full Position (3D)
5     DGPR Reference
6     Clock Hold (2D)
7     Overdetermined Clock
```

```
Byte 2 - Disciplining Mode
0     Normal (Locked to GPS)
1     Power Up
2     Auto Holdover
3     Manual Holdover
4     Recovery
5     Not Used
6     Disciplining Disabled
```

```
Byte 8/9 - Critical Alarms (MSB/LSB) Bit Masked
0   0   0   0     0   0   0  0     0  0  0  0     0   0   0   0
15  14  13  12    11  10  9  8     7  6  5  4     3   2   1   0 

Bit 4 = DAC at Rail

Therefore, bytes 8/9 will either be 00 00 (all good) or 00 10 (DAC at Rail).
```

```
Byte 10/11 - Minor Alarms (MSB/LSB) Bit Masked
0   0   0   0     0   0   0  0     0  0  0  0     0   0   0   0
15  14  13  12    11  10  9  8     7  6  5  4     3   2   1   0 

Bit 0  = DAC Near Rail
Bit 1  = Antenna Open
Bit 2  = Antenna Shorted
Bit 3  = Not Tracking Satellites
Bit 4  = Not Disciplining Oscillator
Bit 5  = Survey In-progress
Bit 6  = No Stored Position
Bit 7  = Leap Second Pending
Bit 8  = In Test Mode
Bit 9  = Position is Questionable
Bit 10 = Not Used
Bit 11 = Almanac Not Available
Bit 12 = PPS Not Generated
Bit 13-15 = Not Defined

Therefore, 00 08 would be Bit 3 set, which would be Not Tracking Satellites.
```

```
Byte 12 - GPS Decoding Status (result is in hex)
0x00  Doing Fixes
0x01  Don't Have GPS Time
0x03  PDOP is Too High
0x08  No Usable Sats
0x09  Only 1 Usable Sat
0x0A  Only 2 Usable Sats
0x0B  Only 3 Usable Sats
0x0C  The Chosen Sat is Unusable
0x10  TRAIM Rejected the Fix

To get "happy", we need 00. Anything else will cause loss of GPS lock. So, a 08 would be No Usable Sats. 
```

```
Byte 13 - Disciplining Activity (result is in decimal)
0     Phase Locking
1     Oscillator Warm-up
2     Frequency Locking
3     Placing PPS
4     Initializing Loop Filter
5     Compensating OCXO (Holdover)
6     Inactive
7     Not Used
8     Recovery Mode
9     Calibration/Control Voltage     
```

Former versions of firmware reported less information: 

```
	printf("GPS-DEBUG: TSIP: ok %d, 9 - 14: %02x %02x %02x %02x %02x %02x\n",
					happy,gps_buf[9],gps_buf[10],gps_buf[11],gps_buf[12],gps_buf[13],gps_buf[14]);
```

Those reported 0x8F-AC bytes 8-13. See above for a breakdown.

Sample messages:

```
GPS-DEBUG: TSIP: ok 1, 9 - 14: 00 00 00 00 00 00 - everything is good in the 'hood, Doing Fixes, Phase Locking

GPS-DEBUG: TSIP: ok 0, 9 - 14: 00 00 00 18 08 06 - not happy, Not Tracking Satellites, Not Disciplining Oscillator (0x18 --> 0b000000011000), No Usable Sats, Inactive

GPS-DEBUG: TSIP: ok 0, 9 - 14: 00 00 00 08 08 05 - not happy, Not Tracking Satellites, No Useable Sats, Compensating OXCO (holdover)

GPS-DEBUG: TSIP: ok 0, 9 - 14: 00 00 00 00 00 05 - not happy, Compensating OXCO (holdover)

GPS-DEBUG: TSIP: ok 1, 9 - 14: 00 00 00 00 00 08 - happy, Recovery Mode

GPS-DEBUG: TSIP: ok 0, 9 - 14: 00 00 00 00 00 04 - not happy, Initializing Loop Filter
```