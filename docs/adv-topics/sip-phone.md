# Setting up a SIP Phone
This document describes the steps necessary to set up a SIP phone in ASL3.  The setup procedure has changed due to the depreciation of chan_sip.  Users are now required to use chan_pjsip.  chan_pjsip brings new features to the sip stack and is the supported sip channel for the future.

## Update modules.conf
chan_pjsip requires a number of modules to be loaded.  You should start by editing /etc/asterisk/modules.conf and add the following at the bottom of the file:


```
    ;
    ;modules for pjsip
    ;
    noload = app_voicemail.so
    load = bridge_builtin_features.so
    load = bridge_builtin_interval_features.so
    load = bridge_holding.so
    load = bridge_native_rtp.so
    load = bridge_simple.so
    load = bridge_softmix.so
    load = chan_bridge_media.so
    load = chan_pjsip.so
    load = func_pjsip_endpoint.so
    load = func_sorcery.so
    load = func_devstate.so
    load = res_pjproject.so
    load = res_pjsip_acl.so
    load = res_pjsip_authenticator_digest.so
    load = res_pjsip_caller_id.so
    load = res_pjsip_dialog_info_body_generator.so
    load = res_pjsip_diversion.so
    load = res_pjsip_dtmf_info.so
    load = res_pjsip_endpoint_identifier_anonymous.so
    load = res_pjsip_endpoint_identifier_ip.so
    load = res_pjsip_endpoint_identifier_user.so
    load = res_pjsip_exten_state.so
    load = res_pjsip_header_funcs.so
    load = res_pjsip_logger.so
    load = res_pjsip_messaging.so
    load = res_pjsip_mwi_body_generator.so
    load = res_pjsip_mwi.so
    load = res_pjsip_nat.so
    load = res_pjsip_notify.so
    load = res_pjsip_one_touch_record_info.so
    load = res_pjsip_outbound_authenticator_digest.so
    load = res_pjsip_outbound_publish.so
    load = res_pjsip_outbound_registration.so
    load = res_pjsip_path.so
    load = res_pjsip_pidf_body_generator.so
    load = res_pjsip_pidf_digium_body_supplement.so
    load = res_pjsip_pidf_eyebeam_body_supplement.so
    load = res_pjsip_publish_asterisk.so
    load = res_pjsip_pubsub.so
    load = res_pjsip_refer.so
    load = res_pjsip_registrar.so
    load = res_pjsip_rfc3326.so
    load = res_pjsip_sdp_rtp.so
    load = res_pjsip_send_to_voicemail.so
    load = res_pjsip_session.so
    load = res_pjsip.so
    noload = res_pjsip_t38.so
    noload = res_pjsip_transport_websocket.so
    load = res_pjsip_xpidf_body_generator.so
    load = res_rtp_asterisk.so
    load = res_sorcery_astdb.so
    load = res_sorcery_config.so
    load = res_sorcery_memory.so
    load = res_sorcery_realtime.so
```


## Update extensions.conf

The next step is to update extension.conf.  This creates a dial plan that controls access to your node by sip phones.  Edit /etc/asterisk/extensions.conf and add the following to the bottom of the file.  This example will set up extension 1001 as your local phone and the dialing plan for your node.


```
    [sip-phones]
    exten => 1001,1,Dial(PJSIP/${EXTEN},60,rT)

    exten => ${NODE},1,Ringing
    exten => ${NODE},n,Answer(3000)
    exten => ${NODE},n,Set(NODENUM=${CALLERID(number)})
    exten => ${NODE},n,Playback(extension)
    exten => ${NODE},n,SayDigits(${NODENUM})
    exten => ${NODE},n,Playback(connected)
    exten => ${NODE},n,Playback(rpt/node)
    exten => ${NODE},n,SayDigits(${EXTEN})
    exten => ${NODE},n,rpt(${EXTEN}|P)
    exten => ${NODE},n,Hangup
```


The above dial plan will allow your sip phone to dial your node number.  This dial plan announces the extension number and the connecting node number.  The orange highlighted lines can be removed if you do not want the announcement.

The ${NODE} variable is defined at the top of extensions.conf and should be your assigned node number.  See the following.


```
    [globals]
    HOMENPA = 999 ; change this to your Area Code
    NODE = 1999   ; change this to your node number
```


The entry **1001** in extensions.conf is the extension number for your sip phone.  If you want to use a different extension number, change **1001** to your desired extension number.

_Note:  If you attempt to copy extensions.conf from a previous release of AllStarLink, it will fail.  AllStarLink version 3 requires comma delimiters instead of pipe symbols for standard asterisk functions.  The rpt function continues to use a pipe delimiter.  This is subject to change in a future release._

## Update pjsip.conf

You are now ready to configure pjsip.  Edit /etc/asterisk/pjsip.conf.  Don’t get overwhelmed by all of the text in the sample configuration.  pjsip supports several configurations.  This document focuses on the necessary entries to get a sip phone operational.

Scroll down to the Basic UDP transport section.  It should look like the following:


```
    ; Basic UDP transport
    ;
    [transport-udp]
    type=transport
    protocol=udp    ;udp,tcp,tls,ws,wss,flow
    bind=0.0.0.0:5060
```


Scroll down to the section titled Endpoint Configured For Use With A Sip Phone.  For each extension, you will need to enter 3 sections.  Here is an example for extension 1001.


```
    [1001]
    type=endpoint
    transport=transport-udp
    context=sip-phones
    disallow=all
    allow=ulaw
    allow=alaw
    allow=gsm
    auth=1001
    aors=1001
    callerid="My CallerID"
    ;
    ; A few more transports to pick from, and some related options below them.
    ;
    ;transport=transport-tls
    ;media_encryption=sdes
    ;transport=transport-udp-ipv6
    ;transport=transport-udp-nat
    ;direct_media=no
    ;
    ; MWI related options

    ;aggregate_mwi=yes
    ;mailboxes=6001@default,7001@default
    ;mwi_from_user=6001
    ;
    ; Extension and Device state options
    ;
    ;device_state_busy_at=1
    ;allow_subscribe=yes
    ;sub_min_expiry=30
    ;
    ; STIR/SHAKEN support.
    ;
    ;stir_shaken=no
    ;stir_shaken_profile=my_profile

    [1001]
    type=auth
    auth_type=userpass
    password=1001
    username=1001

    [1001]
    type=aor
    max_contacts=4
    ;contact=sip:6001@192.0.2.1:5060
```


If you want to use a different extension number, you will need to change **[1001]** with your desired number.  The item **callerid="My CallerID"** should also be updated for your preferred caller identifier.

The items **password=1001** and **username=1001** should be updated to match the username and password you want for your extension number.  You should use a complex password.  Do not use the extension number.  You can use the password generator located [here ](https://www.lastpass.com/features/password-generator#generatorTool)to generate a complex password.

These three sections can be replicated for each extension that you want to add to the system.

## Restart your asterisk

After completing these changes, you must restart asterisk or reboot your system.

```bash
systemctl restart asterisk
```

## Example config with multiple sip phones
As noted above you can have more sip phones.  Here is an example of a simple dial plan that has multiple extensions.

```
    [sip-phones]
    ; Extension 210 - Line 1
    ; Extension 211 - Line 2
    ; Extension 212 - Garage
    ; Extension 213 - Cordless ATA
    ; Extension 1000 - Voice Mail

    exten => 210,1,Dial(PJSIP/210,60,rT)
    exten => 211,1,Dial(PJSIP/211,60,rT)
    exten => 212,1,Dial(PJSIP/212,60,rT)
    exten => 213,1,Dial(PJSIP/213,60,rT)
    exten => 1000,1,VoiceMailMain(210)
    exten => 1000,2,Hangup

    ; Allow SIP calls to local nodes
    exten => 1998,1,rpt(1998|P)
    exten => 1999,1,rpt(1999|P)
```


This example includes voicemail.  To use voice mail, you will need to change `noload = app_voicemail.so `to `load = app_voicemail.so.`

## Troubleshooting

If you have trouble connecting your sip phone, start the asterisk command line with `asterisk -rvvv`.  Enter the command `pjsip set logger on`.  This will show the communications between the sip phone and asterisk.  It will also show the actions in your dial plan.

## Security

If you will be exposing your system to the outside world.  You should consider using fail2ban to protect the system.