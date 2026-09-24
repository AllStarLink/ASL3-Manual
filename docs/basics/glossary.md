# Glossary

This glossary defines terms, acronyms, and named tools that are specific to AllStarLink, `app_rpt`, amateur (ham) radio, or PBX/telephony (particularly Asterisk) as they are used throughout this manual. General computing, Linux, or networking terms are omitted unless they carry a specialized meaning in this context.

## 0-9

**44Net (AMPRNet)** — A block of globally routable IPv4 addresses (`44.x.x.x`) allocated for amateur radio use.

**44Net Connect** — A VPN service that gives an AllStarLink node a publicly routable 44Net IPv4 address over a WireGuard tunnel, commonly used when a node is behind NAT/CGNAT.

## A

**A Record** — A DNS record type returned by AllStarLink's node-lookup service, giving the IPv4 address of a node's IAX server or proxy.

**AAAA Record** — A DNS record type returned by AllStarLink's node-lookup service, giving the IPv6 address of a node's IAX server or proxy.


**Access List (Allowlist / Denylist)** — A per-node ASL3 access-control list, stored in the Asterisk database (AstDB) and enforced by contexts like `[radio-secure]` and `[allstar-public]`, that permits ("allowlist") or blocks ("denylist") connections from specific node numbers or callsigns; replaces the older global "blacklist"/"whitelist" system. Changes take effect immediately without editing config files or restarting.

**Adjacent Node** — A node directly connected to a given node, as opposed to one reachable only indirectly through another node.

**ADPCM (Adaptive Differential Pulse Code Modulation)** — A compact audio encoding that `chan_voter` and VOTER/RTCM clients can use instead of the default u-law encoding.

**AIOC (All-In-One-Cable)** — A low-cost USB radio interface device that can be recognized natively or reprogrammed to emulate a C-Media CM108 chip.

**Allmon3** — AllStarLink's current web-based dashboard for monitoring and controlling nodes, communicating with Asterisk over the Asterisk Manager Interface (AMI).

**allmon3-passwd** — The command-line utility used to add, edit, or delete Allmon3 user accounts stored in `/etc/allmon3/users`.

**allmon3.ini** — The Allmon3 configuration file where monitored node connections are defined, one stanza per node number, with host/port/credentials.

**`[allstar-public]` context** — The `extensions.conf`/`iax.conf` context that handles connections authenticated via the Web Transceiver token method.

**`[allstar-sys]` context** — The `extensions.conf`/`iax.conf` context that processes AllStarLink Telephone Portal calls.

**AllStarLink** — A network of amateur radio repeaters, remote base stations, and hotspots linked to each other over VoIP.

**AllStarLink Portal** — The web application (allstarlink.org/portal) where users register an account, add servers, request node numbers/passwords, and configure how a node presents itself to the network.

**AllStarLink Telephone Portal** — A dial-in phone number that lets a caller with a Portal account and PIN connect into or control a node from the PSTN.

**AMI (Asterisk Manager Interface)** — Asterisk's TCP-based management/control protocol, used by tools like Allmon3 to query and control a node; considered high-risk to expose to the public Internet.

**app_rpt** — The Asterisk application that provides AllStarLink's core repeater-controller, node, and linking functionality, invoked from the dialplan via the `Rpt()` application.

**Archive Directory (`archivedir=`)** — The `rpt.conf` setting that enables per-node audio recording and activity logging, storing recordings under a per-node-number subdirectory, keyed off COR activity.

**asl-backup-menu** — The utility (standalone or via `asl-menu`) for creating, restoring, editing, and deleting backups of a node's AllStarLink/Asterisk configuration.

**asl-broadcastify** — A templated, multi-instance systemd service that streams a node's audio to Broadcastify via ffmpeg, independent of the main Asterisk process.

**asl-check-install** — A command that checks an AllStarLink installation for problems, typically run after an OS upgrade.

**asl-find-sound** — A utility that lists USB sound devices compatible with `app_rpt`, for use as the `devstr=` value in `simpleusb.conf`/`usbradio.conf`.

**asl-menu** — ASL3's main text-based configuration menu utility, used to manage a node's number, password, audio interface, access lists, and other settings without manually editing files.

**asl-node-auth-check** — A command that performs a comprehensive check of a node's configuration, reachability, and registration status.

**asl-node-lookup** — A command-line tool that queries AllStarLink's DNS servers (and, as root, the local node table) for information about a node number.

**asl-play-arn** — A utility that plays the Amateur Radio Newsline audio bulletin on a specified node, immediately or at a scheduled time.

**asl-repo-switch** — A utility that changes the package release stream (e.g. main or beta) used for AllStarLink software updates.

**asl-say** — A tool for making Asterisk speak basic statements, such as the time or system IP address, on a specified node.

**asl-show-version** — A utility that reports the installed versions of all ASL3 packages, Asterisk, and `app_rpt`, typically used in bug reports.

**asl-tts** — AllStarLink's built-in text-to-speech command, using the Piper engine to generate and play spoken audio on a node without a pre-recorded sound file.

**asl3-update-astdb** — The engine that generates `astdb.txt`, the legacy node-name database used by third-party applications.

**asl3-update-nodelist** — The engine/service that periodically updates `rpt_extnodes`, the local node dictionary database used for node number resolution.

**ASL2** — AllStarLink version 2, the predecessor to ASL3, with no direct upgrade or migration path to ASL3.

**ASL3** — AllStarLink version 3, the current generation of the AllStarLink node software, built on Asterisk 20+.

**ASL3 Appliance** — A pre-packaged, near-turnkey configuration of ASL3 (for Debian systems, PCs, or Raspberry Pi) bundling Asterisk/`app_rpt`, Cockpit, Allmon3, and supporting tools.

**ASL3 Nodelist Updater** — The optional package that maintains a local cached copy of the AllStarLink node database for faster or offline node number lookups.

**astdb.txt** — A downloadable AllStarLink node-name database file historically used by third-party applications such as Supermon or Node Remote.

**Asterisk** — The open-source PBX (telephony) software platform that AllStarLink and `app_rpt` are built on.

**Asterisk CLI (Console)** — Asterisk's interactive command-line interface (`asterisk -rvvv`) used to issue live commands and troubleshoot a node.

**Asterisk Database (AstDB)** — Asterisk's built-in key/value database that ASL3 uses to store allowlist/denylist entries and other runtime state.

**asterisk user** — The dedicated, non-root system account under which the Asterisk process runs in ASL3.

**Autopatch** — An `app_rpt` feature letting radio users dial out to (or receive calls from) the public switched telephone network through a VoIP trunk connected to the node.

## B

**Backup and Restore menu** — The `asl-menu` section that backs up and restores a node's AllStar and Asterisk configuration.

**Band Plan** — A frequency allocation scheme, set by a regional/national amateur radio authority, specifying which frequencies/services are permitted within an amateur band.

**Beta channel** — An optional AllStarLink package repository stream containing pre-release software with in-progress bug fixes and features.

**bindport= / bindaddr=** — `iax.conf` directives that set the local UDP port (default `4569`) and address Asterisk listens on for incoming IAX2 connections.

**Bootloader (VOTER/RTCM)** — The initial firmware stage on a VOTER/RTCM's dsPIC that runs at power-up and allows remote firmware updates over Ethernet before handing control to the main firmware.

**Broadcastify** — A public audio-streaming platform that ASL3 nodes can stream repeater/node audio to via a feed account.

## C

**Call Token (IAX2 Call Token)** — An IAX2 anti-spoofing security mechanism required by Asterisk 20+ that some older client software doesn't support, sometimes requiring `requirecalltoken = no`.

**callsign** — The unique identifier issued by a licensing authority to an amateur radio operator/station, used to identify nodes, EchoLink accounts, and APRS reports.

**CGNAT (Carrier Grade NAT)** — A carrier networking technique that shares a public IP among many customers, breaking the IP-address matching that AllStarLink IAX connections traditionally require.

**chan_echolink** — The Asterisk channel driver implementing EchoLink connectivity for an AllStarLink node.

**chan_pjsip** — The modern Asterisk PJSIP channel driver used for SIP phone connections to a node, replacing the deprecated `chan_sip`.

**chan_simpleusb** — The "SimpleUSB" Asterisk channel driver used to interface a basic (no-DSP) USB radio sound card to `app_rpt`.

**chan_tlb** — The Asterisk channel driver implementing the TheLinkBox (TLB) linking protocol.

**chan_usbradio** — The "USBRadio" Asterisk channel driver, providing full-DSP USB radio interfacing with configurable audio filters and GPIO pins.

**chan_voter** — The Asterisk channel driver implementing the VOTER "master site," which receives/sends VOTER protocol packets, votes between receivers, and presents a radio channel to `app_rpt`.

**Channel Driver** — An Asterisk module (e.g. SimpleUSB, USBRadio, Voter, TLB, EchoLink) that provides the audio/signalling interface between `app_rpt` and a specific type of radio or network hardware.

**CM108/CM119** — C-Media USB audio chipsets commonly used in radio-to-computer USB sound fob (URI) interfaces, providing usable GPIO pins for PTT/COR/CTCSS signaling.

**Codec** — The audio compression format (e.g. u-law, ADPCM, GSM, slin) negotiated for IAX2 connections between nodes.

**Command Mode** — A DTMF operating mode where subsequent digits are sent directly to a specified remote node, bypassing local command decoding, until `#` is pressed.

**Configuration Template** — ASL3's stanza-inheritance system (e.g. `[node-main](!)` / `[1999](node-main)`) that lets multiple node stanzas in `rpt.conf`, `simpleusb.conf`, `usbradio.conf`, and `gps.conf` inherit shared default settings.

**Context (Asterisk)** — A named section of the Asterisk dialplan in `extensions.conf` that groups related call-handling logic, such as `[autopatch]` or `[allstar-sys]`.

**Control Operator (COP) Functions** — A privileged DTMF function class in `rpt.conf` used for control-operator-level administrative commands, such as manipulating GPIO pins or enabling Parrot/Sleep Mode.

**COR (Carrier Operated Relay) / COS (Carrier Operated Switch)** — The signal/state indicating a radio receiver has detected a valid carrier (squelch open), used to trigger recordings, keying, and activity logging.

**Courtesy Tone** — An audible tone or sound played when a transmission ends (on un-key) to signal repeater/link status to users.

**CTCSS (Continuous Tone-Coded Squelch System)** — A sub-audible tone (also called a "PL" tone) used for squelch and access control on repeaters and radios, calibrated as part of audio-level setup.

**CW ID** — A Morse code station identification sent by a node, configured via `idrecording=`.

## D

**DCS (Digital Coded Squelch)** — A digital sub-audible squelch/access code used as an alternative to CTCSS.

**De-emphasis** — Audio filtering applied to discriminator audio that reverses transmitter pre-emphasis, controlled by the `COR Type`/`nodeemp` options.

**Deviation (Peak Deviation)** — The amount of frequency shift produced by modulating an FM transmitter, calibrated as part of AllStarLink audio-level setup.

**Dialplan** — The Asterisk call-routing logic in `extensions.conf` that processes incoming calls/connections and hands them off to `app_rpt`.

**Discriminator Audio** — The raw, un-de-emphasized output of an FM receiver's discriminator, required by the VOTER/RTCM for noise-based squelch and RSSI analysis.

**DNS Node Resolution** — AllStarLink's method of resolving a node number to its IP address via DNS queries against `nodes.allstarlink.org`.

**DTMF (Dual-Tone Multi-Frequency)** — Touch-tone signaling used to send function/command codes to `app_rpt` from a radio or phone.

**DTMF Function** — A command triggered when a user dials a defined DTMF sequence prefixed by `funcchar`, used to control macros, linking, and other node behaviors; grouped into named "function classes" (e.g. `ilink`, `cop`, `autopatchup`) that determine what a code does.

**Duplex Mode** — An `rpt.conf` setting (0–4) controlling how a node handles simultaneous transmit/receive, telemetry tones, and hang time; distinct from the physical radio concepts of full duplex (simultaneous TX/RX, e.g. a repeater) and half duplex (TX/RX cannot occur simultaneously, e.g. simplex or remote-base nodes).

## E

**Echo Mode** — A diagnostic mode in `simpleusb-tune-menu` that loops back received audio so interface levels can be verified.

**EchoLink** — A separate VoIP-based amateur radio network that AllStarLink nodes can bridge to via `chan_echolink`, using a reserved node-number range prefixed with `3`.

**Event Management Subsystem** — An `app_rpt` mechanism, configured in `rpt.conf`'s `[events]` stanza, that triggers actions based on state transitions like keying or link changes.

**extensions.conf** — The Asterisk configuration file containing the dialplan that routes connections to `app_rpt` and handles autopatch calls.

**External Node Directory File (`rpt_extnodes`)** — A locally cached copy of the AllStarLink node database (maintained by `asl3-update-nodelist`) that `app_rpt` uses to resolve node numbers to IP addresses/ports, as an alternative or fallback to DNS.

## F

**Foreign Telemetry** — Telemetry announced on the local node when a remotely connected node performs an action, as distinct from telemetry generated by the local node itself.

**Full Quieting** — A ham radio term for a received signal strong enough to produce no audible noise, used as the reference condition when calibrating VOTER/RTCM audio levels.

## G

**GPIO (General Purpose Input/Output)** — Configurable input/output pins on a URI/USB sound fob (or parallel port) used for control and status signaling (e.g. PTT, COR) in `app_rpt`.

## H

**Hang Time (`hangtime=`)** — The length of time a repeater/node keeps its transmitter keyed after a user un-keys, akin to a squelch tail; often shortened for hot spot responsiveness.

**Hot Spot** — A low-power, typically simplex, personal AllStarLink node/gateway device used for local radio-to-network access (e.g. ClearNode, HotSpotRadio).

**HTTP Registration** — ASL3's default node-registration method (replacing IAX2 registration), which publishes a node's connection info via HTTP/DNS, configured via `rpt_http_registrations.conf`.

**Hub** — A node, often without an attached radio, used as a common meeting point that other nodes connect to.

## I

**IAX / IAX2 (Inter-Asterisk eXchange)** — The primary Asterisk VoIP protocol AllStarLink nodes use to connect to each other and to registration servers (default UDP port `4569`), configured in `iax.conf`.

**IAX Direct Authentication** — Configuring `iax.conf` to authenticate individual IAX2 clients/peers directly, bypassing the full ASL registration infrastructure.

**IAX Proxy** — An arrangement where an AllStarLink server with unstable/NATed connectivity (the Server Proxy Client) relays all its IAX2 traffic through a stable Server Proxy Server.

**IAX Registration** — The legacy method of registering a node's location with the AllStarLink Network using a `register=` directive in `iax.conf`, superseded by HTTP Registration.

**IAX Text Protocol** — An informally documented text-frame protocol `app_rpt` uses over IAX2 to exchange telemetry, keyed status, and messages between nodes (e.g. the `NEWKEY`/`IAXKEY` handshake).

**IAXRpt** — An older Windows "soft phone" client used to connect to an AllStarLink node over IAX2 using a computer's microphone/speaker.

**Initial Node Number (INN)** — A user's first, base AllStarLink node number, before being expanded into a Node Number Extension (NNX) series.

**iax.conf** — The Asterisk configuration file defining IAX usernames, secrets, ports, and contexts used to authenticate incoming node connections.

## J

**Jitter Buffer** — A buffering mechanism (in Asterisk/IAX2, or `chan_voter`'s multi-dimensional version) that smooths out network timing variation in received audio packets, or time-aligns audio from multiple VOTER/RTCM clients for voting.

## K

**Kerchunk** — Ham radio slang for briefly keying and un-keying a transmitter, often to test that a node/repeater is keying up correctly or to reset a time-out timer.

## L

**Loopback Protection** — `app_rpt` logic that refuses a connection when it detects the same node number already present elsewhere in the link path, preventing routing loops.

## M

**Macro** — A stored, numbered sequence of one or more DTMF commands (defined in a `[macro]` stanza) invoked by a single DTMF code, the scheduler, or an external script.

**Monitor Mode** — A link/phone connection mode that allows listening to a node/link without transmitting or exercising DTMF function control.

**Morse ID** — A telemetry method (`|i`) that sends a node's identification as Morse code.

## N

**NBFM (Narrow Band FM)** — The standard 5 kHz peak-deviation FM mode assumed as the baseline for AllStarLink audio-level calibration.

**NNX (Node Number Extension)** — A method of expanding a single issued AllStarLink node number into up to ten sequential node numbers by appending an extra digit.

**Node** — A logical AllStarLink endpoint, identified by a unique node number, running Asterisk/`app_rpt` and typically representing a radio, application, or link.

**Node Number** — The unique numeric identifier assigned to an AllStarLink node, analogous to a telephone number, used throughout dialplan, registration, and linking.

**Node Number Stanza** — The `rpt.conf` section, named after the node's number (e.g. `[1999]`), that holds all configuration options for that node.

**Node Registration** — The process by which a node announces its connection info to the AllStarLink Network so other nodes can locate and connect to it (see HTTP Registration, IAX Registration).

**nodes stanza** — The `rpt.conf` `[nodes]` section that acts like a local "hosts file," listing known nodes and their IP/hostname and port for lookup.

## P

**Parrot Mode** — A node mode that records a user's transmitted audio and plays it back after they un-key (after a `parrottime` delay), used for audio testing or to build a simplex repeater.

**peer** — In Asterisk/IAX2 terminology, a remote endpoint definition (`type=peer` in `iax.conf`) representing a server that can originate and/or receive calls.

**Permanent Node Connection** — A persistent link between two nodes that continuously reattempts connection and survives network outages and far-end reboots, established with `ilink,12/13/18` and removed with `ilink,11`.

**Phone Portal PIN** — The numeric code assigned to an AllStarLink Portal account, required to authenticate calls to the Telephone Portal.

**Ping Ponging (Relay Racing)** — A back-and-forth keying loop between two linked simplex nodes caused by COR or squelch glitches.

**Piper (piper-tts)** — The open-source, offline text-to-speech engine used by `asl-tts` to generate spoken node audio without cloud dependencies.

**PL Tone / DPL** — Common shorthand for CTCSS ("PL", Private Line) and DCS ("DPL", Digital Private Line) sub-audible squelch tones used for repeater and radio access control.

**PPS (Pulse-Per-Second)** — A precise, once-per-second timing pulse output by a GPS receiver that the VOTER/RTCM uses to discipline its internal clock for sample-accurate audio timing.

**Pre-emphasis** — High-frequency boost applied to transmit audio, normally by the transmitter (or by the VOTER/RTCM itself when generating CTCSS/direct-modulation audio), to match standard FM de-emphasis on receive.

**Private Node** — A node that does not directly connect to (or accept connections from) the public AllStarLink network, typically numbered under 2000, used for local/off-network testing.

## R

**radio-secure context** — The `extensions.conf` context, called from `iax.conf`'s `[radio]` stanza, that authenticates and routes incoming IAX2 node-to-node connections to `app_rpt`.

**Remote Base** — A node configuration where the attached radio can be remotely tuned/controlled (frequency-agile) rather than acting as a fixed repeater.

**Reverse Burst / Chicken Burst** — CTCSS "turn-off" styles (`txtoctype=`) where the tone is briefly phase-shifted (reverse burst) or continues briefly with no tone (chicken/notone burst) when a transmission un-keys, to quickly mute the receiving radio's squelch tail.

**RTCM (Radio Thin Client Module)** — Micro-Node International's commercial, surface-mount version of the VOTER hardware, protocol-compatible with the original through-hole VOTER board.

**RX Toneburst** — A repeater access method (common in Europe) requiring an initial burst of a specific tone (typically 1750 Hz) to "wake up" the repeater before it accepts carrier access.

## S

**SA818 / DRA818** — An inexpensive VHF/UHF RF transceiver module commonly used to build low-cost AllStarLink node/hotspot radio interfaces; `sa818` and `sa818-menu` are the command-line and interactive utilities used to program it.

**Scheduler** — The built-in `app_rpt` time-based scheduler, distinct from system cron, that triggers a macro to run once when a defined time/date pattern in the `[schedule]` stanza matches; can be toggled via control-state mnemonics `skena`/`skdis`.

**Server** — The physical or virtual machine that runs the Asterisk/`app_rpt` software and hosts one or more Nodes.

**SHARI** — A popular Raspberry Pi USB/HAT radio interface board sold by Kits4Hams.

**Simple Node Auth** — An AllStarLink API for authenticating infrastructure clients using a node number and node password.

**Simplex** — A radio mode where transmit and receive share the same frequency and cannot occur simultaneously; simplex nodes require VOX for autopatch.

**Simplex Dumb Phone Control Mode (S)** — An `app_rpt` dialplan option giving audio-only, toggle-PTT phone access to a simplex/half-duplex radio system.

**SimpleUSB** — One of `app_rpt`'s two USB radio interface driver/configuration types (`chan_simpleusb`, configured in `simpleusb.conf`), for basic USB radio interfaces without DSP-based tone decoding.

**simpleusb-tune-menu** — An interactive menu utility for tuning a SimpleUSB radio interface's TX/RX audio levels and checking COS/CTCSS/PTT signaling.

**Simulcast** — Operating multiple transmitters on the same frequency, precisely synchronized in time and frequency, so their coverage overlaps without mutual interference.

**SIP (Session Initiation Protocol)** — A VoIP signaling protocol commonly used by termination providers for autopatch trunks and by SIP phones, configured via `pjsip.conf`.

**Sleep Mode** — A node mode that disables the local repeater receiver after a period of inactivity (`sleeptime=`), re-enabled by remote traffic/telemetry or a `cop,53` command.

**Sound File Formats** — The header-less, 8kHz mono audio codec formats (`ulaw`, `gsm`, `pcm`) commonly used for Asterisk/`app_rpt` sound files.

**Splatter Filter** — Transmitter audio processing (limiting and filtering) that prevents adjacent-channel interference, normally provided by the transmitter unless the VOTER/RTCM feeds a direct modulation input.

**Squelch** — The receiver setting/circuit that mutes a radio's audio output until a signal, or a matching tone/code, is present; VOTER/RTCM's squelch threshold is set via a "squelch calibration" procedure performed with the antenna removed.

**SRV Record** — A DNS record type returned by AllStarLink's node-lookup service that gives a node's IAX2 port.

**stanza** — A named block of `key=value` settings in an ASL/Asterisk configuration file, delimited by square brackets; also called a context in dialplan terms.

**Startup Macro** — A macro (`startup_macro`) automatically executed when Asterisk starts, commonly used to establish a permanent link connection on boot.

**Stats API** — An AllStarLink JSON API for retrieving node and link statistics.

## T

**Tail Message** — A short audio message periodically played after a user un-keys (at the "tail" of a transmission), which can be interrupted ("squashed") if someone keys up over it.

**Telemetry** — Silent, out-of-band data messages exchanged between AllStarLink nodes on connect/disconnect and other events, defined in a `[telemetry]` stanza, which each node can announce, ignore, or customize.

**TheLinkBox (TLB)** — A third-party linking program (by WB6YMH) that interfaces with `app_rpt` via the `chan_tlb` channel driver and `tlb.conf`, using a private node number.

**Tone Group** — A set of four comma-separated values (two frequencies, duration, amplitude) defining one segment of a telemetry tone sequence.

**Tonemacro** — A macro triggered by receiving a specific CTCSS tone rather than a DTMF sequence, normally executing only once per newly received tone.

**TOT (Timeout Timer)** — The `app_rpt` feature (`totime=`) that limits the maximum continuous transmission length on a node/repeater, forcibly un-keying a stuck transmitter.

**TXT Record** — A DNS record type returned by AllStarLink's node-lookup service containing debugging info such as node number, IP address, and IAX port.

## U

**u-law** — The standard audio codec used by AllStarLink for node-to-node and client audio.

**URI (USB Radio Interface)** — A USB sound-card-based radio interface device (often built on chips like the CM108/CM119) used to connect a radio to an Asterisk server.

**USB EEPROM** — Onboard memory in some USB radio interfaces (e.g. CM119A/CM119B) used to store audio configuration values like `rxmixerset`.

**USBRadio** — The other `app_rpt` USB radio interface driver/configuration type (`chan_usbradio`, configured in `usbradio.conf`), supporting DSP-based squelch detection, CTCSS/DCS tone encode/decode, and additional audio filtering.

## V

**VFO (Variable Frequency Oscillator)** — The tunable frequency mode of a remote base radio, set via the `remote,2` command as opposed to a stored memory channel.

**VID/PID** — The USB vendor identifier and product identifier used by ASL3 to recognize compatible sound card interfaces.

**VOIP (Voice Over IP)** — The technology used by telephone termination providers to connect Asterisk-based autopatch calls to the PSTN.

**VOTER (Voice Observing Time Extension for Radio)** — The original open-source, GPS-timed receiver-voting hardware/protocol system created by Jim Dixon, WB6NIL, for use with `app_rpt`/AllStarLink; combines audio from multiple remote receiver sites and votes for the best signal.

**VOTER Protocol** — The connectionless, UDP-based protocol (historically port 667, now 1667) carrying timestamped/GPS-referenced audio, RSSI, and GPS position between VOTER/RTCM clients and the `chan_voter` host.

**VOX (Voice Operated Transmit)** — An audio-level-triggered PTT mechanism used for simplex nodes, autopatch, SIP phones, or the Telephone Portal, where a physical PTT signal isn't available.

## W

**Web Admin Portal** — The branded name for the Cockpit-based web administration interface on an ASL3 Appliance.

**Web Transceiver (WT)** — A browser/portal-based authentication method (originally a Java applet) letting apps connect to a node using AllStarLink Portal credentials, issued a token via the WebTransceiver Auth API.

