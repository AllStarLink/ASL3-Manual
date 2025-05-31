# VOTER Simulcasting
Simulcasting is a means by where you operate multiple **transmitters** on the same frequency, at the same time, in diverse geographic locations, sending the same data/information.

In doing so, you realize a number of advantages:

* Improved coverage area
* Improved signal strength/field strength at the subscriber receivers
* Better spectrum utilization
* Increased (transmitter) redundancy

While the above are all great achievements, building a properly functioning simulcast system is **very** difficult to do in practice.

If the transmitters aren't *precisely* on frequency (or tightly controlled), they will *beat* with each other, causing holes/nulls in the coverage area where there is poor signal/distortion.

Audio (and/or data) has to be sent from the master/host site to all participating transmitters. The delay in getting to each transmitter site will be different (latency) and may not be consistent (may have jitter). So, you have to compensate for these delays and by inserting a *launch delay* that is equivalent to the delay to get from the host to the furthest site in all the *other* sites, so that the audio/data actually gets sent out over the air at the same time from all transmitters.

The audio (and/or data) being sent over the air has to be *phase coherent* (all in-phase). Otherwise, as the signals mix in the air, you will again end up with holes and other artifacts in the received signal.

These are just a few of the many issues faced in building a simulcast system. Not for the weak of heart, but it is a lot of fun when it is working! Theoretically, (if you could get it coordinated and get enough sites) you could have a networked repeater system on the *same frequency* all over a state, with seamless coverage.

The VOTER/RTCM boards do support simulcasting, however, there are a bunch of quirks that one needs to be aware of.

## Radio Hardware
For best results, you should use all identical RF equipment between your voting RX sites and simulcast TX sites. 

If you don't, you can end up with strange audio artifacts when different receivers are used, and other strange audio issues when different transmitters are used. The most important thing when setting your levels is that **ALL** the RX and TX levels **match** from radio to radio. 

The best way this is achieved is using a "master" radio and reference from that - all radios might be identical models, but may not have identical audio characteristics so check those levels! Also check CTCSS and audio levels separately to make sure they all match.

## 9.6MHz Oscillator
If you want reliable simulcast with an acceptable level of overlap warble, you MUST inject a GPS-disciplined or OCXO 9.6MHz signal to the clock of the VOTER/RTCM, in lieu of their stock internal crystal. 

Otherwise, the inherent internal clock jitter of the VOTER/RTCM will cause CTCSS warble, etc. in areas where your transmitters overlap. The 1 PPS feed that you normally feed the VOTER/RTCM is acceptable for voting, but naturally, a typical crystal-driven clock will slightly drift in between the pulses every second due to inherent jitter, etc., and that isn't good for situations like simulcast which demand sample-accurate performance.

Here are some comments from Joe, KC2IRV, on the subject. He has also created his own wiki, specific to simulcast issues, you can find it at: [http://rtcmsimulcast.wikifoundry.com/](http://rtcmsimulcast.wikifoundry.com/). 

> I felt I needed to let those on this mailing list know my findings with simulcasting with the RTCM units since I have received a great deal of help and information from people on this list.
>
> For the past week I have had a two (2) site simulcast system up and running on UHF using the RTCM units. I have done a great deal of testing and proving on the bench and it is so far working beautifully. 
>
> The one issue that was made apparent to me early on was that in order for the RTCM's to be suitable for simulcast, the processor inside it needed to be clocked to a more accurate source. This source is supposed to be the Programmable Clock Generator Module in order to produce a GPS locked 9.6 MHz reference for the processor. Unfortunately this unit is not currently available.
>
>Knowing this, I started to go down the road of possibly designing my own, but stumbled upon a cheap, plentiful supply of Symmetricom 9.6 MHz sinewave OCXO's. I took a chance and ordered a few to experiment with to see if the RTCM would be able to use this in place of the supplied crystal for a clock. I found they did, with that I decided to modify the RTCM with an SMA connector just above the audio adjustment pots and use this OCXO. I trimmed the frequency on the units to match each other and used them to produce the processor clock.
>
>After a week of testing, I have found the results in the overlap areas to be exactly as I would expect them on a public safety/commercial simulcast system. While in an overlap region where both transmitters are within 3dB of one another, to the ear you hear no audio phase wandering. Of course, this has only been a week of testing so I wouldn't call it case closed yet.
>
> I will say that if this system remains this way after testing for 6 months to a year than using a 9.6 MHz OCXO is a viable alternative to achieve the needed precision and accuracy needed for the processor clock to make it suitable for simulcast.

Comments from Jim Dixon on the issue:

> You have to use **something** that will take the precise 10MHz (or whatever it is) from the GPSDO and PLL (phase-locked) convert it to 9.6MHz (square wave at 3.3V for the CPU clock).
>
> We had to use 9.6MHz mainly because of the DAC in the dsPIC instead of 10MHz. The options for various divide/clock radios in the part are RATHER limited. As I recall, there wasn't even a way of getting the necessary 16kb/s sample rate on the ADC from 10MHZ, either.

## Micro-Node RTCM Clock Issue

James, KI0KN, had some strange-ness with some of his RTCM's when used for voting. As soon as he changed menu item 10 on the RTCM to either a (1) or a (0) instead of (2), he **instantly** got this on the RTCM console:

```
04/05/2016 18:44:13.660  Lost GPS Time synchronization
04/05/2016 18:44:13.660  Host Connection Lost (Pri) (10.16.1.240)
```

And it sits there forever and never re-establishes connection to the host. The issue was finally traced to a bad batch of 9.6MHz crystals that affected a small run of the RTCM's. The issue was eventually resolved by Micro-Node, but we'll document it here just for record keeping.

James comments to the mail list:

> Well, after many of you offered your time and thoughts on my voter problem, Jim, WB6NIL, graciously donated a couple of hours of his time to remotely help me and he uncovered the problem.
>
> All 5 of my RTCMs were purchased within the last 6 months, and I suspect all 5 have the same problem (will verify that today). The problem is that the microprocessor crystal is running too fast! There is 9.6Mhz crystal that drives the MPU, on the particular unit that Jim helped me diagnose, it's running 2.5khz too fast.  
>
> There is a sanity check in the firmware that makes sure the correct number of samples were taken in the last second (it's supposed to be 8000) and fails if the sample is incorrectly sized (mine is taking 8003 samples).  Jim helped adjust the code to be more tolerant of the sampling error and my whole system instantly worked.
>
> I have since tested it with ALL my GPSs (they all work great!). So I now have everything working, including the voting.
>
> I haven't contact Micro-Node about it yet. Jim told me that voting should work fine but this clock error would probably not be acceptable for Simulcast (something we have no plans on doing as of now). Since mine are deployed at mountain top sites, I'll probably pursue a crystal that is running at the correct frequency and use "standard" firmware so that if the decision is ever made to play with simulcast, I won't be right back in this same boat.
>
> Thanks to all that helped out, and a HUGE thanks to Jim for taking the time to troubleshoot this.
>
> BTW- This clock error will NOT effect the RTCM in mix client mode, it only affects it in voting or simulcast mode!
>
> In voter.c, the stock line is:
>
```
if ((samplecnt >= 7999) && (samplecnt <= 8001))

it needs to be changed to something like:

if ((samplecnt >= 7999) && (samplecnt <= 8003 ))
```
>
> That was just enough to make my first RTCM work. I've had a chance now to check a few more of my RTCMs on the bench this morning and the crystal frequencies are kind of all over. The next one I had on the bench was 5.2Khz fast. The above code was still not enough to fix it (as would be expected) so it looks like the quality control on whatever manufacturer that crystal is, isn't very good (or a low tolerance crystal is being used). I am going to pursue crystal replacement to get a highly accurate, stable, on-frequency crystal in there as my first choice. Changing the firmware 5 different times doesn't seem like the right answer.
>
> Jim put that sanity check in there for a reason. Working around it '''may''' allow the device to work, but to me, it seems getting the hardware operating the way it was supposed to originally is the better answer. I will follow up with Micro-node and let you all know how it goes.


After following up with Micro-Node:

> They were all off, some were off a LOT. I talked to Mark @ Micronode. He told me there were 25 units that made it out the door with a crystal from an unapproved source and that was quite likely the reason for the problem. He gladly sent me 5 new crystals to replace (he offered to replace them himself if I sent the units in, but I am comfortable doing it myself to save the time and postage). 
>
> I haven't received them in the mail yet to show that the problem is fixed, but I will post here when that happens. He was great to work with and had no issue getting things set straight. If you are having the same issue and your RTCMs were bought about the same time, I'd suggest you contact him and have him help you resolve the issue!
