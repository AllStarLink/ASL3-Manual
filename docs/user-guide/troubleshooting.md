# Basic Troubleshooting Tips
When asking for help on [AllStarLink Community](https://community.allstarlink.org) or in a [GitHub](https://github.com/AllStarLink) Issue here are some tips on how to ask for help and how to get common troubleshooting information that is often needed to understand your specific issues.

## Tips on Asking for Help
Keep in mind that when asking for help, the pool of people likely able to help have no understanding of your personal setup, situation, skills, etc. In order to get good help, you need to ask a good question. Make sure when asking for help that you hit the following points:

#### Explain **Precisely** What is not Working Properly
Requests for help such as "ASL doesn't work" or "my Pi crashes" or "I can't do X" without any further details or information is unable to be diagnosed and assisted.

Examples of **GOOD** ways to ask a question:

* I just built a new ASL3 Pi and when I try to connect to the interface I get __this particular__ error.

* After I configured my node, I am trying to do __this particular thing__ and it doesn't work because of __this particular error__.

* I am trying to configure __this particular feature__ in `rpt.conf` and when I do, __this particular thing__ happens.

* I used to be able to do __this thing__ and after I change __this other thing__ then __this thing__ stopped working.

Basically, before submitting your question to Community, make sure your post contains the basics of "what am I trying to do", "what do I think should be happening", and "what is happening instead". If you are filing an issue on GitHub, use the Issue Templates - they ask for information for a reason.

#### Be Ready to Provide Requested Basic Troubleshooting Info
If you are going to ask for help, be ready and willing to provide the basic troubleshooting information that is requested. For example, if you're having a problem linking to another node, be ready to provide - or even better provide in advance - the basic troubleshooting information needed to help with your problem.

Items that may be requested include elements such as:

* How is your node connected to the Internet?

* What IAX2 port is configured?

* What client are you using?

* What radio type are you using?

* What is your IP address?

* Is the time correct on your system?

* Can you put a monitor on the device and tell what the screen says

* What did the log say about...?

#### AllStarLink Does Not Support Certain Other Projects/Tools
Core AllStarLink does not support certain other projects/tools such as HamVOIP, Supermon/Supermon2, SkyWarnPlus, or AllScan. Some of the developers of these tools such as SkyWarnPlus and AllScan are active and answer questions on the Community, and others are not.

If you are told, "that isn't supported but have you tried doing it in this supported way", consider giving it a try. 

#### AllStarLink v3 Contains 14+ Years of Changes
The release of AllStarLink v3 uses modern Asterisk 20 LTS. Legacy installs use Asterisk 1.4 which was end of life in 2012. Thus, there are literally 14+ years of changes of how Asterisk operates that `app_rpt` (the main engine behind ASL) had to conform to. Notably, the configuration syntax which changed gradually over time for users staying current with Asterisk, is an "all of a sudden" change in ASL3. One cannot paste old configurations into modern ASL3 and expect it to "just work".

Additionally, Asterisk no longer runs as the root user on Linux which means that its ability to do things to the system such as make OS changes is purposefully restricted. ASL3 and Asterisk are very security conscious as many of our users run ASL3 systems on the open Internet.

#### Give Questioners the Benefit of the Doubt
In general, if people are asking questions about the details of your problem, they are likely trying to help and not nitpick. In general, if many people are having the problem, it is already known and [likely documented](../basics/incompatibles.md#known-issues).

If it's not, then likely your issue is unique to your setup and providing the requested troubleshooting is needed to help you further.

## Basic Troubleshooting

### Gathering Logs
If you are asked to provide logs, there are two standard ways to provide logs, using [`Cockpit`](../pi/cockpit-basics.md) or using the `journalctl` tool from the 
Linux CLI.

#### Gathering Logs with Cockpit
In the [Cockpit interface](../pi/cockpit-basics.md), click **Services** on the left navbar. The service list will display. Wait for the full list to load and then click
on the blue link name of the service. The common services are:

* `allmon3` - Allmon3

* `asl3-update-astdb` - Maintenance of the `astdb.txt` file used by third-party apps

* `asl3-update-nodelist` - Maintenance of the "file" based lookup database, if installed

* `asterisk` - Core `Asterisk/app_rpt`

* `networking` - Information about network interfaces

* `NetworkManager` - Information about network items of all sorts

* `systemd-timesyncd` - Information about network time synchronization

After clicking on one of the links, wait until **Service logs** fills in and then view the logs. Clicking **View all logs** will show more logs.

#### Gathering Logs with CLI/SSH
Use the `journalctl -xeu` command to provide logging output. For example:

```
journalctl -xeu asterisk.service
```

Common services are:

* `allmon3.service` - Allmon3

* `asl3-update-astdb.service` - Maintenance of the `astdb.txt` file used by third-party apps

* `asl3-update-nodelist.service` - Maintenance of the "file" based lookup database, if installed

* `asterisk.service` - Core `Asterisk/app_rpt`

* `networking.service` - Information about network interfaces

* `NetworkManager.service` - Information about network items of all sorts

* `systemd-timesyncd.service` - Information about network time synchronization

### Gathering Configs
It is often needed to gather certain configuration details. Use the [Cockpit Console](../pi/cockpit-console.md) or the SSH/CLI interface. People asking for information will likely provide the filename needed in their request. However, here are some easy ways to get the data requested:

* `tail -n50 FILE` - Print the last 50 lines of `FILE`

* `tail -F FILE` - Print the output of `FILE` as it is written to (useful for watching logs
live). Press Ctrl+c to exit

* `more FILE` - Print `FILE` by pages

* `less FILE` - Less is more than more... Less is an interactive scroller and searching interface. For example typing `/SOMETHING` will search for the string "SOMETHING" forward from where you are in the file and `?SOMETHING` will search backwards. Enter CTRL+c to exit

* `grep SOMETHING FILE` - This is for basic searching within a file. For example, you can use `grep` to answer the question "what does the line with FOO in FILE say?". This command
would be `grep FOO FILE`. Note that by default, your `grep` searches are case-sensitive, use the `-i` flag for case-insensitive searches, i.e. `grep -i FOO FILE` will find all instances of "foo", "FOO", "FoO", etc. 

When possible, please copy/paste log and search text instead of attaching screenshots into systems for troubleshooting. Text is far easier to deal with (can be quoted in replies), and will make your trouble show up in search engines to help "the next person".
