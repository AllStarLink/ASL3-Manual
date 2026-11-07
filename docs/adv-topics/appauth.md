# App Authentication Changes

AllStarLink is replacing the old "WebTransceiver" (WT) login method used by mobile and desktop apps with a new, more secure method called **App Authentication** (AppAuth). Apps that connect to nodes using your AllStarLink Portal callsign and password are **not** going away. Only the way those apps prove who you are is changing.

| Date | What Happens |
| - | - |
| **December 5, 2026** | The one-year transition period begins. |
| **June 3, 2027** | Apps still using the old WebTransceiver login stop working. |
| **December 6, 2027** | Nodes that have not been updated can no longer accept connections from apps. |

What you need to do depends on whether you run a node, use an app, or both:

* [ASL3 Nodes](#asl3-nodes): keep your node updated
* [App Users](#app-users): keep your apps updated
* [HamVOIP Nodes](#hamvoip-node-owners): apply a manual config change
* [Other Legacy Nodes](#other-legacy-nodes): apply a manual config change

For the background on why this change is occurring, see [Background](#background).


## ASL3 Nodes

If you run an ASL3 node, the work is done for you by the regular software updates. You only need to make sure your node is kept up to date. On the ASL3 Appliance, use the [Cockpit Updates](../pi/cockpit-updates.md) page. See [Updating ASL3](../user-guide/updates.md) for more details.

If you are using the ASL3 packages but not the full ASL3 Appliance, install updates as you normally would. From the command line:

```bash
sudo apt update
sudo apt upgrade -y
```

That's all that's needed in almost all cases.

### Highly Customized extensions.conf

If you have a highly customized `/etc/asterisk/extensions.conf`, the update changes the `[allstar-public]` context in `/etc/asterisk/extensions.conf` so that your node checks app logins using the new AppAuth method. Your node will continue to accept connections from older apps during the transition period. To check whether your node is ready, run:

```bash
grep appauth /etc/asterisk/extensions.conf
```

If the command prints a line containing `api.allstarlink.org/v1/appauth/validate`, your node is ready and there is nothing else to do.

If the command prints nothing, your `[allstar-public]` context still uses the old method. Update the `[allstar-public]` context to match the example in the [ASL002 App Authentication standard](https://github.com/AllStarLink/Standards/blob/main/ASL002-App_Authentication.md), then reload the dialplan:

```bash
sudo asterisk -rx 'dialplan reload'
```

## App Users

If you use a phone or computer app that logs in with your AllStarLink Portal callsign and password, such as those listed in [External Applications](../user-guide/externalapps.md), you need to make sure the app is kept up to date.

* **Turn on automatic updates** for the app in your phone's app store, or check for updates regularly.
* **Update before June 3, 2027.** After that date, apps that have not been updated to support AppAuth will no longer be able to log in and connect to nodes.
* **If your app stops connecting** after June 3, 2027, check for an app update first. If no update is available, contact the app's developer. AllStarLink does not write or support these third-party apps.

Your login does not change. You will still sign in to the app with your AllStarLink Portal callsign and password.

!!! note
    Apps that connect using [IAX Direct Authentication](../adv-topics/iax-auth.md) or [SIP](../adv-topics/sip-phone.md) with a username and password configured on the node itself are not affected by this change.

## HamVOIP Node Owners

HamVOIP Node Owners must apply a manual change to `/etc/asterisk/extensions.conf`. For most users, this can be accomplished by the following:

1. SSH into your HamVOIP system as **root**
2. Select item **9 Start Bash shell interface**
3. Copy and paste the following command into your terminal and press **Enter**:

    ```bash
    curl -fsSL https://repo.allstarlink.org/hotfix/appauth-update.sh | bash
    ```

4. Watch the output for any errors. If this is successful, then you can simply exit the terminal.

### Highly Customized HamVOIP extensions.conf

If you have a highly customized `/etc/asterisk/extensions.conf`, the update changes the `[allstar-public]` context in `/etc/asterisk/extensions.conf` so that your node checks app logins using the new AppAuth method. Your node will continue to accept connections from older apps during the transition period. To check whether your node is ready, run:

```bash
grep appauth /etc/asterisk/extensions.conf
```

If the command prints a line containing `api.allstarlink.org/v1/appauth/validate`, your node is ready and there is nothing else to do.

If the command prints nothing, your `[allstar-public]` context still uses the old method. Update the `[allstar-public]` context to the following:

```conf
[allstar-public]

exten => s,1,Ringing
exten => s,n,Set(TOKEN=${CUT(CALLERID(name),/,1)})
exten => s,n,Set(CALLSIGN=${CUT(CALLERID(name),/,2)})
exten => s,n,Set(RESP=${CURL(https://api.allstarlink.org/v1/appauth/validate?t=${TOKEN}&u=${CALLSIGN})})
exten => s,n,Set(NODENUM=${CALLERID(number)})
exten => s,n,GotoIf($["${RESP:0:1}" = "?"]?hangit)
exten => s,n,GotoIf($["${RESP:0:1}" = ""]?hangit)
exten => s,n,GotoIf($["${RESP:0:5}" != "OHYES"]?hangit)
exten => s,n,Set(RCALLSIGN=${RESP:5})
exten => s,n,Set(CALLSIGN=${IF($["${CALLSIGN}" = ""]?${RCALLSIGN}:${CALLSIGN})})
exten => s,n,GotoIf($["${RCALLSIGN}" != "${CALLSIGN}"]?hangit)
exten => s,n,Wait(3)
exten => s,n,Playback(rpt/node|noanswer)
exten => s,n,Saydigits(${NODENUM})
exten => s,n,Set(CALLERID(num)=0)
exten => s,n,Set(CALLERID(name)=${CALLSIGN})
exten => s,n,Rpt(${NODENUM}|X)
exten => s,n,Hangup
exten => s,n(hangit),Answer
exten => s,n(hangit),Wait(1)
exten => s,n(hangit),Hangup

exten => 9999,1,Goto(allstar-public|s|1)
```

Then reload the diaplan with:

```bash
asterisk -rx 'dialplan reload'
```

## Other Legacy Nodes

Other legacy Node Owners(limey, dial, etc) must apply a manual change to `/etc/asterisk/extensions.conf`:

```conf
[allstar-public]
exten => s,1,Ringing
exten => s,n,Set(TOKEN=${CUT(CALLERID(name),/,1)})
exten => s,n,Set(CALLSIGN=${CUT(CALLERID(name),/,2)})
exten => s,n,Set(RESP=${CURL(https://api.allstarlink.org/v1/appauth/validate?t=${TOKEN}&u=${CALLSIGN})})
exten => s,n,Set(NODENUM=${CALLERID(number)})
exten => s,n,GotoIf($["${RESP:0:1}" = "?"]?hangit)
exten => s,n,GotoIf($["${RESP:0:1}" = ""]?hangit)
exten => s,n,GotoIf($["${RESP:0:5}" != "OHYES"]?hangit)
exten => s,n,Set(RCALLSIGN=${RESP:5})
exten => s,n,Set(CALLSIGN=${IF($["${CALLSIGN}" = ""]?${RCALLSIGN}:${CALLSIGN})})
exten => s,n,GotoIf($["${RCALLSIGN}" != "${CALLSIGN}"]?hangit)
exten => s,n,Wait(3)
exten => s,n,Playback(rpt/node|noanswer)
exten => s,n,Saydigits(${NODENUM})
exten => s,n,Set(CALLERID(num)=0)
exten => s,n,Set(CALLERID(name)=${CALLSIGN})
exten => s,n,Rpt(${NODENUM}|X)
exten => s,n,Hangup
exten => s,n(hangit),Answer
exten => s,n(hangit),Wait(1)
exten => s,n(hangit),Hangup
exten => 9999,1,Goto(allstar-public|s|1)
```

and then restart their system.

## Background

This section explains why the change is being made. You do not need to read it to update your node or app.

### What Was WebTransceiver?

The original WebTransceiver was a Java applet on the AllStarLink website that let users connect to nodes from a web browser. Browsers dropped support for Java applets long ago, but the login method behind it lived on. Many mobile and desktop apps adopted it as the way to connect to a node without needing a node of their own.

### Why Is It Being Replaced?

The WebTransceiver method has two serious weaknesses:

1. **No session security.** The login credential is sent over the network unencrypted, and nothing prevents someone who captures it from reusing it.
2. **Weak credentials.** The credential is not unique enough to reliably tell users apart.

AppAuth fixes these problems while keeping app connections working. It also lets AllStarLink retire the old WebTransceiver service on www.allstarlink.org that has prevented improvements to the AllStarLink portal system.

### How AppAuth Works

1. When you connect, the app sends your Portal callsign and password securely to the AllStarLink API and receives a **one-time-use token**.
2. The app places the call to the node, passing along the token and your callsign.
3. The node asks the AllStarLink API whether the token is valid for that callsign.
4. If the token is valid, the connection is allowed. The token is then deleted and can never be used again.

Tokens that are never used expire after one day. Because every token works only once, a captured token is useless to anyone else.

### The Transition Period

Old and new apps and nodes will work together during the transition:

* **Updated node, updated app:** Uses AppAuth. Works permanently.
* **Updated node, old app:** Works until June 3, 2027.
* **Old node, updated app:** Works until December 6, 2027.
* **Old node, old app:** Works until June 3, 2027.

After December 6, 2027, only updated nodes and updated apps will be able to connect.

### More Information

* [ASL002 - App Authentication](https://github.com/AllStarLink/Standards/blob/main/ASL002-App_Authentication.md): the full technical standard
* [App Authentication to Replace "WebTransceiver" Auth](https://community.allstarlink.org/t/app-authentication-to-replace-webtransceiver-auth-testing-open/25051): the announcement on the AllStarLink Community
* [AllStarLink APIs](../developers/api.md): information for app developers
