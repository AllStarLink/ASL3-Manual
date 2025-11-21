# Securing Allmon3 with HTTPS

By default, Allmon3 is installed without HTTPS support. Hence, when you browse to your Allmon3 dashboard, you get a warning about the webpage being "insecure".

Adding HTTPS support is relatively painless, using a certificate from [LetsEncrypt](https://letsencrypt.org/).

## Pre-requisites
There are pre-requisites to deploying a LetsEncrypt certificate successfully. The following process assumes the following:

* you have Allmon3 running on a supported Debian installation, with Apache as the webserver

* there are no other "virtual hosts" running on the webserver (there shouldn't be with a stock ASL3 installation)

* you have a registered domain name and/or subdomain name to deploy against

* the DNS for your domain name is configured to point at your server running Allmon3

!!! note "Static IP and Domain Names"
    This process is tested on an Allmon3 installation running "in the cloud" on a VPS with a static IP address and registered domain name. It IS possible to deploy LetsEncrypt with a dynamic DNS, but that is beyond the scope of this document. You are still likely to need a registered domain name (to point at your dynamic hostname), search for "letsencrypt ddns" to find more information on the process.

!!! warning "Firewall Rules"
    If you have Allmon3 on a public-facing webserver, we hope you're running a firewall! Remember to allow *both* ports `80/TCP` and `443/TCP` though your firewall, if you haven't already.

## Install Certbot
LetsEncryt uses the `certbot` utility to manage certificate requests and renewals. Install `certbot` as follows:

```
sudo apt update
sudo apt upgrade
sudo apt install certbot python3-certbot-apache
```

This will ensure that your system is up to date, then install `certbot` and the helper plugin for interacting with the Apache webserver.

## Request Certificate
Now, we will request and install a certificate for the webserver from LetsEncrypt. With the stock ASL3/Allmon3 installation, `certbot` and its associated plugin will automatically request a certificate, then modify your Apache webserver configuration files accordingly to support encryption.

Run the following command to secure your webserver:

```
sudo certbot --apache --agree-tos --redirect --hsts --staple-ocsp --email you@example.com -d yourdomain.com
```

This is a breakdown of the options used:


* `--apache`: Specifies that the webserver in use is Apache.
* `--agree-tos`: Indicates your agreement to Let’s Encrypt’s terms of service.
* `--redirect`: Sets up a permanent 301 redirect from HTTP to HTTPS, ensuring all traffic is encrypted.
* `--hsts`: Adds a Strict-Transport-Security header to enforce secure connections.
* `--staple-ocsp`: Enables OCSP Stapling, enhancing SSL negotiation performance while maintaining user privacy.
* `--email`: The email address to which you will receive notifications related to your SSL certificate.

Replace `you@example.com` with your actual email and `yourdomain.com` with your domain name OR sub-domain name (ie. `allstar.yourdomain.com`).

You will be asked if you want to give permission to use your email for statistical purposes (you can answer no, if you like). When the process completes, you should see something like:

```
Account registered.
Requesting a certificate for allstar.yourdomain.com

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/allstar.yourdomain.com/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/allstar.yourdomain.com/privkey.pem
This certificate expires on 2025-10-23.
These files will be updated when the certificate renews.
Certbot has set up a scheduled task to automatically renew this certificate in the background.

Deploying certificate
Successfully deployed certificate for allstar.yourdomain.com to /etc/apache2/sites-available/000-default-le-ssl.conf
Congratulations! You have successfully enabled HTTPS on https://allstar.yourdomain.com

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If you like Certbot, please consider supporting our work by:
 * Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
 * Donating to EFF:                    https://eff.org/donate-le
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

That's it! If you reload your Allmon3 webpage, it should re-direct the HTTP request to HTTPS, and you webpage will now show as being "secure" (and users will no longer get the warning from their browser).

## Certificate Renewal
Many online tutorials talk about adding a `cron` job with `crontab -e` in order to renew your certificate before it expires in 90-days. While it is a safeguard, it technically should not be required. If you note during the installation of the certificate, you will see the message:

```
Certbot has set up a scheduled task to automatically renew this certificate in the background.
```

This actually configures a timer with `systemd` to check twice daily that the certificate is valid, and renew it if it is expiring.

You can confirm the timer is installed with `sudo systemctl list-timers`:

```
NEXT                        LEFT           LAST                        PASSED       UNIT                         ACTIVATES
Fri 2025-07-25 18:14:09 EDT 6h left        Fri 2025-07-25 07:32:47 EDT 4h 7min ago  apt-daily.timer              apt-daily.service
Fri 2025-07-25 20:22:45 EDT 8h left        -                           -            certbot.timer                certbot.service
Sat 2025-07-26 00:00:00 EDT 12h left       -                           -            dpkg-db-backup.timer         dpkg-db-backup.service
Sat 2025-07-26 00:00:00 EDT 12h left       Fri 2025-07-25 00:11:13 EDT 11h ago      logrotate.timer              logrotate.service
Sat 2025-07-26 00:49:35 EDT 13h left       Fri 2025-07-25 00:30:51 EDT 11h ago      man-db.timer                 man-db.service
Sat 2025-07-26 01:19:49 EDT 13h left       Fri 2025-07-25 01:19:46 EDT 10h ago      systemd-tmpfiles-clean.timer systemd-tmpfiles-clean.service
Sat 2025-07-26 06:50:17 EDT 19h left       Fri 2025-07-25 06:47:47 EDT 4h 52min ago apt-daily-upgrade.timer      apt-daily-upgrade.service
Sat 2025-07-26 10:08:00 EDT 22h left       Fri 2025-07-25 10:07:59 EDT 1h 32min ago asl-telemetry.timer          asl-telemetry.service
Sun 2025-07-27 03:10:11 EDT 1 day 15h left Fri 2025-07-25 00:12:11 EDT 11h ago      e2scrub_all.timer            e2scrub_all.service
Mon 2025-07-28 00:04:42 EDT 2 days left    Fri 2025-07-25 00:29:23 EDT 11h ago      fstrim.timer                 fstrim.service

10 timers listed.
Pass --all to see loaded but inactive timers, too.
```

The `certbot.timer` lives at `/lib/systemd/system/certbot.timer`, and calls the `certbot.service` which lives at `/usr/lib/systemd/system/certbot.service`.

