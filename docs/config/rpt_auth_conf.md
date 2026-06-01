# rpt_auth.conf
rpt_auth.conf is the per-user TOTP authentication secrets file for [TOTP DTMF Authentication](../adv-topics/totp-auth.md). It maps 4-digit user IDs to their TOTP secrets and the privileged command stanzas they are granted access to upon login.

The file location is configured per-node in `rpt.conf` via the [`auth_users`](../adv-topics/totp-auth.md#configuration) key. A common path is `/etc/asterisk/rpt_auth.conf`.

## File Permissions

!!! warning
    This file contains shared TOTP secrets equivalent to passwords. Restrict permissions strictly:

    ```bash
    sudo chown asterisk:asterisk /etc/asterisk/rpt_auth.conf
    sudo chmod 0640              /etc/asterisk/rpt_auth.conf
    ```

## Format

```ini
[users]
<id4> = <BASE32_SECRET>, <command_set_stanza>
```

Field|Description
-----|----------
`<id4>`|Exactly 4 ASCII decimal digits (e.g. `1234`). Leading zeros are significant (`0001` ≠ `1`). Must be unique within the file.
`<BASE32_SECRET>`|RFC 4648 uppercase base32 encoded secret. Optional `=` padding. This is the same encoding used by Google Authenticator, Authy, FreeOTP, etc. Generate with: `head -c 20 /dev/urandom | base32`
`<command_set_stanza>`|Name of a `[functions-...]` stanza in `rpt.conf` that this user is granted access to upon login. Do not include brackets.

- Whitespace around commas is tolerated.
- Lines starting with `;` are comments.

## Example

```ini
[users]
; User 1234 — admin, granted totp-admin
1234 = JBSWY3DPEHPK3PXPABCDEFGHIJKLMNOP, totp-admin

; User 5678 — control op, granted totp-operator
5678 = KRSXG5BAMFRGGZDFMZTWQ2LK, granted totp-operator

; User 9999 — read-only diagnostics, granted totp-diag
9999 = NB2HI4DTHIXS653XO4XHSZLO, totp-diag
```

## Notes

- TOTP algorithm parameters (time step, window) are **not** per-user. They are configured per-node in `rpt.conf` via `auth_otp_step` and `auth_otp_window`.
- If this file is missing, unreadable, or contains syntax errors, the auth feature is silently disabled and a warning is logged. The node continues to operate normally for unauthenticated users.
- After editing this file, reload the module for changes to take effect:

    ```bash
    asterisk -rx "module reload app_rpt.so"
    ```
