# Calibrating Audio Levels For The Allstar Link System

## Introduction
Proper audio level calibration is crucial for ensuring good audio quality, and consistent audio levels from node-to-node. Fortunately, the procedure is not that complicated. To properly perform the audio level calibration, you will need the following items:

    An asterisk app_rpt.c compiled with Asterisk and installed.
    A service monitor, preferably one capable of simultaneous generation and analysis (e.g. HP 8920, IFR1200, or a separate signal generator and deviation meter), plus cabling.
    An audio signal generator
    Terminal access to the machine being calibrated.
    Tweaking tools if your radio or interface board have physical adjustment pots, or the appropriate service software for your radio.

## Assumptions
    1) The system you are calibrating uses 5khz deviation (standard nbfm) as the maximum peak deviation. For narrow band systems everything is half. So the step below which say to use 3kHz should use 1.5kHz.
    2) You must know the node number and the channel number of the radio port you wish to test. This can be looked up in rpt.conf.

## Procedure

### Checking the Radio's Transmitter's Peak Deviation
If you intend to drive the transmitter at the microphone input, or at another audio input before pre-emphasis and limiting, you must ensure that the peak deviation of the transmitter is no more than what is required to operate on the channel (typically 5KHz). If you driving the modulator directly from a URI, this section can be skipped.

    1) Disable the generation of CTCSS tones in the transmitter. (If you don't encode CTCSS, skip this step and steps 6 and 7)
    2) Hook up the audio signal generator to the transmitter microphone input, set it for a 1kHz sine wave, and the lowest output setting. Hook up the service monitor to the transmitter RF output (with appropriate attenuation for protection of your Service Monitor) and key the transmitter.
    3) On the service monitor, monitor the peak deviation of the transmitter. Gradually increase the output of the audio signal generator until further adjustment does not increase the deviation. Make a note of the peak deviation at this point.
    4) If the peak deviation is more than 5kHz, then adjust the transmitter deviation pot or soft pot so that the peak deviation reading on the service monitor is no more than 5kHz. Check the shape of the audio waveform on the service monitor's scope. It should show evidence of hard limiting (it should look like a square wave with rounded edges)
    5) Reduce the level of the audio signal generator so that the service monitor reads 3kHz of peak deviation. The audio waveform should now be a sine wave with no evidence of limiting.
    6) Re-enable the generation of CTCSS tones in the transmitter
    7) Check that the peak deviation is no more than 3.6 kHz. If it is more than this, adjust the CTCSS level so that a reading of 3.6kHz is attained.

### Adjusting the Transmit Audio Level
    1) Disable CTCSS tone generation in the transmitter or at the CTCSS encoder.
    2) Enable the test tone generator in rpt.conf and restart Asterisk
    3) Connect the radio interface to the transmitter
    4) Bring up the Asterisk CLI.
    5) From the asterisk CLI, type rpt fun yournodenumber *989 where yournodenumber is the node number assigned to you.
    6) The transmitter should key and you may hear a tone. Adjust the tx level until the service monitor indicates 3kHz of peak deviation.
    7) From the asterisk CLI, type rpt fun yournodenumber #. This will kill the test tone and unkey the transmitter.
    8) If encoding CTCSS, re-enable the CTCSS encoder in the transmitter, then repeat the previous 3 steps. You should see no more than 3.6KHz of deviation with the CTCSS tone generator enabled. If it is higher than this, adjust the CTCSS level per your transmitter's service documentation until a 3.6KHz of deviation is seen on the service monitor.

### Adjusting the Receive Audio Level
The procedure depends on what type of radio you have interfaced. If your radio is a repeater, use the full duplex procedure, if your radio is a remote base or simplex node, use the half-duplex procedure. Note: if you have a URI, the automated setup procedure should have set the receive level very close to what it needs to be. This section can be used to verify the receive level is correct for a URI, but the URI receive level should always be set using the automated adjustment procedure.

### Full Duplex Radios
Adjusting the receive level of a full duplex radio is easy.

    1) Disable the transmitter CTCSS encoder. Bypass the receiver CTCSS decoder so that it is in carrier squelch.
    2) Monitor the deviation of the transmitter on the service monitor while simultaneously injecting a 1kHz tone frequency at 3kHz deviation on the receiver.
    3) Adjust the receive level pot until you see 3kHz of deviation on the transmit frequency.
    4) Disable the signal on the receiver. The receive audio level is now set.

### Half Duplex Radios
Half duplex radios will require the use of a second node which has had the transmit level properly set, and is not transmitting a CTCSS tone. The second node must be receivable by your service monitor or deviation meter but does not need to be co-located with the node undergoing the receive level adjustment. The CODEC used to send audio to the second node must either be uLAW or ADPCM. The GSM codec will give inaccurate results.

    1) Using the Asterisk CLI, connect the node to be adjusted to the transmit node: rpt fun yournodenum *3txnodenum
    2) Monitor the deviation of the second node's transmitter on the service monitor while simultaneously injecting a 1kHz tone frequency at 3kHz deviation on the receiver on the first node.
    3) Adjust the receive level pot until you see 3kHz of deviation on the transmit frequency.
    4) Disable the signal on the receiver. The receive audio level is now set.
    5) Disconnect the receive node from the transmitter: rpt fun yournodenum *1txnodenum