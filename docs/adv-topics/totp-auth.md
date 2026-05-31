# Time Based One Time Password Authentication
TOTP Authentication allows node administrators to gate privileged DTMF commands behind a one-time password. Authorized operators authenticate over the air using a 4-digit user ID and a 6-digit code from a standard authenticator app (Google Authenticator, Authy, FreeOTP, 1Password, etc.) before gaining access to additional commands.

## How It Works
By default, every DTMF function in `rpt.conf` is accessible to anyone who can key the radio. This feature adds an **additional, privileged command set** that becomes available only after a user authenticates.

The login flow:

1. User keys a DTMF login prefix followed by their 4-digit user ID and a 6-digit one-time code from their authenticator app.
2. If the code is valid, their privileged commands become available **in addition to** the normal commands for that node.
3. The session remains active as long as the user keeps issuing commands (sliding timeout). After a period of inactivity, the session expires automatically.
4. The user can also log out explicitly via DTMF.

Key properties:

- **Per-node** — each node has its own independent session
- **Single session** — only one user can be authenticated per node at a time
- **Additive** — authenticated users gain extra commands; normal commands remain available to everyone
- **Standard TOTP** — works with any RFC 6238 compatible authenticator app

## Configuration

### rpt.conf — Node-Level Keys

Add the following keys inside your node stanza (e.g. `[1999](node-main)`):

```ini
auth_users             = /etc/asterisk/rpt_auth.conf
auth_timeout           = 300
auth_lockout_threshold = 5
auth_lockout_duration  = 60
auth_otp_step          = 30
auth_otp_window        = 1
```

Key|Description|Default|Range
---|-----------|-------|-----
`auth_users`|Path to the user/secret file. **Required** to enable the feature. If omitted, auth is disabled.|*(none)*|File path
`auth_timeout`|Sliding session timeout in seconds. Active use refreshes the timer.|300|30–86400
`auth_lockout_threshold`|Number of failed login attempts before lockout. Set to 0 to disable lockout.|5|0–1000
`auth_lockout_duration`|How long a locked-out user must wait, in seconds.|60|0–86400
`auth_otp_step`|TOTP time step in seconds. Must match your authenticator app (usually 30).|30|10–120
`auth_otp_window`|Number of time steps to accept on each side of the current step. Controls clock-skew tolerance.|1|0–3

!!! note
    Only `auth_users` is required. If it is not set or the file is missing/unreadable, the feature is silently disabled and all login attempts return an error tone.

### rpt.conf — Function Table Entries

The auth function must be reachable from your **default** functions stanza so that unauthenticated users can log in. Add entries for each sub-command:

```ini
[functions-main](!)
; ... your existing entries ...
A1 = auth,a
A2 = auth,s
A3 = auth,l
```

Sub-command|Parameter|Description
-----------|---------|----------
Login|`a`|Authenticate. Expects exactly 10 additional digits (4-digit user ID + 6-digit OTP).
Status|`s`|Query session status. Plays a courtesy tone if a session is active.
Logout|`l`|End the current session.

!!! tip
    The prefixes `A1`, `A2`, `A3` are examples. You can use any available DTMF prefix (e.g. `991`, `992`, `993`).

### rpt.conf — Privileged Command Stanzas

Define one `[functions-...]` stanza per role containing the commands available to authenticated users:

```ini
[functions-admin]
*99 = cop,5
*98 = cop,6
*73 = cmd,/usr/local/bin/restart-link.sh

[functions-controlop]
*55 = cop,42
```

These stanzas use the same `prefix = action,param` syntax as any other functions stanza. They are only reachable when an authenticated user mapped to that stanza is logged in.

!!! warning "Prefix Collisions"
    If the same prefix exists in both your default functions stanza and a privileged stanza, the privileged version takes priority when a session is active. Avoid overlapping prefixes that could shadow critical default commands.

### rpt_auth.conf — User and Secret File

Create the user/secret file at the path specified by `auth_users`. See the full reference at [rpt_auth.conf](../config/rpt_auth_conf.md).

```ini
[users]
1234 = JBSWY3DPEHPK3PXPABCDEFGHIJKLMNOP, functions-admin
5678 = KRSXG5BAMFRGGZDFMZTWQ2LK, functions-controlop
```

Each line maps a 4-digit user ID to a base32 TOTP secret and a privileged stanza name.

!!! warning "File Permissions"
    This file contains shared secrets equivalent to passwords. Restrict permissions:

    ```bash
    sudo chown root:asterisk /etc/asterisk/rpt_auth.conf
    sudo chmod 0640         /etc/asterisk/rpt_auth.conf
    ```

## Setting Up Users

### Generate a Secret

Generate a random 160-bit (20-byte) base32-encoded secret:

```bash
head -c 20 /dev/urandom | base32
```

This produces a string like `JBSWY3DPEHPK3PXPABCDEFGHIJKLMNOP`.

### Enroll the Authenticator App

**Option A — Manual entry:**

In the authenticator app, choose "manual entry" and enter:

- Account name: anything descriptive (e.g. `myrepeater-1234`)
- Key: the base32 secret string
- Type: Time-based
- Period: 30 seconds
- Digits: 6
- Algorithm: SHA-1

**Option B — QR code (recommended):**

```bash
# Install qrencode if needed: sudo apt install qrencode
SECRET=JBSWY3DPEHPK3PXPABCDEFGHIJKLMNOP
USER_ID=1234
ISSUER=myrepeater

echo "otpauth://totp/${ISSUER}:${USER_ID}?secret=${SECRET}&issuer=${ISSUER}&algorithm=SHA1&digits=6&period=30" \
    | qrencode -t ANSIUTF8
```

Have the user scan the QR code with their authenticator app.

### Add the User to rpt_auth.conf

```ini
[users]
1234 = JBSWY3DPEHPK3PXPABCDEFGHIJKLMNOP, functions-admin
```

### Reload

```bash
asterisk -rx "module reload app_rpt.so"
```

!!! note
    Reloading clears all active auth sessions on all nodes. Users must re-authenticate after a reload.

## Day-to-Day Usage

Using the example prefixes `*A1` (login), `*A2` (status), `*A3` (logout):

1. Open your authenticator app and note the current 6-digit code (e.g. `849203`).
2. Key `*A11234849203` on the radio (prefix + 4-digit user ID + 6-digit code).
3. Listen for the courtesy tone indicating successful login.
4. Issue privileged commands (e.g. `*99`). Each successful command refreshes the session timeout.
5. When finished, key `*A3` to log out. (Or simply stop — the session expires after `auth_timeout` seconds of inactivity.)

If the code is wrong, you will hear the standard error tone. After `auth_lockout_threshold` consecutive failures, that user ID is locked out for `auth_lockout_duration` seconds.

!!! note "Security"
    All failure modes (wrong code, locked out, feature disabled) produce identical error tones on the air. An attacker cannot distinguish between failure reasons by listening. Details are only visible in the Asterisk log and CLI.

## CLI Commands

Two Asterisk CLI commands are available for managing auth sessions:

### Show Session Status

```
asterisk -rx "rpt auth show <node>"
```

Displays whether a session is active, which user is logged in, time remaining, failed-attempt count, and lockout status.

### Force Logout

```
asterisk -rx "rpt auth logout <node>"
```

Immediately clears the active session on the specified node. Useful if a user forgets to log out or as part of an incident-response procedure.

## Operational Notes

- **One session per node.** If a second user logs in while a first is already authenticated, the first session is replaced without warning.

- **Time sync is critical.** TOTP relies on the node's system clock. If your node's clock drifts more than `auth_otp_window × auth_otp_step` seconds from real time (default ±30 seconds), all logins will fail. Use NTP (`chrony` or `systemd-timesyncd`).

- **Reloading clears sessions.** Any `module reload app_rpt.so` or rpt.conf reload clears all active auth sessions. Users must re-authenticate.

- **Disabling without removing configuration.** Comment out `auth_users` in `rpt.conf` and reload. Login attempts will return error tones. The DTMF prefixes will still consume input but produce only error tones.

- **Syntax errors in rpt_auth.conf.** If the file has parse errors or is unreadable, the feature is silently disabled, a warning is logged, and the node continues running normally for unauthenticated users.

- **No network management interface.** Adding/removing users and rotating secrets requires editing `rpt_auth.conf` on disk and reloading. There is no network attack surface for the secret store.

## Troubleshooting

Symptom|Likely Cause
-------|------------
Every OTP attempt fails|Clock skew on the node. Check `date` vs. real time. Enable NTP.
Specific user always fails|Wrong secret in `rpt_auth.conf` or user enrolled the wrong secret in their app. Re-generate and re-enroll.
Login OK but privileged command still fails|Stanza name in `rpt_auth.conf` doesn't match a `[functions-...]` stanza in `rpt.conf`. Check for typos.
All logins fail with "feature disabled" in log|`auth_users` not set, path is wrong, or file is unreadable by Asterisk. Check `ls -l` and the path.
User locked out unexpectedly|Too many wrong codes entered. Use `rpt auth show <node>` to check. Wait for `auth_lockout_duration` to expire, or reload the module to clear.
Authenticated command works but normal commands break|Prefix collision — your privileged stanza is shadowing a default command. Use non-overlapping prefixes.
`module reload` doesn't pick up new users|Reload may have failed. Check the Asterisk log for parse errors in `rpt_auth.conf`.
